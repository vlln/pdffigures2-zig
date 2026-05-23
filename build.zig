const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const mupdf_prefix = b.option([]const u8, "mupdf-prefix", "MuPDF installation prefix (e.g. /usr/local or ~/.local)");
    const static_link = b.option(bool, "static", "Prefer static linking for all MuPDF dependencies") orelse false;
    const skip_e2e = b.option(bool, "skip-e2e", "Skip end-to-end tests that require local PDF files") orelse false;

    const link_opts: std.Build.Module.LinkSystemLibraryOptions = .{
        .preferred_link_mode = if (static_link) .static else .dynamic,
    };

    const build_options = b.addOptions();
    build_options.addOption(bool, "skip_e2e", skip_e2e);

    const main_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    main_module.addOptions("build_options", build_options);

    const exe = b.addExecutable(.{
        .name = "pdffigures2",
        .root_module = main_module,
    });

    // MuPDF and all its transitive dependencies (from pkg-config --static --libs mupdf)
    const mupdf_deps = [_][]const u8{
        "mupdf",     "mupdf-third", "mujs",
        "gumbo",     "openjp2",     "jbig2dec",
        "jpeg",      "z",           "m",
        "harfbuzz",  "freetype",  "bz2",         "png16",
        "brotlidec", "brotlicommon",
    };
    for (mupdf_deps) |dep| {
        exe.root_module.linkSystemLibrary(dep, link_opts);
    }
    if (mupdf_prefix) |prefix| {
        exe.root_module.addLibraryPath(.{ .cwd_relative = b.pathJoin(&.{ prefix, "lib" }) });
        exe.root_module.addIncludePath(.{ .cwd_relative = b.pathJoin(&.{ prefix, "include" }) });
    }

    b.installArtifact(exe);

    // Shared library (C ABI)
    const lib_module = b.createModule(.{
        .root_source_file = b.path("src/c_api.zig"),
        .target = target,
        .optimize = optimize,
    });
    const lib = b.addLibrary(.{
        .linkage = .dynamic,
        .name = "pdffigures2",
        .root_module = lib_module,
    });
    for (mupdf_deps) |dep| {
        lib.root_module.linkSystemLibrary(dep, link_opts);
    }
    if (mupdf_prefix) |prefix| {
        lib.root_module.addLibraryPath(.{ .cwd_relative = b.pathJoin(&.{ prefix, "lib" }) });
        lib.root_module.addIncludePath(.{ .cwd_relative = b.pathJoin(&.{ prefix, "include" }) });
    }
    b.installArtifact(lib);
    b.installFile("include/pdffigures2.h", "include/pdffigures2.h");

    // Run step
    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // Test step
    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });
    for (mupdf_deps) |dep| {
        exe_tests.root_module.linkSystemLibrary(dep, link_opts);
    }
    if (mupdf_prefix) |prefix| {
        exe_tests.root_module.addLibraryPath(.{ .cwd_relative = b.pathJoin(&.{ prefix, "lib" }) });
        exe_tests.root_module.addIncludePath(.{ .cwd_relative = b.pathJoin(&.{ prefix, "include" }) });
    }

    const run_exe_tests = b.addRunArtifact(exe_tests);
    const test_step = b.step("test", "Run all tests");
    test_step.dependOn(&run_exe_tests.step);
}