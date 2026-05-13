// Minimal logging wrapper using Zig's std.log.
// Translation of Logging.scala.

const std = @import("std");

pub const log = std.log.scoped(.pdffigures2);

/// Logging configuration for programmatic setup (when needed by CLI).
pub const LogConfig = struct {
    level: std.log.Level,

    pub fn init(debug_logging: bool) LogConfig {
        return .{ .level = if (debug_logging) .debug else .info };
    }
};