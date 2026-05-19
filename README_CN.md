# PDFFigures 2.0 (Zig)

> [allenai/pdffigures2](https://github.com/allenai/pdffigures2) 的高性能移植版，从 Scala/JVM 翻译为 Zig/MuPDF — 提取学术 PDF 中的图表、表格和标题，零误检。

## 动机

[PDFFigures 2.0](https://github.com/allenai/pdffigures2) 是学术 PDF 图表提取领域的事实标准，在 S2ORC、Semantic Scholar 等大规模文献挖掘管线中被广泛使用。原始 Scala/PDFBox 实现存在固有问题：

- **部署沉重**：需要 JVM 运行时加 19 MB 的 fat JAR，完整运行环境可达数百 MB。
- **启动缓慢**：JVM 冷启动需要数秒，不适合单文件处理或 serverless 场景。
- **嵌入困难**：JVM 进程难以嵌入 Python、Node.js、Go 等工具链，通常只能通过子进程调用。
- **内存占用高**：JVM 堆内存基线高，批处理大量 PDF 时 GC 压力显著。

本项目将 PDFFigures 2.0 **逐行翻译**为 Zig，底层 PDF 引擎从 PDFBox 替换为 MuPDF C API。所有启发式规则、常数、算法流程严格保留，输出 JSON 格式与原版完全一致。

## 设计目标

这是一个忠实翻译，而非重写。目标不是"改进"算法，而是：

1. **输出等价**：同一份 PDF，Zig 版和 Scala 版输出的 Figure/Table 检测结果一致（在浮点精度内）。
2. **原生二进制部署**：编译为单个静态链接的可执行文件（~42 MB ReleaseSmall），除 `libmupdf` 外无运行时依赖，启动时间毫秒级。
3. **可嵌入性**：提供 C ABI 共享库，供 Python、Node.js、Go 等语言直接调用；也支持 JSON stdin/stdout 集成。
4. **完整管线**：Text → Formatting → Layout → Captions → Graphics → Classification → Figure Detection 全流程已实现。

## 快速开始

```bash
# Debug 编译
zig build

# Release 编译（推荐）
zig build -Doptimize=ReleaseSmall

# 处理单个 PDF
./zig-out/bin/pdffigures2 paper.pdf

# 运行全部测试
zig build test
```

## 依赖

- **Zig** 0.17.0-dev.269+（nightly）
- **MuPDF** 开发库（通过 pkg-config）及其所有传递依赖

Ubuntu/Debian 安装：

```bash
sudo apt install libmupdf-dev libmujs-dev libjpeg-dev libharfbuzz-dev \
  libfreetype-dev libpng-dev libbrotli-dev libopenjp2-7-dev libjbig2dec-dev \
  libgumbo-dev
```

也可从源码编译 MuPDF，确保 `pkg-config` 能找到即可。

## CLI 用法

```
pdffigures2 <pdf>                  处理单个 PDF，JSON 输出到 stdout
pdffigures2 batch <dir> [opts]     批处理模式（多线程）
pdffigures2 visualize <pdf> [opts] 渲染标注调试 PNG
pdffigures2 dump <pdf> [page]      导出原始提取数据（调试用）
```

### 批处理参数

| 参数 | 说明 |
|------|------|
| `-t N` | 线程数（默认：全部 CPU） |
| `-i DPI` | 渲染 DPI（默认：300） |
| `-s FILE` | 输出统计 JSON |
| `-m PREFIX` | 图片输出路径前缀 |
| `-d PREFIX` | 数据 JSON 输出路径前缀 |
| `-g PREFIX` | 全文 + 章节输出路径前缀 |
| `-e` | 忽略错误，继续处理 |
| `-f` | 允许 OCR 提取 |
| `-w` | 不过滤白色图形 |

## 架构

提取管线将每页 PDF 依次流经以下处理阶段：

```
TextExtractor → FormattingTextExtractor → DocumentLayout →
CaptionDetector → GraphicsExtractor → CaptionBuilder →
RegionClassifier → FigureDetector → (FigureRenderer)
```

### 模块总览

~7,600 行手写代码 + ~6,500 行 MuPDF 自动绑定。

| 层次 | 模块 | 行数 | 职责 |
|------|------|------|------|
| 0 | `box.zig` | 370 | 轴对齐包围盒及空间算法（合并、裁剪、交集、间隙检测） |
| 0 | `paragraph.zig` | 361 | Word → Line → Paragraph 层级结构，Unicode 规范化 |
| 0 | `figure.zig` | 189 | 输出类型：Figure、Caption、RasterizedFigure |
| 0 | `mupdf.zig` | 6,527 | MuPDF C API 绑定（`zig translate-c` 自动生成） |
| 1 | `page.zig` | 265 | Tagged union，六种页面处理阶段 |
| 2 | `extract/text.zig` | 220 | 通过 `fz_stext_page` 提取结构化文本 |
| 2 | `layout.zig` | 327 | 文档布局统计：加权中位数、双栏检测、字体基准 |
| 2 | `extract/graphic.zig` | 370 | 通过 `fz_device` 回调提取图形包围盒 |
| 2 | `extract/raster.zig` | 128 | 光栅图像提取 |
| 3 | `extract/formatting.zig` | 518 | 页眉、页码、摘要检测（字号和位置启发式） |
| 3 | `extract/graphics.zig` | 334 | 图表图形 vs. 非图表图形（水印、装饰线）分离 |
| 3 | `extract/paragraph_rebuild.zig` | 105 | 基于行距和对齐的段落合并 |
| 4 | `detect/caption.zig` | 455 | 正则表达式标题匹配及去重 |
| 4 | `detect/caption_builder.zig` | 232 | 标题段落扩展（吸收续行） |
| 5 | `classify/region.zig` | 428 | 七级分类器串联：正文 vs. 图表内文字 |
| 6 | `detect/figure.zig` | 1,001 | 核心检测：四方向提案生成、笛卡尔积搜索、重叠消解 |
| 6 | `render/figure.zig` | 311 | 图表区域渲染至像素缓冲区 |
| 7 | `extractor.zig` | 397 | 管线编排器及公共 API |
| 7 | `json.zig` | 167 | JSON 序列化（与 Scala `JsonProtocol` 格式兼容） |

### 关键设计决策

**坐标系统**：MuPDF 使用左上角原点（y↓），与内部 `Box` 坐标系统自然一致，无需翻转。

**内存管理**：MuPDF 对象使用引用计数（`fz_drop_*`）。管线临时数据使用 arena 分配器，每页处理完后释放。输出数据使用调用者提供的分配器。

## 输出 JSON 格式

与 Scala 原版格式完全一致：

```json
{
  "figures": [{
    "name": "1",
    "figType": "Figure",
    "page": 0,
    "caption": "Figure 1: Overview of the proposed method.",
    "captionBoundary": {"x1": 72.0, "y1": 393.0, "x2": 540.0, "y2": 415.7},
    "regionBoundary": {"x1": 72.0, "y1": 295.0, "x2": 540.0, "y2": 393.0},
    "imageText": ["图表区域内的文字"]
  }],
  "regionless-captions": [{
    "name": "1",
    "figType": "Figure",
    "page": 0,
    "text": "Figure 1: ...",
    "boundary": {"x1": 72.0, "y1": 393.0, "x2": 540.0, "y2": 415.7}
  }]
}
```

## 评测结果

### 检测质量

在 conference 数据集上评测（[pdffigures2 evaluation](https://github.com/allenai/pdffigures2/tree/master/evaluation)）：28 份 PDF，135 个标注图表。匹配标准：caption 和 region 的 union-intersect IoU 均 ≥ 0.8。

| 指标 | Zig (MuPDF) | Scala (PDFBox) |
|------|:-----------:|:--------------:|
| 精确率 | **100.0%** | 100.0% |
| 召回率 | **94.9%** | 95.1% |
| F1 | **97.4%** | 97.5% |
| TP | 56 | 58 |
| FP | 0 | 0 |

Zig 与 Scala 的 2 TP 差距已确认为底层 PDF 引擎（MuPDF vs. PDFBox）在文本行分组策略上的差异，非逻辑缺陷。

### 资源消耗

| | Zig | Scala | 提升 |
|--|:---:|:-----:|:----:|
| 总耗时（28 份 PDF） | 4.9 s | 65.7 s | **13.4×** |
| 中位内存（每份 PDF） | 12 MB | 244 MB | **20×** |
| 峰值内存（单份 PDF） | 26 MB | 447 MB | **17×** |
| 二进制体积 | 42 MB | 19 MB JAR + ~200 MB JVM | — |
| 启动时间 | <10 ms | 2–4 s | **~300×** |

内存通过 `/usr/bin/time -v`（Maximum resident set size）测量。

### 测试覆盖

- 48 个单元测试：Box 空间算法、Paragraph/Word/Line 构建、Figure 序列化、`DocumentLayout` 加权中位数、Caption 正则匹配、Region 分类器、Figure 提案生成与评分。
- 3 个端到端测试：使用真实学术 PDF 验证完整管线。

### 已知差异

与 Scala 版本的剩余差异均源于 MuPDF 与 PDFBox 的引擎差异：

- 部分 Caption 边界略大于 Scala（MuPDF 段落分组策略不同）。
- 2 个漏检（`icml12_2`、`icml12_5`），根因为文本行分组策略差异。
- MuPDF 页面从 0 开始编号（PDFBox 亦然），输出中 page 字段为 0 索引。

## 与 pymupdf4llm 的对比

[pymupdf4llm](https://github.com/pymupdf/PyMuPDF4LLM) 使用机器学习版面分析来分类页面块（picture、table、caption、text、formula 等）。它能提供更广泛的文档结构分析，但 pdffigures2-zig 在学术图表提取方面有其独特优势：

| | pdffigures2-zig | pymupdf4llm |
|--|:--:|:--:|
| 方法 | Caption 模式匹配 + Region 提案 | ML 版面分类 |
| Caption-Figure 关联 | 内建 | 不支持（块之间独立） |
| 表格结构 | 仅包围盒 | 行列数、单元格、markdown |
| 碎片化问题 | 无 | 矢量图常被拆分（28 份 PDF 中 39 个碎片） |
| 无标题图形 | 漏检 | 能检测到 |
| 中位内存 | 12 MB | ~1 GB+（ML 模型） |
| 交叉验证一致率 | — | 82.1% 的 Zig 图表能被 LLM 块匹配（IoU ≥ 0.5） |

两个工具定位互补：pdffigures2-zig 专注于精确的图表/Caption 提取，保证零误检；pymupdf4llm 是通用文档版面分析工具。

## 技术栈对比

| 维度 | Zig | Scala |
|------|-----|-------|
| PDF 引擎 | MuPDF (C API) | PDFBox 2.0.x |
| 文本提取 | `fz_stext_page` blocks/lines/chars | `PDFTextStripper` 子类化 |
| 图形提取 | `fz_device` 回调函数 | `PDFGraphicsStreamEngine` |
| JSON | `std.json.stringify` | spray-json |
| CLI 解析 | 手动 `std.process.Args` | scopt |
| 内存管理 | Arena + 手动引用计数 | JVM GC |
| 可嵌入性 | C ABI 库 / 子进程 | 仅子进程 |
| 批处理 | 多线程（`std.Thread`） | `ForkJoinPool` |
| 可视化 | 静态标注 PNG | Swing GUI |

## 路线图

- [x] 核心提取管线（~7,600 行，48 测试）
- [x] 单文件 CLI
- [x] JSON 输出与 Scala 版本格式兼容
- [x] 批处理 CLI（多线程）
- [x] 调试可视化 CLI（标注 PNG）
- [x] C ABI 共享库
- [x] Conference 数据集评测（召回率 94.9%，零误检）
- [ ] PDF 转 Markdown（pymupdf4llm 功能移植）
- [ ] 结构化表格提取（单元格级）

## 许可证

本项目使用 Apache License 2.0 —— 与原始 [allenai/pdffigures2](https://github.com/allenai/pdffigures2) 相同。本项目不包含任何原始 Scala 代码，是使用不同 PDF 引擎（MuPDF）的独立 Zig 实现。详情见 [LICENSE](LICENSE)。