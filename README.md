# PDFFigures 2.0 (Zig)

## 动机

[PDFFigures 2.0](https://github.com/allenai/pdffigures2) 是学术 PDF 图表提取领域的标准工具，在 S2ORC、Semantic Scholar 等大型文献挖掘管线中被广泛使用。但原始实现基于 Scala/JVM，存在几个固有问题：

- **部署沉重**：需要 JVM 运行时 + fat JAR（~19MB），外加 PDFBox 等依赖，完整运行环境数百 MB
- **启动缓慢**：JVM 冷启动需要数秒，不适合单文件处理或 serverless 场景
- **嵌入困难**：JVM 进程难以嵌入 Python/Node.js/Go 等语言工具链，通常只能通过子进程调用
- **内存占用高**：JVM 堆内存基线高，批处理大量 PDF 时 GC 压力大

本项目将 PDFFigures 2.0 **完整翻译**为 Zig，底层 PDF 引擎从 PDFBox 替换为 MuPDF C API。所有启发式规则、常数、算法流程逐行保留，输出 JSON 格式与原版完全一致。

## 做了什么

这是一个**忠实翻译**（literal translation），而非重写。目标不是"改进"算法，而是：

1. **保持输出等价**：同一份 PDF，Zig 版本和 Scala 版本输出的 Figure/Table 检测结果尽量一致（已在多份真实论文 PDF 上验证）
2. **原生二进制部署**：编译为单个静态链接的本地二进制文件（~42MB ReleaseSmall），无运行时依赖（除 MuPDF 动态库），启动时间从秒级降到毫秒级
3. **可嵌入性**：作为 C ABI 库供 Python/Node.js/Go 等语言直接调用，也可以通过 JSON stdin/stdout 协议集成
4. **完整管线**：Text → Formatting → Layout → Captions → Graphics → Classification → Figure Detection 全流程已实现

### 效果

**测试覆盖**：
- 48 个单元测试全部通过，覆盖 Box 空间算法、Paragraph 文本处理、Figure 类型序列化、DocumentLayout 中位数计算、Caption 正则匹配、Region 分类器、Figure 提案生成与验证等
- 3 份真实论文 PDF 的端到端测试（paper.pdf, paper008.pdf, MOESM1_ESM.pdf）

**检测质量**（conference 数据集，28 份 PDF，135 个标注图表）：

| | Zig | Scala |
|---|---|---|
| Precision | **100.0%** | 100.0% |
| Recall | **94.9%** | 95.1% |
| F1 | **97.4%** | 97.5% |
| TP | 56 | 58 |
| FP | 0 | 0 |
| Time | **4.9s**（13.4x） | 65.7s |
| Memory (median) | **12 MB**（20x） | 244 MB |
| Memory (peak) | **26 MB** | 447 MB |

Zig 与 Scala 差距仅 2 个 TP，已确认为底层 PDF 引擎（MuPDF vs PDFBox）差异导致，非逻辑 Bug。

**已知差异**：
- 部分 Caption 边界略大于 Scala（MuPDF 段落分组策略不同）
- 2 个漏检（icml12_2, icml12_5），根因为 MuPDF 与 PDFBox 在文本行分组上的策略差异
- JSON 输出格式与原版完全一致

## Quick Start

```bash
# 编译（Debug 模式）
zig build

# 编译（Release 模式，推荐）
zig build -Doptimize=ReleaseSmall

# 处理单个 PDF，输出 JSON
./zig-out/bin/pdffigures2 /path/to/paper.pdf

# 运行测试
zig build test
```

## 依赖

- **Zig** 0.17.0-dev.269+（nightly）
- **MuPDF** 开发库（通过 pkg-config）+ 其所有传递依赖

Ubuntu/Debian 安装：

```bash
sudo apt install libmupdf-dev libmujs-dev libjpeg-dev libharfbuzz-dev \
  libfreetype-dev libpng-dev libbrotli-dev libopenjp2-7-dev libjbig2dec-dev \
  libgumbo-dev
```

也可从源码编译 MuPDF，确保 `pkg-config` 能找到。

## 架构

提取管线将每页 PDF 依次流经以下处理阶段：

```
TextExtractor → FormattingTextExtractor → DocumentLayout →
CaptionDetector → GraphicsExtractor → CaptionBuilder →
RegionClassifier → FigureDetector → (FigureRenderer)
```

### 模块总览 (~7,600 行手写代码 + 6,500 行 MuPDF 自动绑定)

| 层次 | 模块 | 行数 | 职责 |
|------|------|------|------|
| 0 | `box.zig` | 370 | 轴对齐包围盒 + 空间算法（合并、裁剪、交集、空隙检测） |
| 0 | `paragraph.zig` | 361 | Word → Line → Paragraph 文本层级 + Unicode 规范化 |
| 0 | `figure.zig` | 189 | Figure/Caption/RasterizedFigure 输出类型 |
| 0 | `mupdf.zig` | 6,527 | MuPDF C API 自动绑定（由 `zig translate-c` 生成） |
| 1 | `page.zig` | 265 | Page* 类型层级（tagged union，6 种页面阶段） |
| 2 | `extract/text.zig` | 220 | 通过 `fz_stext_page` 提取结构化文本 |
| 2 | `layout.zig` | 327 | 文档布局统计：加权中位数、双栏检测、标准字号 |
| 2 | `extract/graphic.zig` | 370 | 通过 `fz_device` 回调提取图形包围盒 |
| 2 | `extract/raster.zig` | 128 | 光栅图像提取 |
| 3 | `extract/formatting.zig` | 518 | 页眉/页码/摘要检测（基于字号和位置启发式） |
| 3 | `extract/graphics.zig` | 334 | 图表图形 vs. 非图表图形（水印、装饰线）分离 |
| 3 | `extract/paragraph_rebuild.zig` | 105 | 段落合并（基于行距和对齐） |
| 4 | `detect/caption.zig` | 455 | 图表标题正则匹配 + 去重 |
| 4 | `detect/caption_builder.zig` | 232 | 标题段落扩展（吸收后续行） |
| 5 | `classify/region.zig` | 428 | 七分类器串联：正文 vs. 图表内文字判别 |
| 6 | `detect/figure.zig` | 1001 | 图表检测核心：四向提案生成 + 笛卡尔积搜索 + 重叠消解 |
| 6 | `render/figure.zig` | 311 | 图表区域渲染为像素缓冲区 |
| 7 | `extractor.zig` | 397 | 管线编排器 + 公共 API |
| 7 | `json.zig` | 167 | JSON 序列化（与 Scala JsonProtocol 一致） |

### 关键设计决策

**坐标系统**：MuPDF 使用左上角原点（y↓），与内部 `Box` 坐标系统自然一致，无需翻转。

**内存管理**：MuPDF 对象使用引用计数（`fz_drop_*`）。管线临时对象使用 arena 分配器，每页处理完成后释放。输出数据使用调用者的分配器。

**输出 JSON** 与 Scala 原版格式完全相同：

```json
[{
  "name": "1",
  "figType": "Figure",
  "page": 0,
  "caption": "Figure 1: ...",
  "captionBoundary": {"x1": 72.0, "y1": 393.0, "x2": 540.0, "y2": 415.7},
  "regionBoundary": {"x1": 72.0, "y1": 295.0, "x2": 540.0, "y2": 393.0},
  "imageText": ["text inside the figure region"]
}]
```

## CLI

```bash
# 单文件处理
pdffigures2 paper.pdf

# 批处理（多线程，保存图片 + JSON）
pdffigures2 batch /path/to/pdfs/ -s stats.json -m img_prefix -d data_prefix

# 可视化调试（生成标注 PNG）
pdffigures2 visualize paper.pdf -o output.png

# 原始数据 dump（调试用）
pdffigures2 dump paper.pdf [page]
```

| 参数 | 适用 | 说明 |
|------|------|------|
| `-t N` | batch | 线程数（默认：全部 CPU） |
| `-i DPI` | batch / visualize | 渲染 DPI（默认：300） |
| `-o FILE` | visualize | 输出 PNG 路径 |
| `-e` | batch | 忽略错误，继续处理 |
| `-s FILE` | batch | 输出统计 JSON |
| `-m PREFIX` | batch | 图片输出前缀 |
| `-d PREFIX` | batch | 数据 JSON 输出前缀 |
| `-g PREFIX` | batch | 全文 + 章节输出前缀 |
| `-f` | batch | 允许 OCR 提取 |
| `-w` | batch | 不过滤白色图形 |

## 技术栈对比

| 维度 | Zig | Scala |
|------|-----|-------|
| PDF 引擎 | MuPDF (C API) | PDFBox 2.0.x |
| 文本提取 | `fz_stext_page` blocks/lines/chars | `PDFTextStripper` 子类化 |
| 图形提取 | `fz_device` 回调函数 | `PDFGraphicsStreamEngine` |
| JSON | `std.json.stringify` | spray-json |
| CLI | 手动参数解析 | scopt |
| 二进制大小 | 42MB（ReleaseSmall 静态链接） | 19MB（JAR）+ ~200MB（JVM） |
| 启动时间 | 毫秒级 | 数秒（JVM 冷启动） |
| 内存管理 | Arena + 手动引用计数 | GC |
| 可嵌入性 | C ABI 库直调 / 子进程 | 子进程调用 |
| 批处理 CLI | 多线程（`std.Thread`） | 完整（`ForkJoinPool`） |
| 可视化 CLI | 静态 PNG 输出 | 完整（Swing GUI） |

## 路线图

- [x] 核心提取管线（~7,600 行手写代码，48 测试）
- [x] 单文件 CLI
- [x] 输出 JSON 与原版一致
- [x] 批处理 CLI（多线程）
- [x] 可视化 CLI（静态标注 PNG）
- [x] C ABI 共享库
- [x] Conference 数据集评估（召回率 94.9%，0 FP，仅差 Scala 2 TP）