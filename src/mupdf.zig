const __root = @This();
pub const __builtin = @import("std").zig.c_translation.builtins;
pub const __helpers = @import("std").zig.c_translation.helpers;
pub const ptrdiff_t = c_long;
pub const wchar_t = c_int;
pub const max_align_t = extern struct {
    __aro_max_align_ll: c_longlong = 0,
    __aro_max_align_ld: c_longdouble = 0,
};
pub const struct___va_list_tag_1 = extern struct {
    unnamed_0: c_uint = 0,
    unnamed_1: c_uint = 0,
    unnamed_2: ?*anyopaque = null,
    unnamed_3: ?*anyopaque = null,
};
pub const __builtin_va_list = [1]struct___va_list_tag_1;
pub const va_list = __builtin_va_list;
pub const __gnuc_va_list = __builtin_va_list;
pub const __jmp_buf = [8]c_long;
pub const __sigset_t = extern struct {
    __val: [16]c_ulong = @import("std").mem.zeroes([16]c_ulong),
};
pub const struct___jmp_buf_tag = extern struct {
    __jmpbuf: __jmp_buf = @import("std").mem.zeroes(__jmp_buf),
    __mask_was_saved: c_int = 0,
    __saved_mask: __sigset_t = @import("std").mem.zeroes(__sigset_t),
    pub const setjmp = __root.setjmp;
    pub const __sigsetjmp = __root.__sigsetjmp;
    pub const _setjmp = __root._setjmp;
    pub const longjmp = __root.longjmp;
    pub const _longjmp = __root._longjmp;
    pub const siglongjmp = __root.siglongjmp;
};
pub const jmp_buf = [1]struct___jmp_buf_tag;
pub extern fn setjmp(__env: [*c]struct___jmp_buf_tag) c_int;
pub extern fn __sigsetjmp(__env: [*c]struct___jmp_buf_tag, __savemask: c_int) c_int;
pub extern fn _setjmp(__env: [*c]struct___jmp_buf_tag) c_int;
pub extern fn longjmp(__env: [*c]struct___jmp_buf_tag, __val: c_int) noreturn;
pub extern fn _longjmp(__env: [*c]struct___jmp_buf_tag, __val: c_int) noreturn;
pub const sigjmp_buf = [1]struct___jmp_buf_tag;
pub extern fn siglongjmp(__env: [*c]struct___jmp_buf_tag, __val: c_int) noreturn;
pub const __u_char = u8;
pub const __u_short = c_ushort;
pub const __u_int = c_uint;
pub const __u_long = c_ulong;
pub const __int8_t = i8;
pub const __uint8_t = u8;
pub const __int16_t = c_short;
pub const __uint16_t = c_ushort;
pub const __int32_t = c_int;
pub const __uint32_t = c_uint;
pub const __int64_t = c_long;
pub const __uint64_t = c_ulong;
pub const __int_least8_t = __int8_t;
pub const __uint_least8_t = __uint8_t;
pub const __int_least16_t = __int16_t;
pub const __uint_least16_t = __uint16_t;
pub const __int_least32_t = __int32_t;
pub const __uint_least32_t = __uint32_t;
pub const __int_least64_t = __int64_t;
pub const __uint_least64_t = __uint64_t;
pub const __quad_t = c_long;
pub const __u_quad_t = c_ulong;
pub const __intmax_t = c_long;
pub const __uintmax_t = c_ulong;
pub const __dev_t = c_ulong;
pub const __uid_t = c_uint;
pub const __gid_t = c_uint;
pub const __ino_t = c_ulong;
pub const __ino64_t = c_ulong;
pub const __mode_t = c_uint;
pub const __nlink_t = c_ulong;
pub const __off_t = c_long;
pub const __off64_t = c_long;
pub const __pid_t = c_int;
pub const __fsid_t = extern struct {
    __val: [2]c_int = @import("std").mem.zeroes([2]c_int),
};
pub const __clock_t = c_long;
pub const __rlim_t = c_ulong;
pub const __rlim64_t = c_ulong;
pub const __id_t = c_uint;
pub const __time_t = c_long;
pub const __useconds_t = c_uint;
pub const __suseconds_t = c_long;
pub const __suseconds64_t = c_long;
pub const __daddr_t = c_int;
pub const __key_t = c_int;
pub const __clockid_t = c_int;
pub const __timer_t = ?*anyopaque;
pub const __blksize_t = c_long;
pub const __blkcnt_t = c_long;
pub const __blkcnt64_t = c_long;
pub const __fsblkcnt_t = c_ulong;
pub const __fsblkcnt64_t = c_ulong;
pub const __fsfilcnt_t = c_ulong;
pub const __fsfilcnt64_t = c_ulong;
pub const __fsword_t = c_long;
pub const __ssize_t = c_long;
pub const __syscall_slong_t = c_long;
pub const __syscall_ulong_t = c_ulong;
pub const __loff_t = __off64_t;
pub const __caddr_t = [*c]u8;
pub const __intptr_t = c_long;
pub const __socklen_t = c_uint;
pub const __sig_atomic_t = c_int;
const union_unnamed_2 = extern union {
    __wch: c_uint,
    __wchb: [4]u8,
};
pub const __mbstate_t = extern struct {
    __count: c_int = 0,
    __value: union_unnamed_2 = @import("std").mem.zeroes(union_unnamed_2),
};
pub const struct__G_fpos_t = extern struct {
    __pos: __off_t = 0,
    __state: __mbstate_t = @import("std").mem.zeroes(__mbstate_t),
};
pub const __fpos_t = struct__G_fpos_t;
pub const struct__G_fpos64_t = extern struct {
    __pos: __off64_t = 0,
    __state: __mbstate_t = @import("std").mem.zeroes(__mbstate_t),
};
pub const __fpos64_t = struct__G_fpos64_t;
pub const struct__IO_marker = opaque {};
pub const _IO_lock_t = anyopaque;
pub const struct__IO_codecvt = opaque {};
pub const struct__IO_wide_data = opaque {};
pub const struct__IO_FILE = extern struct {
    _flags: c_int = 0,
    _IO_read_ptr: [*c]u8 = null,
    _IO_read_end: [*c]u8 = null,
    _IO_read_base: [*c]u8 = null,
    _IO_write_base: [*c]u8 = null,
    _IO_write_ptr: [*c]u8 = null,
    _IO_write_end: [*c]u8 = null,
    _IO_buf_base: [*c]u8 = null,
    _IO_buf_end: [*c]u8 = null,
    _IO_save_base: [*c]u8 = null,
    _IO_backup_base: [*c]u8 = null,
    _IO_save_end: [*c]u8 = null,
    _markers: ?*struct__IO_marker = null,
    _chain: [*c]struct__IO_FILE = null,
    _fileno: c_int = 0,
    _flags2: c_int = 0,
    _old_offset: __off_t = 0,
    _cur_column: c_ushort = 0,
    _vtable_offset: i8 = 0,
    _shortbuf: [1]u8 = @import("std").mem.zeroes([1]u8),
    _lock: ?*_IO_lock_t = null,
    _offset: __off64_t = 0,
    _codecvt: ?*struct__IO_codecvt = null,
    _wide_data: ?*struct__IO_wide_data = null,
    _freeres_list: [*c]struct__IO_FILE = null,
    _freeres_buf: ?*anyopaque = null,
    __pad5: usize = 0,
    _mode: c_int = 0,
    _unused2: [20]u8 = @import("std").mem.zeroes([20]u8),
    pub const fclose = __root.fclose;
    pub const fflush = __root.fflush;
    pub const fflush_unlocked = __root.fflush_unlocked;
    pub const setbuf = __root.setbuf;
    pub const setvbuf = __root.setvbuf;
    pub const setbuffer = __root.setbuffer;
    pub const setlinebuf = __root.setlinebuf;
    pub const fprintf = __root.fprintf;
    pub const vfprintf = __root.vfprintf;
    pub const fscanf = __root.fscanf;
    pub const vfscanf = __root.vfscanf;
    pub const fgetc = __root.fgetc;
    pub const getc = __root.getc;
    pub const getc_unlocked = __root.getc_unlocked;
    pub const fgetc_unlocked = __root.fgetc_unlocked;
    pub const getw = __root.getw;
    pub const fseek = __root.fseek;
    pub const ftell = __root.ftell;
    pub const rewind = __root.rewind;
    pub const fseeko = __root.fseeko;
    pub const ftello = __root.ftello;
    pub const fgetpos = __root.fgetpos;
    pub const fsetpos = __root.fsetpos;
    pub const clearerr = __root.clearerr;
    pub const feof = __root.feof;
    pub const ferror = __root.ferror;
    pub const clearerr_unlocked = __root.clearerr_unlocked;
    pub const feof_unlocked = __root.feof_unlocked;
    pub const ferror_unlocked = __root.ferror_unlocked;
    pub const fileno = __root.fileno;
    pub const fileno_unlocked = __root.fileno_unlocked;
    pub const pclose = __root.pclose;
    pub const flockfile = __root.flockfile;
    pub const ftrylockfile = __root.ftrylockfile;
    pub const funlockfile = __root.funlockfile;
    pub const __uflow = __root.__uflow;
    pub const __overflow = __root.__overflow;
    pub const unlocked = __root.fflush_unlocked;
    pub const uflow = __root.__uflow;
    pub const overflow = __root.__overflow;
};
pub const __FILE = struct__IO_FILE;
pub const FILE = struct__IO_FILE;
pub const cookie_read_function_t = fn (__cookie: ?*anyopaque, __buf: [*c]u8, __nbytes: usize) callconv(.c) __ssize_t;
pub const cookie_write_function_t = fn (__cookie: ?*anyopaque, __buf: [*c]const u8, __nbytes: usize) callconv(.c) __ssize_t;
pub const cookie_seek_function_t = fn (__cookie: ?*anyopaque, __pos: [*c]__off64_t, __w: c_int) callconv(.c) c_int;
pub const cookie_close_function_t = fn (__cookie: ?*anyopaque) callconv(.c) c_int;
pub const struct__IO_cookie_io_functions_t = extern struct {
    read: ?*const cookie_read_function_t = null,
    write: ?*const cookie_write_function_t = null,
    seek: ?*const cookie_seek_function_t = null,
    close: ?*const cookie_close_function_t = null,
};
pub const cookie_io_functions_t = struct__IO_cookie_io_functions_t;
pub const off_t = __off_t;
pub const fpos_t = __fpos_t;
pub extern var stdin: [*c]FILE;
pub extern var stdout: [*c]FILE;
pub extern var stderr: [*c]FILE;
pub extern fn remove(__filename: [*c]const u8) c_int;
pub extern fn rename(__old: [*c]const u8, __new: [*c]const u8) c_int;
pub extern fn renameat(__oldfd: c_int, __old: [*c]const u8, __newfd: c_int, __new: [*c]const u8) c_int;
pub extern fn fclose(__stream: [*c]FILE) c_int;
pub extern fn tmpfile() [*c]FILE;
pub extern fn tmpnam([*c]u8) [*c]u8;
pub extern fn tmpnam_r(__s: [*c]u8) [*c]u8;
pub extern fn tempnam(__dir: [*c]const u8, __pfx: [*c]const u8) [*c]u8;
pub extern fn fflush(__stream: [*c]FILE) c_int;
pub extern fn fflush_unlocked(__stream: [*c]FILE) c_int;
pub extern fn fopen(noalias __filename: [*c]const u8, noalias __modes: [*c]const u8) [*c]FILE;
pub extern fn freopen(noalias __filename: [*c]const u8, noalias __modes: [*c]const u8, noalias __stream: [*c]FILE) [*c]FILE;
pub extern fn fdopen(__fd: c_int, __modes: [*c]const u8) [*c]FILE;
pub extern fn fopencookie(noalias __magic_cookie: ?*anyopaque, noalias __modes: [*c]const u8, __io_funcs: cookie_io_functions_t) [*c]FILE;
pub extern fn fmemopen(__s: ?*anyopaque, __len: usize, __modes: [*c]const u8) [*c]FILE;
pub extern fn open_memstream(__bufloc: [*c][*c]u8, __sizeloc: [*c]usize) [*c]FILE;
pub extern fn setbuf(noalias __stream: [*c]FILE, noalias __buf: [*c]u8) void;
pub extern fn setvbuf(noalias __stream: [*c]FILE, noalias __buf: [*c]u8, __modes: c_int, __n: usize) c_int;
pub extern fn setbuffer(noalias __stream: [*c]FILE, noalias __buf: [*c]u8, __size: usize) void;
pub extern fn setlinebuf(__stream: [*c]FILE) void;
pub extern fn fprintf(noalias __stream: [*c]FILE, noalias __format: [*c]const u8, ...) c_int;
pub extern fn printf(noalias __format: [*c]const u8, ...) c_int;
pub extern fn sprintf(noalias __s: [*c]u8, noalias __format: [*c]const u8, ...) c_int;
pub extern fn vfprintf(noalias __s: [*c]FILE, noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn vprintf(noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn vsprintf(noalias __s: [*c]u8, noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn snprintf(noalias __s: [*c]u8, __maxlen: usize, noalias __format: [*c]const u8, ...) c_int;
pub extern fn vsnprintf(noalias __s: [*c]u8, __maxlen: usize, noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn vasprintf(noalias __ptr: [*c][*c]u8, noalias __f: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn __asprintf(noalias __ptr: [*c][*c]u8, noalias __fmt: [*c]const u8, ...) c_int;
pub extern fn asprintf(noalias __ptr: [*c][*c]u8, noalias __fmt: [*c]const u8, ...) c_int;
pub extern fn vdprintf(__fd: c_int, noalias __fmt: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn dprintf(__fd: c_int, noalias __fmt: [*c]const u8, ...) c_int;
pub extern fn fscanf(noalias __stream: [*c]FILE, noalias __format: [*c]const u8, ...) c_int;
pub extern fn scanf(noalias __format: [*c]const u8, ...) c_int;
pub extern fn sscanf(noalias __s: [*c]const u8, noalias __format: [*c]const u8, ...) c_int;
pub extern fn vfscanf(noalias __s: [*c]FILE, noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn vscanf(noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn vsscanf(noalias __s: [*c]const u8, noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag_1) c_int;
pub extern fn fgetc(__stream: [*c]FILE) c_int;
pub extern fn getc(__stream: [*c]FILE) c_int;
pub extern fn getchar() c_int;
pub extern fn getc_unlocked(__stream: [*c]FILE) c_int;
pub extern fn getchar_unlocked() c_int;
pub extern fn fgetc_unlocked(__stream: [*c]FILE) c_int;
pub extern fn fputc(__c: c_int, __stream: [*c]FILE) c_int;
pub extern fn putc(__c: c_int, __stream: [*c]FILE) c_int;
pub extern fn putchar(__c: c_int) c_int;
pub extern fn fputc_unlocked(__c: c_int, __stream: [*c]FILE) c_int;
pub extern fn putc_unlocked(__c: c_int, __stream: [*c]FILE) c_int;
pub extern fn putchar_unlocked(__c: c_int) c_int;
pub extern fn getw(__stream: [*c]FILE) c_int;
pub extern fn putw(__w: c_int, __stream: [*c]FILE) c_int;
pub extern fn fgets(noalias __s: [*c]u8, __n: c_int, noalias __stream: [*c]FILE) [*c]u8;
pub extern fn __getdelim(noalias __lineptr: [*c][*c]u8, noalias __n: [*c]usize, __delimiter: c_int, noalias __stream: [*c]FILE) __ssize_t;
pub extern fn getdelim(noalias __lineptr: [*c][*c]u8, noalias __n: [*c]usize, __delimiter: c_int, noalias __stream: [*c]FILE) __ssize_t;
pub extern fn getline(noalias __lineptr: [*c][*c]u8, noalias __n: [*c]usize, noalias __stream: [*c]FILE) __ssize_t;
pub extern fn fputs(noalias __s: [*c]const u8, noalias __stream: [*c]FILE) c_int;
pub extern fn puts(__s: [*c]const u8) c_int;
pub extern fn ungetc(__c: c_int, __stream: [*c]FILE) c_int;
pub extern fn fread(noalias __ptr: ?*anyopaque, __size: usize, __n: usize, noalias __stream: [*c]FILE) usize;
pub extern fn fwrite(noalias __ptr: ?*const anyopaque, __size: usize, __n: usize, noalias __s: [*c]FILE) usize;
pub extern fn fread_unlocked(noalias __ptr: ?*anyopaque, __size: usize, __n: usize, noalias __stream: [*c]FILE) usize;
pub extern fn fwrite_unlocked(noalias __ptr: ?*const anyopaque, __size: usize, __n: usize, noalias __stream: [*c]FILE) usize;
pub extern fn fseek(__stream: [*c]FILE, __off: c_long, __whence: c_int) c_int;
pub extern fn ftell(__stream: [*c]FILE) c_long;
pub extern fn rewind(__stream: [*c]FILE) void;
pub extern fn fseeko(__stream: [*c]FILE, __off: __off_t, __whence: c_int) c_int;
pub extern fn ftello(__stream: [*c]FILE) __off_t;
pub extern fn fgetpos(noalias __stream: [*c]FILE, noalias __pos: [*c]fpos_t) c_int;
pub extern fn fsetpos(__stream: [*c]FILE, __pos: [*c]const fpos_t) c_int;
pub extern fn clearerr(__stream: [*c]FILE) void;
pub extern fn feof(__stream: [*c]FILE) c_int;
pub extern fn ferror(__stream: [*c]FILE) c_int;
pub extern fn clearerr_unlocked(__stream: [*c]FILE) void;
pub extern fn feof_unlocked(__stream: [*c]FILE) c_int;
pub extern fn ferror_unlocked(__stream: [*c]FILE) c_int;
pub extern fn perror(__s: [*c]const u8) void;
pub extern fn fileno(__stream: [*c]FILE) c_int;
pub extern fn fileno_unlocked(__stream: [*c]FILE) c_int;
pub extern fn pclose(__stream: [*c]FILE) c_int;
pub extern fn popen(__command: [*c]const u8, __modes: [*c]const u8) [*c]FILE;
pub extern fn ctermid(__s: [*c]u8) [*c]u8;
pub extern fn flockfile(__stream: [*c]FILE) void;
pub extern fn ftrylockfile(__stream: [*c]FILE) c_int;
pub extern fn funlockfile(__stream: [*c]FILE) void;
pub extern fn __uflow([*c]FILE) c_int;
pub extern fn __overflow([*c]FILE, c_int) c_int;
pub const int_least8_t = __int_least8_t;
pub const int_least16_t = __int_least16_t;
pub const int_least32_t = __int_least32_t;
pub const int_least64_t = __int_least64_t;
pub const uint_least8_t = __uint_least8_t;
pub const uint_least16_t = __uint_least16_t;
pub const uint_least32_t = __uint_least32_t;
pub const uint_least64_t = __uint_least64_t;
pub const int_fast8_t = i8;
pub const int_fast16_t = c_long;
pub const int_fast32_t = c_long;
pub const int_fast64_t = c_long;
pub const uint_fast8_t = u8;
pub const uint_fast16_t = c_ulong;
pub const uint_fast32_t = c_ulong;
pub const uint_fast64_t = c_ulong;
pub const intmax_t = __intmax_t;
pub const uintmax_t = __uintmax_t;
pub const div_t = extern struct {
    quot: c_int = 0,
    rem: c_int = 0,
};
pub const ldiv_t = extern struct {
    quot: c_long = 0,
    rem: c_long = 0,
};
pub const lldiv_t = extern struct {
    quot: c_longlong = 0,
    rem: c_longlong = 0,
};
pub extern fn __ctype_get_mb_cur_max() usize;
pub extern fn atof(__nptr: [*c]const u8) f64;
pub extern fn atoi(__nptr: [*c]const u8) c_int;
pub extern fn atol(__nptr: [*c]const u8) c_long;
pub extern fn atoll(__nptr: [*c]const u8) c_longlong;
pub extern fn strtod(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8) f64;
pub extern fn strtof(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8) f32;
pub extern fn strtold(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8) c_longdouble;
pub extern fn strtol(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8, __base: c_int) c_long;
pub extern fn strtoul(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8, __base: c_int) c_ulong;
pub extern fn strtoq(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8, __base: c_int) c_longlong;
pub extern fn strtouq(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8, __base: c_int) c_ulonglong;
pub extern fn strtoll(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8, __base: c_int) c_longlong;
pub extern fn strtoull(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8, __base: c_int) c_ulonglong;
pub extern fn l64a(__n: c_long) [*c]u8;
pub extern fn a64l(__s: [*c]const u8) c_long;
pub const u_char = __u_char;
pub const u_short = __u_short;
pub const u_int = __u_int;
pub const u_long = __u_long;
pub const quad_t = __quad_t;
pub const u_quad_t = __u_quad_t;
pub const fsid_t = __fsid_t;
pub const loff_t = __loff_t;
pub const ino_t = __ino_t;
pub const dev_t = __dev_t;
pub const gid_t = __gid_t;
pub const mode_t = __mode_t;
pub const nlink_t = __nlink_t;
pub const uid_t = __uid_t;
pub const pid_t = __pid_t;
pub const id_t = __id_t;
pub const daddr_t = __daddr_t;
pub const caddr_t = __caddr_t;
pub const key_t = __key_t;
pub const clock_t = __clock_t;
pub const clockid_t = __clockid_t;
pub const time_t = __time_t;
pub const timer_t = __timer_t;
pub const ulong = c_ulong;
pub const ushort = c_ushort;
pub const uint = c_uint;
pub const u_int8_t = __uint8_t;
pub const u_int16_t = __uint16_t;
pub const u_int32_t = __uint32_t;
pub const u_int64_t = __uint64_t;
pub const register_t = c_int;
pub fn __bswap_16(arg___bsx: __uint16_t) callconv(.c) __uint16_t {
    var __bsx = arg___bsx;
    _ = &__bsx;
    return @byteSwap(@as(__uint16_t, __bsx));
}
pub fn __bswap_32(arg___bsx: __uint32_t) callconv(.c) __uint32_t {
    var __bsx = arg___bsx;
    _ = &__bsx;
    return @bitCast(@as(c_int, @byteSwap(@as(c_int, @bitCast(@as(c_uint, @truncate(__bsx)))))));
}
pub fn __bswap_64(arg___bsx: __uint64_t) callconv(.c) __uint64_t {
    var __bsx = arg___bsx;
    _ = &__bsx;
    return @bitCast(@as(c_long, @byteSwap(@as(c_long, @bitCast(@as(c_ulong, @truncate(__bsx)))))));
}
pub fn __uint16_identity(arg___x: __uint16_t) callconv(.c) __uint16_t {
    var __x = arg___x;
    _ = &__x;
    return __x;
}
pub fn __uint32_identity(arg___x: __uint32_t) callconv(.c) __uint32_t {
    var __x = arg___x;
    _ = &__x;
    return __x;
}
pub fn __uint64_identity(arg___x: __uint64_t) callconv(.c) __uint64_t {
    var __x = arg___x;
    _ = &__x;
    return __x;
}
pub const sigset_t = __sigset_t;
pub const struct_timeval = extern struct {
    tv_sec: __time_t = 0,
    tv_usec: __suseconds_t = 0,
};
pub const struct_timespec = extern struct {
    tv_sec: __time_t = 0,
    tv_nsec: __syscall_slong_t = 0,
};
pub const suseconds_t = __suseconds_t;
pub const __fd_mask = c_long;
pub const fd_set = extern struct {
    __fds_bits: [16]__fd_mask = @import("std").mem.zeroes([16]__fd_mask),
};
pub const fd_mask = __fd_mask;
pub extern fn select(__nfds: c_int, noalias __readfds: [*c]fd_set, noalias __writefds: [*c]fd_set, noalias __exceptfds: [*c]fd_set, noalias __timeout: [*c]struct_timeval) c_int;
pub extern fn pselect(__nfds: c_int, noalias __readfds: [*c]fd_set, noalias __writefds: [*c]fd_set, noalias __exceptfds: [*c]fd_set, noalias __timeout: [*c]const struct_timespec, noalias __sigmask: [*c]const __sigset_t) c_int;
pub const blksize_t = __blksize_t;
pub const blkcnt_t = __blkcnt_t;
pub const fsblkcnt_t = __fsblkcnt_t;
pub const fsfilcnt_t = __fsfilcnt_t;
const struct_unnamed_3 = extern struct {
    __low: c_uint = 0,
    __high: c_uint = 0,
};
pub const __atomic_wide_counter = extern union {
    __value64: c_ulonglong,
    __value32: struct_unnamed_3,
};
pub const struct___pthread_internal_list = extern struct {
    __prev: [*c]struct___pthread_internal_list = null,
    __next: [*c]struct___pthread_internal_list = null,
};
pub const __pthread_list_t = struct___pthread_internal_list;
pub const struct___pthread_internal_slist = extern struct {
    __next: [*c]struct___pthread_internal_slist = null,
};
pub const __pthread_slist_t = struct___pthread_internal_slist;
pub const struct___pthread_mutex_s = extern struct {
    __lock: c_int = 0,
    __count: c_uint = 0,
    __owner: c_int = 0,
    __nusers: c_uint = 0,
    __kind: c_int = 0,
    __spins: c_short = 0,
    __elision: c_short = 0,
    __list: __pthread_list_t = @import("std").mem.zeroes(__pthread_list_t),
};
pub const struct___pthread_rwlock_arch_t = extern struct {
    __readers: c_uint = 0,
    __writers: c_uint = 0,
    __wrphase_futex: c_uint = 0,
    __writers_futex: c_uint = 0,
    __pad3: c_uint = 0,
    __pad4: c_uint = 0,
    __cur_writer: c_int = 0,
    __shared: c_int = 0,
    __rwelision: i8 = 0,
    __pad1: [7]u8 = @import("std").mem.zeroes([7]u8),
    __pad2: c_ulong = 0,
    __flags: c_uint = 0,
};
pub const struct___pthread_cond_s = extern struct {
    __wseq: __atomic_wide_counter = @import("std").mem.zeroes(__atomic_wide_counter),
    __g1_start: __atomic_wide_counter = @import("std").mem.zeroes(__atomic_wide_counter),
    __g_refs: [2]c_uint = @import("std").mem.zeroes([2]c_uint),
    __g_size: [2]c_uint = @import("std").mem.zeroes([2]c_uint),
    __g1_orig_size: c_uint = 0,
    __wrefs: c_uint = 0,
    __g_signals: [2]c_uint = @import("std").mem.zeroes([2]c_uint),
};
pub const __tss_t = c_uint;
pub const __thrd_t = c_ulong;
pub const __once_flag = extern struct {
    __data: c_int = 0,
};
pub const pthread_t = c_ulong;
pub const pthread_mutexattr_t = extern union {
    __size: [4]u8,
    __align: c_int,
};
pub const pthread_condattr_t = extern union {
    __size: [4]u8,
    __align: c_int,
};
pub const pthread_key_t = c_uint;
pub const pthread_once_t = c_int;
pub const union_pthread_attr_t = extern union {
    __size: [56]u8,
    __align: c_long,
};
pub const pthread_attr_t = union_pthread_attr_t;
pub const pthread_mutex_t = extern union {
    __data: struct___pthread_mutex_s,
    __size: [40]u8,
    __align: c_long,
};
pub const pthread_cond_t = extern union {
    __data: struct___pthread_cond_s,
    __size: [48]u8,
    __align: c_longlong,
};
pub const pthread_rwlock_t = extern union {
    __data: struct___pthread_rwlock_arch_t,
    __size: [56]u8,
    __align: c_long,
};
pub const pthread_rwlockattr_t = extern union {
    __size: [8]u8,
    __align: c_long,
};
pub const pthread_spinlock_t = c_int;
pub const pthread_barrier_t = extern union {
    __size: [32]u8,
    __align: c_long,
};
pub const pthread_barrierattr_t = extern union {
    __size: [4]u8,
    __align: c_int,
};
pub extern fn random() c_long;
pub extern fn srandom(__seed: c_uint) void;
pub extern fn initstate(__seed: c_uint, __statebuf: [*c]u8, __statelen: usize) [*c]u8;
pub extern fn setstate(__statebuf: [*c]u8) [*c]u8;
pub const struct_random_data = extern struct {
    fptr: [*c]i32 = null,
    rptr: [*c]i32 = null,
    state: [*c]i32 = null,
    rand_type: c_int = 0,
    rand_deg: c_int = 0,
    rand_sep: c_int = 0,
    end_ptr: [*c]i32 = null,
    pub const random_r = __root.random_r;
    pub const r = __root.random_r;
};
pub extern fn random_r(noalias __buf: [*c]struct_random_data, noalias __result: [*c]i32) c_int;
pub extern fn srandom_r(__seed: c_uint, __buf: [*c]struct_random_data) c_int;
pub extern fn initstate_r(__seed: c_uint, noalias __statebuf: [*c]u8, __statelen: usize, noalias __buf: [*c]struct_random_data) c_int;
pub extern fn setstate_r(noalias __statebuf: [*c]u8, noalias __buf: [*c]struct_random_data) c_int;
pub extern fn rand() c_int;
pub extern fn srand(__seed: c_uint) void;
pub extern fn rand_r(__seed: [*c]c_uint) c_int;
pub extern fn drand48() f64;
pub extern fn erand48(__xsubi: [*c]c_ushort) f64;
pub extern fn lrand48() c_long;
pub extern fn nrand48(__xsubi: [*c]c_ushort) c_long;
pub extern fn mrand48() c_long;
pub extern fn jrand48(__xsubi: [*c]c_ushort) c_long;
pub extern fn srand48(__seedval: c_long) void;
pub extern fn seed48(__seed16v: [*c]c_ushort) [*c]c_ushort;
pub extern fn lcong48(__param: [*c]c_ushort) void;
pub const struct_drand48_data = extern struct {
    __x: [3]c_ushort = @import("std").mem.zeroes([3]c_ushort),
    __old_x: [3]c_ushort = @import("std").mem.zeroes([3]c_ushort),
    __c: c_ushort = 0,
    __init: c_ushort = 0,
    __a: c_ulonglong = 0,
    pub const drand48_r = __root.drand48_r;
    pub const lrand48_r = __root.lrand48_r;
    pub const mrand48_r = __root.mrand48_r;
    pub const r = __root.drand48_r;
};
pub extern fn drand48_r(noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]f64) c_int;
pub extern fn erand48_r(__xsubi: [*c]c_ushort, noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]f64) c_int;
pub extern fn lrand48_r(noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]c_long) c_int;
pub extern fn nrand48_r(__xsubi: [*c]c_ushort, noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]c_long) c_int;
pub extern fn mrand48_r(noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]c_long) c_int;
pub extern fn jrand48_r(__xsubi: [*c]c_ushort, noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]c_long) c_int;
pub extern fn srand48_r(__seedval: c_long, __buffer: [*c]struct_drand48_data) c_int;
pub extern fn seed48_r(__seed16v: [*c]c_ushort, __buffer: [*c]struct_drand48_data) c_int;
pub extern fn lcong48_r(__param: [*c]c_ushort, __buffer: [*c]struct_drand48_data) c_int;
pub extern fn arc4random() __uint32_t;
pub extern fn arc4random_buf(__buf: ?*anyopaque, __size: usize) void;
pub extern fn arc4random_uniform(__upper_bound: __uint32_t) __uint32_t;
pub extern fn malloc(__size: usize) ?*anyopaque;
pub extern fn calloc(__nmemb: usize, __size: usize) ?*anyopaque;
pub extern fn realloc(__ptr: ?*anyopaque, __size: usize) ?*anyopaque;
pub extern fn free(__ptr: ?*anyopaque) void;
pub extern fn reallocarray(__ptr: ?*anyopaque, __nmemb: usize, __size: usize) ?*anyopaque;
pub extern fn alloca(__size: usize) ?*anyopaque;
pub extern fn valloc(__size: usize) ?*anyopaque;
pub extern fn posix_memalign(__memptr: [*c]?*anyopaque, __alignment: usize, __size: usize) c_int;
pub extern fn aligned_alloc(__alignment: usize, __size: usize) ?*anyopaque;
pub extern fn abort() noreturn;
pub extern fn atexit(__func: ?*const fn () callconv(.c) void) c_int;
pub extern fn at_quick_exit(__func: ?*const fn () callconv(.c) void) c_int;
pub extern fn on_exit(__func: ?*const fn (__status: c_int, __arg: ?*anyopaque) callconv(.c) void, __arg: ?*anyopaque) c_int;
pub extern fn exit(__status: c_int) noreturn;
pub extern fn quick_exit(__status: c_int) noreturn;
pub extern fn _Exit(__status: c_int) noreturn;
pub extern fn getenv(__name: [*c]const u8) [*c]u8;
pub extern fn putenv(__string: [*c]u8) c_int;
pub extern fn setenv(__name: [*c]const u8, __value: [*c]const u8, __replace: c_int) c_int;
pub extern fn unsetenv(__name: [*c]const u8) c_int;
pub extern fn clearenv() c_int;
pub extern fn mktemp(__template: [*c]u8) [*c]u8;
pub extern fn mkstemp(__template: [*c]u8) c_int;
pub extern fn mkstemps(__template: [*c]u8, __suffixlen: c_int) c_int;
pub extern fn mkdtemp(__template: [*c]u8) [*c]u8;
pub extern fn system(__command: [*c]const u8) c_int;
pub extern fn realpath(noalias __name: [*c]const u8, noalias __resolved: [*c]u8) [*c]u8;
pub const __compar_fn_t = ?*const fn (?*const anyopaque, ?*const anyopaque) callconv(.c) c_int;
pub extern fn bsearch(__key: ?*const anyopaque, __base: ?*const anyopaque, __nmemb: usize, __size: usize, __compar: __compar_fn_t) ?*anyopaque;
pub extern fn qsort(__base: ?*anyopaque, __nmemb: usize, __size: usize, __compar: __compar_fn_t) void;
pub extern fn abs(__x: c_int) c_int;
pub extern fn labs(__x: c_long) c_long;
pub extern fn llabs(__x: c_longlong) c_longlong;
pub extern fn div(__numer: c_int, __denom: c_int) div_t;
pub extern fn ldiv(__numer: c_long, __denom: c_long) ldiv_t;
pub extern fn lldiv(__numer: c_longlong, __denom: c_longlong) lldiv_t;
pub extern fn ecvt(__value: f64, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int) [*c]u8;
pub extern fn fcvt(__value: f64, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int) [*c]u8;
pub extern fn gcvt(__value: f64, __ndigit: c_int, __buf: [*c]u8) [*c]u8;
pub extern fn qecvt(__value: c_longdouble, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int) [*c]u8;
pub extern fn qfcvt(__value: c_longdouble, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int) [*c]u8;
pub extern fn qgcvt(__value: c_longdouble, __ndigit: c_int, __buf: [*c]u8) [*c]u8;
pub extern fn ecvt_r(__value: f64, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int, noalias __buf: [*c]u8, __len: usize) c_int;
pub extern fn fcvt_r(__value: f64, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int, noalias __buf: [*c]u8, __len: usize) c_int;
pub extern fn qecvt_r(__value: c_longdouble, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int, noalias __buf: [*c]u8, __len: usize) c_int;
pub extern fn qfcvt_r(__value: c_longdouble, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int, noalias __buf: [*c]u8, __len: usize) c_int;
pub extern fn mblen(__s: [*c]const u8, __n: usize) c_int;
pub extern fn mbtowc(noalias __pwc: [*c]wchar_t, noalias __s: [*c]const u8, __n: usize) c_int;
pub extern fn wctomb(__s: [*c]u8, __wchar: wchar_t) c_int;
pub extern fn mbstowcs(noalias __pwcs: [*c]wchar_t, noalias __s: [*c]const u8, __n: usize) usize;
pub extern fn wcstombs(noalias __s: [*c]u8, noalias __pwcs: [*c]const wchar_t, __n: usize) usize;
pub extern fn rpmatch(__response: [*c]const u8) c_int;
pub extern fn getsubopt(noalias __optionp: [*c][*c]u8, noalias __tokens: [*c]const [*c]u8, noalias __valuep: [*c][*c]u8) c_int;
pub extern fn getloadavg(__loadavg: [*c]f64, __nelem: c_int) c_int;
pub extern fn memcpy(noalias __dest: ?*anyopaque, noalias __src: ?*const anyopaque, __n: usize) ?*anyopaque;
pub extern fn memmove(__dest: ?*anyopaque, __src: ?*const anyopaque, __n: usize) ?*anyopaque;
pub extern fn memccpy(noalias __dest: ?*anyopaque, noalias __src: ?*const anyopaque, __c: c_int, __n: usize) ?*anyopaque;
pub extern fn memset(__s: ?*anyopaque, __c: c_int, __n: usize) ?*anyopaque;
pub extern fn memcmp(__s1: ?*const anyopaque, __s2: ?*const anyopaque, __n: usize) c_int;
pub extern fn __memcmpeq(__s1: ?*const anyopaque, __s2: ?*const anyopaque, __n: usize) c_int;
pub extern fn memchr(__s: ?*const anyopaque, __c: c_int, __n: usize) ?*anyopaque;
pub extern fn strcpy(noalias __dest: [*c]u8, noalias __src: [*c]const u8) [*c]u8;
pub extern fn strncpy(noalias __dest: [*c]u8, noalias __src: [*c]const u8, __n: usize) [*c]u8;
pub extern fn strcat(noalias __dest: [*c]u8, noalias __src: [*c]const u8) [*c]u8;
pub extern fn strncat(noalias __dest: [*c]u8, noalias __src: [*c]const u8, __n: usize) [*c]u8;
pub extern fn strcmp(__s1: [*c]const u8, __s2: [*c]const u8) c_int;
pub extern fn strncmp(__s1: [*c]const u8, __s2: [*c]const u8, __n: usize) c_int;
pub extern fn strcoll(__s1: [*c]const u8, __s2: [*c]const u8) c_int;
pub extern fn strxfrm(noalias __dest: [*c]u8, noalias __src: [*c]const u8, __n: usize) usize;
pub const struct___locale_data_4 = opaque {};
pub const struct___locale_struct = extern struct {
    __locales: [13]?*struct___locale_data_4 = @import("std").mem.zeroes([13]?*struct___locale_data_4),
    __ctype_b: [*c]const c_ushort = null,
    __ctype_tolower: [*c]const c_int = null,
    __ctype_toupper: [*c]const c_int = null,
    __names: [13][*c]const u8 = @import("std").mem.zeroes([13][*c]const u8),
};
pub const __locale_t = [*c]struct___locale_struct;
pub const locale_t = __locale_t;
pub extern fn strcoll_l(__s1: [*c]const u8, __s2: [*c]const u8, __l: locale_t) c_int;
pub extern fn strxfrm_l(__dest: [*c]u8, __src: [*c]const u8, __n: usize, __l: locale_t) usize;
pub extern fn strdup(__s: [*c]const u8) [*c]u8;
pub extern fn strndup(__string: [*c]const u8, __n: usize) [*c]u8;
pub extern fn strchr(__s: [*c]const u8, __c: c_int) [*c]u8;
pub extern fn strrchr(__s: [*c]const u8, __c: c_int) [*c]u8;
pub extern fn strchrnul(__s: [*c]const u8, __c: c_int) [*c]u8;
pub extern fn strcspn(__s: [*c]const u8, __reject: [*c]const u8) usize;
pub extern fn strspn(__s: [*c]const u8, __accept: [*c]const u8) usize;
pub extern fn strpbrk(__s: [*c]const u8, __accept: [*c]const u8) [*c]u8;
pub extern fn strstr(__haystack: [*c]const u8, __needle: [*c]const u8) [*c]u8;
pub extern fn strtok(noalias __s: [*c]u8, noalias __delim: [*c]const u8) [*c]u8;
pub extern fn __strtok_r(noalias __s: [*c]u8, noalias __delim: [*c]const u8, noalias __save_ptr: [*c][*c]u8) [*c]u8;
pub extern fn strtok_r(noalias __s: [*c]u8, noalias __delim: [*c]const u8, noalias __save_ptr: [*c][*c]u8) [*c]u8;
pub extern fn strcasestr(__haystack: [*c]const u8, __needle: [*c]const u8) [*c]u8;
pub extern fn memmem(__haystack: ?*const anyopaque, __haystacklen: usize, __needle: ?*const anyopaque, __needlelen: usize) ?*anyopaque;
pub extern fn __mempcpy(noalias __dest: ?*anyopaque, noalias __src: ?*const anyopaque, __n: usize) ?*anyopaque;
pub extern fn mempcpy(noalias __dest: ?*anyopaque, noalias __src: ?*const anyopaque, __n: usize) ?*anyopaque;
pub extern fn strlen(__s: [*c]const u8) usize;
pub extern fn strnlen(__string: [*c]const u8, __maxlen: usize) usize;
pub extern fn strerror(__errnum: c_int) [*c]u8;
pub extern fn strerror_r(__errnum: c_int, __buf: [*c]u8, __buflen: usize) c_int;
pub extern fn strerror_l(__errnum: c_int, __l: locale_t) [*c]u8;
pub extern fn bcmp(__s1: ?*const anyopaque, __s2: ?*const anyopaque, __n: usize) c_int;
pub extern fn bcopy(__src: ?*const anyopaque, __dest: ?*anyopaque, __n: usize) void;
pub extern fn bzero(__s: ?*anyopaque, __n: usize) void;
pub extern fn index(__s: [*c]const u8, __c: c_int) [*c]u8;
pub extern fn rindex(__s: [*c]const u8, __c: c_int) [*c]u8;
pub extern fn ffs(__i: c_int) c_int;
pub extern fn ffsl(__l: c_long) c_int;
pub extern fn ffsll(__ll: c_longlong) c_int;
pub extern fn strcasecmp(__s1: [*c]const u8, __s2: [*c]const u8) c_int;
pub extern fn strncasecmp(__s1: [*c]const u8, __s2: [*c]const u8, __n: usize) c_int;
pub extern fn strcasecmp_l(__s1: [*c]const u8, __s2: [*c]const u8, __loc: locale_t) c_int;
pub extern fn strncasecmp_l(__s1: [*c]const u8, __s2: [*c]const u8, __n: usize, __loc: locale_t) c_int;
pub extern fn explicit_bzero(__s: ?*anyopaque, __n: usize) void;
pub extern fn strsep(noalias __stringp: [*c][*c]u8, noalias __delim: [*c]const u8) [*c]u8;
pub extern fn strsignal(__sig: c_int) [*c]u8;
pub extern fn __stpcpy(noalias __dest: [*c]u8, noalias __src: [*c]const u8) [*c]u8;
pub extern fn stpcpy(noalias __dest: [*c]u8, noalias __src: [*c]const u8) [*c]u8;
pub extern fn __stpncpy(noalias __dest: [*c]u8, noalias __src: [*c]const u8, __n: usize) [*c]u8;
pub extern fn stpncpy(noalias __dest: [*c]u8, noalias __src: [*c]const u8, __n: usize) [*c]u8;
pub extern fn strlcpy(noalias __dest: [*c]u8, noalias __src: [*c]const u8, __n: usize) usize;
pub extern fn strlcat(noalias __dest: [*c]u8, noalias __src: [*c]const u8, __n: usize) usize;
pub extern fn Memento_checkBlock(?*anyopaque) c_int;
pub extern fn Memento_checkAllMemory() c_int;
pub extern fn Memento_check() c_int;
pub extern fn Memento_setParanoia(c_int) c_int;
pub extern fn Memento_paranoidAt(c_int) c_int;
pub extern fn Memento_breakAt(c_int) c_int;
pub extern fn Memento_breakOnFree(a: ?*anyopaque) void;
pub extern fn Memento_breakOnRealloc(a: ?*anyopaque) void;
pub extern fn Memento_getBlockNum(?*anyopaque) c_int;
pub extern fn Memento_find(a: ?*anyopaque) c_int;
pub extern fn Memento_breakpoint() void;
pub extern fn Memento_failAt(c_int) c_int;
pub extern fn Memento_failThisEvent() c_int;
pub extern fn Memento_listBlocks() void;
pub extern fn Memento_listNewBlocks() void;
pub extern fn Memento_listPhasedBlocks() void;
pub extern fn Memento_setMax(usize) usize;
pub extern fn Memento_stats() void;
pub extern fn Memento_label(?*anyopaque, [*c]const u8) ?*anyopaque;
pub extern fn Memento_tick() void;
pub extern fn Memento_setVerbose(c_int) c_int;
pub extern fn Memento_addBacktraceLimitFnname(fnname: [*c]const u8) c_int;
pub extern fn Memento_setAtexitFin(atexitfin: c_int) c_int;
pub extern fn Memento_setIgnoreNewDelete(ignore: c_int) c_int;
pub extern fn Memento_malloc(s: usize) ?*anyopaque;
pub extern fn Memento_realloc(?*anyopaque, s: usize) ?*anyopaque;
pub extern fn Memento_free(?*anyopaque) void;
pub extern fn Memento_calloc(usize, usize) ?*anyopaque;
pub extern fn Memento_strdup([*c]const u8) [*c]u8;
pub extern fn Memento_asprintf(ret: [*c][*c]u8, format: [*c]const u8, ...) c_int;
pub extern fn Memento_vasprintf(ret: [*c][*c]u8, format: [*c]const u8, ap: [*c]struct___va_list_tag_1) c_int;
pub extern fn Memento_info(addr: ?*anyopaque) void;
pub extern fn Memento_listBlockInfo() void;
pub extern fn Memento_blockInfo(blk: ?*anyopaque) void;
pub extern fn Memento_takeByteRef(blk: ?*anyopaque) ?*anyopaque;
pub extern fn Memento_dropByteRef(blk: ?*anyopaque) ?*anyopaque;
pub extern fn Memento_takeShortRef(blk: ?*anyopaque) ?*anyopaque;
pub extern fn Memento_dropShortRef(blk: ?*anyopaque) ?*anyopaque;
pub extern fn Memento_takeIntRef(blk: ?*anyopaque) ?*anyopaque;
pub extern fn Memento_dropIntRef(blk: ?*anyopaque) ?*anyopaque;
pub extern fn Memento_takeRef(blk: ?*anyopaque) ?*anyopaque;
pub extern fn Memento_dropRef(blk: ?*anyopaque) ?*anyopaque;
pub extern fn Memento_adjustRef(blk: ?*anyopaque, adjust: c_int) ?*anyopaque;
pub extern fn Memento_reference(blk: ?*anyopaque) ?*anyopaque;
pub extern fn Memento_checkPointerOrNull(blk: ?*anyopaque) c_int;
pub extern fn Memento_checkBytePointerOrNull(blk: ?*anyopaque) c_int;
pub extern fn Memento_checkShortPointerOrNull(blk: ?*anyopaque) c_int;
pub extern fn Memento_checkIntPointerOrNull(blk: ?*anyopaque) c_int;
pub extern fn Memento_startLeaking() void;
pub extern fn Memento_stopLeaking() void;
pub extern fn Memento_sequence() c_int;
pub extern fn Memento_squeezing() c_int;
pub extern fn Memento_fin() void;
pub extern fn Memento_bt() void;
pub extern fn Memento_cpp_new(size: usize) ?*anyopaque;
pub extern fn Memento_cpp_delete(pointer: ?*anyopaque) void;
pub extern fn Memento_cpp_new_array(size: usize) ?*anyopaque;
pub extern fn Memento_cpp_delete_array(pointer: ?*anyopaque) void;
pub extern fn Memento_showHash(hash: c_uint) void;
pub const fz_jmp_buf = sigjmp_buf;
pub extern fn fz_stat_ctime(path: [*c]const u8) i64;
pub extern fn fz_stat_mtime(path: [*c]const u8) i64;
pub fn fz_is_pow2(arg_a: c_int) callconv(.c) c_int {
    var a = arg_a;
    _ = &a;
    return @intFromBool((a != @as(c_int, 0)) and ((a & (a - @as(c_int, 1))) == @as(c_int, 0)));
}
pub extern fn __assert_fail(__assertion: [*c]const u8, __file: [*c]const u8, __line: c_uint, __function: [*c]const u8) noreturn;
pub extern fn __assert_perror_fail(__errnum: c_int, __file: [*c]const u8, __line: c_uint, __function: [*c]const u8) noreturn;
pub extern fn __assert(__assertion: [*c]const u8, __file: [*c]const u8, __line: c_int) noreturn;
pub fn fz_mul255(arg_a: c_int, arg_b: c_int) callconv(.c) c_int {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    var x: c_int = (a * b) + @as(c_int, 128);
    _ = &x;
    x += x >> @intCast(@as(c_int, 8));
    return x >> @intCast(@as(c_int, 8));
}
pub fn fz_div255(arg_c: c_int, arg_a: c_int) callconv(.c) c_int {
    var c = arg_c;
    _ = &c;
    var a = arg_a;
    _ = &a;
    return if (a != 0) (c * @divTrunc(@as(c_int, 255) * @as(c_int, 256), a)) >> @intCast(@as(c_int, 8)) else @as(c_int, 0);
}
pub extern fn fz_atof(s: [*c]const u8) f32;
pub extern fn fz_atoi(s: [*c]const u8) c_int;
pub extern fn fz_atoi64(s: [*c]const u8) i64;
pub fn fz_abs(arg_f: f32) callconv(.c) f32 {
    var f = arg_f;
    _ = &f;
    return if (f < @as(f32, @floatFromInt(@as(c_int, 0)))) -f else f;
}
pub fn fz_absi(arg_i: c_int) callconv(.c) c_int {
    var i = arg_i;
    _ = &i;
    return if (i < @as(c_int, 0)) -i else i;
}
pub fn fz_min(arg_a: f32, arg_b: f32) callconv(.c) f32 {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    return if (a < b) a else b;
}
pub fn fz_mini(arg_a: c_int, arg_b: c_int) callconv(.c) c_int {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    return if (a < b) a else b;
}
pub fn fz_minz(arg_a: usize, arg_b: usize) callconv(.c) usize {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    return if (a < b) a else b;
}
pub fn fz_mini64(arg_a: i64, arg_b: i64) callconv(.c) i64 {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    return if (a < b) a else b;
}
pub fn fz_max(arg_a: f32, arg_b: f32) callconv(.c) f32 {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    return if (a > b) a else b;
}
pub fn fz_maxi(arg_a: c_int, arg_b: c_int) callconv(.c) c_int {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    return if (a > b) a else b;
}
pub fn fz_maxz(arg_a: usize, arg_b: usize) callconv(.c) usize {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    return if (a > b) a else b;
}
pub fn fz_maxi64(arg_a: i64, arg_b: i64) callconv(.c) i64 {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    return if (a > b) a else b;
}
pub fn fz_clamp(arg_x: f32, arg_min: f32, arg_max: f32) callconv(.c) f32 {
    var x = arg_x;
    _ = &x;
    var min = arg_min;
    _ = &min;
    var max = arg_max;
    _ = &max;
    return if (x < min) min else if (x > max) max else x;
}
pub fn fz_clampi(arg_x: c_int, arg_min: c_int, arg_max: c_int) callconv(.c) c_int {
    var x = arg_x;
    _ = &x;
    var min = arg_min;
    _ = &min;
    var max = arg_max;
    _ = &max;
    return if (x < min) min else if (x > max) max else x;
}
pub fn fz_clamp64(arg_x: i64, arg_min: i64, arg_max: i64) callconv(.c) i64 {
    var x = arg_x;
    _ = &x;
    var min = arg_min;
    _ = &min;
    var max = arg_max;
    _ = &max;
    return if (x < min) min else if (x > max) max else x;
}
pub fn fz_clampd(arg_x: f64, arg_min: f64, arg_max: f64) callconv(.c) f64 {
    var x = arg_x;
    _ = &x;
    var min = arg_min;
    _ = &min;
    var max = arg_max;
    _ = &max;
    return if (x < min) min else if (x > max) max else x;
}
pub fn fz_clampp(arg_x: ?*anyopaque, arg_min: ?*anyopaque, arg_max: ?*anyopaque) callconv(.c) ?*anyopaque {
    var x = arg_x;
    _ = &x;
    var min = arg_min;
    _ = &min;
    var max = arg_max;
    _ = &max;
    return if (x < min) min else if (x > max) max else x;
}
pub const fz_point = extern struct {
    x: f32 = 0,
    y: f32 = 0,
    pub const fz_transform_point = __root.fz_transform_point;
    pub const fz_transform_vector = __root.fz_transform_vector;
    pub const fz_normalize_vector = __root.fz_normalize_vector;
    pub const fz_is_point_inside_quad = __root.fz_is_point_inside_quad;
    pub const fz_is_point_inside_rect = __root.fz_is_point_inside_rect;
    pub const point = __root.fz_transform_point;
    pub const vector = __root.fz_transform_vector;
    pub const quad = __root.fz_is_point_inside_quad;
    pub const rect = __root.fz_is_point_inside_rect;
};
pub fn fz_make_point(arg_x: f32, arg_y: f32) callconv(.c) fz_point {
    var x = arg_x;
    _ = &x;
    var y = arg_y;
    _ = &y;
    var p: fz_point = fz_point{
        .x = x,
        .y = y,
    };
    _ = &p;
    return p;
}
pub const fz_rect = extern struct {
    x0: f32 = 0,
    y0: f32 = 0,
    x1: f32 = 0,
    y1: f32 = 0,
    pub const fz_is_empty_rect = __root.fz_is_empty_rect;
    pub const fz_is_infinite_rect = __root.fz_is_infinite_rect;
    pub const fz_is_valid_rect = __root.fz_is_valid_rect;
    pub const fz_transform_page = __root.fz_transform_page;
    pub const fz_intersect_rect = __root.fz_intersect_rect;
    pub const fz_union_rect = __root.fz_union_rect;
    pub const fz_irect_from_rect = __root.fz_irect_from_rect;
    pub const fz_round_rect = __root.fz_round_rect;
    pub const fz_expand_rect = __root.fz_expand_rect;
    pub const fz_include_point_in_rect = __root.fz_include_point_in_rect;
    pub const fz_translate_rect = __root.fz_translate_rect;
    pub const fz_contains_rect = __root.fz_contains_rect;
    pub const fz_transform_rect = __root.fz_transform_rect;
    pub const fz_quad_from_rect = __root.fz_quad_from_rect;
    pub const rect = __root.fz_is_empty_rect;
    pub const page = __root.fz_transform_page;
};
pub fn fz_make_rect(arg_x0: f32, arg_y0: f32, arg_x1: f32, arg_y1: f32) callconv(.c) fz_rect {
    var x0 = arg_x0;
    _ = &x0;
    var y0 = arg_y0;
    _ = &y0;
    var x1 = arg_x1;
    _ = &x1;
    var y1 = arg_y1;
    _ = &y1;
    var r: fz_rect = fz_rect{
        .x0 = x0,
        .y0 = y0,
        .x1 = x1,
        .y1 = y1,
    };
    _ = &r;
    return r;
}
pub const fz_irect = extern struct {
    x0: c_int = 0,
    y0: c_int = 0,
    x1: c_int = 0,
    y1: c_int = 0,
    pub const fz_is_empty_irect = __root.fz_is_empty_irect;
    pub const fz_is_infinite_irect = __root.fz_is_infinite_irect;
    pub const fz_is_valid_irect = __root.fz_is_valid_irect;
    pub const fz_irect_width = __root.fz_irect_width;
    pub const fz_irect_height = __root.fz_irect_height;
    pub const fz_intersect_irect = __root.fz_intersect_irect;
    pub const fz_rect_from_irect = __root.fz_rect_from_irect;
    pub const fz_expand_irect = __root.fz_expand_irect;
    pub const fz_translate_irect = __root.fz_translate_irect;
    pub const irect = __root.fz_is_empty_irect;
    pub const width = __root.fz_irect_width;
    pub const height = __root.fz_irect_height;
};
pub fn fz_make_irect(arg_x0: c_int, arg_y0: c_int, arg_x1: c_int, arg_y1: c_int) callconv(.c) fz_irect {
    var x0 = arg_x0;
    _ = &x0;
    var y0 = arg_y0;
    _ = &y0;
    var x1 = arg_x1;
    _ = &x1;
    var y1 = arg_y1;
    _ = &y1;
    var r: fz_irect = fz_irect{
        .x0 = x0,
        .y0 = y0,
        .x1 = x1,
        .y1 = y1,
    };
    _ = &r;
    return r;
}
pub extern const fz_unit_rect: fz_rect;
pub extern const fz_empty_rect: fz_rect;
pub extern const fz_empty_irect: fz_irect;
pub extern const fz_infinite_rect: fz_rect;
pub extern const fz_infinite_irect: fz_irect;
pub fn fz_is_empty_rect(arg_r: fz_rect) callconv(.c) c_int {
    var r = arg_r;
    _ = &r;
    return @intFromBool((r.x0 >= r.x1) or (r.y0 >= r.y1));
}
pub fn fz_is_empty_irect(arg_r: fz_irect) callconv(.c) c_int {
    var r = arg_r;
    _ = &r;
    return @intFromBool((r.x0 >= r.x1) or (r.y0 >= r.y1));
}
pub fn fz_is_infinite_rect(arg_r: fz_rect) callconv(.c) c_int {
    var r = arg_r;
    _ = &r;
    return @intFromBool((((r.x0 == @as(f32, @floatFromInt(@as(c_int, @bitCast(@as(c_uint, @truncate(@as(c_uint, 2147483648)))))))) and (r.x1 == @as(f32, @floatFromInt(@as(c_int, 2147483520))))) and (r.y0 == @as(f32, @floatFromInt(@as(c_int, @bitCast(@as(c_uint, @truncate(@as(c_uint, 2147483648))))))))) and (r.y1 == @as(f32, @floatFromInt(@as(c_int, 2147483520)))));
}
pub fn fz_is_infinite_irect(arg_r: fz_irect) callconv(.c) c_int {
    var r = arg_r;
    _ = &r;
    return @intFromBool((((r.x0 == @as(c_int, @bitCast(@as(c_uint, @truncate(@as(c_uint, 2147483648)))))) and (r.x1 == @as(c_int, 2147483520))) and (r.y0 == @as(c_int, @bitCast(@as(c_uint, @truncate(@as(c_uint, 2147483648))))))) and (r.y1 == @as(c_int, 2147483520)));
}
pub fn fz_is_valid_rect(arg_r: fz_rect) callconv(.c) c_int {
    var r = arg_r;
    _ = &r;
    return @intFromBool((r.x0 <= r.x1) and (r.y0 <= r.y1));
}
pub fn fz_is_valid_irect(arg_r: fz_irect) callconv(.c) c_int {
    var r = arg_r;
    _ = &r;
    return @intFromBool((r.x0 <= r.x1) and (r.y0 <= r.y1));
}
pub fn fz_irect_width(arg_r: fz_irect) callconv(.c) c_uint {
    var r = arg_r;
    _ = &r;
    const static_local___PRETTY_FUNCTION__ = struct {
        const __PRETTY_FUNCTION__: [37:0]u8 = "unsigned int fz_irect_width(fz_irect)".*;
    };
    _ = &static_local___PRETTY_FUNCTION__;
    var w: c_uint = undefined;
    _ = &w;
    if (r.x0 >= r.x1) return 0;
    w = @as(c_uint, @bitCast(@as(c_int, r.x1))) -% @as(c_uint, @bitCast(@as(c_int, r.x0)));
    _ = @sizeOf(@TypeOf(if (@as(c_int, @bitCast(@as(c_uint, @truncate(w)))) >= @as(c_int, 0)) @as(c_int, 1) else @as(c_int, 0)));
    {
        if (@as(c_int, @bitCast(@as(c_uint, @truncate(w)))) >= @as(c_int, 0)) {} else {
            __assert_fail("(int)w >= 0", "/usr/include/mupdf/fitz/geometry.h", 330, @ptrCast(@alignCast(&static_local___PRETTY_FUNCTION__.__PRETTY_FUNCTION__)));
        }
    }
    if (@as(c_int, @bitCast(@as(c_uint, @truncate(w)))) < @as(c_int, 0)) return 0;
    return @bitCast(@as(c_int, @as(c_int, @bitCast(@as(c_uint, @truncate(w))))));
}
pub fn fz_irect_height(arg_r: fz_irect) callconv(.c) c_int {
    var r = arg_r;
    _ = &r;
    const static_local___PRETTY_FUNCTION__ = struct {
        const __PRETTY_FUNCTION__: [29:0]u8 = "int fz_irect_height(fz_irect)".*;
    };
    _ = &static_local___PRETTY_FUNCTION__;
    var h: c_uint = undefined;
    _ = &h;
    if (r.y0 >= r.y1) return 0;
    h = @bitCast(@as(c_int, r.y1 - r.y0));
    _ = @sizeOf(@TypeOf(if (@as(c_int, @bitCast(@as(c_uint, @truncate(h)))) >= @as(c_int, 0)) @as(c_int, 1) else @as(c_int, 0)));
    {
        if (@as(c_int, @bitCast(@as(c_uint, @truncate(h)))) >= @as(c_int, 0)) {} else {
            __assert_fail("(int)h >= 0", "/usr/include/mupdf/fitz/geometry.h", 349, @ptrCast(@alignCast(&static_local___PRETTY_FUNCTION__.__PRETTY_FUNCTION__)));
        }
    }
    if (@as(c_int, @bitCast(@as(c_uint, @truncate(h)))) < @as(c_int, 0)) return 0;
    return @bitCast(@as(c_uint, @truncate(h)));
}
pub const fz_matrix = extern struct {
    a: f32 = 0,
    b: f32 = 0,
    c: f32 = 0,
    d: f32 = 0,
    e: f32 = 0,
    f: f32 = 0,
    pub const fz_is_identity = __root.fz_is_identity;
    pub const fz_concat = __root.fz_concat;
    pub const fz_pre_scale = __root.fz_pre_scale;
    pub const fz_post_scale = __root.fz_post_scale;
    pub const fz_pre_shear = __root.fz_pre_shear;
    pub const fz_pre_rotate = __root.fz_pre_rotate;
    pub const fz_pre_translate = __root.fz_pre_translate;
    pub const fz_invert_matrix = __root.fz_invert_matrix;
    pub const fz_try_invert_matrix = __root.fz_try_invert_matrix;
    pub const fz_is_rectilinear = __root.fz_is_rectilinear;
    pub const fz_matrix_expansion = __root.fz_matrix_expansion;
    pub const fz_matrix_max_expansion = __root.fz_matrix_max_expansion;
    pub const identity = __root.fz_is_identity;
    pub const concat = __root.fz_concat;
    pub const scale = __root.fz_pre_scale;
    pub const shear = __root.fz_pre_shear;
    pub const rotate = __root.fz_pre_rotate;
    pub const translate = __root.fz_pre_translate;
    pub const matrix = __root.fz_invert_matrix;
    pub const rectilinear = __root.fz_is_rectilinear;
    pub const expansion = __root.fz_matrix_expansion;
    pub const max_expansion = __root.fz_matrix_max_expansion;
};
pub extern const fz_identity: fz_matrix;
pub fn fz_make_matrix(arg_a: f32, arg_b: f32, arg_c: f32, arg_d: f32, arg_e: f32, arg_f: f32) callconv(.c) fz_matrix {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    var c = arg_c;
    _ = &c;
    var d = arg_d;
    _ = &d;
    var e = arg_e;
    _ = &e;
    var f = arg_f;
    _ = &f;
    var m: fz_matrix = fz_matrix{
        .a = a,
        .b = b,
        .c = c,
        .d = d,
        .e = e,
        .f = f,
    };
    _ = &m;
    return m;
}
pub fn fz_is_identity(arg_m: fz_matrix) callconv(.c) c_int {
    var m = arg_m;
    _ = &m;
    return @intFromBool((((((m.a == @as(f32, @floatFromInt(@as(c_int, 1)))) and (m.b == @as(f32, @floatFromInt(@as(c_int, 0))))) and (m.c == @as(f32, @floatFromInt(@as(c_int, 0))))) and (m.d == @as(f32, @floatFromInt(@as(c_int, 1))))) and (m.e == @as(f32, @floatFromInt(@as(c_int, 0))))) and (m.f == @as(f32, @floatFromInt(@as(c_int, 0)))));
}
pub extern fn fz_concat(left: fz_matrix, right: fz_matrix) fz_matrix;
pub extern fn fz_scale(sx: f32, sy: f32) fz_matrix;
pub extern fn fz_pre_scale(m: fz_matrix, sx: f32, sy: f32) fz_matrix;
pub extern fn fz_post_scale(m: fz_matrix, sx: f32, sy: f32) fz_matrix;
pub extern fn fz_shear(sx: f32, sy: f32) fz_matrix;
pub extern fn fz_pre_shear(m: fz_matrix, sx: f32, sy: f32) fz_matrix;
pub extern fn fz_rotate(degrees: f32) fz_matrix;
pub extern fn fz_pre_rotate(m: fz_matrix, degrees: f32) fz_matrix;
pub extern fn fz_translate(tx: f32, ty: f32) fz_matrix;
pub extern fn fz_pre_translate(m: fz_matrix, tx: f32, ty: f32) fz_matrix;
pub extern fn fz_transform_page(mediabox: fz_rect, resolution: f32, rotate: f32) fz_matrix;
pub extern fn fz_invert_matrix(matrix: fz_matrix) fz_matrix;
pub extern fn fz_try_invert_matrix(inv: [*c]fz_matrix, src: fz_matrix) c_int;
pub extern fn fz_is_rectilinear(m: fz_matrix) c_int;
pub extern fn fz_matrix_expansion(m: fz_matrix) f32;
pub extern fn fz_intersect_rect(a: fz_rect, b: fz_rect) fz_rect;
pub extern fn fz_intersect_irect(a: fz_irect, b: fz_irect) fz_irect;
pub extern fn fz_union_rect(a: fz_rect, b: fz_rect) fz_rect;
pub extern fn fz_irect_from_rect(rect: fz_rect) fz_irect;
pub extern fn fz_round_rect(rect: fz_rect) fz_irect;
pub extern fn fz_rect_from_irect(bbox: fz_irect) fz_rect;
pub extern fn fz_expand_rect(b: fz_rect, expand: f32) fz_rect;
pub extern fn fz_expand_irect(a: fz_irect, expand: c_int) fz_irect;
pub extern fn fz_include_point_in_rect(r: fz_rect, p: fz_point) fz_rect;
pub extern fn fz_translate_rect(a: fz_rect, xoff: f32, yoff: f32) fz_rect;
pub extern fn fz_translate_irect(a: fz_irect, xoff: c_int, yoff: c_int) fz_irect;
pub extern fn fz_contains_rect(a: fz_rect, b: fz_rect) c_int;
pub extern fn fz_transform_point(point: fz_point, m: fz_matrix) fz_point;
pub extern fn fz_transform_point_xy(x: f32, y: f32, m: fz_matrix) fz_point;
pub extern fn fz_transform_vector(vector: fz_point, m: fz_matrix) fz_point;
pub extern fn fz_transform_rect(rect: fz_rect, m: fz_matrix) fz_rect;
pub extern fn fz_normalize_vector(p: fz_point) fz_point;
pub extern fn fz_gridfit_matrix(as_tiled: c_int, m: fz_matrix) fz_matrix;
pub extern fn fz_matrix_max_expansion(m: fz_matrix) f32;
pub const fz_quad = extern struct {
    ul: fz_point = @import("std").mem.zeroes(fz_point),
    ur: fz_point = @import("std").mem.zeroes(fz_point),
    ll: fz_point = @import("std").mem.zeroes(fz_point),
    lr: fz_point = @import("std").mem.zeroes(fz_point),
    pub const fz_rect_from_quad = __root.fz_rect_from_quad;
    pub const fz_transform_quad = __root.fz_transform_quad;
    pub const fz_is_quad_inside_quad = __root.fz_is_quad_inside_quad;
    pub const fz_is_quad_intersecting_quad = __root.fz_is_quad_intersecting_quad;
    pub const quad = __root.fz_rect_from_quad;
};
pub fn fz_make_quad(arg_ul_x: f32, arg_ul_y: f32, arg_ur_x: f32, arg_ur_y: f32, arg_ll_x: f32, arg_ll_y: f32, arg_lr_x: f32, arg_lr_y: f32) callconv(.c) fz_quad {
    var ul_x = arg_ul_x;
    _ = &ul_x;
    var ul_y = arg_ul_y;
    _ = &ul_y;
    var ur_x = arg_ur_x;
    _ = &ur_x;
    var ur_y = arg_ur_y;
    _ = &ur_y;
    var ll_x = arg_ll_x;
    _ = &ll_x;
    var ll_y = arg_ll_y;
    _ = &ll_y;
    var lr_x = arg_lr_x;
    _ = &lr_x;
    var lr_y = arg_lr_y;
    _ = &lr_y;
    var q: fz_quad = fz_quad{
        .ul = fz_point{
            .x = ul_x,
            .y = ul_y,
        },
        .ur = fz_point{
            .x = ur_x,
            .y = ur_y,
        },
        .ll = fz_point{
            .x = ll_x,
            .y = ll_y,
        },
        .lr = fz_point{
            .x = lr_x,
            .y = lr_y,
        },
    };
    _ = &q;
    return q;
}
pub extern fn fz_quad_from_rect(r: fz_rect) fz_quad;
pub extern fn fz_rect_from_quad(q: fz_quad) fz_rect;
pub extern fn fz_transform_quad(q: fz_quad, m: fz_matrix) fz_quad;
pub extern fn fz_is_point_inside_quad(p: fz_point, q: fz_quad) c_int;
pub extern fn fz_is_point_inside_rect(p: fz_point, r: fz_rect) c_int;
pub extern fn fz_is_point_inside_irect(x: c_int, y: c_int, r: fz_irect) c_int;
pub extern fn fz_is_quad_inside_quad(needle: fz_quad, haystack: fz_quad) c_int;
pub extern fn fz_is_quad_intersecting_quad(a: fz_quad, b: fz_quad) c_int;
pub const struct_fz_font_context = opaque {};
pub const fz_font_context = struct_fz_font_context;
pub const struct_fz_colorspace_context = opaque {};
pub const fz_colorspace_context = struct_fz_colorspace_context;
pub const struct_fz_style_context = opaque {};
pub const fz_style_context = struct_fz_style_context;
pub const struct_fz_tuning_context = opaque {};
pub const fz_tuning_context = struct_fz_tuning_context;
pub const struct_fz_store = opaque {};
pub const fz_store = struct_fz_store;
pub const struct_fz_glyph_cache = opaque {};
pub const fz_glyph_cache = struct_fz_glyph_cache;
pub const struct_fz_document_handler_context = opaque {};
pub const fz_document_handler_context = struct_fz_document_handler_context;
pub const fz_output = struct_fz_output;
pub const struct_fz_context = extern struct {
    user: ?*anyopaque = null,
    alloc: fz_alloc_context = @import("std").mem.zeroes(fz_alloc_context),
    locks: fz_locks_context = @import("std").mem.zeroes(fz_locks_context),
    @"error": fz_error_context = @import("std").mem.zeroes(fz_error_context),
    warn: fz_warn_context = @import("std").mem.zeroes(fz_warn_context),
    aa: fz_aa_context = @import("std").mem.zeroes(fz_aa_context),
    seed48: [7]u16 = @import("std").mem.zeroes([7]u16),
    icc_enabled: c_int = 0,
    throw_on_repair: c_int = 0,
    handler: ?*fz_document_handler_context = null,
    style: ?*fz_style_context = null,
    tuning: ?*fz_tuning_context = null,
    stddbg: [*c]fz_output = null,
    font: ?*fz_font_context = null,
    colorspace: ?*fz_colorspace_context = null,
    store: ?*fz_store = null,
    glyph_cache: ?*fz_glyph_cache = null,
    pub const fz_vthrow = __root.fz_vthrow;
    pub const fz_throw = __root.fz_throw;
    pub const fz_rethrow = __root.fz_rethrow;
    pub const fz_morph_error = __root.fz_morph_error;
    pub const fz_vwarn = __root.fz_vwarn;
    pub const fz_warn = __root.fz_warn;
    pub const fz_caught_message = __root.fz_caught_message;
    pub const fz_caught = __root.fz_caught;
    pub const fz_rethrow_if = __root.fz_rethrow_if;
    pub const fz_log_error_printf = __root.fz_log_error_printf;
    pub const fz_vlog_error_printf = __root.fz_vlog_error_printf;
    pub const fz_log_error = __root.fz_log_error;
    pub const fz_start_throw_on_repair = __root.fz_start_throw_on_repair;
    pub const fz_end_throw_on_repair = __root.fz_end_throw_on_repair;
    pub const fz_flush_warnings = __root.fz_flush_warnings;
    pub const fz_assert_lock_held = __root.fz_assert_lock_held;
    pub const fz_assert_lock_not_held = __root.fz_assert_lock_not_held;
    pub const fz_lock_debug_lock = __root.fz_lock_debug_lock;
    pub const fz_lock_debug_unlock = __root.fz_lock_debug_unlock;
    pub const fz_clone_context = __root.fz_clone_context;
    pub const fz_drop_context = __root.fz_drop_context;
    pub const fz_set_user_context = __root.fz_set_user_context;
    pub const fz_user_context = __root.fz_user_context;
    pub const fz_set_error_callback = __root.fz_set_error_callback;
    pub const fz_error_callback = __root.fz_error_callback;
    pub const fz_set_warning_callback = __root.fz_set_warning_callback;
    pub const fz_warning_callback = __root.fz_warning_callback;
    pub const fz_tune_image_decode = __root.fz_tune_image_decode;
    pub const fz_tune_image_scale = __root.fz_tune_image_scale;
    pub const fz_aa_level = __root.fz_aa_level;
    pub const fz_set_aa_level = __root.fz_set_aa_level;
    pub const fz_text_aa_level = __root.fz_text_aa_level;
    pub const fz_set_text_aa_level = __root.fz_set_text_aa_level;
    pub const fz_graphics_aa_level = __root.fz_graphics_aa_level;
    pub const fz_set_graphics_aa_level = __root.fz_set_graphics_aa_level;
    pub const fz_graphics_min_line_width = __root.fz_graphics_min_line_width;
    pub const fz_set_graphics_min_line_width = __root.fz_set_graphics_min_line_width;
    pub const fz_user_css = __root.fz_user_css;
    pub const fz_set_user_css = __root.fz_set_user_css;
    pub const fz_use_document_css = __root.fz_use_document_css;
    pub const fz_set_use_document_css = __root.fz_set_use_document_css;
    pub const fz_enable_icc = __root.fz_enable_icc;
    pub const fz_disable_icc = __root.fz_disable_icc;
    pub const fz_malloc = __root.fz_malloc;
    pub const fz_calloc = __root.fz_calloc;
    pub const fz_realloc = __root.fz_realloc;
    pub const fz_free = __root.fz_free;
    pub const fz_malloc_no_throw = __root.fz_malloc_no_throw;
    pub const fz_calloc_no_throw = __root.fz_calloc_no_throw;
    pub const fz_realloc_no_throw = __root.fz_realloc_no_throw;
    pub const fz_strdup = __root.fz_strdup;
    pub const fz_memrnd = __root.fz_memrnd;
    pub const fz_push_try = __root.fz_push_try;
    pub const fz_do_try = __root.fz_do_try;
    pub const fz_do_always = __root.fz_do_always;
    pub const fz_do_catch = __root.fz_do_catch;
    pub const fz_lock = __root.fz_lock;
    pub const fz_unlock = __root.fz_unlock;
    pub const fz_keep_imp = __root.fz_keep_imp;
    pub const fz_keep_imp_locked = __root.fz_keep_imp_locked;
    pub const fz_keep_imp8_locked = __root.fz_keep_imp8_locked;
    pub const fz_keep_imp8 = __root.fz_keep_imp8;
    pub const fz_keep_imp16 = __root.fz_keep_imp16;
    pub const fz_drop_imp = __root.fz_drop_imp;
    pub const fz_drop_imp8 = __root.fz_drop_imp8;
    pub const fz_drop_imp16 = __root.fz_drop_imp16;
    pub const fz_keep_buffer = __root.fz_keep_buffer;
    pub const fz_drop_buffer = __root.fz_drop_buffer;
    pub const fz_buffer_storage = __root.fz_buffer_storage;
    pub const fz_string_from_buffer = __root.fz_string_from_buffer;
    pub const fz_new_buffer = __root.fz_new_buffer;
    pub const fz_new_buffer_from_data = __root.fz_new_buffer_from_data;
    pub const fz_new_buffer_from_shared_data = __root.fz_new_buffer_from_shared_data;
    pub const fz_new_buffer_from_copied_data = __root.fz_new_buffer_from_copied_data;
    pub const fz_clone_buffer = __root.fz_clone_buffer;
    pub const fz_new_buffer_from_base64 = __root.fz_new_buffer_from_base64;
    pub const fz_resize_buffer = __root.fz_resize_buffer;
    pub const fz_grow_buffer = __root.fz_grow_buffer;
    pub const fz_trim_buffer = __root.fz_trim_buffer;
    pub const fz_clear_buffer = __root.fz_clear_buffer;
    pub const fz_slice_buffer = __root.fz_slice_buffer;
    pub const fz_append_buffer = __root.fz_append_buffer;
    pub const fz_append_base64 = __root.fz_append_base64;
    pub const fz_append_base64_buffer = __root.fz_append_base64_buffer;
    pub const fz_append_data = __root.fz_append_data;
    pub const fz_append_string = __root.fz_append_string;
    pub const fz_append_byte = __root.fz_append_byte;
    pub const fz_append_rune = __root.fz_append_rune;
    pub const fz_append_int32_le = __root.fz_append_int32_le;
    pub const fz_append_int16_le = __root.fz_append_int16_le;
    pub const fz_append_int32_be = __root.fz_append_int32_be;
    pub const fz_append_int16_be = __root.fz_append_int16_be;
    pub const fz_append_bits = __root.fz_append_bits;
    pub const fz_append_bits_pad = __root.fz_append_bits_pad;
    pub const fz_append_pdf_string = __root.fz_append_pdf_string;
    pub const fz_append_printf = __root.fz_append_printf;
    pub const fz_append_vprintf = __root.fz_append_vprintf;
    pub const fz_terminate_buffer = __root.fz_terminate_buffer;
    pub const fz_md5_buffer = __root.fz_md5_buffer;
    pub const fz_buffer_extract = __root.fz_buffer_extract;
    pub const fz_decode_uri = __root.fz_decode_uri;
    pub const fz_decode_uri_component = __root.fz_decode_uri_component;
    pub const fz_encode_uri = __root.fz_encode_uri;
    pub const fz_encode_uri_component = __root.fz_encode_uri_component;
    pub const fz_encode_uri_pathname = __root.fz_encode_uri_pathname;
    pub const fz_format_output_path = __root.fz_format_output_path;
    pub const fz_is_page_range = __root.fz_is_page_range;
    pub const fz_parse_page_range = __root.fz_parse_page_range;
    pub const fz_file_exists = __root.fz_file_exists;
    pub const fz_open_file = __root.fz_open_file;
    pub const fz_try_open_file = __root.fz_try_open_file;
    pub const fz_open_memory = __root.fz_open_memory;
    pub const fz_open_buffer = __root.fz_open_buffer;
    pub const fz_open_leecher = __root.fz_open_leecher;
    pub const fz_keep_stream = __root.fz_keep_stream;
    pub const fz_drop_stream = __root.fz_drop_stream;
    pub const fz_tell = __root.fz_tell;
    pub const fz_seek = __root.fz_seek;
    pub const fz_read = __root.fz_read;
    pub const fz_skip = __root.fz_skip;
    pub const fz_read_all = __root.fz_read_all;
    pub const fz_read_file = __root.fz_read_file;
    pub const fz_try_read_file = __root.fz_try_read_file;
    pub const fz_read_uint16 = __root.fz_read_uint16;
    pub const fz_read_uint24 = __root.fz_read_uint24;
    pub const fz_read_uint32 = __root.fz_read_uint32;
    pub const fz_read_uint64 = __root.fz_read_uint64;
    pub const fz_read_uint16_le = __root.fz_read_uint16_le;
    pub const fz_read_uint24_le = __root.fz_read_uint24_le;
    pub const fz_read_uint32_le = __root.fz_read_uint32_le;
    pub const fz_read_uint64_le = __root.fz_read_uint64_le;
    pub const fz_read_int16 = __root.fz_read_int16;
    pub const fz_read_int32 = __root.fz_read_int32;
    pub const fz_read_int64 = __root.fz_read_int64;
    pub const fz_read_int16_le = __root.fz_read_int16_le;
    pub const fz_read_int32_le = __root.fz_read_int32_le;
    pub const fz_read_int64_le = __root.fz_read_int64_le;
    pub const fz_read_float_le = __root.fz_read_float_le;
    pub const fz_read_float = __root.fz_read_float;
    pub const fz_read_string = __root.fz_read_string;
    pub const fz_read_rune = __root.fz_read_rune;
    pub const fz_read_utf16_le = __root.fz_read_utf16_le;
    pub const fz_read_utf16_be = __root.fz_read_utf16_be;
    pub const fz_new_stream = __root.fz_new_stream;
    pub const fz_read_best = __root.fz_read_best;
    pub const fz_read_line = __root.fz_read_line;
    pub const fz_skip_string = __root.fz_skip_string;
    pub const fz_skip_space = __root.fz_skip_space;
    pub const fz_available = __root.fz_available;
    pub const fz_read_byte = __root.fz_read_byte;
    pub const fz_peek_byte = __root.fz_peek_byte;
    pub const fz_unread_byte = __root.fz_unread_byte;
    pub const fz_is_eof = __root.fz_is_eof;
    pub const fz_read_bits = __root.fz_read_bits;
    pub const fz_read_rbits = __root.fz_read_rbits;
    pub const fz_sync_bits = __root.fz_sync_bits;
    pub const fz_is_eof_bits = __root.fz_is_eof_bits;
    pub const fz_open_file_ptr_no_close = __root.fz_open_file_ptr_no_close;
    pub const fz_new_output = __root.fz_new_output;
    pub const fz_new_output_with_path = __root.fz_new_output_with_path;
    pub const fz_new_output_with_buffer = __root.fz_new_output_with_buffer;
    pub const fz_stdout = __root.fz_stdout;
    pub const fz_stderr = __root.fz_stderr;
    pub const fz_set_stddbg = __root.fz_set_stddbg;
    pub const fz_stddbg = __root.fz_stddbg;
    pub const fz_write_printf = __root.fz_write_printf;
    pub const fz_write_vprintf = __root.fz_write_vprintf;
    pub const fz_seek_output = __root.fz_seek_output;
    pub const fz_tell_output = __root.fz_tell_output;
    pub const fz_flush_output = __root.fz_flush_output;
    pub const fz_close_output = __root.fz_close_output;
    pub const fz_drop_output = __root.fz_drop_output;
    pub const fz_output_supports_stream = __root.fz_output_supports_stream;
    pub const fz_stream_from_output = __root.fz_stream_from_output;
    pub const fz_truncate_output = __root.fz_truncate_output;
    pub const fz_write_data = __root.fz_write_data;
    pub const fz_write_buffer = __root.fz_write_buffer;
    pub const fz_write_string = __root.fz_write_string;
    pub const fz_write_int32_be = __root.fz_write_int32_be;
    pub const fz_write_int32_le = __root.fz_write_int32_le;
    pub const fz_write_uint32_be = __root.fz_write_uint32_be;
    pub const fz_write_uint32_le = __root.fz_write_uint32_le;
    pub const fz_write_int16_be = __root.fz_write_int16_be;
    pub const fz_write_int16_le = __root.fz_write_int16_le;
    pub const fz_write_uint16_be = __root.fz_write_uint16_be;
    pub const fz_write_uint16_le = __root.fz_write_uint16_le;
    pub const fz_write_char = __root.fz_write_char;
    pub const fz_write_byte = __root.fz_write_byte;
    pub const fz_write_float_be = __root.fz_write_float_be;
    pub const fz_write_float_le = __root.fz_write_float_le;
    pub const fz_write_rune = __root.fz_write_rune;
    pub const fz_write_base64 = __root.fz_write_base64;
    pub const fz_write_base64_buffer = __root.fz_write_base64_buffer;
    pub const fz_write_bits = __root.fz_write_bits;
    pub const fz_write_bits_sync = __root.fz_write_bits_sync;
    pub const fz_format_string = __root.fz_format_string;
    pub const fz_asprintf = __root.fz_asprintf;
    pub const fz_save_buffer = __root.fz_save_buffer;
    pub const fz_new_asciihex_output = __root.fz_new_asciihex_output;
    pub const fz_new_ascii85_output = __root.fz_new_ascii85_output;
    pub const fz_new_rle_output = __root.fz_new_rle_output;
    pub const fz_new_arc4_output = __root.fz_new_arc4_output;
    pub const fz_new_deflate_output = __root.fz_new_deflate_output;
    pub const fz_log = __root.fz_log;
    pub const fz_log_module = __root.fz_log_module;
    pub const fz_new_log_for_module = __root.fz_new_log_for_module;
    pub const fz_new_hash_table = __root.fz_new_hash_table;
    pub const fz_drop_hash_table = __root.fz_drop_hash_table;
    pub const fz_hash_find = __root.fz_hash_find;
    pub const fz_hash_insert = __root.fz_hash_insert;
    pub const fz_hash_remove = __root.fz_hash_remove;
    pub const fz_hash_for_each = __root.fz_hash_for_each;
    pub const fz_hash_filter = __root.fz_hash_filter;
    pub const fz_new_pool = __root.fz_new_pool;
    pub const fz_pool_alloc = __root.fz_pool_alloc;
    pub const fz_pool_strdup = __root.fz_pool_strdup;
    pub const fz_pool_size = __root.fz_pool_size;
    pub const fz_drop_pool = __root.fz_drop_pool;
    pub const fz_tree_lookup = __root.fz_tree_lookup;
    pub const fz_tree_insert = __root.fz_tree_insert;
    pub const fz_drop_tree = __root.fz_drop_tree;
    pub const fz_bidi_fragment_text = __root.fz_bidi_fragment_text;
    pub const fz_open_archive = __root.fz_open_archive;
    pub const fz_open_archive_with_stream = __root.fz_open_archive_with_stream;
    pub const fz_try_open_archive_with_stream = __root.fz_try_open_archive_with_stream;
    pub const fz_open_directory = __root.fz_open_directory;
    pub const fz_is_directory = __root.fz_is_directory;
    pub const fz_drop_archive = __root.fz_drop_archive;
    pub const fz_keep_archive = __root.fz_keep_archive;
    pub const fz_archive_format = __root.fz_archive_format;
    pub const fz_count_archive_entries = __root.fz_count_archive_entries;
    pub const fz_list_archive_entry = __root.fz_list_archive_entry;
    pub const fz_has_archive_entry = __root.fz_has_archive_entry;
    pub const fz_open_archive_entry = __root.fz_open_archive_entry;
    pub const fz_try_open_archive_entry = __root.fz_try_open_archive_entry;
    pub const fz_read_archive_entry = __root.fz_read_archive_entry;
    pub const fz_try_read_archive_entry = __root.fz_try_read_archive_entry;
    pub const fz_is_tar_archive = __root.fz_is_tar_archive;
    pub const fz_open_tar_archive = __root.fz_open_tar_archive;
    pub const fz_open_tar_archive_with_stream = __root.fz_open_tar_archive_with_stream;
    pub const fz_is_zip_archive = __root.fz_is_zip_archive;
    pub const fz_open_zip_archive = __root.fz_open_zip_archive;
    pub const fz_open_zip_archive_with_stream = __root.fz_open_zip_archive_with_stream;
    pub const fz_new_zip_writer = __root.fz_new_zip_writer;
    pub const fz_new_zip_writer_with_output = __root.fz_new_zip_writer_with_output;
    pub const fz_write_zip_entry = __root.fz_write_zip_entry;
    pub const fz_close_zip_writer = __root.fz_close_zip_writer;
    pub const fz_drop_zip_writer = __root.fz_drop_zip_writer;
    pub const fz_new_tree_archive = __root.fz_new_tree_archive;
    pub const fz_tree_archive_add_buffer = __root.fz_tree_archive_add_buffer;
    pub const fz_tree_archive_add_data = __root.fz_tree_archive_add_data;
    pub const fz_new_multi_archive = __root.fz_new_multi_archive;
    pub const fz_mount_multi_archive = __root.fz_mount_multi_archive;
    pub const fz_new_archive_of_size = __root.fz_new_archive_of_size;
    pub const fz_parse_xml = __root.fz_parse_xml;
    pub const fz_parse_xml_stream = __root.fz_parse_xml_stream;
    pub const fz_parse_xml_archive_entry = __root.fz_parse_xml_archive_entry;
    pub const fz_try_parse_xml_archive_entry = __root.fz_try_parse_xml_archive_entry;
    pub const fz_parse_xml_from_html5 = __root.fz_parse_xml_from_html5;
    pub const fz_keep_xml = __root.fz_keep_xml;
    pub const fz_drop_xml = __root.fz_drop_xml;
    pub const fz_detach_xml = __root.fz_detach_xml;
    pub const fz_xml_add_att = __root.fz_xml_add_att;
    pub const fz_dom_body = __root.fz_dom_body;
    pub const fz_dom_document_element = __root.fz_dom_document_element;
    pub const fz_dom_create_element = __root.fz_dom_create_element;
    pub const fz_dom_create_text_node = __root.fz_dom_create_text_node;
    pub const fz_dom_find = __root.fz_dom_find;
    pub const fz_dom_find_next = __root.fz_dom_find_next;
    pub const fz_dom_append_child = __root.fz_dom_append_child;
    pub const fz_dom_insert_before = __root.fz_dom_insert_before;
    pub const fz_dom_insert_after = __root.fz_dom_insert_after;
    pub const fz_dom_remove = __root.fz_dom_remove;
    pub const fz_dom_clone = __root.fz_dom_clone;
    pub const fz_dom_first_child = __root.fz_dom_first_child;
    pub const fz_dom_parent = __root.fz_dom_parent;
    pub const fz_dom_next = __root.fz_dom_next;
    pub const fz_dom_previous = __root.fz_dom_previous;
    pub const fz_dom_add_attribute = __root.fz_dom_add_attribute;
    pub const fz_dom_remove_attribute = __root.fz_dom_remove_attribute;
    pub const fz_dom_attribute = __root.fz_dom_attribute;
    pub const fz_dom_get_attribute = __root.fz_dom_get_attribute;
    pub const fz_deflate_bound = __root.fz_deflate_bound;
    pub const fz_deflate = __root.fz_deflate;
    pub const fz_new_deflated_data = __root.fz_new_deflated_data;
    pub const fz_new_deflated_data_from_buffer = __root.fz_new_deflated_data_from_buffer;
    pub const fz_compress_ccitt_fax_g3 = __root.fz_compress_ccitt_fax_g3;
    pub const fz_compress_ccitt_fax_g4 = __root.fz_compress_ccitt_fax_g4;
    pub const fz_keep_storable = __root.fz_keep_storable;
    pub const fz_drop_storable = __root.fz_drop_storable;
    pub const fz_keep_key_storable = __root.fz_keep_key_storable;
    pub const fz_drop_key_storable = __root.fz_drop_key_storable;
    pub const fz_keep_key_storable_key = __root.fz_keep_key_storable_key;
    pub const fz_drop_key_storable_key = __root.fz_drop_key_storable_key;
    pub const fz_new_store_context = __root.fz_new_store_context;
    pub const fz_keep_store_context = __root.fz_keep_store_context;
    pub const fz_drop_store_context = __root.fz_drop_store_context;
    pub const fz_store_item = __root.fz_store_item;
    pub const fz_find_item = __root.fz_find_item;
    pub const fz_remove_item = __root.fz_remove_item;
    pub const fz_empty_store = __root.fz_empty_store;
    pub const fz_store_scavenge = __root.fz_store_scavenge;
    pub const fz_store_scavenge_external = __root.fz_store_scavenge_external;
    pub const fz_shrink_store = __root.fz_shrink_store;
    pub const fz_filter_store = __root.fz_filter_store;
    pub const fz_debug_store = __root.fz_debug_store;
    pub const fz_defer_reap_start = __root.fz_defer_reap_start;
    pub const fz_defer_reap_end = __root.fz_defer_reap_end;
    pub const fz_open_null_filter = __root.fz_open_null_filter;
    pub const fz_open_range_filter = __root.fz_open_range_filter;
    pub const fz_open_endstream_filter = __root.fz_open_endstream_filter;
    pub const fz_open_concat = __root.fz_open_concat;
    pub const fz_concat_push_drop = __root.fz_concat_push_drop;
    pub const fz_open_arc4 = __root.fz_open_arc4;
    pub const fz_open_aesd = __root.fz_open_aesd;
    pub const fz_open_a85d = __root.fz_open_a85d;
    pub const fz_open_ahxd = __root.fz_open_ahxd;
    pub const fz_open_rld = __root.fz_open_rld;
    pub const fz_open_dctd = __root.fz_open_dctd;
    pub const fz_open_faxd = __root.fz_open_faxd;
    pub const fz_open_flated = __root.fz_open_flated;
    pub const fz_open_lzwd = __root.fz_open_lzwd;
    pub const fz_open_predict = __root.fz_open_predict;
    pub const fz_open_jbig2d = __root.fz_open_jbig2d;
    pub const fz_load_jbig2_globals = __root.fz_load_jbig2_globals;
    pub const fz_keep_jbig2_globals = __root.fz_keep_jbig2_globals;
    pub const fz_drop_jbig2_globals = __root.fz_drop_jbig2_globals;
    pub const fz_drop_jbig2_globals_imp = __root.fz_drop_jbig2_globals_imp;
    pub const fz_jbig2_globals_data = __root.fz_jbig2_globals_data;
    pub const fz_open_sgilog16 = __root.fz_open_sgilog16;
    pub const fz_open_sgilog24 = __root.fz_open_sgilog24;
    pub const fz_open_sgilog32 = __root.fz_open_sgilog32;
    pub const fz_open_thunder = __root.fz_open_thunder;
    pub const fz_open_compressed_buffer = __root.fz_open_compressed_buffer;
    pub const fz_open_image_decomp_stream_from_buffer = __root.fz_open_image_decomp_stream_from_buffer;
    pub const fz_open_image_decomp_stream = __root.fz_open_image_decomp_stream;
    pub const fz_recognize_image_format = __root.fz_recognize_image_format;
    pub const fz_drop_compressed_buffer = __root.fz_drop_compressed_buffer;
    pub const fz_new_colorspace = __root.fz_new_colorspace;
    pub const fz_keep_colorspace = __root.fz_keep_colorspace;
    pub const fz_drop_colorspace = __root.fz_drop_colorspace;
    pub const fz_new_indexed_colorspace = __root.fz_new_indexed_colorspace;
    pub const fz_new_icc_colorspace = __root.fz_new_icc_colorspace;
    pub const fz_new_cal_gray_colorspace = __root.fz_new_cal_gray_colorspace;
    pub const fz_new_cal_rgb_colorspace = __root.fz_new_cal_rgb_colorspace;
    pub const fz_colorspace_type = __root.fz_colorspace_type;
    pub const fz_colorspace_name = __root.fz_colorspace_name;
    pub const fz_colorspace_n = __root.fz_colorspace_n;
    pub const fz_colorspace_is_subtractive = __root.fz_colorspace_is_subtractive;
    pub const fz_colorspace_device_n_has_only_cmyk = __root.fz_colorspace_device_n_has_only_cmyk;
    pub const fz_colorspace_device_n_has_cmyk = __root.fz_colorspace_device_n_has_cmyk;
    pub const fz_colorspace_is_gray = __root.fz_colorspace_is_gray;
    pub const fz_colorspace_is_rgb = __root.fz_colorspace_is_rgb;
    pub const fz_colorspace_is_cmyk = __root.fz_colorspace_is_cmyk;
    pub const fz_colorspace_is_lab = __root.fz_colorspace_is_lab;
    pub const fz_colorspace_is_indexed = __root.fz_colorspace_is_indexed;
    pub const fz_colorspace_is_device_n = __root.fz_colorspace_is_device_n;
    pub const fz_colorspace_is_device = __root.fz_colorspace_is_device;
    pub const fz_colorspace_is_device_gray = __root.fz_colorspace_is_device_gray;
    pub const fz_colorspace_is_device_cmyk = __root.fz_colorspace_is_device_cmyk;
    pub const fz_colorspace_is_lab_icc = __root.fz_colorspace_is_lab_icc;
    pub const fz_is_valid_blend_colorspace = __root.fz_is_valid_blend_colorspace;
    pub const fz_base_colorspace = __root.fz_base_colorspace;
    pub const fz_device_gray = __root.fz_device_gray;
    pub const fz_device_rgb = __root.fz_device_rgb;
    pub const fz_device_bgr = __root.fz_device_bgr;
    pub const fz_device_cmyk = __root.fz_device_cmyk;
    pub const fz_device_lab = __root.fz_device_lab;
    pub const fz_colorspace_name_colorant = __root.fz_colorspace_name_colorant;
    pub const fz_colorspace_colorant = __root.fz_colorspace_colorant;
    pub const fz_clamp_color = __root.fz_clamp_color;
    pub const fz_convert_color = __root.fz_convert_color;
    pub const fz_new_default_colorspaces = __root.fz_new_default_colorspaces;
    pub const fz_keep_default_colorspaces = __root.fz_keep_default_colorspaces;
    pub const fz_drop_default_colorspaces = __root.fz_drop_default_colorspaces;
    pub const fz_clone_default_colorspaces = __root.fz_clone_default_colorspaces;
    pub const fz_default_gray = __root.fz_default_gray;
    pub const fz_default_rgb = __root.fz_default_rgb;
    pub const fz_default_cmyk = __root.fz_default_cmyk;
    pub const fz_default_output_intent = __root.fz_default_output_intent;
    pub const fz_set_default_gray = __root.fz_set_default_gray;
    pub const fz_set_default_rgb = __root.fz_set_default_rgb;
    pub const fz_set_default_cmyk = __root.fz_set_default_cmyk;
    pub const fz_set_default_output_intent = __root.fz_set_default_output_intent;
    pub const fz_drop_colorspace_imp = __root.fz_drop_colorspace_imp;
    pub const fz_new_separations = __root.fz_new_separations;
    pub const fz_keep_separations = __root.fz_keep_separations;
    pub const fz_drop_separations = __root.fz_drop_separations;
    pub const fz_add_separation = __root.fz_add_separation;
    pub const fz_add_separation_equivalents = __root.fz_add_separation_equivalents;
    pub const fz_set_separation_behavior = __root.fz_set_separation_behavior;
    pub const fz_separation_current_behavior = __root.fz_separation_current_behavior;
    pub const fz_separation_name = __root.fz_separation_name;
    pub const fz_count_separations = __root.fz_count_separations;
    pub const fz_count_active_separations = __root.fz_count_active_separations;
    pub const fz_compare_separations = __root.fz_compare_separations;
    pub const fz_clone_separations_for_overprint = __root.fz_clone_separations_for_overprint;
    pub const fz_convert_separation_colors = __root.fz_convert_separation_colors;
    pub const fz_separation_equivalent = __root.fz_separation_equivalent;
    pub const fz_pixmap_bbox = __root.fz_pixmap_bbox;
    pub const fz_pixmap_width = __root.fz_pixmap_width;
    pub const fz_pixmap_height = __root.fz_pixmap_height;
    pub const fz_pixmap_x = __root.fz_pixmap_x;
    pub const fz_pixmap_y = __root.fz_pixmap_y;
    pub const fz_pixmap_size = __root.fz_pixmap_size;
    pub const fz_new_pixmap = __root.fz_new_pixmap;
    pub const fz_new_pixmap_with_bbox = __root.fz_new_pixmap_with_bbox;
    pub const fz_new_pixmap_with_data = __root.fz_new_pixmap_with_data;
    pub const fz_new_pixmap_with_bbox_and_data = __root.fz_new_pixmap_with_bbox_and_data;
    pub const fz_new_pixmap_from_pixmap = __root.fz_new_pixmap_from_pixmap;
    pub const fz_clone_pixmap = __root.fz_clone_pixmap;
    pub const fz_keep_pixmap = __root.fz_keep_pixmap;
    pub const fz_drop_pixmap = __root.fz_drop_pixmap;
    pub const fz_pixmap_colorspace = __root.fz_pixmap_colorspace;
    pub const fz_pixmap_components = __root.fz_pixmap_components;
    pub const fz_pixmap_colorants = __root.fz_pixmap_colorants;
    pub const fz_pixmap_spots = __root.fz_pixmap_spots;
    pub const fz_pixmap_alpha = __root.fz_pixmap_alpha;
    pub const fz_pixmap_samples = __root.fz_pixmap_samples;
    pub const fz_pixmap_stride = __root.fz_pixmap_stride;
    pub const fz_set_pixmap_resolution = __root.fz_set_pixmap_resolution;
    pub const fz_clear_pixmap_with_value = __root.fz_clear_pixmap_with_value;
    pub const fz_fill_pixmap_with_color = __root.fz_fill_pixmap_with_color;
    pub const fz_clear_pixmap_rect_with_value = __root.fz_clear_pixmap_rect_with_value;
    pub const fz_clear_pixmap = __root.fz_clear_pixmap;
    pub const fz_invert_pixmap = __root.fz_invert_pixmap;
    pub const fz_invert_pixmap_alpha = __root.fz_invert_pixmap_alpha;
    pub const fz_invert_pixmap_luminance = __root.fz_invert_pixmap_luminance;
    pub const fz_tint_pixmap = __root.fz_tint_pixmap;
    pub const fz_invert_pixmap_rect = __root.fz_invert_pixmap_rect;
    pub const fz_invert_pixmap_raw = __root.fz_invert_pixmap_raw;
    pub const fz_gamma_pixmap = __root.fz_gamma_pixmap;
    pub const fz_convert_pixmap = __root.fz_convert_pixmap;
    pub const fz_is_pixmap_monochrome = __root.fz_is_pixmap_monochrome;
    pub const fz_alpha_from_gray = __root.fz_alpha_from_gray;
    pub const fz_decode_tile = __root.fz_decode_tile;
    pub const fz_md5_pixmap = __root.fz_md5_pixmap;
    pub const fz_unpack_stream = __root.fz_unpack_stream;
    pub const fz_warp_pixmap = __root.fz_warp_pixmap;
    pub const fz_clone_pixmap_area_with_different_seps = __root.fz_clone_pixmap_area_with_different_seps;
    pub const fz_new_pixmap_from_alpha_channel = __root.fz_new_pixmap_from_alpha_channel;
    pub const fz_new_pixmap_from_color_and_mask = __root.fz_new_pixmap_from_color_and_mask;
    pub const fz_scale_pixmap = __root.fz_scale_pixmap;
    pub const fz_subsample_pixmap = __root.fz_subsample_pixmap;
    pub const fz_copy_pixmap_rect = __root.fz_copy_pixmap_rect;
    pub const fz_keep_bitmap = __root.fz_keep_bitmap;
    pub const fz_drop_bitmap = __root.fz_drop_bitmap;
    pub const fz_new_bitmap_from_pixmap = __root.fz_new_bitmap_from_pixmap;
    pub const fz_new_bitmap_from_pixmap_band = __root.fz_new_bitmap_from_pixmap_band;
    pub const fz_new_bitmap = __root.fz_new_bitmap;
    pub const fz_clear_bitmap = __root.fz_clear_bitmap;
    pub const fz_default_halftone = __root.fz_default_halftone;
    pub const fz_keep_halftone = __root.fz_keep_halftone;
    pub const fz_drop_halftone = __root.fz_drop_halftone;
    pub const fz_get_pixmap_from_image = __root.fz_get_pixmap_from_image;
    pub const fz_get_unscaled_pixmap_from_image = __root.fz_get_unscaled_pixmap_from_image;
    pub const fz_keep_image = __root.fz_keep_image;
    pub const fz_drop_image = __root.fz_drop_image;
    pub const fz_keep_image_store_key = __root.fz_keep_image_store_key;
    pub const fz_drop_image_store_key = __root.fz_drop_image_store_key;
    pub const fz_new_image_of_size = __root.fz_new_image_of_size;
    pub const fz_new_image_from_compressed_buffer = __root.fz_new_image_from_compressed_buffer;
    pub const fz_new_image_from_pixmap = __root.fz_new_image_from_pixmap;
    pub const fz_new_image_from_buffer = __root.fz_new_image_from_buffer;
    pub const fz_new_image_from_file = __root.fz_new_image_from_file;
    pub const fz_drop_image_imp = __root.fz_drop_image_imp;
    pub const fz_drop_image_base = __root.fz_drop_image_base;
    pub const fz_decomp_image_from_stream = __root.fz_decomp_image_from_stream;
    pub const fz_convert_indexed_pixmap_to_base = __root.fz_convert_indexed_pixmap_to_base;
    pub const fz_convert_separation_pixmap_to_base = __root.fz_convert_separation_pixmap_to_base;
    pub const fz_image_size = __root.fz_image_size;
    pub const fz_image_orientation = __root.fz_image_orientation;
    pub const fz_image_orientation_matrix = __root.fz_image_orientation_matrix;
    pub const fz_compressed_image_buffer = __root.fz_compressed_image_buffer;
    pub const fz_set_compressed_image_buffer = __root.fz_set_compressed_image_buffer;
    pub const fz_pixmap_image_tile = __root.fz_pixmap_image_tile;
    pub const fz_set_pixmap_image_tile = __root.fz_set_pixmap_image_tile;
    pub const fz_load_jpx = __root.fz_load_jpx;
    pub const fz_load_tiff_subimage_count = __root.fz_load_tiff_subimage_count;
    pub const fz_load_tiff_subimage = __root.fz_load_tiff_subimage;
    pub const fz_load_pnm_subimage_count = __root.fz_load_pnm_subimage_count;
    pub const fz_load_pnm_subimage = __root.fz_load_pnm_subimage;
    pub const fz_load_jbig2_subimage_count = __root.fz_load_jbig2_subimage_count;
    pub const fz_load_jbig2_subimage = __root.fz_load_jbig2_subimage;
    pub const fz_load_bmp_subimage_count = __root.fz_load_bmp_subimage_count;
    pub const fz_load_bmp_subimage = __root.fz_load_bmp_subimage;
    pub const fz_keep_shade = __root.fz_keep_shade;
    pub const fz_drop_shade = __root.fz_drop_shade;
    pub const fz_bound_shade = __root.fz_bound_shade;
    pub const fz_drop_shade_color_cache = __root.fz_drop_shade_color_cache;
    pub const fz_paint_shade = __root.fz_paint_shade;
    pub const fz_process_shade = __root.fz_process_shade;
    pub const fz_drop_shade_imp = __root.fz_drop_shade_imp;
    pub const fz_font_ft_face = __root.fz_font_ft_face;
    pub const fz_font_t3_procs = __root.fz_font_t3_procs;
    pub const fz_font_shaper_data = __root.fz_font_shaper_data;
    pub const fz_font_name = __root.fz_font_name;
    pub const fz_font_is_bold = __root.fz_font_is_bold;
    pub const fz_font_is_italic = __root.fz_font_is_italic;
    pub const fz_font_is_serif = __root.fz_font_is_serif;
    pub const fz_font_is_monospaced = __root.fz_font_is_monospaced;
    pub const fz_font_bbox = __root.fz_font_bbox;
    pub const fz_install_load_system_font_funcs = __root.fz_install_load_system_font_funcs;
    pub const fz_load_system_font = __root.fz_load_system_font;
    pub const fz_load_system_cjk_font = __root.fz_load_system_cjk_font;
    pub const fz_lookup_builtin_font = __root.fz_lookup_builtin_font;
    pub const fz_lookup_base14_font = __root.fz_lookup_base14_font;
    pub const fz_lookup_cjk_font = __root.fz_lookup_cjk_font;
    pub const fz_lookup_cjk_font_by_language = __root.fz_lookup_cjk_font_by_language;
    pub const fz_lookup_noto_font = __root.fz_lookup_noto_font;
    pub const fz_lookup_noto_math_font = __root.fz_lookup_noto_math_font;
    pub const fz_lookup_noto_music_font = __root.fz_lookup_noto_music_font;
    pub const fz_lookup_noto_symbol1_font = __root.fz_lookup_noto_symbol1_font;
    pub const fz_lookup_noto_symbol2_font = __root.fz_lookup_noto_symbol2_font;
    pub const fz_lookup_noto_emoji_font = __root.fz_lookup_noto_emoji_font;
    pub const fz_lookup_noto_boxes_font = __root.fz_lookup_noto_boxes_font;
    pub const fz_load_fallback_font = __root.fz_load_fallback_font;
    pub const fz_new_type3_font = __root.fz_new_type3_font;
    pub const fz_new_font_from_memory = __root.fz_new_font_from_memory;
    pub const fz_new_font_from_buffer = __root.fz_new_font_from_buffer;
    pub const fz_new_font_from_file = __root.fz_new_font_from_file;
    pub const fz_new_base14_font = __root.fz_new_base14_font;
    pub const fz_new_cjk_font = __root.fz_new_cjk_font;
    pub const fz_new_builtin_font = __root.fz_new_builtin_font;
    pub const fz_set_font_embedding = __root.fz_set_font_embedding;
    pub const fz_keep_font = __root.fz_keep_font;
    pub const fz_drop_font = __root.fz_drop_font;
    pub const fz_set_font_bbox = __root.fz_set_font_bbox;
    pub const fz_bound_glyph = __root.fz_bound_glyph;
    pub const fz_glyph_cacheable = __root.fz_glyph_cacheable;
    pub const fz_run_t3_glyph = __root.fz_run_t3_glyph;
    pub const fz_advance_glyph = __root.fz_advance_glyph;
    pub const fz_encode_character = __root.fz_encode_character;
    pub const fz_encode_character_sc = __root.fz_encode_character_sc;
    pub const fz_encode_character_by_glyph_name = __root.fz_encode_character_by_glyph_name;
    pub const fz_encode_character_with_fallback = __root.fz_encode_character_with_fallback;
    pub const fz_get_glyph_name = __root.fz_get_glyph_name;
    pub const fz_font_ascender = __root.fz_font_ascender;
    pub const fz_font_descender = __root.fz_font_descender;
    pub const fz_font_digest = __root.fz_font_digest;
    pub const fz_decouple_type3_font = __root.fz_decouple_type3_font;
    pub const fz_hb_lock = __root.fz_hb_lock;
    pub const fz_hb_unlock = __root.fz_hb_unlock;
    pub const fz_walk_path = __root.fz_walk_path;
    pub const fz_new_path = __root.fz_new_path;
    pub const fz_keep_path = __root.fz_keep_path;
    pub const fz_drop_path = __root.fz_drop_path;
    pub const fz_trim_path = __root.fz_trim_path;
    pub const fz_pack_path = __root.fz_pack_path;
    pub const fz_clone_path = __root.fz_clone_path;
    pub const fz_currentpoint = __root.fz_currentpoint;
    pub const fz_moveto = __root.fz_moveto;
    pub const fz_lineto = __root.fz_lineto;
    pub const fz_rectto = __root.fz_rectto;
    pub const fz_quadto = __root.fz_quadto;
    pub const fz_curveto = __root.fz_curveto;
    pub const fz_curvetov = __root.fz_curvetov;
    pub const fz_curvetoy = __root.fz_curvetoy;
    pub const fz_closepath = __root.fz_closepath;
    pub const fz_transform_path = __root.fz_transform_path;
    pub const fz_bound_path = __root.fz_bound_path;
    pub const fz_adjust_rect_for_stroke = __root.fz_adjust_rect_for_stroke;
    pub const fz_new_stroke_state = __root.fz_new_stroke_state;
    pub const fz_new_stroke_state_with_dash_len = __root.fz_new_stroke_state_with_dash_len;
    pub const fz_keep_stroke_state = __root.fz_keep_stroke_state;
    pub const fz_drop_stroke_state = __root.fz_drop_stroke_state;
    pub const fz_unshare_stroke_state = __root.fz_unshare_stroke_state;
    pub const fz_unshare_stroke_state_with_dash_len = __root.fz_unshare_stroke_state_with_dash_len;
    pub const fz_clone_stroke_state = __root.fz_clone_stroke_state;
    pub const fz_new_text = __root.fz_new_text;
    pub const fz_keep_text = __root.fz_keep_text;
    pub const fz_drop_text = __root.fz_drop_text;
    pub const fz_show_glyph = __root.fz_show_glyph;
    pub const fz_show_glyph_aux = __root.fz_show_glyph_aux;
    pub const fz_show_string = __root.fz_show_string;
    pub const fz_measure_string = __root.fz_measure_string;
    pub const fz_bound_text = __root.fz_bound_text;
    pub const fz_glyph_bbox = __root.fz_glyph_bbox;
    pub const fz_glyph_width = __root.fz_glyph_width;
    pub const fz_glyph_height = __root.fz_glyph_height;
    pub const fz_keep_glyph = __root.fz_keep_glyph;
    pub const fz_drop_glyph = __root.fz_drop_glyph;
    pub const fz_outline_glyph = __root.fz_outline_glyph;
    pub const fz_fill_path = __root.fz_fill_path;
    pub const fz_stroke_path = __root.fz_stroke_path;
    pub const fz_clip_path = __root.fz_clip_path;
    pub const fz_clip_stroke_path = __root.fz_clip_stroke_path;
    pub const fz_fill_text = __root.fz_fill_text;
    pub const fz_stroke_text = __root.fz_stroke_text;
    pub const fz_clip_text = __root.fz_clip_text;
    pub const fz_clip_stroke_text = __root.fz_clip_stroke_text;
    pub const fz_ignore_text = __root.fz_ignore_text;
    pub const fz_pop_clip = __root.fz_pop_clip;
    pub const fz_fill_shade = __root.fz_fill_shade;
    pub const fz_fill_image = __root.fz_fill_image;
    pub const fz_fill_image_mask = __root.fz_fill_image_mask;
    pub const fz_clip_image_mask = __root.fz_clip_image_mask;
    pub const fz_begin_mask = __root.fz_begin_mask;
    pub const fz_end_mask = __root.fz_end_mask;
    pub const fz_begin_group = __root.fz_begin_group;
    pub const fz_end_group = __root.fz_end_group;
    pub const fz_begin_tile = __root.fz_begin_tile;
    pub const fz_begin_tile_id = __root.fz_begin_tile_id;
    pub const fz_end_tile = __root.fz_end_tile;
    pub const fz_render_flags = __root.fz_render_flags;
    pub const fz_set_default_colorspaces = __root.fz_set_default_colorspaces;
    pub const fz_begin_layer = __root.fz_begin_layer;
    pub const fz_end_layer = __root.fz_end_layer;
    pub const fz_begin_structure = __root.fz_begin_structure;
    pub const fz_end_structure = __root.fz_end_structure;
    pub const fz_begin_metatext = __root.fz_begin_metatext;
    pub const fz_end_metatext = __root.fz_end_metatext;
    pub const fz_new_device_of_size = __root.fz_new_device_of_size;
    pub const fz_close_device = __root.fz_close_device;
    pub const fz_drop_device = __root.fz_drop_device;
    pub const fz_keep_device = __root.fz_keep_device;
    pub const fz_enable_device_hints = __root.fz_enable_device_hints;
    pub const fz_disable_device_hints = __root.fz_disable_device_hints;
    pub const fz_device_current_scissor = __root.fz_device_current_scissor;
    pub const fz_new_trace_device = __root.fz_new_trace_device;
    pub const fz_new_xmltext_device = __root.fz_new_xmltext_device;
    pub const fz_new_bbox_device = __root.fz_new_bbox_device;
    pub const fz_new_test_device = __root.fz_new_test_device;
    pub const fz_new_draw_device = __root.fz_new_draw_device;
    pub const fz_new_draw_device_with_bbox = __root.fz_new_draw_device_with_bbox;
    pub const fz_new_draw_device_with_proof = __root.fz_new_draw_device_with_proof;
    pub const fz_new_draw_device_with_bbox_proof = __root.fz_new_draw_device_with_bbox_proof;
    pub const fz_new_draw_device_type3 = __root.fz_new_draw_device_type3;
    pub const fz_parse_draw_options = __root.fz_parse_draw_options;
    pub const fz_new_draw_device_with_options = __root.fz_new_draw_device_with_options;
    pub const fz_new_display_list = __root.fz_new_display_list;
    pub const fz_new_list_device = __root.fz_new_list_device;
    pub const fz_run_display_list = __root.fz_run_display_list;
    pub const fz_keep_display_list = __root.fz_keep_display_list;
    pub const fz_drop_display_list = __root.fz_drop_display_list;
    pub const fz_bound_display_list = __root.fz_bound_display_list;
    pub const fz_new_image_from_display_list = __root.fz_new_image_from_display_list;
    pub const fz_display_list_is_empty = __root.fz_display_list_is_empty;
    pub const fz_new_layout = __root.fz_new_layout;
    pub const fz_drop_layout = __root.fz_drop_layout;
    pub const fz_add_layout_line = __root.fz_add_layout_line;
    pub const fz_add_layout_char = __root.fz_add_layout_char;
    pub const fz_new_stext_page = __root.fz_new_stext_page;
    pub const fz_drop_stext_page = __root.fz_drop_stext_page;
    pub const fz_print_stext_page_as_html = __root.fz_print_stext_page_as_html;
    pub const fz_print_stext_header_as_html = __root.fz_print_stext_header_as_html;
    pub const fz_print_stext_trailer_as_html = __root.fz_print_stext_trailer_as_html;
    pub const fz_print_stext_page_as_xhtml = __root.fz_print_stext_page_as_xhtml;
    pub const fz_print_stext_header_as_xhtml = __root.fz_print_stext_header_as_xhtml;
    pub const fz_print_stext_trailer_as_xhtml = __root.fz_print_stext_trailer_as_xhtml;
    pub const fz_print_stext_page_as_xml = __root.fz_print_stext_page_as_xml;
    pub const fz_print_stext_page_as_json = __root.fz_print_stext_page_as_json;
    pub const fz_print_stext_page_as_text = __root.fz_print_stext_page_as_text;
    pub const fz_search_stext_page = __root.fz_search_stext_page;
    pub const fz_highlight_selection = __root.fz_highlight_selection;
    pub const fz_snap_selection = __root.fz_snap_selection;
    pub const fz_copy_selection = __root.fz_copy_selection;
    pub const fz_copy_rectangle = __root.fz_copy_rectangle;
    pub const fz_parse_stext_options = __root.fz_parse_stext_options;
    pub const fz_new_stext_device = __root.fz_new_stext_device;
    pub const fz_new_ocr_device = __root.fz_new_ocr_device;
    pub const fz_open_reflowed_document = __root.fz_open_reflowed_document;
    pub const fz_generate_transition = __root.fz_generate_transition;
    pub const fz_purge_glyph_cache = __root.fz_purge_glyph_cache;
    pub const fz_render_glyph_pixmap = __root.fz_render_glyph_pixmap;
    pub const fz_render_t3_glyph_direct = __root.fz_render_t3_glyph_direct;
    pub const fz_prepare_t3_glyph = __root.fz_prepare_t3_glyph;
    pub const fz_dump_glyph_cache_stats = __root.fz_dump_glyph_cache_stats;
    pub const fz_subpixel_adjust = __root.fz_subpixel_adjust;
    pub const fz_new_link_of_size = __root.fz_new_link_of_size;
    pub const fz_keep_link = __root.fz_keep_link;
    pub const fz_drop_link = __root.fz_drop_link;
    pub const fz_is_external_link = __root.fz_is_external_link;
    pub const fz_set_link_rect = __root.fz_set_link_rect;
    pub const fz_set_link_uri = __root.fz_set_link_uri;
    pub const fz_outline_iterator_item = __root.fz_outline_iterator_item;
    pub const fz_outline_iterator_next = __root.fz_outline_iterator_next;
    pub const fz_outline_iterator_prev = __root.fz_outline_iterator_prev;
    pub const fz_outline_iterator_up = __root.fz_outline_iterator_up;
    pub const fz_outline_iterator_down = __root.fz_outline_iterator_down;
    pub const fz_outline_iterator_insert = __root.fz_outline_iterator_insert;
    pub const fz_outline_iterator_delete = __root.fz_outline_iterator_delete;
    pub const fz_outline_iterator_update = __root.fz_outline_iterator_update;
    pub const fz_drop_outline_iterator = __root.fz_drop_outline_iterator;
    pub const fz_new_outline = __root.fz_new_outline;
    pub const fz_keep_outline = __root.fz_keep_outline;
    pub const fz_drop_outline = __root.fz_drop_outline;
    pub const fz_load_outline_from_iterator = __root.fz_load_outline_from_iterator;
    pub const fz_new_outline_iterator_of_size = __root.fz_new_outline_iterator_of_size;
    pub const fz_outline_iterator_from_outline = __root.fz_outline_iterator_from_outline;
    pub const fz_register_document_handler = __root.fz_register_document_handler;
    pub const fz_register_document_handlers = __root.fz_register_document_handlers;
    pub const fz_recognize_document = __root.fz_recognize_document;
    pub const fz_recognize_document_content = __root.fz_recognize_document_content;
    pub const fz_recognize_document_stream_content = __root.fz_recognize_document_stream_content;
    pub const fz_open_document = __root.fz_open_document;
    pub const fz_open_accelerated_document = __root.fz_open_accelerated_document;
    pub const fz_open_document_with_stream = __root.fz_open_document_with_stream;
    pub const fz_open_document_with_buffer = __root.fz_open_document_with_buffer;
    pub const fz_open_accelerated_document_with_stream = __root.fz_open_accelerated_document_with_stream;
    pub const fz_document_supports_accelerator = __root.fz_document_supports_accelerator;
    pub const fz_save_accelerator = __root.fz_save_accelerator;
    pub const fz_output_accelerator = __root.fz_output_accelerator;
    pub const fz_new_document_of_size = __root.fz_new_document_of_size;
    pub const fz_keep_document = __root.fz_keep_document;
    pub const fz_drop_document = __root.fz_drop_document;
    pub const fz_needs_password = __root.fz_needs_password;
    pub const fz_authenticate_password = __root.fz_authenticate_password;
    pub const fz_load_outline = __root.fz_load_outline;
    pub const fz_new_outline_iterator = __root.fz_new_outline_iterator;
    pub const fz_is_document_reflowable = __root.fz_is_document_reflowable;
    pub const fz_layout_document = __root.fz_layout_document;
    pub const fz_make_bookmark = __root.fz_make_bookmark;
    pub const fz_lookup_bookmark = __root.fz_lookup_bookmark;
    pub const fz_count_pages = __root.fz_count_pages;
    pub const fz_resolve_link_dest = __root.fz_resolve_link_dest;
    pub const fz_format_link_uri = __root.fz_format_link_uri;
    pub const fz_resolve_link = __root.fz_resolve_link;
    pub const fz_last_page = __root.fz_last_page;
    pub const fz_next_page = __root.fz_next_page;
    pub const fz_previous_page = __root.fz_previous_page;
    pub const fz_clamp_location = __root.fz_clamp_location;
    pub const fz_location_from_page_number = __root.fz_location_from_page_number;
    pub const fz_page_number_from_location = __root.fz_page_number_from_location;
    pub const fz_load_page = __root.fz_load_page;
    pub const fz_count_chapters = __root.fz_count_chapters;
    pub const fz_count_chapter_pages = __root.fz_count_chapter_pages;
    pub const fz_load_chapter_page = __root.fz_load_chapter_page;
    pub const fz_load_links = __root.fz_load_links;
    pub const fz_new_page_of_size = __root.fz_new_page_of_size;
    pub const fz_bound_page = __root.fz_bound_page;
    pub const fz_bound_page_box = __root.fz_bound_page_box;
    pub const fz_run_page = __root.fz_run_page;
    pub const fz_run_page_contents = __root.fz_run_page_contents;
    pub const fz_run_page_annots = __root.fz_run_page_annots;
    pub const fz_run_page_widgets = __root.fz_run_page_widgets;
    pub const fz_keep_page = __root.fz_keep_page;
    pub const fz_keep_page_locked = __root.fz_keep_page_locked;
    pub const fz_drop_page = __root.fz_drop_page;
    pub const fz_page_presentation = __root.fz_page_presentation;
    pub const fz_page_label = __root.fz_page_label;
    pub const fz_has_permission = __root.fz_has_permission;
    pub const fz_lookup_metadata = __root.fz_lookup_metadata;
    pub const fz_set_metadata = __root.fz_set_metadata;
    pub const fz_document_output_intent = __root.fz_document_output_intent;
    pub const fz_page_separations = __root.fz_page_separations;
    pub const fz_page_uses_overprint = __root.fz_page_uses_overprint;
    pub const fz_create_link = __root.fz_create_link;
    pub const fz_delete_link = __root.fz_delete_link;
    pub const fz_process_opened_pages = __root.fz_process_opened_pages;
    pub const fz_new_display_list_from_page = __root.fz_new_display_list_from_page;
    pub const fz_new_display_list_from_page_number = __root.fz_new_display_list_from_page_number;
    pub const fz_new_display_list_from_page_contents = __root.fz_new_display_list_from_page_contents;
    pub const fz_new_pixmap_from_display_list = __root.fz_new_pixmap_from_display_list;
    pub const fz_new_pixmap_from_page = __root.fz_new_pixmap_from_page;
    pub const fz_new_pixmap_from_page_number = __root.fz_new_pixmap_from_page_number;
    pub const fz_new_pixmap_from_page_contents = __root.fz_new_pixmap_from_page_contents;
    pub const fz_new_pixmap_from_display_list_with_separations = __root.fz_new_pixmap_from_display_list_with_separations;
    pub const fz_new_pixmap_from_page_with_separations = __root.fz_new_pixmap_from_page_with_separations;
    pub const fz_new_pixmap_from_page_number_with_separations = __root.fz_new_pixmap_from_page_number_with_separations;
    pub const fz_new_pixmap_from_page_contents_with_separations = __root.fz_new_pixmap_from_page_contents_with_separations;
    pub const fz_fill_pixmap_from_display_list = __root.fz_fill_pixmap_from_display_list;
    pub const fz_new_stext_page_from_page = __root.fz_new_stext_page_from_page;
    pub const fz_new_stext_page_from_page_number = __root.fz_new_stext_page_from_page_number;
    pub const fz_new_stext_page_from_chapter_page_number = __root.fz_new_stext_page_from_chapter_page_number;
    pub const fz_new_stext_page_from_display_list = __root.fz_new_stext_page_from_display_list;
    pub const fz_new_buffer_from_stext_page = __root.fz_new_buffer_from_stext_page;
    pub const fz_new_buffer_from_page = __root.fz_new_buffer_from_page;
    pub const fz_new_buffer_from_page_number = __root.fz_new_buffer_from_page_number;
    pub const fz_new_buffer_from_display_list = __root.fz_new_buffer_from_display_list;
    pub const fz_search_page = __root.fz_search_page;
    pub const fz_search_page_number = __root.fz_search_page_number;
    pub const fz_search_chapter_page_number = __root.fz_search_chapter_page_number;
    pub const fz_search_display_list = __root.fz_search_display_list;
    pub const fz_new_display_list_from_svg = __root.fz_new_display_list_from_svg;
    pub const fz_new_image_from_svg = __root.fz_new_image_from_svg;
    pub const fz_new_display_list_from_svg_xml = __root.fz_new_display_list_from_svg_xml;
    pub const fz_new_image_from_svg_xml = __root.fz_new_image_from_svg_xml;
    pub const fz_write_image_as_data_uri = __root.fz_write_image_as_data_uri;
    pub const fz_write_pixmap_as_data_uri = __root.fz_write_pixmap_as_data_uri;
    pub const fz_append_image_as_data_uri = __root.fz_append_image_as_data_uri;
    pub const fz_append_pixmap_as_data_uri = __root.fz_append_pixmap_as_data_uri;
    pub const fz_new_xhtml_document_from_document = __root.fz_new_xhtml_document_from_document;
    pub const fz_new_buffer_from_page_with_format = __root.fz_new_buffer_from_page_with_format;
    pub const fz_has_option = __root.fz_has_option;
    pub const fz_copy_option = __root.fz_copy_option;
    pub const fz_new_document_writer = __root.fz_new_document_writer;
    pub const fz_new_document_writer_with_output = __root.fz_new_document_writer_with_output;
    pub const fz_new_document_writer_with_buffer = __root.fz_new_document_writer_with_buffer;
    pub const fz_new_pdf_writer = __root.fz_new_pdf_writer;
    pub const fz_new_pdf_writer_with_output = __root.fz_new_pdf_writer_with_output;
    pub const fz_new_svg_writer = __root.fz_new_svg_writer;
    pub const fz_new_text_writer = __root.fz_new_text_writer;
    pub const fz_new_text_writer_with_output = __root.fz_new_text_writer_with_output;
    pub const fz_new_odt_writer = __root.fz_new_odt_writer;
    pub const fz_new_odt_writer_with_output = __root.fz_new_odt_writer_with_output;
    pub const fz_new_docx_writer = __root.fz_new_docx_writer;
    pub const fz_new_docx_writer_with_output = __root.fz_new_docx_writer_with_output;
    pub const fz_new_ps_writer = __root.fz_new_ps_writer;
    pub const fz_new_ps_writer_with_output = __root.fz_new_ps_writer_with_output;
    pub const fz_new_pcl_writer = __root.fz_new_pcl_writer;
    pub const fz_new_pcl_writer_with_output = __root.fz_new_pcl_writer_with_output;
    pub const fz_new_pclm_writer = __root.fz_new_pclm_writer;
    pub const fz_new_pclm_writer_with_output = __root.fz_new_pclm_writer_with_output;
    pub const fz_new_pwg_writer = __root.fz_new_pwg_writer;
    pub const fz_new_pwg_writer_with_output = __root.fz_new_pwg_writer_with_output;
    pub const fz_new_cbz_writer = __root.fz_new_cbz_writer;
    pub const fz_new_cbz_writer_with_output = __root.fz_new_cbz_writer_with_output;
    pub const fz_new_pdfocr_writer = __root.fz_new_pdfocr_writer;
    pub const fz_new_pdfocr_writer_with_output = __root.fz_new_pdfocr_writer_with_output;
    pub const fz_pdfocr_writer_set_progress = __root.fz_pdfocr_writer_set_progress;
    pub const fz_new_jpeg_pixmap_writer = __root.fz_new_jpeg_pixmap_writer;
    pub const fz_new_png_pixmap_writer = __root.fz_new_png_pixmap_writer;
    pub const fz_new_pam_pixmap_writer = __root.fz_new_pam_pixmap_writer;
    pub const fz_new_pnm_pixmap_writer = __root.fz_new_pnm_pixmap_writer;
    pub const fz_new_pgm_pixmap_writer = __root.fz_new_pgm_pixmap_writer;
    pub const fz_new_ppm_pixmap_writer = __root.fz_new_ppm_pixmap_writer;
    pub const fz_new_pbm_pixmap_writer = __root.fz_new_pbm_pixmap_writer;
    pub const fz_new_pkm_pixmap_writer = __root.fz_new_pkm_pixmap_writer;
    pub const fz_begin_page = __root.fz_begin_page;
    pub const fz_end_page = __root.fz_end_page;
    pub const fz_write_document = __root.fz_write_document;
    pub const fz_close_document_writer = __root.fz_close_document_writer;
    pub const fz_drop_document_writer = __root.fz_drop_document_writer;
    pub const fz_new_pixmap_writer = __root.fz_new_pixmap_writer;
    pub const fz_new_document_writer_of_size = __root.fz_new_document_writer_of_size;
    pub const fz_write_header = __root.fz_write_header;
    pub const fz_write_band = __root.fz_write_band;
    pub const fz_close_band_writer = __root.fz_close_band_writer;
    pub const fz_drop_band_writer = __root.fz_drop_band_writer;
    pub const fz_new_band_writer_of_size = __root.fz_new_band_writer_of_size;
    pub const fz_pcl_preset = __root.fz_pcl_preset;
    pub const fz_parse_pcl_options = __root.fz_parse_pcl_options;
    pub const fz_new_mono_pcl_band_writer = __root.fz_new_mono_pcl_band_writer;
    pub const fz_write_bitmap_as_pcl = __root.fz_write_bitmap_as_pcl;
    pub const fz_save_bitmap_as_pcl = __root.fz_save_bitmap_as_pcl;
    pub const fz_new_color_pcl_band_writer = __root.fz_new_color_pcl_band_writer;
    pub const fz_write_pixmap_as_pcl = __root.fz_write_pixmap_as_pcl;
    pub const fz_save_pixmap_as_pcl = __root.fz_save_pixmap_as_pcl;
    pub const fz_parse_pclm_options = __root.fz_parse_pclm_options;
    pub const fz_new_pclm_band_writer = __root.fz_new_pclm_band_writer;
    pub const fz_write_pixmap_as_pclm = __root.fz_write_pixmap_as_pclm;
    pub const fz_save_pixmap_as_pclm = __root.fz_save_pixmap_as_pclm;
    pub const fz_parse_pdfocr_options = __root.fz_parse_pdfocr_options;
    pub const fz_new_pdfocr_band_writer = __root.fz_new_pdfocr_band_writer;
    pub const fz_pdfocr_band_writer_set_progress = __root.fz_pdfocr_band_writer_set_progress;
    pub const fz_write_pixmap_as_pdfocr = __root.fz_write_pixmap_as_pdfocr;
    pub const fz_save_pixmap_as_pdfocr = __root.fz_save_pixmap_as_pdfocr;
    pub const fz_save_pixmap_as_png = __root.fz_save_pixmap_as_png;
    pub const fz_write_pixmap_as_jpeg = __root.fz_write_pixmap_as_jpeg;
    pub const fz_save_pixmap_as_jpeg = __root.fz_save_pixmap_as_jpeg;
    pub const fz_write_pixmap_as_png = __root.fz_write_pixmap_as_png;
    pub const fz_new_png_band_writer = __root.fz_new_png_band_writer;
    pub const fz_new_buffer_from_image_as_png = __root.fz_new_buffer_from_image_as_png;
    pub const fz_new_buffer_from_image_as_pnm = __root.fz_new_buffer_from_image_as_pnm;
    pub const fz_new_buffer_from_image_as_pam = __root.fz_new_buffer_from_image_as_pam;
    pub const fz_new_buffer_from_image_as_psd = __root.fz_new_buffer_from_image_as_psd;
    pub const fz_new_buffer_from_image_as_jpeg = __root.fz_new_buffer_from_image_as_jpeg;
    pub const fz_new_buffer_from_pixmap_as_png = __root.fz_new_buffer_from_pixmap_as_png;
    pub const fz_new_buffer_from_pixmap_as_pnm = __root.fz_new_buffer_from_pixmap_as_pnm;
    pub const fz_new_buffer_from_pixmap_as_pam = __root.fz_new_buffer_from_pixmap_as_pam;
    pub const fz_new_buffer_from_pixmap_as_psd = __root.fz_new_buffer_from_pixmap_as_psd;
    pub const fz_new_buffer_from_pixmap_as_jpeg = __root.fz_new_buffer_from_pixmap_as_jpeg;
    pub const fz_save_pixmap_as_pnm = __root.fz_save_pixmap_as_pnm;
    pub const fz_write_pixmap_as_pnm = __root.fz_write_pixmap_as_pnm;
    pub const fz_new_pnm_band_writer = __root.fz_new_pnm_band_writer;
    pub const fz_save_pixmap_as_pam = __root.fz_save_pixmap_as_pam;
    pub const fz_write_pixmap_as_pam = __root.fz_write_pixmap_as_pam;
    pub const fz_new_pam_band_writer = __root.fz_new_pam_band_writer;
    pub const fz_save_bitmap_as_pbm = __root.fz_save_bitmap_as_pbm;
    pub const fz_write_bitmap_as_pbm = __root.fz_write_bitmap_as_pbm;
    pub const fz_new_pbm_band_writer = __root.fz_new_pbm_band_writer;
    pub const fz_save_pixmap_as_pbm = __root.fz_save_pixmap_as_pbm;
    pub const fz_save_bitmap_as_pkm = __root.fz_save_bitmap_as_pkm;
    pub const fz_write_bitmap_as_pkm = __root.fz_write_bitmap_as_pkm;
    pub const fz_new_pkm_band_writer = __root.fz_new_pkm_band_writer;
    pub const fz_save_pixmap_as_pkm = __root.fz_save_pixmap_as_pkm;
    pub const fz_write_pixmap_as_ps = __root.fz_write_pixmap_as_ps;
    pub const fz_save_pixmap_as_ps = __root.fz_save_pixmap_as_ps;
    pub const fz_new_ps_band_writer = __root.fz_new_ps_band_writer;
    pub const fz_write_ps_file_header = __root.fz_write_ps_file_header;
    pub const fz_write_ps_file_trailer = __root.fz_write_ps_file_trailer;
    pub const fz_save_pixmap_as_psd = __root.fz_save_pixmap_as_psd;
    pub const fz_write_pixmap_as_psd = __root.fz_write_pixmap_as_psd;
    pub const fz_new_psd_band_writer = __root.fz_new_psd_band_writer;
    pub const fz_save_pixmap_as_pwg = __root.fz_save_pixmap_as_pwg;
    pub const fz_save_bitmap_as_pwg = __root.fz_save_bitmap_as_pwg;
    pub const fz_write_pixmap_as_pwg = __root.fz_write_pixmap_as_pwg;
    pub const fz_write_bitmap_as_pwg = __root.fz_write_bitmap_as_pwg;
    pub const fz_write_pixmap_as_pwg_page = __root.fz_write_pixmap_as_pwg_page;
    pub const fz_write_bitmap_as_pwg_page = __root.fz_write_bitmap_as_pwg_page;
    pub const fz_new_mono_pwg_band_writer = __root.fz_new_mono_pwg_band_writer;
    pub const fz_new_pwg_band_writer = __root.fz_new_pwg_band_writer;
    pub const fz_write_pwg_file_header = __root.fz_write_pwg_file_header;
    pub const fz_new_svg_device = __root.fz_new_svg_device;
    pub const fz_new_svg_device_with_id = __root.fz_new_svg_device_with_id;
    pub const fz_new_story = __root.fz_new_story;
    pub const fz_story_warnings = __root.fz_story_warnings;
    pub const fz_place_story = __root.fz_place_story;
    pub const fz_draw_story = __root.fz_draw_story;
    pub const fz_reset_story = __root.fz_reset_story;
    pub const fz_drop_story = __root.fz_drop_story;
    pub const fz_story_document = __root.fz_story_document;
    pub const fz_story_positions = __root.fz_story_positions;
    pub const fz_write_story = __root.fz_write_story;
    pub const fz_write_stabilized_story = __root.fz_write_stabilized_story;
    pub const vthrow = __root.fz_vthrow;
    pub const throw = __root.fz_throw;
    pub const rethrow = __root.fz_rethrow;
    pub const vwarn = __root.fz_vwarn;
    pub const message = __root.fz_caught_message;
    pub const caught = __root.fz_caught;
    pub const @"if" = __root.fz_rethrow_if;
    pub const repair = __root.fz_start_throw_on_repair;
    pub const warnings = __root.fz_flush_warnings;
    pub const held = __root.fz_assert_lock_held;
    pub const lock = __root.fz_lock_debug_lock;
    pub const unlock = __root.fz_lock_debug_unlock;
    pub const context = __root.fz_clone_context;
    pub const callback = __root.fz_set_error_callback;
    pub const decode = __root.fz_tune_image_decode;
    pub const scale = __root.fz_tune_image_scale;
    pub const level = __root.fz_aa_level;
    pub const width = __root.fz_graphics_min_line_width;
    pub const css = __root.fz_user_css;
    pub const icc = __root.fz_enable_icc;
    pub const memrnd = __root.fz_memrnd;
    pub const @"try" = __root.fz_push_try;
    pub const always = __root.fz_do_always;
    pub const @"catch" = __root.fz_do_catch;
    pub const imp = __root.fz_keep_imp;
    pub const locked = __root.fz_keep_imp_locked;
    pub const imp8 = __root.fz_keep_imp8;
    pub const imp16 = __root.fz_keep_imp16;
    pub const buffer = __root.fz_keep_buffer;
    pub const storage = __root.fz_buffer_storage;
    pub const data = __root.fz_new_buffer_from_data;
    pub const base64 = __root.fz_new_buffer_from_base64;
    pub const string = __root.fz_append_string;
    pub const byte = __root.fz_append_byte;
    pub const rune = __root.fz_append_rune;
    pub const le = __root.fz_append_int32_le;
    pub const be = __root.fz_append_int32_be;
    pub const bits = __root.fz_append_bits;
    pub const pad = __root.fz_append_bits_pad;
    pub const extract = __root.fz_buffer_extract;
    pub const uri = __root.fz_decode_uri;
    pub const component = __root.fz_decode_uri_component;
    pub const pathname = __root.fz_encode_uri_pathname;
    pub const path = __root.fz_format_output_path;
    pub const range = __root.fz_is_page_range;
    pub const exists = __root.fz_file_exists;
    pub const file = __root.fz_open_file;
    pub const memory = __root.fz_open_memory;
    pub const leecher = __root.fz_open_leecher;
    pub const stream = __root.fz_keep_stream;
    pub const tell = __root.fz_tell;
    pub const seek = __root.fz_seek;
    pub const read = __root.fz_read;
    pub const skip = __root.fz_skip;
    pub const all = __root.fz_read_all;
    pub const uint16 = __root.fz_read_uint16;
    pub const uint24 = __root.fz_read_uint24;
    pub const uint32 = __root.fz_read_uint32;
    pub const uint64 = __root.fz_read_uint64;
    pub const int16 = __root.fz_read_int16;
    pub const int32 = __root.fz_read_int32;
    pub const int64 = __root.fz_read_int64;
    pub const float = __root.fz_read_float;
    pub const best = __root.fz_read_best;
    pub const line = __root.fz_read_line;
    pub const space = __root.fz_skip_space;
    pub const available = __root.fz_available;
    pub const eof = __root.fz_is_eof;
    pub const rbits = __root.fz_read_rbits;
    pub const close = __root.fz_open_file_ptr_no_close;
    pub const output = __root.fz_new_output;
    pub const char = __root.fz_write_char;
    pub const sync = __root.fz_write_bits_sync;
    pub const log = __root.fz_log;
    pub const module = __root.fz_log_module;
    pub const table = __root.fz_new_hash_table;
    pub const find = __root.fz_hash_find;
    pub const insert = __root.fz_hash_insert;
    pub const each = __root.fz_hash_for_each;
    pub const filter = __root.fz_hash_filter;
    pub const pool = __root.fz_new_pool;
    pub const size = __root.fz_pool_size;
    pub const lookup = __root.fz_tree_lookup;
    pub const tree = __root.fz_drop_tree;
    pub const text = __root.fz_bidi_fragment_text;
    pub const archive = __root.fz_open_archive;
    pub const directory = __root.fz_open_directory;
    pub const format = __root.fz_archive_format;
    pub const entries = __root.fz_count_archive_entries;
    pub const entry = __root.fz_list_archive_entry;
    pub const writer = __root.fz_new_zip_writer;
    pub const xml = __root.fz_parse_xml;
    pub const html5 = __root.fz_parse_xml_from_html5;
    pub const att = __root.fz_xml_add_att;
    pub const body = __root.fz_dom_body;
    pub const element = __root.fz_dom_document_element;
    pub const node = __root.fz_dom_create_text_node;
    pub const next = __root.fz_dom_find_next;
    pub const child = __root.fz_dom_append_child;
    pub const before = __root.fz_dom_insert_before;
    pub const after = __root.fz_dom_insert_after;
    pub const clone = __root.fz_dom_clone;
    pub const parent = __root.fz_dom_parent;
    pub const previous = __root.fz_dom_previous;
    pub const attribute = __root.fz_dom_add_attribute;
    pub const bound = __root.fz_deflate_bound;
    pub const deflate = __root.fz_deflate;
    pub const g3 = __root.fz_compress_ccitt_fax_g3;
    pub const g4 = __root.fz_compress_ccitt_fax_g4;
    pub const storable = __root.fz_keep_storable;
    pub const key = __root.fz_keep_key_storable_key;
    pub const item = __root.fz_store_item;
    pub const scavenge = __root.fz_store_scavenge;
    pub const external = __root.fz_store_scavenge_external;
    pub const start = __root.fz_defer_reap_start;
    pub const end = __root.fz_defer_reap_end;
    pub const concat = __root.fz_open_concat;
    pub const drop = __root.fz_concat_push_drop;
    pub const arc4 = __root.fz_open_arc4;
    pub const aesd = __root.fz_open_aesd;
    pub const a85d = __root.fz_open_a85d;
    pub const ahxd = __root.fz_open_ahxd;
    pub const rld = __root.fz_open_rld;
    pub const dctd = __root.fz_open_dctd;
    pub const faxd = __root.fz_open_faxd;
    pub const flated = __root.fz_open_flated;
    pub const lzwd = __root.fz_open_lzwd;
    pub const predict = __root.fz_open_predict;
    pub const jbig2d = __root.fz_open_jbig2d;
    pub const globals = __root.fz_load_jbig2_globals;
    pub const sgilog16 = __root.fz_open_sgilog16;
    pub const sgilog24 = __root.fz_open_sgilog24;
    pub const sgilog32 = __root.fz_open_sgilog32;
    pub const thunder = __root.fz_open_thunder;
    pub const @"type" = __root.fz_colorspace_type;
    pub const name = __root.fz_colorspace_name;
    pub const n = __root.fz_colorspace_n;
    pub const subtractive = __root.fz_colorspace_is_subtractive;
    pub const cmyk = __root.fz_colorspace_device_n_has_only_cmyk;
    pub const gray = __root.fz_colorspace_is_gray;
    pub const rgb = __root.fz_colorspace_is_rgb;
    pub const lab = __root.fz_colorspace_is_lab;
    pub const indexed = __root.fz_colorspace_is_indexed;
    pub const device = __root.fz_colorspace_is_device;
    pub const bgr = __root.fz_device_bgr;
    pub const colorant = __root.fz_colorspace_name_colorant;
    pub const color = __root.fz_clamp_color;
    pub const colorspaces = __root.fz_new_default_colorspaces;
    pub const intent = __root.fz_default_output_intent;
    pub const separations = __root.fz_new_separations;
    pub const separation = __root.fz_add_separation;
    pub const equivalents = __root.fz_add_separation_equivalents;
    pub const behavior = __root.fz_set_separation_behavior;
    pub const overprint = __root.fz_clone_separations_for_overprint;
    pub const colors = __root.fz_convert_separation_colors;
    pub const equivalent = __root.fz_separation_equivalent;
    pub const bbox = __root.fz_pixmap_bbox;
    pub const height = __root.fz_pixmap_height;
    pub const x = __root.fz_pixmap_x;
    pub const y = __root.fz_pixmap_y;
    pub const pixmap = __root.fz_new_pixmap;
    pub const components = __root.fz_pixmap_components;
    pub const colorants = __root.fz_pixmap_colorants;
    pub const spots = __root.fz_pixmap_spots;
    pub const alpha = __root.fz_pixmap_alpha;
    pub const samples = __root.fz_pixmap_samples;
    pub const stride = __root.fz_pixmap_stride;
    pub const resolution = __root.fz_set_pixmap_resolution;
    pub const value = __root.fz_clear_pixmap_with_value;
    pub const luminance = __root.fz_invert_pixmap_luminance;
    pub const rect = __root.fz_invert_pixmap_rect;
    pub const raw = __root.fz_invert_pixmap_raw;
    pub const monochrome = __root.fz_is_pixmap_monochrome;
    pub const tile = __root.fz_decode_tile;
    pub const seps = __root.fz_clone_pixmap_area_with_different_seps;
    pub const channel = __root.fz_new_pixmap_from_alpha_channel;
    pub const mask = __root.fz_new_pixmap_from_color_and_mask;
    pub const bitmap = __root.fz_keep_bitmap;
    pub const band = __root.fz_new_bitmap_from_pixmap_band;
    pub const halftone = __root.fz_default_halftone;
    pub const image = __root.fz_get_pixmap_from_image;
    pub const base = __root.fz_drop_image_base;
    pub const orientation = __root.fz_image_orientation;
    pub const matrix = __root.fz_image_orientation_matrix;
    pub const jpx = __root.fz_load_jpx;
    pub const count = __root.fz_load_tiff_subimage_count;
    pub const subimage = __root.fz_load_tiff_subimage;
    pub const shade = __root.fz_keep_shade;
    pub const cache = __root.fz_drop_shade_color_cache;
    pub const face = __root.fz_font_ft_face;
    pub const procs = __root.fz_font_t3_procs;
    pub const bold = __root.fz_font_is_bold;
    pub const italic = __root.fz_font_is_italic;
    pub const serif = __root.fz_font_is_serif;
    pub const monospaced = __root.fz_font_is_monospaced;
    pub const funcs = __root.fz_install_load_system_font_funcs;
    pub const language = __root.fz_lookup_cjk_font_by_language;
    pub const embedding = __root.fz_set_font_embedding;
    pub const glyph = __root.fz_bound_glyph;
    pub const cacheable = __root.fz_glyph_cacheable;
    pub const character = __root.fz_encode_character;
    pub const sc = __root.fz_encode_character_sc;
    pub const fallback = __root.fz_encode_character_with_fallback;
    pub const ascender = __root.fz_font_ascender;
    pub const descender = __root.fz_font_descender;
    pub const digest = __root.fz_font_digest;
    pub const currentpoint = __root.fz_currentpoint;
    pub const moveto = __root.fz_moveto;
    pub const lineto = __root.fz_lineto;
    pub const rectto = __root.fz_rectto;
    pub const quadto = __root.fz_quadto;
    pub const curveto = __root.fz_curveto;
    pub const curvetov = __root.fz_curvetov;
    pub const curvetoy = __root.fz_curvetoy;
    pub const closepath = __root.fz_closepath;
    pub const stroke = __root.fz_adjust_rect_for_stroke;
    pub const state = __root.fz_new_stroke_state;
    pub const len = __root.fz_new_stroke_state_with_dash_len;
    pub const aux = __root.fz_show_glyph_aux;
    pub const clip = __root.fz_pop_clip;
    pub const group = __root.fz_begin_group;
    pub const id = __root.fz_begin_tile_id;
    pub const flags = __root.fz_render_flags;
    pub const layer = __root.fz_begin_layer;
    pub const structure = __root.fz_begin_structure;
    pub const metatext = __root.fz_begin_metatext;
    pub const hints = __root.fz_enable_device_hints;
    pub const scissor = __root.fz_device_current_scissor;
    pub const proof = __root.fz_new_draw_device_with_proof;
    pub const type3 = __root.fz_new_draw_device_type3;
    pub const options = __root.fz_parse_draw_options;
    pub const list = __root.fz_new_display_list;
    pub const empty = __root.fz_display_list_is_empty;
    pub const layout = __root.fz_new_layout;
    pub const page = __root.fz_new_stext_page;
    pub const html = __root.fz_print_stext_page_as_html;
    pub const xhtml = __root.fz_print_stext_page_as_xhtml;
    pub const json = __root.fz_print_stext_page_as_json;
    pub const selection = __root.fz_highlight_selection;
    pub const rectangle = __root.fz_copy_rectangle;
    pub const document = __root.fz_open_reflowed_document;
    pub const transition = __root.fz_generate_transition;
    pub const direct = __root.fz_render_t3_glyph_direct;
    pub const stats = __root.fz_dump_glyph_cache_stats;
    pub const adjust = __root.fz_subpixel_adjust;
    pub const link = __root.fz_keep_link;
    pub const prev = __root.fz_outline_iterator_prev;
    pub const up = __root.fz_outline_iterator_up;
    pub const down = __root.fz_outline_iterator_down;
    pub const delete = __root.fz_outline_iterator_delete;
    pub const update = __root.fz_outline_iterator_update;
    pub const iterator = __root.fz_drop_outline_iterator;
    pub const outline = __root.fz_new_outline;
    pub const handlers = __root.fz_register_document_handlers;
    pub const content = __root.fz_recognize_document_content;
    pub const accelerator = __root.fz_document_supports_accelerator;
    pub const password = __root.fz_needs_password;
    pub const reflowable = __root.fz_is_document_reflowable;
    pub const bookmark = __root.fz_make_bookmark;
    pub const pages = __root.fz_count_pages;
    pub const dest = __root.fz_resolve_link_dest;
    pub const location = __root.fz_clamp_location;
    pub const number = __root.fz_location_from_page_number;
    pub const chapters = __root.fz_count_chapters;
    pub const links = __root.fz_load_links;
    pub const box = __root.fz_bound_page_box;
    pub const contents = __root.fz_run_page_contents;
    pub const annots = __root.fz_run_page_annots;
    pub const widgets = __root.fz_run_page_widgets;
    pub const presentation = __root.fz_page_presentation;
    pub const label = __root.fz_page_label;
    pub const permission = __root.fz_has_permission;
    pub const metadata = __root.fz_lookup_metadata;
    pub const svg = __root.fz_new_display_list_from_svg;
    pub const option = __root.fz_has_option;
    pub const progress = __root.fz_pdfocr_writer_set_progress;
    pub const header = __root.fz_write_header;
    pub const preset = __root.fz_pcl_preset;
    pub const pcl = __root.fz_write_bitmap_as_pcl;
    pub const pclm = __root.fz_write_pixmap_as_pclm;
    pub const pdfocr = __root.fz_write_pixmap_as_pdfocr;
    pub const png = __root.fz_save_pixmap_as_png;
    pub const jpeg = __root.fz_write_pixmap_as_jpeg;
    pub const pnm = __root.fz_new_buffer_from_image_as_pnm;
    pub const pam = __root.fz_new_buffer_from_image_as_pam;
    pub const psd = __root.fz_new_buffer_from_image_as_psd;
    pub const pbm = __root.fz_save_bitmap_as_pbm;
    pub const pkm = __root.fz_save_bitmap_as_pkm;
    pub const ps = __root.fz_write_pixmap_as_ps;
    pub const trailer = __root.fz_write_ps_file_trailer;
    pub const pwg = __root.fz_save_pixmap_as_pwg;
    pub const story = __root.fz_new_story;
    pub const positions = __root.fz_story_positions;
};
pub const fz_context = struct_fz_context;
pub const fz_output_write_fn = fn (ctx: [*c]fz_context, state: ?*anyopaque, data: ?*const anyopaque, n: usize) callconv(.c) void;
pub const fz_output_seek_fn = fn (ctx: [*c]fz_context, state: ?*anyopaque, offset: i64, whence: c_int) callconv(.c) void;
pub const fz_output_tell_fn = fn (ctx: [*c]fz_context, state: ?*anyopaque) callconv(.c) i64;
pub const fz_output_close_fn = fn (ctx: [*c]fz_context, state: ?*anyopaque) callconv(.c) void;
pub const fz_output_drop_fn = fn (ctx: [*c]fz_context, state: ?*anyopaque) callconv(.c) void;
pub const fz_stream_next_fn = fn (ctx: [*c]fz_context, stm: [*c]fz_stream, max: usize) callconv(.c) c_int;
pub const fz_stream_drop_fn = fn (ctx: [*c]fz_context, state: ?*anyopaque) callconv(.c) void;
pub const fz_stream_seek_fn = fn (ctx: [*c]fz_context, stm: [*c]fz_stream, offset: i64, whence: c_int) callconv(.c) void;
pub const struct_fz_stream = extern struct {
    refs: c_int = 0,
    @"error": c_int = 0,
    eof: c_int = 0,
    progressive: c_int = 0,
    pos: i64 = 0,
    avail: c_int = 0,
    bits: c_int = 0,
    rp: [*c]u8 = null,
    wp: [*c]u8 = null,
    state: ?*anyopaque = null,
    next: ?*const fz_stream_next_fn = null,
    drop: ?*const fz_stream_drop_fn = null,
    seek: ?*const fz_stream_seek_fn = null,
};
pub const fz_stream = struct_fz_stream;
pub const fz_stream_from_output_fn = fn (ctx: [*c]fz_context, state: ?*anyopaque) callconv(.c) [*c]fz_stream;
pub const fz_truncate_fn = fn (ctx: [*c]fz_context, state: ?*anyopaque) callconv(.c) void;
pub const struct_fz_output = extern struct {
    state: ?*anyopaque = null,
    write: ?*const fz_output_write_fn = null,
    seek: ?*const fz_output_seek_fn = null,
    tell: ?*const fz_output_tell_fn = null,
    close: ?*const fz_output_close_fn = null,
    drop: ?*const fz_output_drop_fn = null,
    as_stream: ?*const fz_stream_from_output_fn = null,
    truncate: ?*const fz_truncate_fn = null,
    bp: [*c]u8 = null,
    wp: [*c]u8 = null,
    ep: [*c]u8 = null,
    buffered: c_int = 0,
    bits: c_int = 0,
};
pub const fz_alloc_context = extern struct {
    user: ?*anyopaque = null,
    malloc: ?*const fn (?*anyopaque, usize) callconv(.c) ?*anyopaque = null,
    realloc: ?*const fn (?*anyopaque, ?*anyopaque, usize) callconv(.c) ?*anyopaque = null,
    free: ?*const fn (?*anyopaque, ?*anyopaque) callconv(.c) void = null,
    pub const fz_new_context_imp = __root.fz_new_context_imp;
    pub const imp = __root.fz_new_context_imp;
};
pub extern fn fz_vthrow(ctx: [*c]fz_context, errcode: c_int, [*c]const u8, ap: [*c]struct___va_list_tag_1) noreturn;
pub extern fn fz_throw(ctx: [*c]fz_context, errcode: c_int, [*c]const u8, ...) noreturn;
pub extern fn fz_rethrow(ctx: [*c]fz_context) noreturn;
pub extern fn fz_morph_error(ctx: [*c]fz_context, fromcode: c_int, tocode: c_int) void;
pub extern fn fz_vwarn(ctx: [*c]fz_context, fmt: [*c]const u8, ap: [*c]struct___va_list_tag_1) void;
pub extern fn fz_warn(ctx: [*c]fz_context, fmt: [*c]const u8, ...) void;
pub extern fn fz_caught_message(ctx: [*c]fz_context) [*c]const u8;
pub extern fn fz_caught(ctx: [*c]fz_context) c_int;
pub extern fn fz_rethrow_if(ctx: [*c]fz_context, errcode: c_int) void;
pub extern fn fz_log_error_printf(ctx: [*c]fz_context, fmt: [*c]const u8, ...) void;
pub extern fn fz_vlog_error_printf(ctx: [*c]fz_context, fmt: [*c]const u8, ap: [*c]struct___va_list_tag_1) void;
pub extern fn fz_log_error(ctx: [*c]fz_context, str: [*c]const u8) void;
pub extern fn fz_start_throw_on_repair(ctx: [*c]fz_context) void;
pub extern fn fz_end_throw_on_repair(ctx: [*c]fz_context) void;
pub const FZ_ERROR_NONE: c_int = 0;
pub const FZ_ERROR_MEMORY: c_int = 1;
pub const FZ_ERROR_GENERIC: c_int = 2;
pub const FZ_ERROR_SYNTAX: c_int = 3;
pub const FZ_ERROR_MINOR: c_int = 4;
pub const FZ_ERROR_TRYLATER: c_int = 5;
pub const FZ_ERROR_ABORT: c_int = 6;
pub const FZ_ERROR_REPAIRED: c_int = 7;
pub const FZ_ERROR_COUNT: c_int = 8;
const enum_unnamed_5 = c_uint;
pub extern fn fz_flush_warnings(ctx: [*c]fz_context) void;
pub const fz_locks_context = extern struct {
    user: ?*anyopaque = null,
    lock: ?*const fn (user: ?*anyopaque, lock: c_int) callconv(.c) void = null,
    unlock: ?*const fn (user: ?*anyopaque, lock: c_int) callconv(.c) void = null,
};
pub const FZ_LOCK_ALLOC: c_int = 0;
pub const FZ_LOCK_FREETYPE: c_int = 1;
pub const FZ_LOCK_GLYPHCACHE: c_int = 2;
pub const FZ_LOCK_MAX: c_int = 3;
const enum_unnamed_6 = c_uint;
pub extern fn fz_assert_lock_held(ctx: [*c]fz_context, lock: c_int) void;
pub extern fn fz_assert_lock_not_held(ctx: [*c]fz_context, lock: c_int) void;
pub extern fn fz_lock_debug_lock(ctx: [*c]fz_context, lock: c_int) void;
pub extern fn fz_lock_debug_unlock(ctx: [*c]fz_context, lock: c_int) void;
pub const FZ_STORE_UNLIMITED: c_int = 0;
pub const FZ_STORE_DEFAULT: c_int = 268435456;
const enum_unnamed_7 = c_uint;
pub extern fn fz_clone_context(ctx: [*c]fz_context) [*c]fz_context;
pub extern fn fz_drop_context(ctx: [*c]fz_context) void;
pub extern fn fz_set_user_context(ctx: [*c]fz_context, user: ?*anyopaque) void;
pub extern fn fz_user_context(ctx: [*c]fz_context) ?*anyopaque;
pub extern fn fz_default_error_callback(user: ?*anyopaque, message: [*c]const u8) void;
pub extern fn fz_default_warning_callback(user: ?*anyopaque, message: [*c]const u8) void;
pub const fz_error_cb = fn (user: ?*anyopaque, message: [*c]const u8) callconv(.c) void;
pub const fz_warning_cb = fn (user: ?*anyopaque, message: [*c]const u8) callconv(.c) void;
pub extern fn fz_set_error_callback(ctx: [*c]fz_context, error_cb: ?*const fz_error_cb, user: ?*anyopaque) void;
pub extern fn fz_error_callback(ctx: [*c]fz_context, user: [*c]?*anyopaque) ?*const fz_error_cb;
pub extern fn fz_set_warning_callback(ctx: [*c]fz_context, warning_cb: ?*const fz_warning_cb, user: ?*anyopaque) void;
pub extern fn fz_warning_callback(ctx: [*c]fz_context, user: [*c]?*anyopaque) ?*const fz_warning_cb;
pub const fz_tune_image_decode_fn = fn (arg: ?*anyopaque, w: c_int, h: c_int, l2factor: c_int, subarea: [*c]fz_irect) callconv(.c) void;
pub const fz_tune_image_scale_fn = fn (arg: ?*anyopaque, dst_w: c_int, dst_h: c_int, src_w: c_int, src_h: c_int) callconv(.c) c_int;
pub extern fn fz_tune_image_decode(ctx: [*c]fz_context, image_decode: ?*const fz_tune_image_decode_fn, arg: ?*anyopaque) void;
pub extern fn fz_tune_image_scale(ctx: [*c]fz_context, image_scale: ?*const fz_tune_image_scale_fn, arg: ?*anyopaque) void;
pub extern fn fz_aa_level(ctx: [*c]fz_context) c_int;
pub extern fn fz_set_aa_level(ctx: [*c]fz_context, bits: c_int) void;
pub extern fn fz_text_aa_level(ctx: [*c]fz_context) c_int;
pub extern fn fz_set_text_aa_level(ctx: [*c]fz_context, bits: c_int) void;
pub extern fn fz_graphics_aa_level(ctx: [*c]fz_context) c_int;
pub extern fn fz_set_graphics_aa_level(ctx: [*c]fz_context, bits: c_int) void;
pub extern fn fz_graphics_min_line_width(ctx: [*c]fz_context) f32;
pub extern fn fz_set_graphics_min_line_width(ctx: [*c]fz_context, min_line_width: f32) void;
pub extern fn fz_user_css(ctx: [*c]fz_context) [*c]const u8;
pub extern fn fz_set_user_css(ctx: [*c]fz_context, text: [*c]const u8) void;
pub extern fn fz_use_document_css(ctx: [*c]fz_context) c_int;
pub extern fn fz_set_use_document_css(ctx: [*c]fz_context, use: c_int) void;
pub extern fn fz_enable_icc(ctx: [*c]fz_context) void;
pub extern fn fz_disable_icc(ctx: [*c]fz_context) void;
pub extern fn fz_malloc(ctx: [*c]fz_context, size: usize) ?*anyopaque;
pub extern fn fz_calloc(ctx: [*c]fz_context, count: usize, size: usize) ?*anyopaque;
pub extern fn fz_realloc(ctx: [*c]fz_context, p: ?*anyopaque, size: usize) ?*anyopaque;
pub extern fn fz_free(ctx: [*c]fz_context, p: ?*anyopaque) void;
pub extern fn fz_malloc_no_throw(ctx: [*c]fz_context, size: usize) ?*anyopaque;
pub extern fn fz_calloc_no_throw(ctx: [*c]fz_context, count: usize, size: usize) ?*anyopaque;
pub extern fn fz_realloc_no_throw(ctx: [*c]fz_context, p: ?*anyopaque, size: usize) ?*anyopaque;
pub extern fn fz_strdup(ctx: [*c]fz_context, s: [*c]const u8) [*c]u8;
pub extern fn fz_memrnd(ctx: [*c]fz_context, block: [*c]u8, len: c_int) void;
pub extern fn fz_var_imp(?*anyopaque) void;
pub extern fn fz_push_try(ctx: [*c]fz_context) [*c]fz_jmp_buf;
pub extern fn fz_do_try(ctx: [*c]fz_context) c_int;
pub extern fn fz_do_always(ctx: [*c]fz_context) c_int;
pub extern fn fz_do_catch(ctx: [*c]fz_context) c_int;
pub const fz_error_stack_slot = extern struct {
    buffer: fz_jmp_buf = @import("std").mem.zeroes(fz_jmp_buf),
    state: c_int = 0,
    code: c_int = 0,
    padding: [24]u8 = @import("std").mem.zeroes([24]u8),
};
pub const fz_error_context = extern struct {
    top: [*c]fz_error_stack_slot = null,
    stack: [256]fz_error_stack_slot = @import("std").mem.zeroes([256]fz_error_stack_slot),
    padding: fz_error_stack_slot = @import("std").mem.zeroes(fz_error_stack_slot),
    stack_base: [*c]fz_error_stack_slot = null,
    errcode: c_int = 0,
    print_user: ?*anyopaque = null,
    print: ?*const fn (user: ?*anyopaque, message: [*c]const u8) callconv(.c) void = null,
    message: [256]u8 = @import("std").mem.zeroes([256]u8),
};
pub const fz_warn_context = extern struct {
    print_user: ?*anyopaque = null,
    print: ?*const fn (user: ?*anyopaque, message: [*c]const u8) callconv(.c) void = null,
    count: c_int = 0,
    message: [256]u8 = @import("std").mem.zeroes([256]u8),
};
pub const fz_aa_context = extern struct {
    hscale: c_int = 0,
    vscale: c_int = 0,
    scale: c_int = 0,
    bits: c_int = 0,
    text_bits: c_int = 0,
    min_line_width: f32 = 0,
};
pub extern fn fz_new_context_imp(alloc: [*c]const fz_alloc_context, locks: [*c]const fz_locks_context, max_store: usize, version: [*c]const u8) [*c]fz_context;
pub fn fz_lock(arg_ctx: [*c]fz_context, arg_lock: c_int) callconv(.c) void {
    var ctx = arg_ctx;
    _ = &ctx;
    var lock = arg_lock;
    _ = &lock;
    fz_lock_debug_lock(ctx, lock);
    ctx.*.locks.lock.?(ctx.*.locks.user, lock);
}
pub fn fz_unlock(arg_ctx: [*c]fz_context, arg_lock: c_int) callconv(.c) void {
    var ctx = arg_ctx;
    _ = &ctx;
    var lock = arg_lock;
    _ = &lock;
    fz_lock_debug_unlock(ctx, lock);
    ctx.*.locks.unlock.?(ctx.*.locks.user, lock);
}
pub fn fz_keep_imp(arg_ctx: [*c]fz_context, arg_p: ?*anyopaque, arg_refs: [*c]c_int) callconv(.c) ?*anyopaque {
    var ctx = arg_ctx;
    _ = &ctx;
    var p = arg_p;
    _ = &p;
    var refs = arg_refs;
    _ = &refs;
    if (p != null) {
        _ = @as(c_int, 0);
        fz_lock(ctx, FZ_LOCK_ALLOC);
        if (refs.* > @as(c_int, 0)) {
            _ = &p;
            refs.* += 1;
        }
        fz_unlock(ctx, FZ_LOCK_ALLOC);
    }
    return p;
}
pub fn fz_keep_imp_locked(arg_ctx: [*c]fz_context, arg_p: ?*anyopaque, arg_refs: [*c]c_int) callconv(.c) ?*anyopaque {
    var ctx = arg_ctx;
    _ = &ctx;
    var p = arg_p;
    _ = &p;
    var refs = arg_refs;
    _ = &refs;
    if (p != null) {
        _ = @as(c_int, 0);
        if (refs.* > @as(c_int, 0)) {
            _ = &p;
            refs.* += 1;
        }
    }
    return p;
}
pub fn fz_keep_imp8_locked(arg_ctx: [*c]fz_context, arg_p: ?*anyopaque, arg_refs: [*c]i8) callconv(.c) ?*anyopaque {
    var ctx = arg_ctx;
    _ = &ctx;
    var p = arg_p;
    _ = &p;
    var refs = arg_refs;
    _ = &refs;
    if (p != null) {
        _ = @as(c_int, 0);
        if (@as(c_int, refs.*) > @as(c_int, 0)) {
            _ = &p;
            refs.* += 1;
        }
    }
    return p;
}
pub fn fz_keep_imp8(arg_ctx: [*c]fz_context, arg_p: ?*anyopaque, arg_refs: [*c]i8) callconv(.c) ?*anyopaque {
    var ctx = arg_ctx;
    _ = &ctx;
    var p = arg_p;
    _ = &p;
    var refs = arg_refs;
    _ = &refs;
    if (p != null) {
        _ = @as(c_int, 0);
        fz_lock(ctx, FZ_LOCK_ALLOC);
        if (@as(c_int, refs.*) > @as(c_int, 0)) {
            _ = &p;
            refs.* += 1;
        }
        fz_unlock(ctx, FZ_LOCK_ALLOC);
    }
    return p;
}
pub fn fz_keep_imp16(arg_ctx: [*c]fz_context, arg_p: ?*anyopaque, arg_refs: [*c]i16) callconv(.c) ?*anyopaque {
    var ctx = arg_ctx;
    _ = &ctx;
    var p = arg_p;
    _ = &p;
    var refs = arg_refs;
    _ = &refs;
    if (p != null) {
        _ = @as(c_int, 0);
        fz_lock(ctx, FZ_LOCK_ALLOC);
        if (@as(c_int, refs.*) > @as(c_int, 0)) {
            _ = &p;
            refs.* += 1;
        }
        fz_unlock(ctx, FZ_LOCK_ALLOC);
    }
    return p;
}
pub fn fz_drop_imp(arg_ctx: [*c]fz_context, arg_p: ?*anyopaque, arg_refs: [*c]c_int) callconv(.c) c_int {
    var ctx = arg_ctx;
    _ = &ctx;
    var p = arg_p;
    _ = &p;
    var refs = arg_refs;
    _ = &refs;
    if (p != null) {
        var drop: c_int = undefined;
        _ = &drop;
        _ = @as(c_int, 0);
        fz_lock(ctx, FZ_LOCK_ALLOC);
        if (refs.* > @as(c_int, 0)) {
            _ = &p;
            drop = @intFromBool((blk: {
                const ref = &refs.*;
                ref.* -= 1;
                break :blk ref.*;
            }) == @as(c_int, 0));
        } else {
            drop = 0;
        }
        fz_unlock(ctx, FZ_LOCK_ALLOC);
        return drop;
    }
    return 0;
}
pub fn fz_drop_imp8(arg_ctx: [*c]fz_context, arg_p: ?*anyopaque, arg_refs: [*c]i8) callconv(.c) c_int {
    var ctx = arg_ctx;
    _ = &ctx;
    var p = arg_p;
    _ = &p;
    var refs = arg_refs;
    _ = &refs;
    if (p != null) {
        var drop: c_int = undefined;
        _ = &drop;
        _ = @as(c_int, 0);
        fz_lock(ctx, FZ_LOCK_ALLOC);
        if (@as(c_int, refs.*) > @as(c_int, 0)) {
            _ = &p;
            drop = @intFromBool((blk: {
                const ref = &refs.*;
                ref.* -= 1;
                break :blk ref.*;
            }) == @as(c_int, 0));
        } else {
            drop = 0;
        }
        fz_unlock(ctx, FZ_LOCK_ALLOC);
        return drop;
    }
    return 0;
}
pub fn fz_drop_imp16(arg_ctx: [*c]fz_context, arg_p: ?*anyopaque, arg_refs: [*c]i16) callconv(.c) c_int {
    var ctx = arg_ctx;
    _ = &ctx;
    var p = arg_p;
    _ = &p;
    var refs = arg_refs;
    _ = &refs;
    if (p != null) {
        var drop: c_int = undefined;
        _ = &drop;
        _ = @as(c_int, 0);
        fz_lock(ctx, FZ_LOCK_ALLOC);
        if (@as(c_int, refs.*) > @as(c_int, 0)) {
            _ = &p;
            drop = @intFromBool((blk: {
                const ref = &refs.*;
                ref.* -= 1;
                break :blk ref.*;
            }) == @as(c_int, 0));
        } else {
            drop = 0;
        }
        fz_unlock(ctx, FZ_LOCK_ALLOC);
        return drop;
    }
    return 0;
}
pub const fz_buffer = extern struct {
    refs: c_int = 0,
    data: [*c]u8 = null,
    cap: usize = 0,
    len: usize = 0,
    unused_bits: c_int = 0,
    shared: c_int = 0,
};
pub extern fn fz_keep_buffer(ctx: [*c]fz_context, buf: [*c]fz_buffer) [*c]fz_buffer;
pub extern fn fz_drop_buffer(ctx: [*c]fz_context, buf: [*c]fz_buffer) void;
pub extern fn fz_buffer_storage(ctx: [*c]fz_context, buf: [*c]fz_buffer, datap: [*c][*c]u8) usize;
pub extern fn fz_string_from_buffer(ctx: [*c]fz_context, buf: [*c]fz_buffer) [*c]const u8;
pub extern fn fz_new_buffer(ctx: [*c]fz_context, capacity: usize) [*c]fz_buffer;
pub extern fn fz_new_buffer_from_data(ctx: [*c]fz_context, data: [*c]u8, size: usize) [*c]fz_buffer;
pub extern fn fz_new_buffer_from_shared_data(ctx: [*c]fz_context, data: [*c]const u8, size: usize) [*c]fz_buffer;
pub extern fn fz_new_buffer_from_copied_data(ctx: [*c]fz_context, data: [*c]const u8, size: usize) [*c]fz_buffer;
pub extern fn fz_clone_buffer(ctx: [*c]fz_context, buf: [*c]fz_buffer) [*c]fz_buffer;
pub extern fn fz_new_buffer_from_base64(ctx: [*c]fz_context, data: [*c]const u8, size: usize) [*c]fz_buffer;
pub extern fn fz_resize_buffer(ctx: [*c]fz_context, buf: [*c]fz_buffer, capacity: usize) void;
pub extern fn fz_grow_buffer(ctx: [*c]fz_context, buf: [*c]fz_buffer) void;
pub extern fn fz_trim_buffer(ctx: [*c]fz_context, buf: [*c]fz_buffer) void;
pub extern fn fz_clear_buffer(ctx: [*c]fz_context, buf: [*c]fz_buffer) void;
pub extern fn fz_slice_buffer(ctx: [*c]fz_context, buf: [*c]fz_buffer, start: i64, end: i64) [*c]fz_buffer;
pub extern fn fz_append_buffer(ctx: [*c]fz_context, destination: [*c]fz_buffer, source: [*c]fz_buffer) void;
pub extern fn fz_append_base64(ctx: [*c]fz_context, out: [*c]fz_buffer, data: [*c]const u8, size: usize, newline: c_int) void;
pub extern fn fz_append_base64_buffer(ctx: [*c]fz_context, out: [*c]fz_buffer, data: [*c]fz_buffer, newline: c_int) void;
pub extern fn fz_append_data(ctx: [*c]fz_context, buf: [*c]fz_buffer, data: ?*const anyopaque, len: usize) void;
pub extern fn fz_append_string(ctx: [*c]fz_context, buf: [*c]fz_buffer, data: [*c]const u8) void;
pub extern fn fz_append_byte(ctx: [*c]fz_context, buf: [*c]fz_buffer, c: c_int) void;
pub extern fn fz_append_rune(ctx: [*c]fz_context, buf: [*c]fz_buffer, c: c_int) void;
pub extern fn fz_append_int32_le(ctx: [*c]fz_context, buf: [*c]fz_buffer, x: c_int) void;
pub extern fn fz_append_int16_le(ctx: [*c]fz_context, buf: [*c]fz_buffer, x: c_int) void;
pub extern fn fz_append_int32_be(ctx: [*c]fz_context, buf: [*c]fz_buffer, x: c_int) void;
pub extern fn fz_append_int16_be(ctx: [*c]fz_context, buf: [*c]fz_buffer, x: c_int) void;
pub extern fn fz_append_bits(ctx: [*c]fz_context, buf: [*c]fz_buffer, value: c_int, count: c_int) void;
pub extern fn fz_append_bits_pad(ctx: [*c]fz_context, buf: [*c]fz_buffer) void;
pub extern fn fz_append_pdf_string(ctx: [*c]fz_context, buffer: [*c]fz_buffer, text: [*c]const u8) void;
pub extern fn fz_append_printf(ctx: [*c]fz_context, buffer: [*c]fz_buffer, fmt: [*c]const u8, ...) void;
pub extern fn fz_append_vprintf(ctx: [*c]fz_context, buffer: [*c]fz_buffer, fmt: [*c]const u8, args: [*c]struct___va_list_tag_1) void;
pub extern fn fz_terminate_buffer(ctx: [*c]fz_context, buf: [*c]fz_buffer) void;
pub extern fn fz_md5_buffer(ctx: [*c]fz_context, buffer: [*c]fz_buffer, digest: [*c]u8) void;
pub extern fn fz_buffer_extract(ctx: [*c]fz_context, buf: [*c]fz_buffer, data: [*c][*c]u8) usize;
pub extern fn fz_strnlen(s: [*c]const u8, maxlen: usize) usize;
pub extern fn fz_strsep(stringp: [*c][*c]u8, delim: [*c]const u8) [*c]u8;
pub extern fn fz_strlcpy(dst: [*c]u8, src: [*c]const u8, n: usize) usize;
pub extern fn fz_strlcat(dst: [*c]u8, src: [*c]const u8, n: usize) usize;
pub extern fn fz_memmem(haystack: ?*const anyopaque, haystacklen: usize, needle: ?*const anyopaque, needlelen: usize) ?*anyopaque;
pub extern fn fz_dirname(dir: [*c]u8, path: [*c]const u8, dirsize: usize) void;
pub extern fn fz_basename(path: [*c]const u8) [*c]const u8;
pub extern fn fz_urldecode(url: [*c]u8) [*c]u8;
pub extern fn fz_decode_uri(ctx: [*c]fz_context, s: [*c]const u8) [*c]u8;
pub extern fn fz_decode_uri_component(ctx: [*c]fz_context, s: [*c]const u8) [*c]u8;
pub extern fn fz_encode_uri(ctx: [*c]fz_context, s: [*c]const u8) [*c]u8;
pub extern fn fz_encode_uri_component(ctx: [*c]fz_context, s: [*c]const u8) [*c]u8;
pub extern fn fz_encode_uri_pathname(ctx: [*c]fz_context, s: [*c]const u8) [*c]u8;
pub extern fn fz_format_output_path(ctx: [*c]fz_context, path: [*c]u8, size: usize, fmt: [*c]const u8, page: c_int) void;
pub extern fn fz_cleanname(name: [*c]u8) [*c]u8;
pub extern fn fz_realpath(path: [*c]const u8, resolved_path: [*c]u8) [*c]u8;
pub extern fn fz_strcasecmp(a: [*c]const u8, b: [*c]const u8) c_int;
pub extern fn fz_strncasecmp(a: [*c]const u8, b: [*c]const u8, n: usize) c_int;
pub const FZ_UTFMAX: c_int = 4;
const enum_unnamed_8 = c_uint;
pub extern fn fz_chartorune(rune: [*c]c_int, str: [*c]const u8) c_int;
pub extern fn fz_runetochar(str: [*c]u8, rune: c_int) c_int;
pub extern fn fz_runelen(rune: c_int) c_int;
pub extern fn fz_runeidx(str: [*c]const u8, p: [*c]const u8) c_int;
pub extern fn fz_runeptr(str: [*c]const u8, idx: c_int) [*c]const u8;
pub extern fn fz_utflen(s: [*c]const u8) c_int;
pub extern fn fz_strtof(s: [*c]const u8, es: [*c][*c]u8) f32;
pub extern fn fz_grisu(f: f32, s: [*c]u8, exp: [*c]c_int) c_int;
pub extern fn fz_is_page_range(ctx: [*c]fz_context, s: [*c]const u8) c_int;
pub extern fn fz_parse_page_range(ctx: [*c]fz_context, s: [*c]const u8, a: [*c]c_int, b: [*c]c_int, n: c_int) [*c]const u8;
pub extern fn fz_tolower(c: c_int) c_int;
pub extern fn fz_toupper(c: c_int) c_int;
pub extern fn fz_file_exists(ctx: [*c]fz_context, path: [*c]const u8) c_int;
pub extern fn fz_open_file(ctx: [*c]fz_context, filename: [*c]const u8) [*c]fz_stream;
pub extern fn fz_try_open_file(ctx: [*c]fz_context, name: [*c]const u8) [*c]fz_stream;
pub extern fn fz_open_memory(ctx: [*c]fz_context, data: [*c]const u8, len: usize) [*c]fz_stream;
pub extern fn fz_open_buffer(ctx: [*c]fz_context, buf: [*c]fz_buffer) [*c]fz_stream;
pub extern fn fz_open_leecher(ctx: [*c]fz_context, chain: [*c]fz_stream, buf: [*c]fz_buffer) [*c]fz_stream;
pub extern fn fz_keep_stream(ctx: [*c]fz_context, stm: [*c]fz_stream) [*c]fz_stream;
pub extern fn fz_drop_stream(ctx: [*c]fz_context, stm: [*c]fz_stream) void;
pub extern fn fz_tell(ctx: [*c]fz_context, stm: [*c]fz_stream) i64;
pub extern fn fz_seek(ctx: [*c]fz_context, stm: [*c]fz_stream, offset: i64, whence: c_int) void;
pub extern fn fz_read(ctx: [*c]fz_context, stm: [*c]fz_stream, data: [*c]u8, len: usize) usize;
pub extern fn fz_skip(ctx: [*c]fz_context, stm: [*c]fz_stream, len: usize) usize;
pub extern fn fz_read_all(ctx: [*c]fz_context, stm: [*c]fz_stream, initial: usize) [*c]fz_buffer;
pub extern fn fz_read_file(ctx: [*c]fz_context, filename: [*c]const u8) [*c]fz_buffer;
pub extern fn fz_try_read_file(ctx: [*c]fz_context, filename: [*c]const u8) [*c]fz_buffer;
pub extern fn fz_read_uint16(ctx: [*c]fz_context, stm: [*c]fz_stream) u16;
pub extern fn fz_read_uint24(ctx: [*c]fz_context, stm: [*c]fz_stream) u32;
pub extern fn fz_read_uint32(ctx: [*c]fz_context, stm: [*c]fz_stream) u32;
pub extern fn fz_read_uint64(ctx: [*c]fz_context, stm: [*c]fz_stream) u64;
pub extern fn fz_read_uint16_le(ctx: [*c]fz_context, stm: [*c]fz_stream) u16;
pub extern fn fz_read_uint24_le(ctx: [*c]fz_context, stm: [*c]fz_stream) u32;
pub extern fn fz_read_uint32_le(ctx: [*c]fz_context, stm: [*c]fz_stream) u32;
pub extern fn fz_read_uint64_le(ctx: [*c]fz_context, stm: [*c]fz_stream) u64;
pub extern fn fz_read_int16(ctx: [*c]fz_context, stm: [*c]fz_stream) i16;
pub extern fn fz_read_int32(ctx: [*c]fz_context, stm: [*c]fz_stream) i32;
pub extern fn fz_read_int64(ctx: [*c]fz_context, stm: [*c]fz_stream) i64;
pub extern fn fz_read_int16_le(ctx: [*c]fz_context, stm: [*c]fz_stream) i16;
pub extern fn fz_read_int32_le(ctx: [*c]fz_context, stm: [*c]fz_stream) i32;
pub extern fn fz_read_int64_le(ctx: [*c]fz_context, stm: [*c]fz_stream) i64;
pub extern fn fz_read_float_le(ctx: [*c]fz_context, stm: [*c]fz_stream) f32;
pub extern fn fz_read_float(ctx: [*c]fz_context, stm: [*c]fz_stream) f32;
pub extern fn fz_read_string(ctx: [*c]fz_context, stm: [*c]fz_stream, buffer: [*c]u8, len: c_int) void;
pub extern fn fz_read_rune(ctx: [*c]fz_context, in: [*c]fz_stream) c_int;
pub extern fn fz_read_utf16_le(ctx: [*c]fz_context, stm: [*c]fz_stream) c_int;
pub extern fn fz_read_utf16_be(ctx: [*c]fz_context, stm: [*c]fz_stream) c_int;
pub extern fn fz_new_stream(ctx: [*c]fz_context, state: ?*anyopaque, next: ?*const fz_stream_next_fn, drop: ?*const fz_stream_drop_fn) [*c]fz_stream;
pub extern fn fz_read_best(ctx: [*c]fz_context, stm: [*c]fz_stream, initial: usize, truncated: [*c]c_int, worst_case: usize) [*c]fz_buffer;
pub extern fn fz_read_line(ctx: [*c]fz_context, stm: [*c]fz_stream, buf: [*c]u8, max: usize) [*c]u8;
pub extern fn fz_skip_string(ctx: [*c]fz_context, stm: [*c]fz_stream, str: [*c]const u8) c_int;
pub extern fn fz_skip_space(ctx: [*c]fz_context, stm: [*c]fz_stream) void;
pub fn fz_available(arg_ctx: [*c]fz_context, arg_stm: [*c]fz_stream, arg_max: usize) callconv(.c) usize {
    var ctx = arg_ctx;
    _ = &ctx;
    var stm = arg_stm;
    _ = &stm;
    var max = arg_max;
    _ = &max;
    var len: usize = @bitCast(@as(c_long, @divExact(@as(c_long, @bitCast(@intFromPtr(stm.*.wp) -% @intFromPtr(stm.*.rp))), @sizeOf(u8))));
    _ = &len;
    var c: c_int = -@as(c_int, 1);
    _ = &c;
    if (len != 0) return len;
    if (stm.*.eof != 0) return 0;
    if (!(__sigsetjmp(@ptrCast(@alignCast(&fz_push_try(ctx).*)), 0) != 0)) if (fz_do_try(ctx) != 0) while (true) {
        c = stm.*.next.?(ctx, stm, max);
        if (!false) break;
    };
    if (fz_do_catch(ctx) != 0) {
        fz_rethrow_if(ctx, FZ_ERROR_TRYLATER);
        fz_warn(ctx, "read error; treating as end of file");
        stm.*.@"error" = 1;
        c = -@as(c_int, 1);
    }
    if (c == -@as(c_int, 1)) {
        stm.*.eof = 1;
        return 0;
    }
    stm.*.rp -= 1;
    return @bitCast(@as(c_long, @divExact(@as(c_long, @bitCast(@intFromPtr(stm.*.wp) -% @intFromPtr(stm.*.rp))), @sizeOf(u8))));
}
pub fn fz_read_byte(arg_ctx: [*c]fz_context, arg_stm: [*c]fz_stream) callconv(.c) c_int {
    var ctx = arg_ctx;
    _ = &ctx;
    var stm = arg_stm;
    _ = &stm;
    var c: c_int = -@as(c_int, 1);
    _ = &c;
    if (stm.*.rp != stm.*.wp) return (blk: {
        const ref = &stm.*.rp;
        const tmp = ref.*;
        ref.* += 1;
        break :blk tmp;
    }).*;
    if (stm.*.eof != 0) return -@as(c_int, 1);
    if (!(__sigsetjmp(@ptrCast(@alignCast(&fz_push_try(ctx).*)), 0) != 0)) if (fz_do_try(ctx) != 0) while (true) {
        c = stm.*.next.?(ctx, stm, 1);
        if (!false) break;
    };
    if (fz_do_catch(ctx) != 0) {
        fz_rethrow_if(ctx, FZ_ERROR_TRYLATER);
        fz_warn(ctx, "read error; treating as end of file");
        stm.*.@"error" = 1;
        c = -@as(c_int, 1);
    }
    if (c == -@as(c_int, 1)) {
        stm.*.eof = 1;
    }
    return c;
}
pub fn fz_peek_byte(arg_ctx: [*c]fz_context, arg_stm: [*c]fz_stream) callconv(.c) c_int {
    var ctx = arg_ctx;
    _ = &ctx;
    var stm = arg_stm;
    _ = &stm;
    var c: c_int = -@as(c_int, 1);
    _ = &c;
    if (stm.*.rp != stm.*.wp) return stm.*.rp.*;
    if (stm.*.eof != 0) return -@as(c_int, 1);
    if (!(__sigsetjmp(@ptrCast(@alignCast(&fz_push_try(ctx).*)), 0) != 0)) if (fz_do_try(ctx) != 0) while (true) {
        c = stm.*.next.?(ctx, stm, 1);
        if (c != -@as(c_int, 1)) {
            stm.*.rp -= 1;
        }
        if (!false) break;
    };
    if (fz_do_catch(ctx) != 0) {
        fz_rethrow_if(ctx, FZ_ERROR_TRYLATER);
        fz_warn(ctx, "read error; treating as end of file");
        stm.*.@"error" = 1;
        c = -@as(c_int, 1);
    }
    if (c == -@as(c_int, 1)) {
        stm.*.eof = 1;
    }
    return c;
}
pub fn fz_unread_byte(arg_ctx: [*c]fz_context, arg_stm: [*c]fz_stream) callconv(.c) void {
    var ctx = arg_ctx;
    _ = &ctx;
    var stm = arg_stm;
    _ = &stm;
    stm.*.rp -= 1;
}
pub fn fz_is_eof(arg_ctx: [*c]fz_context, arg_stm: [*c]fz_stream) callconv(.c) c_int {
    var ctx = arg_ctx;
    _ = &ctx;
    var stm = arg_stm;
    _ = &stm;
    if (stm.*.rp == stm.*.wp) {
        if (stm.*.eof != 0) return 1;
        return @intFromBool(fz_peek_byte(ctx, stm) == -@as(c_int, 1));
    }
    return 0;
}
pub fn fz_read_bits(arg_ctx: [*c]fz_context, arg_stm: [*c]fz_stream, arg_n: c_int) callconv(.c) c_uint {
    var ctx = arg_ctx;
    _ = &ctx;
    var stm = arg_stm;
    _ = &stm;
    var n = arg_n;
    _ = &n;
    var x: c_int = undefined;
    _ = &x;
    if (n <= stm.*.avail) {
        stm.*.avail -= n;
        x = (stm.*.bits >> @intCast(stm.*.avail)) & ((@as(c_int, 1) << @intCast(n)) - @as(c_int, 1));
    } else {
        x = stm.*.bits & ((@as(c_int, 1) << @intCast(stm.*.avail)) - @as(c_int, 1));
        n -= stm.*.avail;
        stm.*.avail = 0;
        while (n > @as(c_int, 8)) {
            x = (x << @intCast(@as(c_int, 8))) | fz_read_byte(ctx, stm);
            n -= 8;
        }
        if (n > @as(c_int, 0)) {
            stm.*.bits = fz_read_byte(ctx, stm);
            stm.*.avail = @as(c_int, 8) - n;
            x = (x << @intCast(n)) | (stm.*.bits >> @intCast(stm.*.avail));
        }
    }
    return @bitCast(@as(c_int, x));
}
pub fn fz_read_rbits(arg_ctx: [*c]fz_context, arg_stm: [*c]fz_stream, arg_n: c_int) callconv(.c) c_uint {
    var ctx = arg_ctx;
    _ = &ctx;
    var stm = arg_stm;
    _ = &stm;
    var n = arg_n;
    _ = &n;
    var x: c_int = undefined;
    _ = &x;
    if (n <= stm.*.avail) {
        x = stm.*.bits & ((@as(c_int, 1) << @intCast(n)) - @as(c_int, 1));
        stm.*.avail -= n;
        stm.*.bits = stm.*.bits >> @intCast(n);
    } else {
        var used: c_uint = 0;
        _ = &used;
        x = stm.*.bits & ((@as(c_int, 1) << @intCast(stm.*.avail)) - @as(c_int, 1));
        n -= stm.*.avail;
        used = @bitCast(@as(c_int, stm.*.avail));
        stm.*.avail = 0;
        while (n > @as(c_int, 8)) {
            x = @bitCast(@as(c_uint, @truncate((@as(c_uint, @bitCast(@as(c_int, fz_read_byte(ctx, stm)))) << @intCast(used)) | @as(c_uint, @bitCast(@as(c_int, x))))));
            n -= 8;
            used +%= 8;
        }
        if (n > @as(c_int, 0)) {
            stm.*.bits = fz_read_byte(ctx, stm);
            x = @bitCast(@as(c_uint, @truncate((@as(c_uint, @bitCast(@as(c_int, stm.*.bits & ((@as(c_int, 1) << @intCast(n)) - @as(c_int, 1))))) << @intCast(used)) | @as(c_uint, @bitCast(@as(c_int, x))))));
            stm.*.avail = @as(c_int, 8) - n;
            stm.*.bits = stm.*.bits >> @intCast(n);
        }
    }
    return @bitCast(@as(c_int, x));
}
pub fn fz_sync_bits(arg_ctx: [*c]fz_context, arg_stm: [*c]fz_stream) callconv(.c) void {
    var ctx = arg_ctx;
    _ = &ctx;
    var stm = arg_stm;
    _ = &stm;
    stm.*.avail = 0;
}
pub fn fz_is_eof_bits(arg_ctx: [*c]fz_context, arg_stm: [*c]fz_stream) callconv(.c) c_int {
    var ctx = arg_ctx;
    _ = &ctx;
    var stm = arg_stm;
    _ = &stm;
    return @intFromBool((fz_is_eof(ctx, stm) != 0) and ((stm.*.avail == @as(c_int, 0)) or (stm.*.bits == -@as(c_int, 1))));
}
pub extern fn fz_open_file_ptr_no_close(ctx: [*c]fz_context, file: [*c]FILE) [*c]fz_stream;
pub extern fn fz_new_output(ctx: [*c]fz_context, bufsiz: c_int, state: ?*anyopaque, write: ?*const fz_output_write_fn, close: ?*const fz_output_close_fn, drop: ?*const fz_output_drop_fn) [*c]fz_output;
pub extern fn fz_new_output_with_path([*c]fz_context, filename: [*c]const u8, append: c_int) [*c]fz_output;
pub extern fn fz_new_output_with_buffer(ctx: [*c]fz_context, buf: [*c]fz_buffer) [*c]fz_output;
pub extern fn fz_stdout(ctx: [*c]fz_context) [*c]fz_output;
pub extern fn fz_stderr(ctx: [*c]fz_context) [*c]fz_output;
pub extern fn fz_set_stddbg(ctx: [*c]fz_context, out: [*c]fz_output) void;
pub extern fn fz_stddbg(ctx: [*c]fz_context) [*c]fz_output;
pub extern fn fz_write_printf(ctx: [*c]fz_context, out: [*c]fz_output, fmt: [*c]const u8, ...) void;
pub extern fn fz_write_vprintf(ctx: [*c]fz_context, out: [*c]fz_output, fmt: [*c]const u8, ap: [*c]struct___va_list_tag_1) void;
pub extern fn fz_seek_output(ctx: [*c]fz_context, out: [*c]fz_output, off: i64, whence: c_int) void;
pub extern fn fz_tell_output(ctx: [*c]fz_context, out: [*c]fz_output) i64;
pub extern fn fz_flush_output(ctx: [*c]fz_context, out: [*c]fz_output) void;
pub extern fn fz_close_output([*c]fz_context, [*c]fz_output) void;
pub extern fn fz_drop_output([*c]fz_context, [*c]fz_output) void;
pub extern fn fz_output_supports_stream(ctx: [*c]fz_context, out: [*c]fz_output) c_int;
pub extern fn fz_stream_from_output([*c]fz_context, [*c]fz_output) [*c]fz_stream;
pub extern fn fz_truncate_output([*c]fz_context, [*c]fz_output) void;
pub extern fn fz_write_data(ctx: [*c]fz_context, out: [*c]fz_output, data: ?*const anyopaque, size: usize) void;
pub extern fn fz_write_buffer(ctx: [*c]fz_context, out: [*c]fz_output, data: [*c]fz_buffer) void;
pub extern fn fz_write_string(ctx: [*c]fz_context, out: [*c]fz_output, s: [*c]const u8) void;
pub extern fn fz_write_int32_be(ctx: [*c]fz_context, out: [*c]fz_output, x: c_int) void;
pub extern fn fz_write_int32_le(ctx: [*c]fz_context, out: [*c]fz_output, x: c_int) void;
pub extern fn fz_write_uint32_be(ctx: [*c]fz_context, out: [*c]fz_output, x: c_uint) void;
pub extern fn fz_write_uint32_le(ctx: [*c]fz_context, out: [*c]fz_output, x: c_uint) void;
pub extern fn fz_write_int16_be(ctx: [*c]fz_context, out: [*c]fz_output, x: c_int) void;
pub extern fn fz_write_int16_le(ctx: [*c]fz_context, out: [*c]fz_output, x: c_int) void;
pub extern fn fz_write_uint16_be(ctx: [*c]fz_context, out: [*c]fz_output, x: c_uint) void;
pub extern fn fz_write_uint16_le(ctx: [*c]fz_context, out: [*c]fz_output, x: c_uint) void;
pub extern fn fz_write_char(ctx: [*c]fz_context, out: [*c]fz_output, x: u8) void;
pub extern fn fz_write_byte(ctx: [*c]fz_context, out: [*c]fz_output, x: u8) void;
pub extern fn fz_write_float_be(ctx: [*c]fz_context, out: [*c]fz_output, f: f32) void;
pub extern fn fz_write_float_le(ctx: [*c]fz_context, out: [*c]fz_output, f: f32) void;
pub extern fn fz_write_rune(ctx: [*c]fz_context, out: [*c]fz_output, rune: c_int) void;
pub extern fn fz_write_base64(ctx: [*c]fz_context, out: [*c]fz_output, data: [*c]const u8, size: usize, newline: c_int) void;
pub extern fn fz_write_base64_buffer(ctx: [*c]fz_context, out: [*c]fz_output, data: [*c]fz_buffer, newline: c_int) void;
pub extern fn fz_write_bits(ctx: [*c]fz_context, out: [*c]fz_output, data: c_uint, num_bits: c_int) void;
pub extern fn fz_write_bits_sync(ctx: [*c]fz_context, out: [*c]fz_output) void;
pub extern fn fz_format_string(ctx: [*c]fz_context, user: ?*anyopaque, emit: ?*const fn (ctx: [*c]fz_context, user: ?*anyopaque, c: c_int) callconv(.c) void, fmt: [*c]const u8, args: [*c]struct___va_list_tag_1) void;
pub extern fn fz_vsnprintf(buffer: [*c]u8, space: usize, fmt: [*c]const u8, args: [*c]struct___va_list_tag_1) usize;
pub extern fn fz_snprintf(buffer: [*c]u8, space: usize, fmt: [*c]const u8, ...) usize;
pub extern fn fz_asprintf(ctx: [*c]fz_context, fmt: [*c]const u8, ...) [*c]u8;
pub extern fn fz_save_buffer(ctx: [*c]fz_context, buf: [*c]fz_buffer, filename: [*c]const u8) void;
pub extern fn fz_new_asciihex_output(ctx: [*c]fz_context, chain: [*c]fz_output) [*c]fz_output;
pub extern fn fz_new_ascii85_output(ctx: [*c]fz_context, chain: [*c]fz_output) [*c]fz_output;
pub extern fn fz_new_rle_output(ctx: [*c]fz_context, chain: [*c]fz_output) [*c]fz_output;
pub extern fn fz_new_arc4_output(ctx: [*c]fz_context, chain: [*c]fz_output, key: [*c]u8, keylen: usize) [*c]fz_output;
pub extern fn fz_new_deflate_output(ctx: [*c]fz_context, chain: [*c]fz_output, effort: c_int, raw: c_int) [*c]fz_output;
pub extern fn fz_log(ctx: [*c]fz_context, fmt: [*c]const u8, ...) void;
pub extern fn fz_log_module(ctx: [*c]fz_context, module: [*c]const u8, fmt: [*c]const u8, ...) void;
pub extern fn fz_new_log_for_module(ctx: [*c]fz_context, module: [*c]const u8) [*c]fz_output;
pub const fz_md5 = extern struct {
    lo: u32 = 0,
    hi: u32 = 0,
    a: u32 = 0,
    b: u32 = 0,
    c: u32 = 0,
    d: u32 = 0,
    buffer: [64]u8 = @import("std").mem.zeroes([64]u8),
    pub const fz_md5_init = __root.fz_md5_init;
    pub const fz_md5_update = __root.fz_md5_update;
    pub const fz_md5_update_int64 = __root.fz_md5_update_int64;
    pub const fz_md5_final = __root.fz_md5_final;
    pub const init = __root.fz_md5_init;
    pub const update = __root.fz_md5_update;
    pub const update_int64 = __root.fz_md5_update_int64;
    pub const final = __root.fz_md5_final;
};
pub extern fn fz_md5_init(state: [*c]fz_md5) void;
pub extern fn fz_md5_update(state: [*c]fz_md5, input: [*c]const u8, inlen: usize) void;
pub extern fn fz_md5_update_int64(state: [*c]fz_md5, i: i64) void;
pub extern fn fz_md5_final(state: [*c]fz_md5, digest: [*c]u8) void;
const union_unnamed_9 = extern union {
    u8: [64]u8,
    u32: [16]c_uint,
};
pub const fz_sha256 = extern struct {
    state: [8]c_uint = @import("std").mem.zeroes([8]c_uint),
    count: [2]c_uint = @import("std").mem.zeroes([2]c_uint),
    buffer: union_unnamed_9 = @import("std").mem.zeroes(union_unnamed_9),
    pub const fz_sha256_init = __root.fz_sha256_init;
    pub const fz_sha256_update = __root.fz_sha256_update;
    pub const fz_sha256_final = __root.fz_sha256_final;
    pub const init = __root.fz_sha256_init;
    pub const update = __root.fz_sha256_update;
    pub const final = __root.fz_sha256_final;
};
pub extern fn fz_sha256_init(state: [*c]fz_sha256) void;
pub extern fn fz_sha256_update(state: [*c]fz_sha256, input: [*c]const u8, inlen: usize) void;
pub extern fn fz_sha256_final(state: [*c]fz_sha256, digest: [*c]u8) void;
const union_unnamed_10 = extern union {
    u8: [128]u8,
    u64: [16]u64,
};
pub const fz_sha512 = extern struct {
    state: [8]u64 = @import("std").mem.zeroes([8]u64),
    count: [2]c_uint = @import("std").mem.zeroes([2]c_uint),
    buffer: union_unnamed_10 = @import("std").mem.zeroes(union_unnamed_10),
    pub const fz_sha512_init = __root.fz_sha512_init;
    pub const fz_sha512_update = __root.fz_sha512_update;
    pub const fz_sha512_final = __root.fz_sha512_final;
    pub const fz_sha384_init = __root.fz_sha384_init;
    pub const fz_sha384_update = __root.fz_sha384_update;
    pub const fz_sha384_final = __root.fz_sha384_final;
    pub const init = __root.fz_sha512_init;
    pub const update = __root.fz_sha512_update;
    pub const final = __root.fz_sha512_final;
};
pub extern fn fz_sha512_init(state: [*c]fz_sha512) void;
pub extern fn fz_sha512_update(state: [*c]fz_sha512, input: [*c]const u8, inlen: usize) void;
pub extern fn fz_sha512_final(state: [*c]fz_sha512, digest: [*c]u8) void;
pub const fz_sha384 = fz_sha512;
pub extern fn fz_sha384_init(state: [*c]fz_sha384) void;
pub extern fn fz_sha384_update(state: [*c]fz_sha384, input: [*c]const u8, inlen: usize) void;
pub extern fn fz_sha384_final(state: [*c]fz_sha384, digest: [*c]u8) void;
pub const fz_arc4 = extern struct {
    x: c_uint = 0,
    y: c_uint = 0,
    state: [256]u8 = @import("std").mem.zeroes([256]u8),
    pub const fz_arc4_init = __root.fz_arc4_init;
    pub const fz_arc4_encrypt = __root.fz_arc4_encrypt;
    pub const fz_arc4_final = __root.fz_arc4_final;
    pub const init = __root.fz_arc4_init;
    pub const encrypt = __root.fz_arc4_encrypt;
    pub const final = __root.fz_arc4_final;
};
pub extern fn fz_arc4_init(state: [*c]fz_arc4, key: [*c]const u8, len: usize) void;
pub extern fn fz_arc4_encrypt(state: [*c]fz_arc4, dest: [*c]u8, src: [*c]const u8, len: usize) void;
pub extern fn fz_arc4_final(state: [*c]fz_arc4) void;
pub const fz_aes = extern struct {
    nr: c_int = 0,
    rk: [*c]u32 = null,
    buf: [68]u32 = @import("std").mem.zeroes([68]u32),
    pub const fz_aes_setkey_enc = __root.fz_aes_setkey_enc;
    pub const fz_aes_setkey_dec = __root.fz_aes_setkey_dec;
    pub const fz_aes_crypt_cbc = __root.fz_aes_crypt_cbc;
    pub const setkey_enc = __root.fz_aes_setkey_enc;
    pub const setkey_dec = __root.fz_aes_setkey_dec;
    pub const crypt_cbc = __root.fz_aes_crypt_cbc;
};
pub extern fn fz_aes_setkey_enc(ctx: [*c]fz_aes, key: [*c]const u8, keysize: c_int) c_int;
pub extern fn fz_aes_setkey_dec(ctx: [*c]fz_aes, key: [*c]const u8, keysize: c_int) c_int;
pub extern fn fz_aes_crypt_cbc(ctx: [*c]fz_aes, mode: c_int, length: usize, iv: [*c]u8, input: [*c]const u8, output: [*c]u8) void;
pub extern fn fz_getopt(nargc: c_int, nargv: [*c]const [*c]u8, ostr: [*c]const u8) c_int;
pub extern var fz_optind: c_int;
pub extern var fz_optarg: [*c]u8;
pub const struct_fz_hash_table = opaque {};
pub const fz_hash_table = struct_fz_hash_table;
pub const fz_hash_table_drop_fn = fn (ctx: [*c]fz_context, val: ?*anyopaque) callconv(.c) void;
pub extern fn fz_new_hash_table(ctx: [*c]fz_context, initialsize: c_int, keylen: c_int, lock: c_int, drop_val: ?*const fz_hash_table_drop_fn) ?*fz_hash_table;
pub extern fn fz_drop_hash_table(ctx: [*c]fz_context, table: ?*fz_hash_table) void;
pub extern fn fz_hash_find(ctx: [*c]fz_context, table: ?*fz_hash_table, key: ?*const anyopaque) ?*anyopaque;
pub extern fn fz_hash_insert(ctx: [*c]fz_context, table: ?*fz_hash_table, key: ?*const anyopaque, val: ?*anyopaque) ?*anyopaque;
pub extern fn fz_hash_remove(ctx: [*c]fz_context, table: ?*fz_hash_table, key: ?*const anyopaque) void;
pub const fz_hash_table_for_each_fn = fn (ctx: [*c]fz_context, state: ?*anyopaque, key: ?*anyopaque, keylen: c_int, val: ?*anyopaque) callconv(.c) void;
pub extern fn fz_hash_for_each(ctx: [*c]fz_context, table: ?*fz_hash_table, state: ?*anyopaque, callback: ?*const fz_hash_table_for_each_fn) void;
pub const fz_hash_table_filter_fn = fn (ctx: [*c]fz_context, state: ?*anyopaque, key: ?*anyopaque, keylen: c_int, val: ?*anyopaque) callconv(.c) c_int;
pub extern fn fz_hash_filter(ctx: [*c]fz_context, table: ?*fz_hash_table, state: ?*anyopaque, callback: ?*const fz_hash_table_filter_fn) void;
pub const struct_fz_pool = opaque {};
pub const fz_pool = struct_fz_pool;
pub extern fn fz_new_pool(ctx: [*c]fz_context) ?*fz_pool;
pub extern fn fz_pool_alloc(ctx: [*c]fz_context, pool: ?*fz_pool, size: usize) ?*anyopaque;
pub extern fn fz_pool_strdup(ctx: [*c]fz_context, pool: ?*fz_pool, s: [*c]const u8) [*c]u8;
pub extern fn fz_pool_size(ctx: [*c]fz_context, pool: ?*fz_pool) usize;
pub extern fn fz_drop_pool(ctx: [*c]fz_context, pool: ?*fz_pool) void;
pub const struct_fz_tree = opaque {};
pub const fz_tree = struct_fz_tree;
pub extern fn fz_tree_lookup(ctx: [*c]fz_context, node: ?*fz_tree, key: [*c]const u8) ?*anyopaque;
pub extern fn fz_tree_insert(ctx: [*c]fz_context, root: ?*fz_tree, key: [*c]const u8, value: ?*anyopaque) ?*fz_tree;
pub extern fn fz_drop_tree(ctx: [*c]fz_context, node: ?*fz_tree, dropfunc: ?*const fn (ctx: [*c]fz_context, value: ?*anyopaque) callconv(.c) void) void;
pub const FZ_BIDI_LTR: c_int = 0;
pub const FZ_BIDI_RTL: c_int = 1;
pub const FZ_BIDI_NEUTRAL: c_int = 2;
pub const fz_bidi_direction = c_uint;
pub const FZ_BIDI_CLASSIFY_WHITE_SPACE: c_int = 1;
pub const FZ_BIDI_REPLACE_TAB: c_int = 2;
pub const fz_bidi_flags = c_uint;
pub const fz_bidi_fragment_fn = fn (fragment: [*c]const u32, fragmentLen: usize, bidiLevel: c_int, script: c_int, arg: ?*anyopaque) callconv(.c) void;
pub extern fn fz_bidi_fragment_text(ctx: [*c]fz_context, text: [*c]const u32, textlen: usize, baseDir: [*c]fz_bidi_direction, callback: ?*const fz_bidi_fragment_fn, arg: ?*anyopaque, flags: c_int) void;
pub const fz_archive = struct_fz_archive;
pub const struct_fz_archive = extern struct {
    refs: c_int = 0,
    file: [*c]fz_stream = null,
    format: [*c]const u8 = null,
    drop_archive: ?*const fn (ctx: [*c]fz_context, arch: [*c]fz_archive) callconv(.c) void = null,
    count_entries: ?*const fn (ctx: [*c]fz_context, arch: [*c]fz_archive) callconv(.c) c_int = null,
    list_entry: ?*const fn (ctx: [*c]fz_context, arch: [*c]fz_archive, idx: c_int) callconv(.c) [*c]const u8 = null,
    has_entry: ?*const fn (ctx: [*c]fz_context, arch: [*c]fz_archive, name: [*c]const u8) callconv(.c) c_int = null,
    read_entry: ?*const fn (ctx: [*c]fz_context, arch: [*c]fz_archive, name: [*c]const u8) callconv(.c) [*c]fz_buffer = null,
    open_entry: ?*const fn (ctx: [*c]fz_context, arch: [*c]fz_archive, name: [*c]const u8) callconv(.c) [*c]fz_stream = null,
};
pub extern fn fz_open_archive(ctx: [*c]fz_context, filename: [*c]const u8) [*c]fz_archive;
pub extern fn fz_open_archive_with_stream(ctx: [*c]fz_context, file: [*c]fz_stream) [*c]fz_archive;
pub extern fn fz_try_open_archive_with_stream(ctx: [*c]fz_context, file: [*c]fz_stream) [*c]fz_archive;
pub extern fn fz_open_directory(ctx: [*c]fz_context, path: [*c]const u8) [*c]fz_archive;
pub extern fn fz_is_directory(ctx: [*c]fz_context, path: [*c]const u8) c_int;
pub extern fn fz_drop_archive(ctx: [*c]fz_context, arch: [*c]fz_archive) void;
pub extern fn fz_keep_archive(ctx: [*c]fz_context, arch: [*c]fz_archive) [*c]fz_archive;
pub extern fn fz_archive_format(ctx: [*c]fz_context, arch: [*c]fz_archive) [*c]const u8;
pub extern fn fz_count_archive_entries(ctx: [*c]fz_context, arch: [*c]fz_archive) c_int;
pub extern fn fz_list_archive_entry(ctx: [*c]fz_context, arch: [*c]fz_archive, idx: c_int) [*c]const u8;
pub extern fn fz_has_archive_entry(ctx: [*c]fz_context, arch: [*c]fz_archive, name: [*c]const u8) c_int;
pub extern fn fz_open_archive_entry(ctx: [*c]fz_context, arch: [*c]fz_archive, name: [*c]const u8) [*c]fz_stream;
pub extern fn fz_try_open_archive_entry(ctx: [*c]fz_context, arch: [*c]fz_archive, name: [*c]const u8) [*c]fz_stream;
pub extern fn fz_read_archive_entry(ctx: [*c]fz_context, arch: [*c]fz_archive, name: [*c]const u8) [*c]fz_buffer;
pub extern fn fz_try_read_archive_entry(ctx: [*c]fz_context, arch: [*c]fz_archive, name: [*c]const u8) [*c]fz_buffer;
pub extern fn fz_is_tar_archive(ctx: [*c]fz_context, file: [*c]fz_stream) c_int;
pub extern fn fz_open_tar_archive(ctx: [*c]fz_context, filename: [*c]const u8) [*c]fz_archive;
pub extern fn fz_open_tar_archive_with_stream(ctx: [*c]fz_context, file: [*c]fz_stream) [*c]fz_archive;
pub extern fn fz_is_zip_archive(ctx: [*c]fz_context, file: [*c]fz_stream) c_int;
pub extern fn fz_open_zip_archive(ctx: [*c]fz_context, path: [*c]const u8) [*c]fz_archive;
pub extern fn fz_open_zip_archive_with_stream(ctx: [*c]fz_context, file: [*c]fz_stream) [*c]fz_archive;
pub const struct_fz_zip_writer = opaque {};
pub const fz_zip_writer = struct_fz_zip_writer;
pub extern fn fz_new_zip_writer(ctx: [*c]fz_context, filename: [*c]const u8) ?*fz_zip_writer;
pub extern fn fz_new_zip_writer_with_output(ctx: [*c]fz_context, out: [*c]fz_output) ?*fz_zip_writer;
pub extern fn fz_write_zip_entry(ctx: [*c]fz_context, zip: ?*fz_zip_writer, name: [*c]const u8, buf: [*c]fz_buffer, compress: c_int) void;
pub extern fn fz_close_zip_writer(ctx: [*c]fz_context, zip: ?*fz_zip_writer) void;
pub extern fn fz_drop_zip_writer(ctx: [*c]fz_context, zip: ?*fz_zip_writer) void;
pub extern fn fz_new_tree_archive(ctx: [*c]fz_context, tree: ?*fz_tree) [*c]fz_archive;
pub extern fn fz_tree_archive_add_buffer(ctx: [*c]fz_context, arch_: [*c]fz_archive, name: [*c]const u8, buf: [*c]fz_buffer) void;
pub extern fn fz_tree_archive_add_data(ctx: [*c]fz_context, arch_: [*c]fz_archive, name: [*c]const u8, data: ?*const anyopaque, size: usize) void;
pub extern fn fz_new_multi_archive(ctx: [*c]fz_context) [*c]fz_archive;
pub extern fn fz_mount_multi_archive(ctx: [*c]fz_context, arch_: [*c]fz_archive, sub: [*c]fz_archive, path: [*c]const u8) void;
pub extern fn fz_new_archive_of_size(ctx: [*c]fz_context, file: [*c]fz_stream, size: c_int) [*c]fz_archive;
pub const struct_fz_xml = opaque {
    pub const fz_xml_root = __root.fz_xml_root;
    pub const fz_xml_prev = __root.fz_xml_prev;
    pub const fz_xml_next = __root.fz_xml_next;
    pub const fz_xml_up = __root.fz_xml_up;
    pub const fz_xml_down = __root.fz_xml_down;
    pub const fz_xml_is_tag = __root.fz_xml_is_tag;
    pub const fz_xml_tag = __root.fz_xml_tag;
    pub const fz_xml_att = __root.fz_xml_att;
    pub const fz_xml_att_alt = __root.fz_xml_att_alt;
    pub const fz_xml_att_eq = __root.fz_xml_att_eq;
    pub const fz_xml_text = __root.fz_xml_text;
    pub const fz_debug_xml = __root.fz_debug_xml;
    pub const fz_xml_find = __root.fz_xml_find;
    pub const fz_xml_find_next = __root.fz_xml_find_next;
    pub const fz_xml_find_down = __root.fz_xml_find_down;
    pub const fz_xml_find_match = __root.fz_xml_find_match;
    pub const fz_xml_find_next_match = __root.fz_xml_find_next_match;
    pub const fz_xml_find_down_match = __root.fz_xml_find_down_match;
    pub const fz_xml_find_dfs = __root.fz_xml_find_dfs;
    pub const fz_xml_find_dfs_top = __root.fz_xml_find_dfs_top;
    pub const fz_xml_find_next_dfs = __root.fz_xml_find_next_dfs;
    pub const fz_xml_find_next_dfs_top = __root.fz_xml_find_next_dfs_top;
    pub const root = __root.fz_xml_root;
    pub const prev = __root.fz_xml_prev;
    pub const next = __root.fz_xml_next;
    pub const up = __root.fz_xml_up;
    pub const down = __root.fz_xml_down;
    pub const is_tag = __root.fz_xml_is_tag;
    pub const tag = __root.fz_xml_tag;
    pub const att = __root.fz_xml_att;
    pub const att_alt = __root.fz_xml_att_alt;
    pub const att_eq = __root.fz_xml_att_eq;
    pub const text = __root.fz_xml_text;
    pub const xml = __root.fz_debug_xml;
    pub const find = __root.fz_xml_find;
    pub const find_next = __root.fz_xml_find_next;
    pub const find_down = __root.fz_xml_find_down;
    pub const find_match = __root.fz_xml_find_match;
    pub const find_next_match = __root.fz_xml_find_next_match;
    pub const find_down_match = __root.fz_xml_find_down_match;
    pub const find_dfs = __root.fz_xml_find_dfs;
    pub const find_dfs_top = __root.fz_xml_find_dfs_top;
    pub const find_next_dfs = __root.fz_xml_find_next_dfs;
    pub const find_next_dfs_top = __root.fz_xml_find_next_dfs_top;
};
pub const fz_xml = struct_fz_xml;
pub const fz_xml_doc = fz_xml;
pub extern fn fz_parse_xml(ctx: [*c]fz_context, buf: [*c]fz_buffer, preserve_white: c_int) ?*fz_xml;
pub extern fn fz_parse_xml_stream(ctx: [*c]fz_context, stream: [*c]fz_stream, preserve_white: c_int) ?*fz_xml;
pub extern fn fz_parse_xml_archive_entry(ctx: [*c]fz_context, arch: [*c]fz_archive, filename: [*c]const u8, preserve_white: c_int) ?*fz_xml;
pub extern fn fz_try_parse_xml_archive_entry(ctx: [*c]fz_context, arch: [*c]fz_archive, filename: [*c]const u8, preserve_white: c_int) ?*fz_xml;
pub extern fn fz_parse_xml_from_html5(ctx: [*c]fz_context, buf: [*c]fz_buffer) ?*fz_xml;
pub extern fn fz_keep_xml(ctx: [*c]fz_context, xml: ?*fz_xml) ?*fz_xml;
pub extern fn fz_drop_xml(ctx: [*c]fz_context, xml: ?*fz_xml) void;
pub extern fn fz_detach_xml(ctx: [*c]fz_context, node: ?*fz_xml) void;
pub extern fn fz_xml_root(xml: ?*fz_xml_doc) ?*fz_xml;
pub extern fn fz_xml_prev(item: ?*fz_xml) ?*fz_xml;
pub extern fn fz_xml_next(item: ?*fz_xml) ?*fz_xml;
pub extern fn fz_xml_up(item: ?*fz_xml) ?*fz_xml;
pub extern fn fz_xml_down(item: ?*fz_xml) ?*fz_xml;
pub extern fn fz_xml_is_tag(item: ?*fz_xml, name: [*c]const u8) c_int;
pub extern fn fz_xml_tag(item: ?*fz_xml) [*c]u8;
pub extern fn fz_xml_att(item: ?*fz_xml, att: [*c]const u8) [*c]u8;
pub extern fn fz_xml_att_alt(item: ?*fz_xml, one: [*c]const u8, two: [*c]const u8) [*c]u8;
pub extern fn fz_xml_att_eq(item: ?*fz_xml, name: [*c]const u8, match: [*c]const u8) c_int;
pub extern fn fz_xml_add_att(ctx: [*c]fz_context, pool: ?*fz_pool, node: ?*fz_xml, key: [*c]const u8, val: [*c]const u8) void;
pub extern fn fz_xml_text(item: ?*fz_xml) [*c]u8;
pub extern fn fz_debug_xml(item: ?*fz_xml, level: c_int) void;
pub extern fn fz_xml_find(item: ?*fz_xml, tag: [*c]const u8) ?*fz_xml;
pub extern fn fz_xml_find_next(item: ?*fz_xml, tag: [*c]const u8) ?*fz_xml;
pub extern fn fz_xml_find_down(item: ?*fz_xml, tag: [*c]const u8) ?*fz_xml;
pub extern fn fz_xml_find_match(item: ?*fz_xml, tag: [*c]const u8, att: [*c]const u8, match: [*c]const u8) ?*fz_xml;
pub extern fn fz_xml_find_next_match(item: ?*fz_xml, tag: [*c]const u8, att: [*c]const u8, match: [*c]const u8) ?*fz_xml;
pub extern fn fz_xml_find_down_match(item: ?*fz_xml, tag: [*c]const u8, att: [*c]const u8, match: [*c]const u8) ?*fz_xml;
pub extern fn fz_xml_find_dfs(item: ?*fz_xml, tag: [*c]const u8, att: [*c]const u8, match: [*c]const u8) ?*fz_xml;
pub extern fn fz_xml_find_dfs_top(item: ?*fz_xml, tag: [*c]const u8, att: [*c]const u8, match: [*c]const u8, top: ?*fz_xml) ?*fz_xml;
pub extern fn fz_xml_find_next_dfs(item: ?*fz_xml, tag: [*c]const u8, att: [*c]const u8, match: [*c]const u8) ?*fz_xml;
pub extern fn fz_xml_find_next_dfs_top(item: ?*fz_xml, tag: [*c]const u8, att: [*c]const u8, match: [*c]const u8, top: ?*fz_xml) ?*fz_xml;
pub extern fn fz_dom_body(ctx: [*c]fz_context, dom: ?*fz_xml) ?*fz_xml;
pub extern fn fz_dom_document_element(ctx: [*c]fz_context, dom: ?*fz_xml) ?*fz_xml;
pub extern fn fz_dom_create_element(ctx: [*c]fz_context, dom: ?*fz_xml, tag: [*c]const u8) ?*fz_xml;
pub extern fn fz_dom_create_text_node(ctx: [*c]fz_context, dom: ?*fz_xml, text: [*c]const u8) ?*fz_xml;
pub extern fn fz_dom_find(ctx: [*c]fz_context, elt: ?*fz_xml, tag: [*c]const u8, att: [*c]const u8, match: [*c]const u8) ?*fz_xml;
pub extern fn fz_dom_find_next(ctx: [*c]fz_context, elt: ?*fz_xml, tag: [*c]const u8, att: [*c]const u8, match: [*c]const u8) ?*fz_xml;
pub extern fn fz_dom_append_child(ctx: [*c]fz_context, parent: ?*fz_xml, child: ?*fz_xml) void;
pub extern fn fz_dom_insert_before(ctx: [*c]fz_context, node: ?*fz_xml, new_elt: ?*fz_xml) void;
pub extern fn fz_dom_insert_after(ctx: [*c]fz_context, node: ?*fz_xml, new_elt: ?*fz_xml) void;
pub extern fn fz_dom_remove(ctx: [*c]fz_context, elt: ?*fz_xml) void;
pub extern fn fz_dom_clone(ctx: [*c]fz_context, elt: ?*fz_xml) ?*fz_xml;
pub extern fn fz_dom_first_child(ctx: [*c]fz_context, elt: ?*fz_xml) ?*fz_xml;
pub extern fn fz_dom_parent(ctx: [*c]fz_context, elt: ?*fz_xml) ?*fz_xml;
pub extern fn fz_dom_next(ctx: [*c]fz_context, elt: ?*fz_xml) ?*fz_xml;
pub extern fn fz_dom_previous(ctx: [*c]fz_context, elt: ?*fz_xml) ?*fz_xml;
pub extern fn fz_dom_add_attribute(ctx: [*c]fz_context, elt: ?*fz_xml, att: [*c]const u8, value: [*c]const u8) void;
pub extern fn fz_dom_remove_attribute(ctx: [*c]fz_context, elt: ?*fz_xml, att: [*c]const u8) void;
pub extern fn fz_dom_attribute(ctx: [*c]fz_context, elt: ?*fz_xml, att: [*c]const u8) [*c]const u8;
pub extern fn fz_dom_get_attribute(ctx: [*c]fz_context, elt: ?*fz_xml, i: c_int, att: [*c][*c]const u8) [*c]const u8;
pub const FZ_DEFLATE_NONE: c_int = 0;
pub const FZ_DEFLATE_BEST_SPEED: c_int = 1;
pub const FZ_DEFLATE_BEST: c_int = 9;
pub const FZ_DEFLATE_DEFAULT: c_int = -1;
pub const fz_deflate_level = c_int;
pub extern fn fz_deflate_bound(ctx: [*c]fz_context, size: usize) usize;
pub extern fn fz_deflate(ctx: [*c]fz_context, dest: [*c]u8, compressed_length: [*c]usize, source: [*c]const u8, source_length: usize, level: fz_deflate_level) void;
pub extern fn fz_new_deflated_data(ctx: [*c]fz_context, compressed_length: [*c]usize, source: [*c]const u8, source_length: usize, level: fz_deflate_level) [*c]u8;
pub extern fn fz_new_deflated_data_from_buffer(ctx: [*c]fz_context, compressed_length: [*c]usize, buffer: [*c]fz_buffer, level: fz_deflate_level) [*c]u8;
pub extern fn fz_compress_ccitt_fax_g3(ctx: [*c]fz_context, data: [*c]const u8, columns: c_int, rows: c_int) [*c]fz_buffer;
pub extern fn fz_compress_ccitt_fax_g4(ctx: [*c]fz_context, data: [*c]const u8, columns: c_int, rows: c_int) [*c]fz_buffer;
pub const fz_storable = struct_fz_storable;
pub const fz_store_drop_fn = fn ([*c]fz_context, [*c]fz_storable) callconv(.c) void;
pub const struct_fz_storable = extern struct {
    refs: c_int = 0,
    drop: ?*const fz_store_drop_fn = null,
};
pub const fz_key_storable = extern struct {
    storable: fz_storable = @import("std").mem.zeroes(fz_storable),
    store_key_refs: c_short = 0,
};
pub extern fn fz_keep_storable([*c]fz_context, [*c]const fz_storable) ?*anyopaque;
pub extern fn fz_drop_storable([*c]fz_context, [*c]const fz_storable) void;
pub extern fn fz_keep_key_storable([*c]fz_context, [*c]const fz_key_storable) ?*anyopaque;
pub extern fn fz_drop_key_storable([*c]fz_context, [*c]const fz_key_storable) void;
pub extern fn fz_keep_key_storable_key([*c]fz_context, [*c]const fz_key_storable) ?*anyopaque;
pub extern fn fz_drop_key_storable_key([*c]fz_context, [*c]const fz_key_storable) void;
const struct_unnamed_12 = extern struct {
    ptr: ?*const anyopaque = null,
    i: c_int = 0,
};
const struct_unnamed_13 = extern struct {
    ptr: ?*const anyopaque = null,
    i: c_int = 0,
    r: fz_irect = @import("std").mem.zeroes(fz_irect),
};
const struct_unnamed_14 = extern struct {
    id: c_int = 0,
    has_shape: u8 = 0,
    has_group_alpha: u8 = 0,
    m: [4]f32 = @import("std").mem.zeroes([4]f32),
    ptr: ?*anyopaque = null,
}; // /usr/include/mupdf/fitz/store.h:231:17: warning: struct demoted to opaque type - has bitfield
const struct_unnamed_15 = opaque {}; // /usr/include/mupdf/fitz/store.h:239:5: warning: union demoted to opaque type - has opaque field
const union_unnamed_11 = opaque {}; // /usr/include/mupdf/fitz/store.h:240:4: warning: struct demoted to opaque type - has opaque field
pub const fz_store_hash = opaque {};
pub const fz_store_type = extern struct {
    name: [*c]const u8 = null,
    make_hash_key: ?*const fn (ctx: [*c]fz_context, hash: ?*fz_store_hash, key: ?*anyopaque) callconv(.c) c_int = null,
    keep_key: ?*const fn (ctx: [*c]fz_context, key: ?*anyopaque) callconv(.c) ?*anyopaque = null,
    drop_key: ?*const fn (ctx: [*c]fz_context, key: ?*anyopaque) callconv(.c) void = null,
    cmp_key: ?*const fn (ctx: [*c]fz_context, a: ?*anyopaque, b: ?*anyopaque) callconv(.c) c_int = null,
    format_key: ?*const fn (ctx: [*c]fz_context, buf: [*c]u8, size: usize, key: ?*anyopaque) callconv(.c) void = null,
    needs_reap: ?*const fn (ctx: [*c]fz_context, key: ?*anyopaque) callconv(.c) c_int = null,
};
pub extern fn fz_new_store_context(ctx: [*c]fz_context, max: usize) void;
pub extern fn fz_keep_store_context(ctx: [*c]fz_context) ?*fz_store;
pub extern fn fz_drop_store_context(ctx: [*c]fz_context) void;
pub extern fn fz_store_item(ctx: [*c]fz_context, key: ?*anyopaque, val: ?*anyopaque, itemsize: usize, @"type": [*c]const fz_store_type) ?*anyopaque;
pub extern fn fz_find_item(ctx: [*c]fz_context, drop: ?*const fz_store_drop_fn, key: ?*anyopaque, @"type": [*c]const fz_store_type) ?*anyopaque;
pub extern fn fz_remove_item(ctx: [*c]fz_context, drop: ?*const fz_store_drop_fn, key: ?*anyopaque, @"type": [*c]const fz_store_type) void;
pub extern fn fz_empty_store(ctx: [*c]fz_context) void;
pub extern fn fz_store_scavenge(ctx: [*c]fz_context, size: usize, phase: [*c]c_int) c_int;
pub extern fn fz_store_scavenge_external(ctx: [*c]fz_context, size: usize, phase: [*c]c_int) c_int;
pub extern fn fz_shrink_store(ctx: [*c]fz_context, percent: c_uint) c_int;
pub const fz_store_filter_fn = fn (ctx: [*c]fz_context, arg: ?*anyopaque, key: ?*anyopaque) callconv(.c) c_int;
pub extern fn fz_filter_store(ctx: [*c]fz_context, @"fn": ?*const fz_store_filter_fn, arg: ?*anyopaque, @"type": [*c]const fz_store_type) void;
pub extern fn fz_debug_store(ctx: [*c]fz_context, out: [*c]fz_output) void;
pub extern fn fz_defer_reap_start(ctx: [*c]fz_context) void;
pub extern fn fz_defer_reap_end(ctx: [*c]fz_context) void;
pub const struct_fz_jbig2_globals = opaque {};
pub const fz_jbig2_globals = struct_fz_jbig2_globals;
pub const fz_range = extern struct {
    offset: i64 = 0,
    length: u64 = 0,
};
pub extern fn fz_open_null_filter(ctx: [*c]fz_context, chain: [*c]fz_stream, len: u64, offset: i64) [*c]fz_stream;
pub extern fn fz_open_range_filter(ctx: [*c]fz_context, chain: [*c]fz_stream, ranges: [*c]fz_range, nranges: c_int) [*c]fz_stream;
pub extern fn fz_open_endstream_filter(ctx: [*c]fz_context, chain: [*c]fz_stream, len: u64, offset: i64) [*c]fz_stream;
pub extern fn fz_open_concat(ctx: [*c]fz_context, max: c_int, pad: c_int) [*c]fz_stream;
pub extern fn fz_concat_push_drop(ctx: [*c]fz_context, concat: [*c]fz_stream, chain: [*c]fz_stream) void;
pub extern fn fz_open_arc4(ctx: [*c]fz_context, chain: [*c]fz_stream, key: [*c]u8, keylen: c_uint) [*c]fz_stream;
pub extern fn fz_open_aesd(ctx: [*c]fz_context, chain: [*c]fz_stream, key: [*c]u8, keylen: c_uint) [*c]fz_stream;
pub extern fn fz_open_a85d(ctx: [*c]fz_context, chain: [*c]fz_stream) [*c]fz_stream;
pub extern fn fz_open_ahxd(ctx: [*c]fz_context, chain: [*c]fz_stream) [*c]fz_stream;
pub extern fn fz_open_rld(ctx: [*c]fz_context, chain: [*c]fz_stream) [*c]fz_stream;
pub extern fn fz_open_dctd(ctx: [*c]fz_context, chain: [*c]fz_stream, color_transform: c_int, l2factor: c_int, jpegtables: [*c]fz_stream) [*c]fz_stream;
pub extern fn fz_open_faxd(ctx: [*c]fz_context, chain: [*c]fz_stream, k: c_int, end_of_line: c_int, encoded_byte_align: c_int, columns: c_int, rows: c_int, end_of_block: c_int, black_is_1: c_int) [*c]fz_stream;
pub extern fn fz_open_flated(ctx: [*c]fz_context, chain: [*c]fz_stream, window_bits: c_int) [*c]fz_stream;
pub extern fn fz_open_lzwd(ctx: [*c]fz_context, chain: [*c]fz_stream, early_change: c_int, min_bits: c_int, reverse_bits: c_int, old_tiff: c_int) [*c]fz_stream;
pub extern fn fz_open_predict(ctx: [*c]fz_context, chain: [*c]fz_stream, predictor: c_int, columns: c_int, colors: c_int, bpc: c_int) [*c]fz_stream;
pub extern fn fz_open_jbig2d(ctx: [*c]fz_context, chain: [*c]fz_stream, globals: ?*fz_jbig2_globals, embedded: c_int) [*c]fz_stream;
pub extern fn fz_load_jbig2_globals(ctx: [*c]fz_context, buf: [*c]fz_buffer) ?*fz_jbig2_globals;
pub extern fn fz_keep_jbig2_globals(ctx: [*c]fz_context, globals: ?*fz_jbig2_globals) ?*fz_jbig2_globals;
pub extern fn fz_drop_jbig2_globals(ctx: [*c]fz_context, globals: ?*fz_jbig2_globals) void;
pub extern fn fz_drop_jbig2_globals_imp(ctx: [*c]fz_context, globals: [*c]fz_storable) void;
pub extern fn fz_jbig2_globals_data(ctx: [*c]fz_context, globals: ?*fz_jbig2_globals) [*c]fz_buffer;
pub extern fn fz_open_sgilog16(ctx: [*c]fz_context, chain: [*c]fz_stream, w: c_int) [*c]fz_stream;
pub extern fn fz_open_sgilog24(ctx: [*c]fz_context, chain: [*c]fz_stream, w: c_int) [*c]fz_stream;
pub extern fn fz_open_sgilog32(ctx: [*c]fz_context, chain: [*c]fz_stream, w: c_int) [*c]fz_stream;
pub extern fn fz_open_thunder(ctx: [*c]fz_context, chain: [*c]fz_stream, w: c_int) [*c]fz_stream;
const struct_unnamed_17 = extern struct {
    color_transform: c_int = 0,
};
const struct_unnamed_18 = extern struct {
    smask_in_data: c_int = 0,
};
const struct_unnamed_19 = extern struct {
    globals: ?*fz_jbig2_globals = null,
    embedded: c_int = 0,
};
const struct_unnamed_20 = extern struct {
    columns: c_int = 0,
    rows: c_int = 0,
    k: c_int = 0,
    end_of_line: c_int = 0,
    encoded_byte_align: c_int = 0,
    end_of_block: c_int = 0,
    black_is_1: c_int = 0,
    damaged_rows_before_error: c_int = 0,
};
const struct_unnamed_21 = extern struct {
    columns: c_int = 0,
    colors: c_int = 0,
    predictor: c_int = 0,
    bpc: c_int = 0,
};
const struct_unnamed_22 = extern struct {
    columns: c_int = 0,
    colors: c_int = 0,
    predictor: c_int = 0,
    bpc: c_int = 0,
    early_change: c_int = 0,
};
const union_unnamed_16 = extern union {
    jpeg: struct_unnamed_17,
    jpx: struct_unnamed_18,
    jbig2: struct_unnamed_19,
    fax: struct_unnamed_20,
    flate: struct_unnamed_21,
    lzw: struct_unnamed_22,
};
pub const fz_compression_params = extern struct {
    type: c_int = 0,
    u: union_unnamed_16 = @import("std").mem.zeroes(union_unnamed_16),
};
pub const fz_compressed_buffer = extern struct {
    params: fz_compression_params = @import("std").mem.zeroes(fz_compression_params),
    buffer: [*c]fz_buffer = null,
    pub const fz_compressed_buffer_size = __root.fz_compressed_buffer_size;
    pub const size = __root.fz_compressed_buffer_size;
};
pub extern fn fz_compressed_buffer_size(buffer: [*c]fz_compressed_buffer) usize;
pub extern fn fz_open_compressed_buffer(ctx: [*c]fz_context, [*c]fz_compressed_buffer) [*c]fz_stream;
pub extern fn fz_open_image_decomp_stream_from_buffer(ctx: [*c]fz_context, [*c]fz_compressed_buffer, l2factor: [*c]c_int) [*c]fz_stream;
pub extern fn fz_open_image_decomp_stream(ctx: [*c]fz_context, [*c]fz_stream, [*c]fz_compression_params, l2factor: [*c]c_int) [*c]fz_stream;
pub extern fn fz_recognize_image_format(ctx: [*c]fz_context, p: [*c]u8) c_int;
pub extern fn fz_image_type_name(@"type": c_int) [*c]const u8;
pub extern fn fz_lookup_image_type(@"type": [*c]const u8) c_int;
pub const FZ_IMAGE_UNKNOWN: c_int = 0;
pub const FZ_IMAGE_RAW: c_int = 1;
pub const FZ_IMAGE_FAX: c_int = 2;
pub const FZ_IMAGE_FLATE: c_int = 3;
pub const FZ_IMAGE_LZW: c_int = 4;
pub const FZ_IMAGE_RLD: c_int = 5;
pub const FZ_IMAGE_BMP: c_int = 6;
pub const FZ_IMAGE_GIF: c_int = 7;
pub const FZ_IMAGE_JBIG2: c_int = 8;
pub const FZ_IMAGE_JPEG: c_int = 9;
pub const FZ_IMAGE_JPX: c_int = 10;
pub const FZ_IMAGE_JXR: c_int = 11;
pub const FZ_IMAGE_PNG: c_int = 12;
pub const FZ_IMAGE_PNM: c_int = 13;
pub const FZ_IMAGE_TIFF: c_int = 14;
pub const FZ_IMAGE_PSD: c_int = 15;
const enum_unnamed_23 = c_uint;
pub extern fn fz_drop_compressed_buffer(ctx: [*c]fz_context, buf: [*c]fz_compressed_buffer) void;
pub const struct_fz_icc_profile = opaque {};
pub const fz_icc_profile = struct_fz_icc_profile;
pub const FZ_COLORSPACE_NONE: c_int = 0;
pub const FZ_COLORSPACE_GRAY: c_int = 1;
pub const FZ_COLORSPACE_RGB: c_int = 2;
pub const FZ_COLORSPACE_BGR: c_int = 3;
pub const FZ_COLORSPACE_CMYK: c_int = 4;
pub const FZ_COLORSPACE_LAB: c_int = 5;
pub const FZ_COLORSPACE_INDEXED: c_int = 6;
pub const FZ_COLORSPACE_SEPARATION: c_int = 7;
pub const enum_fz_colorspace_type = c_uint;
const struct_unnamed_25 = extern struct {
    buffer: [*c]fz_buffer = null,
    md5: [16]u8 = @import("std").mem.zeroes([16]u8),
    profile: ?*fz_icc_profile = null,
};
pub const fz_colorspace = struct_fz_colorspace;
const struct_unnamed_26 = extern struct {
    base: [*c]fz_colorspace = null,
    high: c_int = 0,
    lookup: [*c]u8 = null,
};
const struct_unnamed_27 = extern struct {
    base: [*c]fz_colorspace = null,
    eval: ?*const fn (ctx: [*c]fz_context, tint: ?*anyopaque, s: [*c]const f32, sn: c_int, d: [*c]f32, dn: c_int) callconv(.c) void = null,
    drop: ?*const fn (ctx: [*c]fz_context, tint: ?*anyopaque) callconv(.c) void = null,
    tint: ?*anyopaque = null,
    colorant: [32][*c]u8 = @import("std").mem.zeroes([32][*c]u8),
};
const union_unnamed_24 = extern union {
    icc: struct_unnamed_25,
    indexed: struct_unnamed_26,
    separation: struct_unnamed_27,
};
pub const struct_fz_colorspace = extern struct {
    key_storable: fz_key_storable = @import("std").mem.zeroes(fz_key_storable),
    type: enum_fz_colorspace_type = @import("std").mem.zeroes(enum_fz_colorspace_type),
    flags: c_int = 0,
    n: c_int = 0,
    name: [*c]u8 = null,
    u: union_unnamed_24 = @import("std").mem.zeroes(union_unnamed_24),
};
pub const struct_fz_separations = opaque {};
pub const fz_separations = struct_fz_separations;
pub const fz_pixmap = struct_fz_pixmap;
pub const struct_fz_pixmap = extern struct {
    storable: fz_storable = @import("std").mem.zeroes(fz_storable),
    x: c_int = 0,
    y: c_int = 0,
    w: c_int = 0,
    h: c_int = 0,
    n: u8 = 0,
    s: u8 = 0,
    alpha: u8 = 0,
    flags: u8 = 0,
    stride: ptrdiff_t = 0,
    seps: ?*fz_separations = null,
    xres: c_int = 0,
    yres: c_int = 0,
    colorspace: [*c]fz_colorspace = null,
    samples: [*c]u8 = null,
    underlying: [*c]fz_pixmap = null,
};
pub const FZ_RI_PERCEPTUAL: c_int = 0;
pub const FZ_RI_RELATIVE_COLORIMETRIC: c_int = 1;
pub const FZ_RI_SATURATION: c_int = 2;
pub const FZ_RI_ABSOLUTE_COLORIMETRIC: c_int = 3;
const enum_unnamed_28 = c_uint;
pub const fz_color_params = extern struct {
    ri: u8 = 0,
    bp: u8 = 0,
    op: u8 = 0,
    opm: u8 = 0,
};
pub extern const fz_default_color_params: fz_color_params;
pub extern fn fz_lookup_rendering_intent(name: [*c]const u8) c_int;
pub extern fn fz_rendering_intent_name(ri: c_int) [*c]const u8;
pub const FZ_MAX_COLORS: c_int = 32;
const enum_unnamed_29 = c_uint;
pub const FZ_COLORSPACE_IS_DEVICE: c_int = 1;
pub const FZ_COLORSPACE_IS_ICC: c_int = 2;
pub const FZ_COLORSPACE_HAS_CMYK: c_int = 4;
pub const FZ_COLORSPACE_HAS_SPOTS: c_int = 8;
pub const FZ_COLORSPACE_HAS_CMYK_AND_SPOTS: c_int = 12;
const enum_unnamed_30 = c_uint;
pub extern fn fz_new_colorspace(ctx: [*c]fz_context, @"type": enum_fz_colorspace_type, flags: c_int, n: c_int, name: [*c]const u8) [*c]fz_colorspace;
pub extern fn fz_keep_colorspace(ctx: [*c]fz_context, colorspace: [*c]fz_colorspace) [*c]fz_colorspace;
pub extern fn fz_drop_colorspace(ctx: [*c]fz_context, colorspace: [*c]fz_colorspace) void;
pub extern fn fz_new_indexed_colorspace(ctx: [*c]fz_context, base: [*c]fz_colorspace, high: c_int, lookup: [*c]u8) [*c]fz_colorspace;
pub extern fn fz_new_icc_colorspace(ctx: [*c]fz_context, @"type": enum_fz_colorspace_type, flags: c_int, name: [*c]const u8, buf: [*c]fz_buffer) [*c]fz_colorspace;
pub extern fn fz_new_cal_gray_colorspace(ctx: [*c]fz_context, wp: [*c]f32, bp: [*c]f32, gamma: f32) [*c]fz_colorspace;
pub extern fn fz_new_cal_rgb_colorspace(ctx: [*c]fz_context, wp: [*c]f32, bp: [*c]f32, gamma: [*c]f32, matrix: [*c]f32) [*c]fz_colorspace;
pub extern fn fz_colorspace_type(ctx: [*c]fz_context, cs: [*c]fz_colorspace) enum_fz_colorspace_type;
pub extern fn fz_colorspace_name(ctx: [*c]fz_context, cs: [*c]fz_colorspace) [*c]const u8;
pub extern fn fz_colorspace_n(ctx: [*c]fz_context, cs: [*c]fz_colorspace) c_int;
pub extern fn fz_colorspace_is_subtractive(ctx: [*c]fz_context, cs: [*c]fz_colorspace) c_int;
pub extern fn fz_colorspace_device_n_has_only_cmyk(ctx: [*c]fz_context, cs: [*c]fz_colorspace) c_int;
pub extern fn fz_colorspace_device_n_has_cmyk(ctx: [*c]fz_context, cs: [*c]fz_colorspace) c_int;
pub extern fn fz_colorspace_is_gray(ctx: [*c]fz_context, cs: [*c]fz_colorspace) c_int;
pub extern fn fz_colorspace_is_rgb(ctx: [*c]fz_context, cs: [*c]fz_colorspace) c_int;
pub extern fn fz_colorspace_is_cmyk(ctx: [*c]fz_context, cs: [*c]fz_colorspace) c_int;
pub extern fn fz_colorspace_is_lab(ctx: [*c]fz_context, cs: [*c]fz_colorspace) c_int;
pub extern fn fz_colorspace_is_indexed(ctx: [*c]fz_context, cs: [*c]fz_colorspace) c_int;
pub extern fn fz_colorspace_is_device_n(ctx: [*c]fz_context, cs: [*c]fz_colorspace) c_int;
pub extern fn fz_colorspace_is_device(ctx: [*c]fz_context, cs: [*c]fz_colorspace) c_int;
pub extern fn fz_colorspace_is_device_gray(ctx: [*c]fz_context, cs: [*c]fz_colorspace) c_int;
pub extern fn fz_colorspace_is_device_cmyk(ctx: [*c]fz_context, cs: [*c]fz_colorspace) c_int;
pub extern fn fz_colorspace_is_lab_icc(ctx: [*c]fz_context, cs: [*c]fz_colorspace) c_int;
pub extern fn fz_is_valid_blend_colorspace(ctx: [*c]fz_context, cs: [*c]fz_colorspace) c_int;
pub extern fn fz_base_colorspace(ctx: [*c]fz_context, cs: [*c]fz_colorspace) [*c]fz_colorspace;
pub extern fn fz_device_gray(ctx: [*c]fz_context) [*c]fz_colorspace;
pub extern fn fz_device_rgb(ctx: [*c]fz_context) [*c]fz_colorspace;
pub extern fn fz_device_bgr(ctx: [*c]fz_context) [*c]fz_colorspace;
pub extern fn fz_device_cmyk(ctx: [*c]fz_context) [*c]fz_colorspace;
pub extern fn fz_device_lab(ctx: [*c]fz_context) [*c]fz_colorspace;
pub extern fn fz_colorspace_name_colorant(ctx: [*c]fz_context, cs: [*c]fz_colorspace, n: c_int, name: [*c]const u8) void;
pub extern fn fz_colorspace_colorant(ctx: [*c]fz_context, cs: [*c]fz_colorspace, n: c_int) [*c]const u8;
pub extern fn fz_clamp_color(ctx: [*c]fz_context, cs: [*c]fz_colorspace, in: [*c]const f32, out: [*c]f32) void;
pub extern fn fz_convert_color(ctx: [*c]fz_context, ss: [*c]fz_colorspace, sv: [*c]const f32, ds: [*c]fz_colorspace, dv: [*c]f32, is: [*c]fz_colorspace, params: fz_color_params) void;
pub const fz_default_colorspaces = extern struct {
    refs: c_int = 0,
    gray: [*c]fz_colorspace = null,
    rgb: [*c]fz_colorspace = null,
    cmyk: [*c]fz_colorspace = null,
    oi: [*c]fz_colorspace = null,
};
pub extern fn fz_new_default_colorspaces(ctx: [*c]fz_context) [*c]fz_default_colorspaces;
pub extern fn fz_keep_default_colorspaces(ctx: [*c]fz_context, default_cs: [*c]fz_default_colorspaces) [*c]fz_default_colorspaces;
pub extern fn fz_drop_default_colorspaces(ctx: [*c]fz_context, default_cs: [*c]fz_default_colorspaces) void;
pub extern fn fz_clone_default_colorspaces(ctx: [*c]fz_context, base: [*c]fz_default_colorspaces) [*c]fz_default_colorspaces;
pub extern fn fz_default_gray(ctx: [*c]fz_context, default_cs: [*c]const fz_default_colorspaces) [*c]fz_colorspace;
pub extern fn fz_default_rgb(ctx: [*c]fz_context, default_cs: [*c]const fz_default_colorspaces) [*c]fz_colorspace;
pub extern fn fz_default_cmyk(ctx: [*c]fz_context, default_cs: [*c]const fz_default_colorspaces) [*c]fz_colorspace;
pub extern fn fz_default_output_intent(ctx: [*c]fz_context, default_cs: [*c]const fz_default_colorspaces) [*c]fz_colorspace;
pub extern fn fz_set_default_gray(ctx: [*c]fz_context, default_cs: [*c]fz_default_colorspaces, cs: [*c]fz_colorspace) void;
pub extern fn fz_set_default_rgb(ctx: [*c]fz_context, default_cs: [*c]fz_default_colorspaces, cs: [*c]fz_colorspace) void;
pub extern fn fz_set_default_cmyk(ctx: [*c]fz_context, default_cs: [*c]fz_default_colorspaces, cs: [*c]fz_colorspace) void;
pub extern fn fz_set_default_output_intent(ctx: [*c]fz_context, default_cs: [*c]fz_default_colorspaces, cs: [*c]fz_colorspace) void;
pub extern fn fz_drop_colorspace_imp(ctx: [*c]fz_context, cs_: [*c]fz_storable) void;
pub const FZ_MAX_SEPARATIONS: c_int = 64;
const enum_unnamed_31 = c_uint;
pub const FZ_SEPARATION_COMPOSITE: c_int = 0;
pub const FZ_SEPARATION_SPOT: c_int = 1;
pub const FZ_SEPARATION_DISABLED: c_int = 2;
pub const fz_separation_behavior = c_uint;
pub extern fn fz_new_separations(ctx: [*c]fz_context, controllable: c_int) ?*fz_separations;
pub extern fn fz_keep_separations(ctx: [*c]fz_context, sep: ?*fz_separations) ?*fz_separations;
pub extern fn fz_drop_separations(ctx: [*c]fz_context, sep: ?*fz_separations) void;
pub extern fn fz_add_separation(ctx: [*c]fz_context, sep: ?*fz_separations, name: [*c]const u8, cs: [*c]fz_colorspace, cs_channel: c_int) void;
pub extern fn fz_add_separation_equivalents(ctx: [*c]fz_context, sep: ?*fz_separations, rgba: u32, cmyk: u32, name: [*c]const u8) void;
pub extern fn fz_set_separation_behavior(ctx: [*c]fz_context, sep: ?*fz_separations, separation: c_int, behavior: fz_separation_behavior) void;
pub extern fn fz_separation_current_behavior(ctx: [*c]fz_context, sep: ?*const fz_separations, separation: c_int) fz_separation_behavior;
pub extern fn fz_separation_name(ctx: [*c]fz_context, sep: ?*const fz_separations, separation: c_int) [*c]const u8;
pub extern fn fz_count_separations(ctx: [*c]fz_context, sep: ?*const fz_separations) c_int;
pub extern fn fz_count_active_separations(ctx: [*c]fz_context, seps: ?*const fz_separations) c_int;
pub extern fn fz_compare_separations(ctx: [*c]fz_context, sep1: ?*const fz_separations, sep2: ?*const fz_separations) c_int;
pub extern fn fz_clone_separations_for_overprint(ctx: [*c]fz_context, seps: ?*fz_separations) ?*fz_separations;
pub extern fn fz_convert_separation_colors(ctx: [*c]fz_context, src_cs: [*c]fz_colorspace, src_color: [*c]const f32, dst_seps: ?*fz_separations, dst_cs: [*c]fz_colorspace, dst_color: [*c]f32, color_params: fz_color_params) void;
pub extern fn fz_separation_equivalent(ctx: [*c]fz_context, seps: ?*const fz_separations, idx: c_int, dst_cs: [*c]fz_colorspace, dst_color: [*c]f32, prf: [*c]fz_colorspace, color_params: fz_color_params) void;
pub const struct_fz_overprint = opaque {};
pub const fz_overprint = struct_fz_overprint;
pub extern fn fz_pixmap_bbox(ctx: [*c]fz_context, pix: [*c]const fz_pixmap) fz_irect;
pub extern fn fz_pixmap_width(ctx: [*c]fz_context, pix: [*c]const fz_pixmap) c_int;
pub extern fn fz_pixmap_height(ctx: [*c]fz_context, pix: [*c]const fz_pixmap) c_int;
pub extern fn fz_pixmap_x(ctx: [*c]fz_context, pix: [*c]const fz_pixmap) c_int;
pub extern fn fz_pixmap_y(ctx: [*c]fz_context, pix: [*c]const fz_pixmap) c_int;
pub extern fn fz_pixmap_size(ctx: [*c]fz_context, pix: [*c]fz_pixmap) usize;
pub extern fn fz_new_pixmap(ctx: [*c]fz_context, cs: [*c]fz_colorspace, w: c_int, h: c_int, seps: ?*fz_separations, alpha: c_int) [*c]fz_pixmap;
pub extern fn fz_new_pixmap_with_bbox(ctx: [*c]fz_context, colorspace: [*c]fz_colorspace, bbox: fz_irect, seps: ?*fz_separations, alpha: c_int) [*c]fz_pixmap;
pub extern fn fz_new_pixmap_with_data(ctx: [*c]fz_context, colorspace: [*c]fz_colorspace, w: c_int, h: c_int, seps: ?*fz_separations, alpha: c_int, stride: c_int, samples: [*c]u8) [*c]fz_pixmap;
pub extern fn fz_new_pixmap_with_bbox_and_data(ctx: [*c]fz_context, colorspace: [*c]fz_colorspace, rect: fz_irect, seps: ?*fz_separations, alpha: c_int, samples: [*c]u8) [*c]fz_pixmap;
pub extern fn fz_new_pixmap_from_pixmap(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, rect: [*c]const fz_irect) [*c]fz_pixmap;
pub extern fn fz_clone_pixmap(ctx: [*c]fz_context, old: [*c]const fz_pixmap) [*c]fz_pixmap;
pub extern fn fz_keep_pixmap(ctx: [*c]fz_context, pix: [*c]fz_pixmap) [*c]fz_pixmap;
pub extern fn fz_drop_pixmap(ctx: [*c]fz_context, pix: [*c]fz_pixmap) void;
pub extern fn fz_pixmap_colorspace(ctx: [*c]fz_context, pix: [*c]const fz_pixmap) [*c]fz_colorspace;
pub extern fn fz_pixmap_components(ctx: [*c]fz_context, pix: [*c]const fz_pixmap) c_int;
pub extern fn fz_pixmap_colorants(ctx: [*c]fz_context, pix: [*c]const fz_pixmap) c_int;
pub extern fn fz_pixmap_spots(ctx: [*c]fz_context, pix: [*c]const fz_pixmap) c_int;
pub extern fn fz_pixmap_alpha(ctx: [*c]fz_context, pix: [*c]const fz_pixmap) c_int;
pub extern fn fz_pixmap_samples(ctx: [*c]fz_context, pix: [*c]const fz_pixmap) [*c]u8;
pub extern fn fz_pixmap_stride(ctx: [*c]fz_context, pix: [*c]const fz_pixmap) c_int;
pub extern fn fz_set_pixmap_resolution(ctx: [*c]fz_context, pix: [*c]fz_pixmap, xres: c_int, yres: c_int) void;
pub extern fn fz_clear_pixmap_with_value(ctx: [*c]fz_context, pix: [*c]fz_pixmap, value: c_int) void;
pub extern fn fz_fill_pixmap_with_color(ctx: [*c]fz_context, pix: [*c]fz_pixmap, colorspace: [*c]fz_colorspace, color: [*c]f32, color_params: fz_color_params) void;
pub extern fn fz_clear_pixmap_rect_with_value(ctx: [*c]fz_context, pix: [*c]fz_pixmap, value: c_int, r: fz_irect) void;
pub extern fn fz_clear_pixmap(ctx: [*c]fz_context, pix: [*c]fz_pixmap) void;
pub extern fn fz_invert_pixmap(ctx: [*c]fz_context, pix: [*c]fz_pixmap) void;
pub extern fn fz_invert_pixmap_alpha(ctx: [*c]fz_context, pix: [*c]fz_pixmap) void;
pub extern fn fz_invert_pixmap_luminance(ctx: [*c]fz_context, pix: [*c]fz_pixmap) void;
pub extern fn fz_tint_pixmap(ctx: [*c]fz_context, pix: [*c]fz_pixmap, black: c_int, white: c_int) void;
pub extern fn fz_invert_pixmap_rect(ctx: [*c]fz_context, image: [*c]fz_pixmap, rect: fz_irect) void;
pub extern fn fz_invert_pixmap_raw(ctx: [*c]fz_context, pix: [*c]fz_pixmap) void;
pub extern fn fz_gamma_pixmap(ctx: [*c]fz_context, pix: [*c]fz_pixmap, gamma: f32) void;
pub extern fn fz_convert_pixmap(ctx: [*c]fz_context, pix: [*c]const fz_pixmap, cs_des: [*c]fz_colorspace, prf: [*c]fz_colorspace, default_cs: [*c]fz_default_colorspaces, color_params: fz_color_params, keep_alpha: c_int) [*c]fz_pixmap;
pub extern fn fz_is_pixmap_monochrome(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap) c_int;
pub extern fn fz_alpha_from_gray(ctx: [*c]fz_context, gray: [*c]fz_pixmap) [*c]fz_pixmap;
pub extern fn fz_decode_tile(ctx: [*c]fz_context, pix: [*c]fz_pixmap, decode: [*c]const f32) void;
pub extern fn fz_md5_pixmap(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, digest: [*c]u8) void;
pub extern fn fz_unpack_stream(ctx: [*c]fz_context, src: [*c]fz_stream, depth: c_int, w: c_int, h: c_int, n: c_int, indexed: c_int, pad: c_int, skip: c_int) [*c]fz_stream;
pub const FZ_PIXMAP_FLAG_INTERPOLATE: c_int = 1;
pub const FZ_PIXMAP_FLAG_FREE_SAMPLES: c_int = 2;
const enum_unnamed_32 = c_uint;
pub extern fn fz_warp_pixmap(ctx: [*c]fz_context, src: [*c]fz_pixmap, points: [*c]const fz_point, width: c_int, height: c_int) [*c]fz_pixmap;
pub extern fn fz_clone_pixmap_area_with_different_seps(ctx: [*c]fz_context, src: [*c]fz_pixmap, bbox: [*c]const fz_irect, dcs: [*c]fz_colorspace, seps: ?*fz_separations, color_params: fz_color_params, default_cs: [*c]fz_default_colorspaces) [*c]fz_pixmap;
pub extern fn fz_new_pixmap_from_alpha_channel(ctx: [*c]fz_context, src: [*c]fz_pixmap) [*c]fz_pixmap;
pub extern fn fz_new_pixmap_from_color_and_mask(ctx: [*c]fz_context, color: [*c]fz_pixmap, mask: [*c]fz_pixmap) [*c]fz_pixmap;
pub extern fn fz_scale_pixmap(ctx: [*c]fz_context, src: [*c]fz_pixmap, x: f32, y: f32, w: f32, h: f32, clip: [*c]const fz_irect) [*c]fz_pixmap;
pub extern fn fz_subsample_pixmap(ctx: [*c]fz_context, tile: [*c]fz_pixmap, factor: c_int) void;
pub extern fn fz_copy_pixmap_rect(ctx: [*c]fz_context, dest: [*c]fz_pixmap, src: [*c]fz_pixmap, r: fz_irect, default_cs: [*c]const fz_default_colorspaces) void;
pub const fz_bitmap = extern struct {
    refs: c_int = 0,
    w: c_int = 0,
    h: c_int = 0,
    stride: c_int = 0,
    n: c_int = 0,
    xres: c_int = 0,
    yres: c_int = 0,
    samples: [*c]u8 = null,
    pub const fz_bitmap_details = __root.fz_bitmap_details;
    pub const details = __root.fz_bitmap_details;
};
pub extern fn fz_keep_bitmap(ctx: [*c]fz_context, bit: [*c]fz_bitmap) [*c]fz_bitmap;
pub extern fn fz_drop_bitmap(ctx: [*c]fz_context, bit: [*c]fz_bitmap) void;
pub const struct_fz_halftone = opaque {};
pub const fz_halftone = struct_fz_halftone;
pub extern fn fz_new_bitmap_from_pixmap(ctx: [*c]fz_context, pix: [*c]fz_pixmap, ht: ?*fz_halftone) [*c]fz_bitmap;
pub extern fn fz_new_bitmap_from_pixmap_band(ctx: [*c]fz_context, pix: [*c]fz_pixmap, ht: ?*fz_halftone, band_start: c_int) [*c]fz_bitmap;
pub extern fn fz_new_bitmap(ctx: [*c]fz_context, w: c_int, h: c_int, n: c_int, xres: c_int, yres: c_int) [*c]fz_bitmap;
pub extern fn fz_bitmap_details(bitmap: [*c]fz_bitmap, w: [*c]c_int, h: [*c]c_int, n: [*c]c_int, stride: [*c]c_int) void;
pub extern fn fz_clear_bitmap(ctx: [*c]fz_context, bit: [*c]fz_bitmap) void;
pub extern fn fz_default_halftone(ctx: [*c]fz_context, num_comps: c_int) ?*fz_halftone;
pub extern fn fz_keep_halftone(ctx: [*c]fz_context, half: ?*fz_halftone) ?*fz_halftone;
pub extern fn fz_drop_halftone(ctx: [*c]fz_context, ht: ?*fz_halftone) void; // /usr/include/mupdf/fitz/image.h:328:15: warning: struct demoted to opaque type - has bitfield
pub const struct_fz_image = opaque {
    pub const fz_image_resolution = __root.fz_image_resolution;
    pub const resolution = __root.fz_image_resolution;
};
pub const fz_image = struct_fz_image;
pub const struct_fz_compressed_image = opaque {};
pub const fz_compressed_image = struct_fz_compressed_image;
pub const struct_fz_pixmap_image = opaque {};
pub const fz_pixmap_image = struct_fz_pixmap_image;
pub extern fn fz_get_pixmap_from_image(ctx: [*c]fz_context, image: ?*fz_image, subarea: [*c]const fz_irect, ctm: [*c]fz_matrix, w: [*c]c_int, h: [*c]c_int) [*c]fz_pixmap;
pub extern fn fz_get_unscaled_pixmap_from_image(ctx: [*c]fz_context, image: ?*fz_image) [*c]fz_pixmap;
pub extern fn fz_keep_image(ctx: [*c]fz_context, image: ?*fz_image) ?*fz_image;
pub extern fn fz_drop_image(ctx: [*c]fz_context, image: ?*fz_image) void;
pub extern fn fz_keep_image_store_key(ctx: [*c]fz_context, image: ?*fz_image) ?*fz_image;
pub extern fn fz_drop_image_store_key(ctx: [*c]fz_context, image: ?*fz_image) void;
pub const fz_drop_image_fn = fn (ctx: [*c]fz_context, image: ?*fz_image) callconv(.c) void;
pub const fz_image_get_pixmap_fn = fn (ctx: [*c]fz_context, im: ?*fz_image, subarea: [*c]fz_irect, w: c_int, h: c_int, l2factor: [*c]c_int) callconv(.c) [*c]fz_pixmap;
pub const fz_image_get_size_fn = fn ([*c]fz_context, ?*fz_image) callconv(.c) usize;
pub extern fn fz_new_image_of_size(ctx: [*c]fz_context, w: c_int, h: c_int, bpc: c_int, colorspace: [*c]fz_colorspace, xres: c_int, yres: c_int, interpolate: c_int, imagemask: c_int, decode: [*c]f32, colorkey: [*c]c_int, mask: ?*fz_image, size: usize, get_pixmap: ?*const fz_image_get_pixmap_fn, get_size: ?*const fz_image_get_size_fn, drop: ?*const fz_drop_image_fn) ?*fz_image;
pub extern fn fz_new_image_from_compressed_buffer(ctx: [*c]fz_context, w: c_int, h: c_int, bpc: c_int, colorspace: [*c]fz_colorspace, xres: c_int, yres: c_int, interpolate: c_int, imagemask: c_int, decode: [*c]f32, colorkey: [*c]c_int, buffer: [*c]fz_compressed_buffer, mask: ?*fz_image) ?*fz_image;
pub extern fn fz_new_image_from_pixmap(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, mask: ?*fz_image) ?*fz_image;
pub extern fn fz_new_image_from_buffer(ctx: [*c]fz_context, buffer: [*c]fz_buffer) ?*fz_image;
pub extern fn fz_new_image_from_file(ctx: [*c]fz_context, path: [*c]const u8) ?*fz_image;
pub extern fn fz_drop_image_imp(ctx: [*c]fz_context, image: [*c]fz_storable) void;
pub extern fn fz_drop_image_base(ctx: [*c]fz_context, image: ?*fz_image) void;
pub extern fn fz_decomp_image_from_stream(ctx: [*c]fz_context, stm: [*c]fz_stream, image: ?*fz_compressed_image, subarea: [*c]fz_irect, indexed: c_int, l2factor: c_int, l2extra: [*c]c_int) [*c]fz_pixmap;
pub extern fn fz_convert_indexed_pixmap_to_base(ctx: [*c]fz_context, src: [*c]const fz_pixmap) [*c]fz_pixmap;
pub extern fn fz_convert_separation_pixmap_to_base(ctx: [*c]fz_context, src: [*c]const fz_pixmap) [*c]fz_pixmap;
pub extern fn fz_image_size(ctx: [*c]fz_context, im: ?*fz_image) usize;
pub extern fn fz_image_resolution(image: ?*fz_image, xres: [*c]c_int, yres: [*c]c_int) void;
pub extern fn fz_image_orientation(ctx: [*c]fz_context, image: ?*fz_image) u8;
pub extern fn fz_image_orientation_matrix(ctx: [*c]fz_context, image: ?*fz_image) fz_matrix;
pub extern fn fz_compressed_image_buffer(ctx: [*c]fz_context, image: ?*fz_image) [*c]fz_compressed_buffer;
pub extern fn fz_set_compressed_image_buffer(ctx: [*c]fz_context, cimg: ?*fz_compressed_image, buf: [*c]fz_compressed_buffer) void;
pub extern fn fz_pixmap_image_tile(ctx: [*c]fz_context, cimg: ?*fz_pixmap_image) [*c]fz_pixmap;
pub extern fn fz_set_pixmap_image_tile(ctx: [*c]fz_context, cimg: ?*fz_pixmap_image, pix: [*c]fz_pixmap) void;
pub extern fn fz_load_jpx(ctx: [*c]fz_context, data: [*c]const u8, size: usize, cs: [*c]fz_colorspace) [*c]fz_pixmap;
pub extern fn fz_load_tiff_subimage_count(ctx: [*c]fz_context, buf: [*c]const u8, len: usize) c_int;
pub extern fn fz_load_tiff_subimage(ctx: [*c]fz_context, buf: [*c]const u8, len: usize, subimage: c_int) [*c]fz_pixmap;
pub extern fn fz_load_pnm_subimage_count(ctx: [*c]fz_context, buf: [*c]const u8, len: usize) c_int;
pub extern fn fz_load_pnm_subimage(ctx: [*c]fz_context, buf: [*c]const u8, len: usize, subimage: c_int) [*c]fz_pixmap;
pub extern fn fz_load_jbig2_subimage_count(ctx: [*c]fz_context, buf: [*c]const u8, len: usize) c_int;
pub extern fn fz_load_jbig2_subimage(ctx: [*c]fz_context, buf: [*c]const u8, len: usize, subimage: c_int) [*c]fz_pixmap;
pub extern fn fz_load_bmp_subimage_count(ctx: [*c]fz_context, buf: [*c]const u8, len: usize) c_int;
pub extern fn fz_load_bmp_subimage(ctx: [*c]fz_context, buf: [*c]const u8, len: usize, subimage: c_int) [*c]fz_pixmap;
pub const FZ_FUNCTION_BASED: c_int = 1;
pub const FZ_LINEAR: c_int = 2;
pub const FZ_RADIAL: c_int = 3;
pub const FZ_MESH_TYPE4: c_int = 4;
pub const FZ_MESH_TYPE5: c_int = 5;
pub const FZ_MESH_TYPE6: c_int = 6;
pub const FZ_MESH_TYPE7: c_int = 7;
const enum_unnamed_33 = c_uint;
const struct_unnamed_35 = extern struct {
    extend: [2]c_int = @import("std").mem.zeroes([2]c_int),
    coords: [2][3]f32 = @import("std").mem.zeroes([2][3]f32),
};
const struct_unnamed_36 = extern struct {
    vprow: c_int = 0,
    bpflag: c_int = 0,
    bpcoord: c_int = 0,
    bpcomp: c_int = 0,
    x0: f32 = 0,
    x1: f32 = 0,
    y0: f32 = 0,
    y1: f32 = 0,
    c0: [32]f32 = @import("std").mem.zeroes([32]f32),
    c1: [32]f32 = @import("std").mem.zeroes([32]f32),
};
const struct_unnamed_37 = extern struct {
    matrix: fz_matrix = @import("std").mem.zeroes(fz_matrix),
    xdivs: c_int = 0,
    ydivs: c_int = 0,
    domain: [2][2]f32 = @import("std").mem.zeroes([2][2]f32),
    fn_vals: [*c]f32 = null,
};
const union_unnamed_34 = extern union {
    l_or_r: struct_unnamed_35,
    m: struct_unnamed_36,
    f: struct_unnamed_37,
};
pub const fz_shade = extern struct {
    storable: fz_storable = @import("std").mem.zeroes(fz_storable),
    bbox: fz_rect = @import("std").mem.zeroes(fz_rect),
    colorspace: [*c]fz_colorspace = null,
    matrix: fz_matrix = @import("std").mem.zeroes(fz_matrix),
    use_background: c_int = 0,
    background: [32]f32 = @import("std").mem.zeroes([32]f32),
    use_function: c_int = 0,
    function: [256][33]f32 = @import("std").mem.zeroes([256][33]f32),
    type: c_int = 0,
    u: union_unnamed_34 = @import("std").mem.zeroes(union_unnamed_34),
    buffer: [*c]fz_compressed_buffer = null,
};
pub extern fn fz_keep_shade(ctx: [*c]fz_context, shade: [*c]fz_shade) [*c]fz_shade;
pub extern fn fz_drop_shade(ctx: [*c]fz_context, shade: [*c]fz_shade) void;
pub extern fn fz_bound_shade(ctx: [*c]fz_context, shade: [*c]fz_shade, ctm: fz_matrix) fz_rect;
pub const struct_fz_shade_color_cache = opaque {};
pub const fz_shade_color_cache = struct_fz_shade_color_cache;
pub extern fn fz_drop_shade_color_cache(ctx: [*c]fz_context, cache: ?*fz_shade_color_cache) void;
pub extern fn fz_paint_shade(ctx: [*c]fz_context, shade: [*c]fz_shade, override_cs: [*c]fz_colorspace, ctm: fz_matrix, dest: [*c]fz_pixmap, color_params: fz_color_params, bbox: fz_irect, eop: ?*const fz_overprint, cache: [*c]?*fz_shade_color_cache) void;
pub const fz_vertex = extern struct {
    p: fz_point = @import("std").mem.zeroes(fz_point),
    c: [32]f32 = @import("std").mem.zeroes([32]f32),
};
pub const fz_shade_prepare_fn = fn (ctx: [*c]fz_context, arg: ?*anyopaque, v: [*c]fz_vertex, c: [*c]const f32) callconv(.c) void;
pub const fz_shade_process_fn = fn (ctx: [*c]fz_context, arg: ?*anyopaque, av: [*c]fz_vertex, bv: [*c]fz_vertex, cv: [*c]fz_vertex) callconv(.c) void;
pub extern fn fz_process_shade(ctx: [*c]fz_context, shade: [*c]fz_shade, ctm: fz_matrix, scissor: fz_rect, prepare: ?*const fz_shade_prepare_fn, process: ?*const fz_shade_process_fn, process_arg: ?*anyopaque) void;
pub extern fn fz_drop_shade_imp(ctx: [*c]fz_context, shade: [*c]fz_storable) void;
pub const fz_device = struct_fz_device;
pub const struct_fz_path = opaque {
    pub const fz_packed_path_size = __root.fz_packed_path_size;
    pub const size = __root.fz_packed_path_size;
};
pub const fz_path = struct_fz_path;
pub const struct_fz_device = extern struct {
    refs: c_int = 0,
    hints: c_int = 0,
    flags: c_int = 0,
    close_device: ?*const fn ([*c]fz_context, [*c]fz_device) callconv(.c) void = null,
    drop_device: ?*const fn ([*c]fz_context, [*c]fz_device) callconv(.c) void = null,
    fill_path: ?*const fn ([*c]fz_context, [*c]fz_device, ?*const fz_path, even_odd: c_int, fz_matrix, [*c]fz_colorspace, color: [*c]const f32, alpha: f32, fz_color_params) callconv(.c) void = null,
    stroke_path: ?*const fn ([*c]fz_context, [*c]fz_device, ?*const fz_path, [*c]const fz_stroke_state, fz_matrix, [*c]fz_colorspace, color: [*c]const f32, alpha: f32, fz_color_params) callconv(.c) void = null,
    clip_path: ?*const fn ([*c]fz_context, [*c]fz_device, ?*const fz_path, even_odd: c_int, fz_matrix, scissor: fz_rect) callconv(.c) void = null,
    clip_stroke_path: ?*const fn ([*c]fz_context, [*c]fz_device, ?*const fz_path, [*c]const fz_stroke_state, fz_matrix, scissor: fz_rect) callconv(.c) void = null,
    fill_text: ?*const fn ([*c]fz_context, [*c]fz_device, [*c]const fz_text, fz_matrix, [*c]fz_colorspace, color: [*c]const f32, alpha: f32, fz_color_params) callconv(.c) void = null,
    stroke_text: ?*const fn ([*c]fz_context, [*c]fz_device, [*c]const fz_text, [*c]const fz_stroke_state, fz_matrix, [*c]fz_colorspace, color: [*c]const f32, alpha: f32, fz_color_params) callconv(.c) void = null,
    clip_text: ?*const fn ([*c]fz_context, [*c]fz_device, [*c]const fz_text, fz_matrix, scissor: fz_rect) callconv(.c) void = null,
    clip_stroke_text: ?*const fn ([*c]fz_context, [*c]fz_device, [*c]const fz_text, [*c]const fz_stroke_state, fz_matrix, scissor: fz_rect) callconv(.c) void = null,
    ignore_text: ?*const fn ([*c]fz_context, [*c]fz_device, [*c]const fz_text, fz_matrix) callconv(.c) void = null,
    fill_shade: ?*const fn ([*c]fz_context, [*c]fz_device, shd: [*c]fz_shade, ctm: fz_matrix, alpha: f32, color_params: fz_color_params) callconv(.c) void = null,
    fill_image: ?*const fn ([*c]fz_context, [*c]fz_device, img: ?*fz_image, ctm: fz_matrix, alpha: f32, color_params: fz_color_params) callconv(.c) void = null,
    fill_image_mask: ?*const fn ([*c]fz_context, [*c]fz_device, img: ?*fz_image, ctm: fz_matrix, [*c]fz_colorspace, color: [*c]const f32, alpha: f32, color_params: fz_color_params) callconv(.c) void = null,
    clip_image_mask: ?*const fn ([*c]fz_context, [*c]fz_device, img: ?*fz_image, ctm: fz_matrix, scissor: fz_rect) callconv(.c) void = null,
    pop_clip: ?*const fn ([*c]fz_context, [*c]fz_device) callconv(.c) void = null,
    begin_mask: ?*const fn ([*c]fz_context, [*c]fz_device, area: fz_rect, luminosity: c_int, [*c]fz_colorspace, bc: [*c]const f32, fz_color_params) callconv(.c) void = null,
    end_mask: ?*const fn ([*c]fz_context, [*c]fz_device) callconv(.c) void = null,
    begin_group: ?*const fn ([*c]fz_context, [*c]fz_device, area: fz_rect, cs: [*c]fz_colorspace, isolated: c_int, knockout: c_int, blendmode: c_int, alpha: f32) callconv(.c) void = null,
    end_group: ?*const fn ([*c]fz_context, [*c]fz_device) callconv(.c) void = null,
    begin_tile: ?*const fn ([*c]fz_context, [*c]fz_device, area: fz_rect, view: fz_rect, xstep: f32, ystep: f32, ctm: fz_matrix, id: c_int) callconv(.c) c_int = null,
    end_tile: ?*const fn ([*c]fz_context, [*c]fz_device) callconv(.c) void = null,
    render_flags: ?*const fn ([*c]fz_context, [*c]fz_device, set: c_int, clear: c_int) callconv(.c) void = null,
    set_default_colorspaces: ?*const fn ([*c]fz_context, [*c]fz_device, [*c]fz_default_colorspaces) callconv(.c) void = null,
    begin_layer: ?*const fn ([*c]fz_context, [*c]fz_device, layer_name: [*c]const u8) callconv(.c) void = null,
    end_layer: ?*const fn ([*c]fz_context, [*c]fz_device) callconv(.c) void = null,
    begin_structure: ?*const fn ([*c]fz_context, [*c]fz_device, standard: fz_structure, raw: [*c]const u8, uid: c_int) callconv(.c) void = null,
    end_structure: ?*const fn ([*c]fz_context, [*c]fz_device) callconv(.c) void = null,
    begin_metatext: ?*const fn ([*c]fz_context, [*c]fz_device, meta: fz_metatext, text: [*c]const u8) callconv(.c) void = null,
    end_metatext: ?*const fn ([*c]fz_context, [*c]fz_device) callconv(.c) void = null,
    d1_rect: fz_rect = @import("std").mem.zeroes(fz_rect),
    container_len: c_int = 0,
    container_cap: c_int = 0,
    container: [*c]fz_device_container_stack = null,
};
pub extern var fz_glyph_name_from_adobe_standard: [256][*c]const u8;
pub extern var fz_glyph_name_from_iso8859_7: [256][*c]const u8;
pub extern var fz_glyph_name_from_koi8u: [256][*c]const u8;
pub extern var fz_glyph_name_from_mac_expert: [256][*c]const u8;
pub extern var fz_glyph_name_from_mac_roman: [256][*c]const u8;
pub extern var fz_glyph_name_from_win_ansi: [256][*c]const u8;
pub extern var fz_glyph_name_from_windows_1252: [256][*c]const u8;
pub extern const fz_unicode_from_iso8859_1: [256]c_ushort;
pub extern const fz_unicode_from_iso8859_7: [256]c_ushort;
pub extern const fz_unicode_from_koi8u: [256]c_ushort;
pub extern const fz_unicode_from_pdf_doc_encoding: [256]c_ushort;
pub extern const fz_unicode_from_windows_1250: [256]c_ushort;
pub extern const fz_unicode_from_windows_1251: [256]c_ushort;
pub extern const fz_unicode_from_windows_1252: [256]c_ushort;
pub extern fn fz_iso8859_1_from_unicode(u: c_int) c_int;
pub extern fn fz_iso8859_7_from_unicode(u: c_int) c_int;
pub extern fn fz_koi8u_from_unicode(u: c_int) c_int;
pub extern fn fz_windows_1250_from_unicode(u: c_int) c_int;
pub extern fn fz_windows_1251_from_unicode(u: c_int) c_int;
pub extern fn fz_windows_1252_from_unicode(u: c_int) c_int;
pub extern fn fz_unicode_from_glyph_name(name: [*c]const u8) c_int;
pub extern fn fz_unicode_from_glyph_name_strict(name: [*c]const u8) c_int;
pub extern fn fz_duplicate_glyph_names_from_unicode(unicode: c_int) [*c][*c]const u8;
pub extern fn fz_glyph_name_from_unicode_sc(unicode: c_int) [*c]const u8;
pub const struct_fz_display_list_38 = opaque {};
pub const struct_fz_font = extern struct {
    refs: c_int = 0,
    name: [32]u8 = @import("std").mem.zeroes([32]u8),
    buffer: [*c]fz_buffer = null,
    flags: fz_font_flags_t = @import("std").mem.zeroes(fz_font_flags_t),
    ft_face: ?*anyopaque = null,
    shaper_data: fz_shaper_data_t = @import("std").mem.zeroes(fz_shaper_data_t),
    t3matrix: fz_matrix = @import("std").mem.zeroes(fz_matrix),
    t3resources: ?*anyopaque = null,
    t3procs: [*c][*c]fz_buffer = null,
    t3lists: [*c]?*struct_fz_display_list_38 = null,
    t3widths: [*c]f32 = null,
    t3flags: [*c]c_ushort = null,
    t3doc: ?*anyopaque = null,
    t3run: ?*const fn (ctx: [*c]fz_context, doc: ?*anyopaque, resources: ?*anyopaque, contents: [*c]fz_buffer, dev: [*c]struct_fz_device, ctm: fz_matrix, gstate: ?*anyopaque, default_cs: [*c]fz_default_colorspaces) callconv(.c) void = null,
    t3freeres: ?*const fn (ctx: [*c]fz_context, doc: ?*anyopaque, resources: ?*anyopaque) callconv(.c) void = null,
    bbox: fz_rect = @import("std").mem.zeroes(fz_rect),
    glyph_count: c_int = 0,
    bbox_table: [*c][*c]fz_rect = null,
    use_glyph_bbox: c_int = 0,
    width_count: c_int = 0,
    width_default: c_short = 0,
    width_table: [*c]c_short = null,
    advance_cache: [*c][*c]f32 = null,
    encoding_cache: [256][*c]u16 = @import("std").mem.zeroes([256][*c]u16),
    has_digest: c_int = 0,
    digest: [16]u8 = @import("std").mem.zeroes([16]u8),
    subfont: c_int = 0,
    pub const fz_font_flags = __root.fz_font_flags;
};
pub const fz_font = struct_fz_font;
pub extern fn fz_font_ft_face(ctx: [*c]fz_context, font: [*c]fz_font) ?*anyopaque;
pub extern fn fz_font_t3_procs(ctx: [*c]fz_context, font: [*c]fz_font) [*c][*c]fz_buffer;
pub const FZ_ADOBE_CNS: c_int = 0;
pub const FZ_ADOBE_GB: c_int = 1;
pub const FZ_ADOBE_JAPAN: c_int = 2;
pub const FZ_ADOBE_KOREA: c_int = 3;
const enum_unnamed_39 = c_uint; // /usr/include/mupdf/fitz/font.h:108:15: warning: struct demoted to opaque type - has bitfield
pub const fz_font_flags_t = opaque {};
pub extern fn fz_font_flags(font: [*c]fz_font) ?*fz_font_flags_t;
pub const fz_shaper_data_t = extern struct {
    shaper_handle: ?*anyopaque = null,
    destroy: ?*const fn (ctx: [*c]fz_context, ?*anyopaque) callconv(.c) void = null,
};
pub extern fn fz_font_shaper_data(ctx: [*c]fz_context, font: [*c]fz_font) [*c]fz_shaper_data_t;
pub extern fn fz_font_name(ctx: [*c]fz_context, font: [*c]fz_font) [*c]const u8;
pub extern fn fz_font_is_bold(ctx: [*c]fz_context, font: [*c]fz_font) c_int;
pub extern fn fz_font_is_italic(ctx: [*c]fz_context, font: [*c]fz_font) c_int;
pub extern fn fz_font_is_serif(ctx: [*c]fz_context, font: [*c]fz_font) c_int;
pub extern fn fz_font_is_monospaced(ctx: [*c]fz_context, font: [*c]fz_font) c_int;
pub extern fn fz_font_bbox(ctx: [*c]fz_context, font: [*c]fz_font) fz_rect;
pub const fz_load_system_font_fn = fn (ctx: [*c]fz_context, name: [*c]const u8, bold: c_int, italic: c_int, needs_exact_metrics: c_int) callconv(.c) [*c]fz_font;
pub const fz_load_system_cjk_font_fn = fn (ctx: [*c]fz_context, name: [*c]const u8, ordering: c_int, serif: c_int) callconv(.c) [*c]fz_font;
pub const fz_load_system_fallback_font_fn = fn (ctx: [*c]fz_context, script: c_int, language: c_int, serif: c_int, bold: c_int, italic: c_int) callconv(.c) [*c]fz_font;
pub extern fn fz_install_load_system_font_funcs(ctx: [*c]fz_context, f: ?*const fz_load_system_font_fn, f_cjk: ?*const fz_load_system_cjk_font_fn, f_fallback: ?*const fz_load_system_fallback_font_fn) void;
pub extern fn fz_load_system_font(ctx: [*c]fz_context, name: [*c]const u8, bold: c_int, italic: c_int, needs_exact_metrics: c_int) [*c]fz_font;
pub extern fn fz_load_system_cjk_font(ctx: [*c]fz_context, name: [*c]const u8, ordering: c_int, serif: c_int) [*c]fz_font;
pub extern fn fz_lookup_builtin_font(ctx: [*c]fz_context, name: [*c]const u8, bold: c_int, italic: c_int, len: [*c]c_int) [*c]const u8;
pub extern fn fz_lookup_base14_font(ctx: [*c]fz_context, name: [*c]const u8, len: [*c]c_int) [*c]const u8;
pub extern fn fz_lookup_cjk_font(ctx: [*c]fz_context, ordering: c_int, len: [*c]c_int, index: [*c]c_int) [*c]const u8;
pub extern fn fz_lookup_cjk_font_by_language(ctx: [*c]fz_context, lang: [*c]const u8, len: [*c]c_int, subfont: [*c]c_int) [*c]const u8;
pub extern fn fz_lookup_cjk_ordering_by_language(name: [*c]const u8) c_int;
pub extern fn fz_lookup_noto_font(ctx: [*c]fz_context, script: c_int, lang: c_int, len: [*c]c_int, subfont: [*c]c_int) [*c]const u8;
pub extern fn fz_lookup_noto_math_font(ctx: [*c]fz_context, len: [*c]c_int) [*c]const u8;
pub extern fn fz_lookup_noto_music_font(ctx: [*c]fz_context, len: [*c]c_int) [*c]const u8;
pub extern fn fz_lookup_noto_symbol1_font(ctx: [*c]fz_context, len: [*c]c_int) [*c]const u8;
pub extern fn fz_lookup_noto_symbol2_font(ctx: [*c]fz_context, len: [*c]c_int) [*c]const u8;
pub extern fn fz_lookup_noto_emoji_font(ctx: [*c]fz_context, len: [*c]c_int) [*c]const u8;
pub extern fn fz_lookup_noto_boxes_font(ctx: [*c]fz_context, len: [*c]c_int) [*c]const u8;
pub extern fn fz_load_fallback_font(ctx: [*c]fz_context, script: c_int, language: c_int, serif: c_int, bold: c_int, italic: c_int) [*c]fz_font;
pub extern fn fz_new_type3_font(ctx: [*c]fz_context, name: [*c]const u8, matrix: fz_matrix) [*c]fz_font;
pub extern fn fz_new_font_from_memory(ctx: [*c]fz_context, name: [*c]const u8, data: [*c]const u8, len: c_int, index: c_int, use_glyph_bbox: c_int) [*c]fz_font;
pub extern fn fz_new_font_from_buffer(ctx: [*c]fz_context, name: [*c]const u8, buffer: [*c]fz_buffer, index: c_int, use_glyph_bbox: c_int) [*c]fz_font;
pub extern fn fz_new_font_from_file(ctx: [*c]fz_context, name: [*c]const u8, path: [*c]const u8, index: c_int, use_glyph_bbox: c_int) [*c]fz_font;
pub extern fn fz_new_base14_font(ctx: [*c]fz_context, name: [*c]const u8) [*c]fz_font;
pub extern fn fz_new_cjk_font(ctx: [*c]fz_context, ordering: c_int) [*c]fz_font;
pub extern fn fz_new_builtin_font(ctx: [*c]fz_context, name: [*c]const u8, is_bold: c_int, is_italic: c_int) [*c]fz_font;
pub extern fn fz_set_font_embedding(ctx: [*c]fz_context, font: [*c]fz_font, embed: c_int) void;
pub extern fn fz_keep_font(ctx: [*c]fz_context, font: [*c]fz_font) [*c]fz_font;
pub extern fn fz_drop_font(ctx: [*c]fz_context, font: [*c]fz_font) void;
pub extern fn fz_set_font_bbox(ctx: [*c]fz_context, font: [*c]fz_font, xmin: f32, ymin: f32, xmax: f32, ymax: f32) void;
pub extern fn fz_bound_glyph(ctx: [*c]fz_context, font: [*c]fz_font, gid: c_int, trm: fz_matrix) fz_rect;
pub extern fn fz_glyph_cacheable(ctx: [*c]fz_context, font: [*c]fz_font, gid: c_int) c_int;
pub extern fn fz_run_t3_glyph(ctx: [*c]fz_context, font: [*c]fz_font, gid: c_int, trm: fz_matrix, dev: [*c]struct_fz_device) void;
pub extern fn fz_advance_glyph(ctx: [*c]fz_context, font: [*c]fz_font, glyph: c_int, wmode: c_int) f32;
pub extern fn fz_encode_character(ctx: [*c]fz_context, font: [*c]fz_font, unicode: c_int) c_int;
pub extern fn fz_encode_character_sc(ctx: [*c]fz_context, font: [*c]fz_font, unicode: c_int) c_int;
pub extern fn fz_encode_character_by_glyph_name(ctx: [*c]fz_context, font: [*c]fz_font, glyphname: [*c]const u8) c_int;
pub extern fn fz_encode_character_with_fallback(ctx: [*c]fz_context, font: [*c]fz_font, unicode: c_int, script: c_int, language: c_int, out_font: [*c][*c]fz_font) c_int;
pub extern fn fz_get_glyph_name(ctx: [*c]fz_context, font: [*c]fz_font, glyph: c_int, buf: [*c]u8, size: c_int) void;
pub extern fn fz_font_ascender(ctx: [*c]fz_context, font: [*c]fz_font) f32;
pub extern fn fz_font_descender(ctx: [*c]fz_context, font: [*c]fz_font) f32;
pub extern fn fz_font_digest(ctx: [*c]fz_context, font: [*c]fz_font, digest: [*c]u8) void;
pub extern fn fz_decouple_type3_font(ctx: [*c]fz_context, font: [*c]fz_font, t3doc: ?*anyopaque) void;
pub extern fn ft_error_string(err: c_int) [*c]const u8;
pub extern fn ft_char_index(face: ?*anyopaque, cid: c_int) c_int;
pub extern fn ft_name_index(face: ?*anyopaque, name: [*c]const u8) c_int;
pub extern fn fz_hb_lock(ctx: [*c]fz_context) void;
pub extern fn fz_hb_unlock(ctx: [*c]fz_context) void;
pub const FZ_LINECAP_BUTT: c_int = 0;
pub const FZ_LINECAP_ROUND: c_int = 1;
pub const FZ_LINECAP_SQUARE: c_int = 2;
pub const FZ_LINECAP_TRIANGLE: c_int = 3;
pub const fz_linecap = c_uint;
pub const FZ_LINEJOIN_MITER: c_int = 0;
pub const FZ_LINEJOIN_ROUND: c_int = 1;
pub const FZ_LINEJOIN_BEVEL: c_int = 2;
pub const FZ_LINEJOIN_MITER_XPS: c_int = 3;
pub const fz_linejoin = c_uint;
pub const fz_stroke_state = extern struct {
    refs: c_int = 0,
    start_cap: fz_linecap = @import("std").mem.zeroes(fz_linecap),
    dash_cap: fz_linecap = @import("std").mem.zeroes(fz_linecap),
    end_cap: fz_linecap = @import("std").mem.zeroes(fz_linecap),
    linejoin: fz_linejoin = @import("std").mem.zeroes(fz_linejoin),
    linewidth: f32 = 0,
    miterlimit: f32 = 0,
    dash_phase: f32 = 0,
    dash_len: c_int = 0,
    dash_list: [32]f32 = @import("std").mem.zeroes([32]f32),
};
pub const fz_path_walker = extern struct {
    moveto: ?*const fn (ctx: [*c]fz_context, arg: ?*anyopaque, x: f32, y: f32) callconv(.c) void = null,
    lineto: ?*const fn (ctx: [*c]fz_context, arg: ?*anyopaque, x: f32, y: f32) callconv(.c) void = null,
    curveto: ?*const fn (ctx: [*c]fz_context, arg: ?*anyopaque, x1: f32, y1: f32, x2: f32, y2: f32, x3: f32, y3: f32) callconv(.c) void = null,
    closepath: ?*const fn (ctx: [*c]fz_context, arg: ?*anyopaque) callconv(.c) void = null,
    quadto: ?*const fn (ctx: [*c]fz_context, arg: ?*anyopaque, x1: f32, y1: f32, x2: f32, y2: f32) callconv(.c) void = null,
    curvetov: ?*const fn (ctx: [*c]fz_context, arg: ?*anyopaque, x2: f32, y2: f32, x3: f32, y3: f32) callconv(.c) void = null,
    curvetoy: ?*const fn (ctx: [*c]fz_context, arg: ?*anyopaque, x1: f32, y1: f32, x3: f32, y3: f32) callconv(.c) void = null,
    rectto: ?*const fn (ctx: [*c]fz_context, arg: ?*anyopaque, x1: f32, y1: f32, x2: f32, y2: f32) callconv(.c) void = null,
};
pub extern fn fz_walk_path(ctx: [*c]fz_context, path: ?*const fz_path, walker: [*c]const fz_path_walker, arg: ?*anyopaque) void;
pub extern fn fz_new_path(ctx: [*c]fz_context) ?*fz_path;
pub extern fn fz_keep_path(ctx: [*c]fz_context, path: ?*const fz_path) ?*fz_path;
pub extern fn fz_drop_path(ctx: [*c]fz_context, path: ?*const fz_path) void;
pub extern fn fz_trim_path(ctx: [*c]fz_context, path: ?*fz_path) void;
pub extern fn fz_packed_path_size(path: ?*const fz_path) c_int;
pub extern fn fz_pack_path(ctx: [*c]fz_context, pack: [*c]u8, path: ?*const fz_path) usize;
pub extern fn fz_clone_path(ctx: [*c]fz_context, path: ?*fz_path) ?*fz_path;
pub extern fn fz_currentpoint(ctx: [*c]fz_context, path: ?*fz_path) fz_point;
pub extern fn fz_moveto(ctx: [*c]fz_context, path: ?*fz_path, x: f32, y: f32) void;
pub extern fn fz_lineto(ctx: [*c]fz_context, path: ?*fz_path, x: f32, y: f32) void;
pub extern fn fz_rectto(ctx: [*c]fz_context, path: ?*fz_path, x0: f32, y0: f32, x1: f32, y1: f32) void;
pub extern fn fz_quadto(ctx: [*c]fz_context, path: ?*fz_path, x0: f32, y0: f32, x1: f32, y1: f32) void;
pub extern fn fz_curveto(ctx: [*c]fz_context, path: ?*fz_path, x0: f32, y0: f32, x1: f32, y1: f32, x2: f32, y2: f32) void;
pub extern fn fz_curvetov(ctx: [*c]fz_context, path: ?*fz_path, x1: f32, y1: f32, x2: f32, y2: f32) void;
pub extern fn fz_curvetoy(ctx: [*c]fz_context, path: ?*fz_path, x0: f32, y0: f32, x2: f32, y2: f32) void;
pub extern fn fz_closepath(ctx: [*c]fz_context, path: ?*fz_path) void;
pub extern fn fz_transform_path(ctx: [*c]fz_context, path: ?*fz_path, transform: fz_matrix) void;
pub extern fn fz_bound_path(ctx: [*c]fz_context, path: ?*const fz_path, stroke: [*c]const fz_stroke_state, ctm: fz_matrix) fz_rect;
pub extern fn fz_adjust_rect_for_stroke(ctx: [*c]fz_context, rect: fz_rect, stroke: [*c]const fz_stroke_state, ctm: fz_matrix) fz_rect;
pub extern const fz_default_stroke_state: fz_stroke_state;
pub extern fn fz_new_stroke_state(ctx: [*c]fz_context) [*c]fz_stroke_state;
pub extern fn fz_new_stroke_state_with_dash_len(ctx: [*c]fz_context, len: c_int) [*c]fz_stroke_state;
pub extern fn fz_keep_stroke_state(ctx: [*c]fz_context, stroke: [*c]const fz_stroke_state) [*c]fz_stroke_state;
pub extern fn fz_drop_stroke_state(ctx: [*c]fz_context, stroke: [*c]const fz_stroke_state) void;
pub extern fn fz_unshare_stroke_state(ctx: [*c]fz_context, shared: [*c]fz_stroke_state) [*c]fz_stroke_state;
pub extern fn fz_unshare_stroke_state_with_dash_len(ctx: [*c]fz_context, shared: [*c]fz_stroke_state, len: c_int) [*c]fz_stroke_state;
pub extern fn fz_clone_stroke_state(ctx: [*c]fz_context, stroke: [*c]fz_stroke_state) [*c]fz_stroke_state;
pub const fz_text_item = extern struct {
    x: f32 = 0,
    y: f32 = 0,
    gid: c_int = 0,
    ucs: c_int = 0,
    cid: c_int = 0,
};
pub const FZ_LANG_UNSET: c_int = 0;
pub const FZ_LANG_ur: c_int = 507;
pub const FZ_LANG_urd: c_int = 3423;
pub const FZ_LANG_ko: c_int = 416;
pub const FZ_LANG_ja: c_int = 37;
pub const FZ_LANG_zh: c_int = 242;
pub const FZ_LANG_zh_Hans: c_int = 14093;
pub const FZ_LANG_zh_Hant: c_int = 14822;
pub const fz_text_language = c_uint; // /usr/include/mupdf/fitz/text.h:71:11: warning: struct demoted to opaque type - has bitfield
pub const struct_fz_text_span = opaque {};
pub const fz_text_span = struct_fz_text_span;
pub const fz_text = extern struct {
    refs: c_int = 0,
    head: ?*fz_text_span = null,
    tail: ?*fz_text_span = null,
};
pub extern fn fz_new_text(ctx: [*c]fz_context) [*c]fz_text;
pub extern fn fz_keep_text(ctx: [*c]fz_context, text: [*c]const fz_text) [*c]fz_text;
pub extern fn fz_drop_text(ctx: [*c]fz_context, text: [*c]const fz_text) void;
pub extern fn fz_show_glyph(ctx: [*c]fz_context, text: [*c]fz_text, font: [*c]fz_font, trm: fz_matrix, glyph: c_int, unicode: c_int, wmode: c_int, bidi_level: c_int, markup_dir: fz_bidi_direction, language: fz_text_language) void;
pub extern fn fz_show_glyph_aux(ctx: [*c]fz_context, text: [*c]fz_text, font: [*c]fz_font, trm: fz_matrix, glyph: c_int, unicode: c_int, cid: c_int, wmode: c_int, bidi_level: c_int, markup_dir: fz_bidi_direction, lang: fz_text_language) void;
pub extern fn fz_show_string(ctx: [*c]fz_context, text: [*c]fz_text, font: [*c]fz_font, trm: fz_matrix, s: [*c]const u8, wmode: c_int, bidi_level: c_int, markup_dir: fz_bidi_direction, language: fz_text_language) fz_matrix;
pub extern fn fz_measure_string(ctx: [*c]fz_context, user_font: [*c]fz_font, trm: fz_matrix, s: [*c]const u8, wmode: c_int, bidi_level: c_int, markup_dir: fz_bidi_direction, language: fz_text_language) fz_matrix;
pub extern fn fz_bound_text(ctx: [*c]fz_context, text: [*c]const fz_text, stroke: [*c]const fz_stroke_state, ctm: fz_matrix) fz_rect;
pub extern fn fz_text_language_from_string(str: [*c]const u8) fz_text_language;
pub extern fn fz_string_from_text_language(str: [*c]u8, lang: fz_text_language) [*c]u8;
pub const struct_fz_glyph = opaque {
    pub const fz_glyph_bbox_no_ctx = __root.fz_glyph_bbox_no_ctx;
    pub const bbox_no_ctx = __root.fz_glyph_bbox_no_ctx;
};
pub const fz_glyph = struct_fz_glyph;
pub extern fn fz_glyph_bbox(ctx: [*c]fz_context, glyph: ?*fz_glyph) fz_irect;
pub extern fn fz_glyph_bbox_no_ctx(src: ?*fz_glyph) fz_irect;
pub extern fn fz_glyph_width(ctx: [*c]fz_context, glyph: ?*fz_glyph) c_int;
pub extern fn fz_glyph_height(ctx: [*c]fz_context, glyph: ?*fz_glyph) c_int;
pub extern fn fz_keep_glyph(ctx: [*c]fz_context, pix: ?*fz_glyph) ?*fz_glyph;
pub extern fn fz_drop_glyph(ctx: [*c]fz_context, pix: ?*fz_glyph) void;
pub extern fn fz_outline_glyph(ctx: [*c]fz_context, font: [*c]fz_font, gid: c_int, ctm: fz_matrix) ?*fz_path;
pub const FZ_DEVFLAG_MASK: c_int = 1;
pub const FZ_DEVFLAG_COLOR: c_int = 2;
pub const FZ_DEVFLAG_UNCACHEABLE: c_int = 4;
pub const FZ_DEVFLAG_FILLCOLOR_UNDEFINED: c_int = 8;
pub const FZ_DEVFLAG_STROKECOLOR_UNDEFINED: c_int = 16;
pub const FZ_DEVFLAG_STARTCAP_UNDEFINED: c_int = 32;
pub const FZ_DEVFLAG_DASHCAP_UNDEFINED: c_int = 64;
pub const FZ_DEVFLAG_ENDCAP_UNDEFINED: c_int = 128;
pub const FZ_DEVFLAG_LINEJOIN_UNDEFINED: c_int = 256;
pub const FZ_DEVFLAG_MITERLIMIT_UNDEFINED: c_int = 512;
pub const FZ_DEVFLAG_LINEWIDTH_UNDEFINED: c_int = 1024;
pub const FZ_DEVFLAG_BBOX_DEFINED: c_int = 2048;
pub const FZ_DEVFLAG_GRIDFIT_AS_TILED: c_int = 4096;
const enum_unnamed_40 = c_uint;
pub const FZ_BLEND_NORMAL: c_int = 0;
pub const FZ_BLEND_MULTIPLY: c_int = 1;
pub const FZ_BLEND_SCREEN: c_int = 2;
pub const FZ_BLEND_OVERLAY: c_int = 3;
pub const FZ_BLEND_DARKEN: c_int = 4;
pub const FZ_BLEND_LIGHTEN: c_int = 5;
pub const FZ_BLEND_COLOR_DODGE: c_int = 6;
pub const FZ_BLEND_COLOR_BURN: c_int = 7;
pub const FZ_BLEND_HARD_LIGHT: c_int = 8;
pub const FZ_BLEND_SOFT_LIGHT: c_int = 9;
pub const FZ_BLEND_DIFFERENCE: c_int = 10;
pub const FZ_BLEND_EXCLUSION: c_int = 11;
pub const FZ_BLEND_HUE: c_int = 12;
pub const FZ_BLEND_SATURATION: c_int = 13;
pub const FZ_BLEND_COLOR: c_int = 14;
pub const FZ_BLEND_LUMINOSITY: c_int = 15;
pub const FZ_BLEND_MODEMASK: c_int = 15;
pub const FZ_BLEND_ISOLATED: c_int = 16;
pub const FZ_BLEND_KNOCKOUT: c_int = 32;
const enum_unnamed_41 = c_uint;
pub extern fn fz_lookup_blendmode(name: [*c]const u8) c_int;
pub extern fn fz_blendmode_name(blendmode: c_int) [*c]const u8;
pub const fz_device_container_stack = extern struct {
    scissor: fz_rect = @import("std").mem.zeroes(fz_rect),
    type: c_int = 0,
    user: c_int = 0,
};
pub const fz_device_container_stack_is_clip: c_int = 0;
pub const fz_device_container_stack_is_mask: c_int = 1;
pub const fz_device_container_stack_is_group: c_int = 2;
pub const fz_device_container_stack_is_tile: c_int = 3;
const enum_unnamed_42 = c_uint;
pub const FZ_STRUCTURE_INVALID: c_int = -1;
pub const FZ_STRUCTURE_DOCUMENT: c_int = 0;
pub const FZ_STRUCTURE_PART: c_int = 1;
pub const FZ_STRUCTURE_ART: c_int = 2;
pub const FZ_STRUCTURE_SECT: c_int = 3;
pub const FZ_STRUCTURE_DIV: c_int = 4;
pub const FZ_STRUCTURE_BLOCKQUOTE: c_int = 5;
pub const FZ_STRUCTURE_CAPTION: c_int = 6;
pub const FZ_STRUCTURE_TOC: c_int = 7;
pub const FZ_STRUCTURE_TOCI: c_int = 8;
pub const FZ_STRUCTURE_INDEX: c_int = 9;
pub const FZ_STRUCTURE_NONSTRUCT: c_int = 10;
pub const FZ_STRUCTURE_PRIVATE: c_int = 11;
pub const FZ_STRUCTURE_DOCUMENTFRAGMENT: c_int = 12;
pub const FZ_STRUCTURE_ASIDE: c_int = 13;
pub const FZ_STRUCTURE_TITLE: c_int = 14;
pub const FZ_STRUCTURE_FENOTE: c_int = 15;
pub const FZ_STRUCTURE_SUB: c_int = 16;
pub const FZ_STRUCTURE_P: c_int = 17;
pub const FZ_STRUCTURE_H: c_int = 18;
pub const FZ_STRUCTURE_H1: c_int = 19;
pub const FZ_STRUCTURE_H2: c_int = 20;
pub const FZ_STRUCTURE_H3: c_int = 21;
pub const FZ_STRUCTURE_H4: c_int = 22;
pub const FZ_STRUCTURE_H5: c_int = 23;
pub const FZ_STRUCTURE_H6: c_int = 24;
pub const FZ_STRUCTURE_LIST: c_int = 25;
pub const FZ_STRUCTURE_LISTITEM: c_int = 26;
pub const FZ_STRUCTURE_LABEL: c_int = 27;
pub const FZ_STRUCTURE_LISTBODY: c_int = 28;
pub const FZ_STRUCTURE_TABLE: c_int = 29;
pub const FZ_STRUCTURE_TR: c_int = 30;
pub const FZ_STRUCTURE_TH: c_int = 31;
pub const FZ_STRUCTURE_TD: c_int = 32;
pub const FZ_STRUCTURE_THEAD: c_int = 33;
pub const FZ_STRUCTURE_TBODY: c_int = 34;
pub const FZ_STRUCTURE_TFOOT: c_int = 35;
pub const FZ_STRUCTURE_SPAN: c_int = 36;
pub const FZ_STRUCTURE_QUOTE: c_int = 37;
pub const FZ_STRUCTURE_NOTE: c_int = 38;
pub const FZ_STRUCTURE_REFERENCE: c_int = 39;
pub const FZ_STRUCTURE_BIBENTRY: c_int = 40;
pub const FZ_STRUCTURE_CODE: c_int = 41;
pub const FZ_STRUCTURE_LINK: c_int = 42;
pub const FZ_STRUCTURE_ANNOT: c_int = 43;
pub const FZ_STRUCTURE_EM: c_int = 44;
pub const FZ_STRUCTURE_STRONG: c_int = 45;
pub const FZ_STRUCTURE_RUBY: c_int = 46;
pub const FZ_STRUCTURE_RB: c_int = 47;
pub const FZ_STRUCTURE_RT: c_int = 48;
pub const FZ_STRUCTURE_RP: c_int = 49;
pub const FZ_STRUCTURE_WARICHU: c_int = 50;
pub const FZ_STRUCTURE_WT: c_int = 51;
pub const FZ_STRUCTURE_WP: c_int = 52;
pub const FZ_STRUCTURE_FIGURE: c_int = 53;
pub const FZ_STRUCTURE_FORMULA: c_int = 54;
pub const FZ_STRUCTURE_FORM: c_int = 55;
pub const FZ_STRUCTURE_ARTIFACT: c_int = 56;
pub const fz_structure = c_int;
pub extern fn fz_structure_to_string(@"type": fz_structure) [*c]const u8;
pub extern fn fz_structure_from_string(str: [*c]const u8) fz_structure;
pub const FZ_METATEXT_ACTUALTEXT: c_int = 0;
pub const FZ_METATEXT_ALT: c_int = 1;
pub const FZ_METATEXT_ABBREVIATION: c_int = 2;
pub const FZ_METATEXT_TITLE: c_int = 3;
pub const fz_metatext = c_uint;
pub extern fn fz_fill_path(ctx: [*c]fz_context, dev: [*c]fz_device, path: ?*const fz_path, even_odd: c_int, ctm: fz_matrix, colorspace: [*c]fz_colorspace, color: [*c]const f32, alpha: f32, color_params: fz_color_params) void;
pub extern fn fz_stroke_path(ctx: [*c]fz_context, dev: [*c]fz_device, path: ?*const fz_path, stroke: [*c]const fz_stroke_state, ctm: fz_matrix, colorspace: [*c]fz_colorspace, color: [*c]const f32, alpha: f32, color_params: fz_color_params) void;
pub extern fn fz_clip_path(ctx: [*c]fz_context, dev: [*c]fz_device, path: ?*const fz_path, even_odd: c_int, ctm: fz_matrix, scissor: fz_rect) void;
pub extern fn fz_clip_stroke_path(ctx: [*c]fz_context, dev: [*c]fz_device, path: ?*const fz_path, stroke: [*c]const fz_stroke_state, ctm: fz_matrix, scissor: fz_rect) void;
pub extern fn fz_fill_text(ctx: [*c]fz_context, dev: [*c]fz_device, text: [*c]const fz_text, ctm: fz_matrix, colorspace: [*c]fz_colorspace, color: [*c]const f32, alpha: f32, color_params: fz_color_params) void;
pub extern fn fz_stroke_text(ctx: [*c]fz_context, dev: [*c]fz_device, text: [*c]const fz_text, stroke: [*c]const fz_stroke_state, ctm: fz_matrix, colorspace: [*c]fz_colorspace, color: [*c]const f32, alpha: f32, color_params: fz_color_params) void;
pub extern fn fz_clip_text(ctx: [*c]fz_context, dev: [*c]fz_device, text: [*c]const fz_text, ctm: fz_matrix, scissor: fz_rect) void;
pub extern fn fz_clip_stroke_text(ctx: [*c]fz_context, dev: [*c]fz_device, text: [*c]const fz_text, stroke: [*c]const fz_stroke_state, ctm: fz_matrix, scissor: fz_rect) void;
pub extern fn fz_ignore_text(ctx: [*c]fz_context, dev: [*c]fz_device, text: [*c]const fz_text, ctm: fz_matrix) void;
pub extern fn fz_pop_clip(ctx: [*c]fz_context, dev: [*c]fz_device) void;
pub extern fn fz_fill_shade(ctx: [*c]fz_context, dev: [*c]fz_device, shade: [*c]fz_shade, ctm: fz_matrix, alpha: f32, color_params: fz_color_params) void;
pub extern fn fz_fill_image(ctx: [*c]fz_context, dev: [*c]fz_device, image: ?*fz_image, ctm: fz_matrix, alpha: f32, color_params: fz_color_params) void;
pub extern fn fz_fill_image_mask(ctx: [*c]fz_context, dev: [*c]fz_device, image: ?*fz_image, ctm: fz_matrix, colorspace: [*c]fz_colorspace, color: [*c]const f32, alpha: f32, color_params: fz_color_params) void;
pub extern fn fz_clip_image_mask(ctx: [*c]fz_context, dev: [*c]fz_device, image: ?*fz_image, ctm: fz_matrix, scissor: fz_rect) void;
pub extern fn fz_begin_mask(ctx: [*c]fz_context, dev: [*c]fz_device, area: fz_rect, luminosity: c_int, colorspace: [*c]fz_colorspace, bc: [*c]const f32, color_params: fz_color_params) void;
pub extern fn fz_end_mask(ctx: [*c]fz_context, dev: [*c]fz_device) void;
pub extern fn fz_begin_group(ctx: [*c]fz_context, dev: [*c]fz_device, area: fz_rect, cs: [*c]fz_colorspace, isolated: c_int, knockout: c_int, blendmode: c_int, alpha: f32) void;
pub extern fn fz_end_group(ctx: [*c]fz_context, dev: [*c]fz_device) void;
pub extern fn fz_begin_tile(ctx: [*c]fz_context, dev: [*c]fz_device, area: fz_rect, view: fz_rect, xstep: f32, ystep: f32, ctm: fz_matrix) void;
pub extern fn fz_begin_tile_id(ctx: [*c]fz_context, dev: [*c]fz_device, area: fz_rect, view: fz_rect, xstep: f32, ystep: f32, ctm: fz_matrix, id: c_int) c_int;
pub extern fn fz_end_tile(ctx: [*c]fz_context, dev: [*c]fz_device) void;
pub extern fn fz_render_flags(ctx: [*c]fz_context, dev: [*c]fz_device, set: c_int, clear: c_int) void;
pub extern fn fz_set_default_colorspaces(ctx: [*c]fz_context, dev: [*c]fz_device, default_cs: [*c]fz_default_colorspaces) void;
pub extern fn fz_begin_layer(ctx: [*c]fz_context, dev: [*c]fz_device, layer_name: [*c]const u8) void;
pub extern fn fz_end_layer(ctx: [*c]fz_context, dev: [*c]fz_device) void;
pub extern fn fz_begin_structure(ctx: [*c]fz_context, dev: [*c]fz_device, standard: fz_structure, raw: [*c]const u8, uid: c_int) void;
pub extern fn fz_end_structure(ctx: [*c]fz_context, dev: [*c]fz_device) void;
pub extern fn fz_begin_metatext(ctx: [*c]fz_context, dev: [*c]fz_device, meta: fz_metatext, text: [*c]const u8) void;
pub extern fn fz_end_metatext(ctx: [*c]fz_context, dev: [*c]fz_device) void;
pub extern fn fz_new_device_of_size(ctx: [*c]fz_context, size: c_int) [*c]fz_device;
pub extern fn fz_close_device(ctx: [*c]fz_context, dev: [*c]fz_device) void;
pub extern fn fz_drop_device(ctx: [*c]fz_context, dev: [*c]fz_device) void;
pub extern fn fz_keep_device(ctx: [*c]fz_context, dev: [*c]fz_device) [*c]fz_device;
pub extern fn fz_enable_device_hints(ctx: [*c]fz_context, dev: [*c]fz_device, hints: c_int) void;
pub extern fn fz_disable_device_hints(ctx: [*c]fz_context, dev: [*c]fz_device, hints: c_int) void;
pub extern fn fz_device_current_scissor(ctx: [*c]fz_context, dev: [*c]fz_device) fz_rect;
pub const FZ_DONT_INTERPOLATE_IMAGES: c_int = 1;
pub const FZ_NO_CACHE: c_int = 2;
const enum_unnamed_43 = c_uint;
pub const fz_cookie = extern struct {
    abort: c_int = 0,
    progress: c_int = 0,
    progress_max: usize = 0,
    errors: c_int = 0,
    incomplete: c_int = 0,
};
pub extern fn fz_new_trace_device(ctx: [*c]fz_context, out: [*c]fz_output) [*c]fz_device;
pub extern fn fz_new_xmltext_device(ctx: [*c]fz_context, out: [*c]fz_output) [*c]fz_device;
pub extern fn fz_new_bbox_device(ctx: [*c]fz_context, rectp: [*c]fz_rect) [*c]fz_device;
pub extern fn fz_new_test_device(ctx: [*c]fz_context, is_color: [*c]c_int, threshold: f32, options: c_int, passthrough: [*c]fz_device) [*c]fz_device;
pub const FZ_TEST_OPT_IMAGES: c_int = 1;
pub const FZ_TEST_OPT_SHADINGS: c_int = 2;
const enum_unnamed_44 = c_uint;
pub extern fn fz_new_draw_device(ctx: [*c]fz_context, transform: fz_matrix, dest: [*c]fz_pixmap) [*c]fz_device;
pub extern fn fz_new_draw_device_with_bbox(ctx: [*c]fz_context, transform: fz_matrix, dest: [*c]fz_pixmap, clip: [*c]const fz_irect) [*c]fz_device;
pub extern fn fz_new_draw_device_with_proof(ctx: [*c]fz_context, transform: fz_matrix, dest: [*c]fz_pixmap, proof_cs: [*c]fz_colorspace) [*c]fz_device;
pub extern fn fz_new_draw_device_with_bbox_proof(ctx: [*c]fz_context, transform: fz_matrix, dest: [*c]fz_pixmap, clip: [*c]const fz_irect, cs: [*c]fz_colorspace) [*c]fz_device;
pub extern fn fz_new_draw_device_type3(ctx: [*c]fz_context, transform: fz_matrix, dest: [*c]fz_pixmap) [*c]fz_device;
pub const fz_draw_options = extern struct {
    rotate: c_int = 0,
    x_resolution: c_int = 0,
    y_resolution: c_int = 0,
    width: c_int = 0,
    height: c_int = 0,
    colorspace: [*c]fz_colorspace = null,
    alpha: c_int = 0,
    graphics: c_int = 0,
    text: c_int = 0,
};
pub extern var fz_draw_options_usage: [*c]const u8;
pub extern fn fz_parse_draw_options(ctx: [*c]fz_context, options: [*c]fz_draw_options, string: [*c]const u8) [*c]fz_draw_options;
pub extern fn fz_new_draw_device_with_options(ctx: [*c]fz_context, options: [*c]const fz_draw_options, mediabox: fz_rect, pixmap: [*c][*c]fz_pixmap) [*c]fz_device;
pub const fz_display_list = struct_fz_display_list_38;
pub extern fn fz_new_display_list(ctx: [*c]fz_context, mediabox: fz_rect) ?*fz_display_list;
pub extern fn fz_new_list_device(ctx: [*c]fz_context, list: ?*fz_display_list) [*c]fz_device;
pub extern fn fz_run_display_list(ctx: [*c]fz_context, list: ?*fz_display_list, dev: [*c]fz_device, ctm: fz_matrix, scissor: fz_rect, cookie: [*c]fz_cookie) void;
pub extern fn fz_keep_display_list(ctx: [*c]fz_context, list: ?*fz_display_list) ?*fz_display_list;
pub extern fn fz_drop_display_list(ctx: [*c]fz_context, list: ?*fz_display_list) void;
pub extern fn fz_bound_display_list(ctx: [*c]fz_context, list: ?*fz_display_list) fz_rect;
pub extern fn fz_new_image_from_display_list(ctx: [*c]fz_context, w: f32, h: f32, list: ?*fz_display_list) ?*fz_image;
pub extern fn fz_display_list_is_empty(ctx: [*c]fz_context, list: ?*const fz_display_list) c_int;
pub const fz_document = struct_fz_document;
pub const fz_document_drop_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document) callconv(.c) void;
pub const fz_document_needs_password_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document) callconv(.c) c_int;
pub const fz_document_authenticate_password_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document, password: [*c]const u8) callconv(.c) c_int;
pub const fz_document_has_permission_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document, permission: fz_permission) callconv(.c) c_int;
pub const struct_fz_outline = extern struct {
    refs: c_int = 0,
    title: [*c]u8 = null,
    uri: [*c]u8 = null,
    page: fz_location = @import("std").mem.zeroes(fz_location),
    x: f32 = 0,
    y: f32 = 0,
    next: [*c]struct_fz_outline = null,
    down: [*c]struct_fz_outline = null,
    is_open: c_int = 0,
};
pub const fz_outline = struct_fz_outline;
pub const fz_document_load_outline_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document) callconv(.c) [*c]fz_outline;
pub const fz_outline_iterator_drop_fn = fn (ctx: [*c]fz_context, iter: [*c]fz_outline_iterator) callconv(.c) void;
pub const fz_outline_iterator_item_fn = fn (ctx: [*c]fz_context, iter: [*c]fz_outline_iterator) callconv(.c) [*c]fz_outline_item;
pub const fz_outline_iterator_next_fn = fn (ctx: [*c]fz_context, iter: [*c]fz_outline_iterator) callconv(.c) c_int;
pub const fz_outline_iterator_prev_fn = fn (ctx: [*c]fz_context, iter: [*c]fz_outline_iterator) callconv(.c) c_int;
pub const fz_outline_iterator_up_fn = fn (ctx: [*c]fz_context, iter: [*c]fz_outline_iterator) callconv(.c) c_int;
pub const fz_outline_iterator_down_fn = fn (ctx: [*c]fz_context, iter: [*c]fz_outline_iterator) callconv(.c) c_int;
pub const fz_outline_iterator_insert_fn = fn (ctx: [*c]fz_context, iter: [*c]fz_outline_iterator, item: [*c]fz_outline_item) callconv(.c) c_int;
pub const fz_outline_iterator_update_fn = fn (ctx: [*c]fz_context, iter: [*c]fz_outline_iterator, item: [*c]fz_outline_item) callconv(.c) void;
pub const fz_outline_iterator_delete_fn = fn (ctx: [*c]fz_context, iter: [*c]fz_outline_iterator) callconv(.c) c_int;
pub const struct_fz_outline_iterator = extern struct {
    drop: ?*const fz_outline_iterator_drop_fn = null,
    item: ?*const fz_outline_iterator_item_fn = null,
    next: ?*const fz_outline_iterator_next_fn = null,
    prev: ?*const fz_outline_iterator_prev_fn = null,
    up: ?*const fz_outline_iterator_up_fn = null,
    down: ?*const fz_outline_iterator_down_fn = null,
    insert: ?*const fz_outline_iterator_insert_fn = null,
    update: ?*const fz_outline_iterator_update_fn = null,
    del: ?*const fz_outline_iterator_delete_fn = null,
    doc: [*c]fz_document = null,
};
pub const fz_outline_iterator = struct_fz_outline_iterator;
pub const fz_document_outline_iterator_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document) callconv(.c) [*c]fz_outline_iterator;
pub const fz_document_layout_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document, w: f32, h: f32, em: f32) callconv(.c) void;
pub const fz_bookmark = isize;
pub const fz_document_make_bookmark_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document, loc: fz_location) callconv(.c) fz_bookmark;
pub const fz_document_lookup_bookmark_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document, mark: fz_bookmark) callconv(.c) fz_location;
pub const fz_document_resolve_link_dest_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document, uri: [*c]const u8) callconv(.c) fz_link_dest;
pub const fz_document_format_link_uri_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document, dest: fz_link_dest) callconv(.c) [*c]u8;
pub const fz_document_count_chapters_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document) callconv(.c) c_int;
pub const fz_document_count_pages_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document, chapter: c_int) callconv(.c) c_int;
pub const fz_page_drop_page_fn = fn (ctx: [*c]fz_context, page: [*c]fz_page) callconv(.c) void;
pub const fz_page_bound_page_fn = fn (ctx: [*c]fz_context, page: [*c]fz_page, box: fz_box_type) callconv(.c) fz_rect;
pub const fz_page_run_page_fn = fn (ctx: [*c]fz_context, page: [*c]fz_page, dev: [*c]fz_device, transform: fz_matrix, cookie: [*c]fz_cookie) callconv(.c) void;
pub const fz_link = struct_fz_link;
pub const fz_link_set_rect_fn = fn (ctx: [*c]fz_context, link: [*c]fz_link, rect: fz_rect) callconv(.c) void;
pub const fz_link_set_uri_fn = fn (ctx: [*c]fz_context, link: [*c]fz_link, uri: [*c]const u8) callconv(.c) void;
pub const fz_link_drop_link_fn = fn (ctx: [*c]fz_context, link: [*c]fz_link) callconv(.c) void;
pub const struct_fz_link = extern struct {
    refs: c_int = 0,
    next: [*c]struct_fz_link = null,
    rect: fz_rect = @import("std").mem.zeroes(fz_rect),
    uri: [*c]u8 = null,
    set_rect_fn: ?*const fz_link_set_rect_fn = null,
    set_uri_fn: ?*const fz_link_set_uri_fn = null,
    drop: ?*const fz_link_drop_link_fn = null,
};
pub const fz_page_load_links_fn = fn (ctx: [*c]fz_context, page: [*c]fz_page) callconv(.c) [*c]fz_link;
pub const fz_page_page_presentation_fn = fn (ctx: [*c]fz_context, page: [*c]fz_page, transition: [*c]fz_transition, duration: [*c]f32) callconv(.c) [*c]fz_transition;
pub const fz_page_control_separation_fn = fn (ctx: [*c]fz_context, page: [*c]fz_page, separation: c_int, disable: c_int) callconv(.c) void;
pub const fz_page_separation_disabled_fn = fn (ctx: [*c]fz_context, page: [*c]fz_page, separation: c_int) callconv(.c) c_int;
pub const fz_page_separations_fn = fn (ctx: [*c]fz_context, page: [*c]fz_page) callconv(.c) ?*fz_separations;
pub const fz_page_uses_overprint_fn = fn (ctx: [*c]fz_context, page: [*c]fz_page) callconv(.c) c_int;
pub const fz_page_create_link_fn = fn (ctx: [*c]fz_context, page: [*c]fz_page, bbox: fz_rect, uri: [*c]const u8) callconv(.c) [*c]fz_link;
pub const fz_page_delete_link_fn = fn (ctx: [*c]fz_context, page: [*c]fz_page, link: [*c]fz_link) callconv(.c) void;
pub const struct_fz_page = extern struct {
    refs: c_int = 0,
    doc: [*c]fz_document = null,
    chapter: c_int = 0,
    number: c_int = 0,
    incomplete: c_int = 0,
    drop_page: ?*const fz_page_drop_page_fn = null,
    bound_page: ?*const fz_page_bound_page_fn = null,
    run_page_contents: ?*const fz_page_run_page_fn = null,
    run_page_annots: ?*const fz_page_run_page_fn = null,
    run_page_widgets: ?*const fz_page_run_page_fn = null,
    load_links: ?*const fz_page_load_links_fn = null,
    page_presentation: ?*const fz_page_page_presentation_fn = null,
    control_separation: ?*const fz_page_control_separation_fn = null,
    separation_disabled: ?*const fz_page_separation_disabled_fn = null,
    separations: ?*const fz_page_separations_fn = null,
    overprint: ?*const fz_page_uses_overprint_fn = null,
    create_link: ?*const fz_page_create_link_fn = null,
    delete_link: ?*const fz_page_delete_link_fn = null,
    prev: [*c][*c]fz_page = null,
    next: [*c]fz_page = null,
};
pub const fz_page = struct_fz_page;
pub const fz_document_load_page_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document, chapter: c_int, page: c_int) callconv(.c) [*c]fz_page;
pub const fz_document_page_label_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document, chapter: c_int, page: c_int, buf: [*c]u8, size: usize) callconv(.c) void;
pub const fz_document_lookup_metadata_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document, key: [*c]const u8, buf: [*c]u8, size: usize) callconv(.c) c_int;
pub const fz_document_set_metadata_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document, key: [*c]const u8, value: [*c]const u8) callconv(.c) c_int;
pub const fz_document_output_intent_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document) callconv(.c) [*c]fz_colorspace;
pub const fz_document_output_accelerator_fn = fn (ctx: [*c]fz_context, doc: [*c]fz_document, out: [*c]fz_output) callconv(.c) void;
pub const struct_fz_document = extern struct {
    refs: c_int = 0,
    drop_document: ?*const fz_document_drop_fn = null,
    needs_password: ?*const fz_document_needs_password_fn = null,
    authenticate_password: ?*const fz_document_authenticate_password_fn = null,
    has_permission: ?*const fz_document_has_permission_fn = null,
    load_outline: ?*const fz_document_load_outline_fn = null,
    outline_iterator: ?*const fz_document_outline_iterator_fn = null,
    layout: ?*const fz_document_layout_fn = null,
    make_bookmark: ?*const fz_document_make_bookmark_fn = null,
    lookup_bookmark: ?*const fz_document_lookup_bookmark_fn = null,
    resolve_link_dest: ?*const fz_document_resolve_link_dest_fn = null,
    format_link_uri: ?*const fz_document_format_link_uri_fn = null,
    count_chapters: ?*const fz_document_count_chapters_fn = null,
    count_pages: ?*const fz_document_count_pages_fn = null,
    load_page: ?*const fz_document_load_page_fn = null,
    page_label: ?*const fz_document_page_label_fn = null,
    lookup_metadata: ?*const fz_document_lookup_metadata_fn = null,
    set_metadata: ?*const fz_document_set_metadata_fn = null,
    get_output_intent: ?*const fz_document_output_intent_fn = null,
    output_accelerator: ?*const fz_document_output_accelerator_fn = null,
    did_layout: c_int = 0,
    is_reflowable: c_int = 0,
    open: [*c]fz_page = null,
};
pub const fz_location = extern struct {
    chapter: c_int = 0,
    page: c_int = 0,
};
pub const struct_fz_layout_char = extern struct {
    x: f32 = 0,
    advance: f32 = 0,
    p: [*c]const u8 = null,
    next: [*c]struct_fz_layout_char = null,
};
pub const fz_layout_char = struct_fz_layout_char;
pub const struct_fz_layout_line = extern struct {
    x: f32 = 0,
    y: f32 = 0,
    font_size: f32 = 0,
    p: [*c]const u8 = null,
    text: [*c]fz_layout_char = null,
    next: [*c]struct_fz_layout_line = null,
};
pub const fz_layout_line = struct_fz_layout_line;
pub const fz_layout_block = extern struct {
    pool: ?*fz_pool = null,
    matrix: fz_matrix = @import("std").mem.zeroes(fz_matrix),
    inv_matrix: fz_matrix = @import("std").mem.zeroes(fz_matrix),
    head: [*c]fz_layout_line = null,
    tailp: [*c][*c]fz_layout_line = null,
    text_tailp: [*c][*c]fz_layout_char = null,
};
pub extern fn fz_new_layout(ctx: [*c]fz_context) [*c]fz_layout_block;
pub extern fn fz_drop_layout(ctx: [*c]fz_context, block: [*c]fz_layout_block) void;
pub extern fn fz_add_layout_line(ctx: [*c]fz_context, block: [*c]fz_layout_block, x: f32, y: f32, h: f32, p: [*c]const u8) void;
pub extern fn fz_add_layout_char(ctx: [*c]fz_context, block: [*c]fz_layout_block, x: f32, w: f32, p: [*c]const u8) void;
pub const fz_stext_char = struct_fz_stext_char;
pub const struct_fz_stext_char = extern struct {
    c: c_int = 0,
    color: c_int = 0,
    origin: fz_point = @import("std").mem.zeroes(fz_point),
    quad: fz_quad = @import("std").mem.zeroes(fz_quad),
    size: f32 = 0,
    font: [*c]fz_font = null,
    next: [*c]fz_stext_char = null,
};
pub const fz_stext_line = struct_fz_stext_line;
pub const struct_fz_stext_line = extern struct {
    wmode: c_int = 0,
    dir: fz_point = @import("std").mem.zeroes(fz_point),
    bbox: fz_rect = @import("std").mem.zeroes(fz_rect),
    first_char: [*c]fz_stext_char = null,
    last_char: [*c]fz_stext_char = null,
    prev: [*c]fz_stext_line = null,
    next: [*c]fz_stext_line = null,
};
const struct_unnamed_46 = extern struct {
    first_line: [*c]fz_stext_line = null,
    last_line: [*c]fz_stext_line = null,
};
const struct_unnamed_47 = extern struct {
    transform: fz_matrix = @import("std").mem.zeroes(fz_matrix),
    image: ?*fz_image = null,
};
const union_unnamed_45 = extern union {
    t: struct_unnamed_46,
    i: struct_unnamed_47,
};
pub const fz_stext_block = struct_fz_stext_block;
pub const struct_fz_stext_block = extern struct {
    type: c_int = 0,
    bbox: fz_rect = @import("std").mem.zeroes(fz_rect),
    u: union_unnamed_45 = @import("std").mem.zeroes(union_unnamed_45),
    prev: [*c]fz_stext_block = null,
    next: [*c]fz_stext_block = null,
};
pub const FZ_STEXT_PRESERVE_LIGATURES: c_int = 1;
pub const FZ_STEXT_PRESERVE_WHITESPACE: c_int = 2;
pub const FZ_STEXT_PRESERVE_IMAGES: c_int = 4;
pub const FZ_STEXT_INHIBIT_SPACES: c_int = 8;
pub const FZ_STEXT_DEHYPHENATE: c_int = 16;
pub const FZ_STEXT_PRESERVE_SPANS: c_int = 32;
pub const FZ_STEXT_MEDIABOX_CLIP: c_int = 64;
pub const FZ_STEXT_USE_CID_FOR_UNKNOWN_UNICODE: c_int = 128;
const enum_unnamed_48 = c_uint;
pub const fz_stext_page = extern struct {
    pool: ?*fz_pool = null,
    mediabox: fz_rect = @import("std").mem.zeroes(fz_rect),
    first_block: [*c]fz_stext_block = null,
    last_block: [*c]fz_stext_block = null,
};
pub const FZ_STEXT_BLOCK_TEXT: c_int = 0;
pub const FZ_STEXT_BLOCK_IMAGE: c_int = 1;
const enum_unnamed_49 = c_uint;
pub extern var fz_stext_options_usage: [*c]const u8;
pub extern fn fz_new_stext_page(ctx: [*c]fz_context, mediabox: fz_rect) [*c]fz_stext_page;
pub extern fn fz_drop_stext_page(ctx: [*c]fz_context, page: [*c]fz_stext_page) void;
pub extern fn fz_print_stext_page_as_html(ctx: [*c]fz_context, out: [*c]fz_output, page: [*c]fz_stext_page, id: c_int) void;
pub extern fn fz_print_stext_header_as_html(ctx: [*c]fz_context, out: [*c]fz_output) void;
pub extern fn fz_print_stext_trailer_as_html(ctx: [*c]fz_context, out: [*c]fz_output) void;
pub extern fn fz_print_stext_page_as_xhtml(ctx: [*c]fz_context, out: [*c]fz_output, page: [*c]fz_stext_page, id: c_int) void;
pub extern fn fz_print_stext_header_as_xhtml(ctx: [*c]fz_context, out: [*c]fz_output) void;
pub extern fn fz_print_stext_trailer_as_xhtml(ctx: [*c]fz_context, out: [*c]fz_output) void;
pub extern fn fz_print_stext_page_as_xml(ctx: [*c]fz_context, out: [*c]fz_output, page: [*c]fz_stext_page, id: c_int) void;
pub extern fn fz_print_stext_page_as_json(ctx: [*c]fz_context, out: [*c]fz_output, page: [*c]fz_stext_page, scale: f32) void;
pub extern fn fz_print_stext_page_as_text(ctx: [*c]fz_context, out: [*c]fz_output, page: [*c]fz_stext_page) void;
pub extern fn fz_search_stext_page(ctx: [*c]fz_context, text: [*c]fz_stext_page, needle: [*c]const u8, hit_mark: [*c]c_int, hit_bbox: [*c]fz_quad, hit_max: c_int) c_int;
pub extern fn fz_highlight_selection(ctx: [*c]fz_context, page: [*c]fz_stext_page, a: fz_point, b: fz_point, quads: [*c]fz_quad, max_quads: c_int) c_int;
pub const FZ_SELECT_CHARS: c_int = 0;
pub const FZ_SELECT_WORDS: c_int = 1;
pub const FZ_SELECT_LINES: c_int = 2;
const enum_unnamed_50 = c_uint;
pub extern fn fz_snap_selection(ctx: [*c]fz_context, page: [*c]fz_stext_page, ap: [*c]fz_point, bp: [*c]fz_point, mode: c_int) fz_quad;
pub extern fn fz_copy_selection(ctx: [*c]fz_context, page: [*c]fz_stext_page, a: fz_point, b: fz_point, crlf: c_int) [*c]u8;
pub extern fn fz_copy_rectangle(ctx: [*c]fz_context, page: [*c]fz_stext_page, area: fz_rect, crlf: c_int) [*c]u8;
pub const fz_stext_options = extern struct {
    flags: c_int = 0,
    scale: f32 = 0,
};
pub extern fn fz_parse_stext_options(ctx: [*c]fz_context, opts: [*c]fz_stext_options, string: [*c]const u8) [*c]fz_stext_options;
pub extern fn fz_new_stext_device(ctx: [*c]fz_context, page: [*c]fz_stext_page, options: [*c]const fz_stext_options) [*c]fz_device;
pub extern fn fz_new_ocr_device(ctx: [*c]fz_context, target: [*c]fz_device, ctm: fz_matrix, mediabox: fz_rect, with_list: c_int, language: [*c]const u8, datadir: [*c]const u8, progress: ?*const fn ([*c]fz_context, ?*anyopaque, c_int) callconv(.c) c_int, progress_arg: ?*anyopaque) [*c]fz_device;
pub extern fn fz_open_reflowed_document(ctx: [*c]fz_context, underdoc: [*c]fz_document, opts: [*c]const fz_stext_options) [*c]fz_document;
pub const FZ_TRANSITION_NONE: c_int = 0;
pub const FZ_TRANSITION_SPLIT: c_int = 1;
pub const FZ_TRANSITION_BLINDS: c_int = 2;
pub const FZ_TRANSITION_BOX: c_int = 3;
pub const FZ_TRANSITION_WIPE: c_int = 4;
pub const FZ_TRANSITION_DISSOLVE: c_int = 5;
pub const FZ_TRANSITION_GLITTER: c_int = 6;
pub const FZ_TRANSITION_FLY: c_int = 7;
pub const FZ_TRANSITION_PUSH: c_int = 8;
pub const FZ_TRANSITION_COVER: c_int = 9;
pub const FZ_TRANSITION_UNCOVER: c_int = 10;
pub const FZ_TRANSITION_FADE: c_int = 11;
const enum_unnamed_51 = c_uint;
pub const fz_transition = extern struct {
    type: c_int = 0,
    duration: f32 = 0,
    vertical: c_int = 0,
    outwards: c_int = 0,
    direction: c_int = 0,
    state0: c_int = 0,
    state1: c_int = 0,
};
pub extern fn fz_generate_transition(ctx: [*c]fz_context, tpix: [*c]fz_pixmap, opix: [*c]fz_pixmap, npix: [*c]fz_pixmap, time: c_int, trans: [*c]fz_transition) c_int;
pub extern fn fz_purge_glyph_cache(ctx: [*c]fz_context) void;
pub extern fn fz_render_glyph_pixmap(ctx: [*c]fz_context, font: [*c]fz_font, gid: c_int, ctm: [*c]fz_matrix, scissor: [*c]const fz_irect, aa: c_int) [*c]fz_pixmap;
pub extern fn fz_render_t3_glyph_direct(ctx: [*c]fz_context, dev: [*c]fz_device, font: [*c]fz_font, gid: c_int, trm: fz_matrix, gstate: ?*anyopaque, def_cs: [*c]fz_default_colorspaces) void;
pub extern fn fz_prepare_t3_glyph(ctx: [*c]fz_context, font: [*c]fz_font, gid: c_int) void;
pub extern fn fz_dump_glyph_cache_stats(ctx: [*c]fz_context, out: [*c]fz_output) void;
pub extern fn fz_subpixel_adjust(ctx: [*c]fz_context, ctm: [*c]fz_matrix, subpix_ctm: [*c]fz_matrix, qe: [*c]u8, qf: [*c]u8) f32;
pub const FZ_LINK_DEST_FIT: c_int = 0;
pub const FZ_LINK_DEST_FIT_B: c_int = 1;
pub const FZ_LINK_DEST_FIT_H: c_int = 2;
pub const FZ_LINK_DEST_FIT_BH: c_int = 3;
pub const FZ_LINK_DEST_FIT_V: c_int = 4;
pub const FZ_LINK_DEST_FIT_BV: c_int = 5;
pub const FZ_LINK_DEST_FIT_R: c_int = 6;
pub const FZ_LINK_DEST_XYZ: c_int = 7;
pub const fz_link_dest_type = c_uint;
pub const fz_link_dest = extern struct {
    loc: fz_location = @import("std").mem.zeroes(fz_location),
    type: fz_link_dest_type = @import("std").mem.zeroes(fz_link_dest_type),
    x: f32 = 0,
    y: f32 = 0,
    w: f32 = 0,
    h: f32 = 0,
    zoom: f32 = 0,
};
pub extern fn fz_make_link_dest_none() fz_link_dest;
pub extern fn fz_make_link_dest_xyz(chapter: c_int, page: c_int, x: f32, y: f32, z: f32) fz_link_dest;
pub extern fn fz_new_link_of_size(ctx: [*c]fz_context, size: c_int, rect: fz_rect, uri: [*c]const u8) [*c]fz_link;
pub extern fn fz_keep_link(ctx: [*c]fz_context, link: [*c]fz_link) [*c]fz_link;
pub extern fn fz_drop_link(ctx: [*c]fz_context, link: [*c]fz_link) void;
pub extern fn fz_is_external_link(ctx: [*c]fz_context, uri: [*c]const u8) c_int;
pub extern fn fz_set_link_rect(ctx: [*c]fz_context, link: [*c]fz_link, rect: fz_rect) void;
pub extern fn fz_set_link_uri(ctx: [*c]fz_context, link: [*c]fz_link, uri: [*c]const u8) void;
pub const fz_outline_item = extern struct {
    title: [*c]u8 = null,
    uri: [*c]u8 = null,
    is_open: c_int = 0,
};
pub extern fn fz_outline_iterator_item(ctx: [*c]fz_context, iter: [*c]fz_outline_iterator) [*c]fz_outline_item;
pub extern fn fz_outline_iterator_next(ctx: [*c]fz_context, iter: [*c]fz_outline_iterator) c_int;
pub extern fn fz_outline_iterator_prev(ctx: [*c]fz_context, iter: [*c]fz_outline_iterator) c_int;
pub extern fn fz_outline_iterator_up(ctx: [*c]fz_context, iter: [*c]fz_outline_iterator) c_int;
pub extern fn fz_outline_iterator_down(ctx: [*c]fz_context, iter: [*c]fz_outline_iterator) c_int;
pub extern fn fz_outline_iterator_insert(ctx: [*c]fz_context, iter: [*c]fz_outline_iterator, item: [*c]fz_outline_item) c_int;
pub extern fn fz_outline_iterator_delete(ctx: [*c]fz_context, iter: [*c]fz_outline_iterator) c_int;
pub extern fn fz_outline_iterator_update(ctx: [*c]fz_context, iter: [*c]fz_outline_iterator, item: [*c]fz_outline_item) void;
pub extern fn fz_drop_outline_iterator(ctx: [*c]fz_context, iter: [*c]fz_outline_iterator) void;
pub extern fn fz_new_outline(ctx: [*c]fz_context) [*c]fz_outline;
pub extern fn fz_keep_outline(ctx: [*c]fz_context, outline: [*c]fz_outline) [*c]fz_outline;
pub extern fn fz_drop_outline(ctx: [*c]fz_context, outline: [*c]fz_outline) void;
pub extern fn fz_load_outline_from_iterator(ctx: [*c]fz_context, iter: [*c]fz_outline_iterator) [*c]fz_outline;
pub extern fn fz_new_outline_iterator_of_size(ctx: [*c]fz_context, size: usize, doc: [*c]fz_document) [*c]fz_outline_iterator;
pub extern fn fz_outline_iterator_from_outline(ctx: [*c]fz_context, outline: [*c]fz_outline) [*c]fz_outline_iterator;
pub const fz_document_recognize_fn = fn (ctx: [*c]fz_context, magic: [*c]const u8) callconv(.c) c_int;
pub const fz_document_open_fn = fn (ctx: [*c]fz_context, filename: [*c]const u8) callconv(.c) [*c]fz_document;
pub const fz_document_open_with_stream_fn = fn (ctx: [*c]fz_context, stream: [*c]fz_stream) callconv(.c) [*c]fz_document;
pub const fz_document_open_accel_fn = fn (ctx: [*c]fz_context, filename: [*c]const u8, accel: [*c]const u8) callconv(.c) [*c]fz_document;
pub const fz_document_open_accel_with_stream_fn = fn (ctx: [*c]fz_context, stream: [*c]fz_stream, accel: [*c]fz_stream) callconv(.c) [*c]fz_document;
pub const fz_document_recognize_content_fn = fn (ctx: [*c]fz_context, stream: [*c]fz_stream) callconv(.c) c_int;
pub const struct_fz_document_handler = extern struct {
    recognize: ?*const fz_document_recognize_fn = null,
    open: ?*const fz_document_open_fn = null,
    open_with_stream: ?*const fz_document_open_with_stream_fn = null,
    extensions: [*c][*c]const u8 = null,
    mimetypes: [*c][*c]const u8 = null,
    open_accel: ?*const fz_document_open_accel_fn = null,
    open_accel_with_stream: ?*const fz_document_open_accel_with_stream_fn = null,
    recognize_content: ?*const fz_document_recognize_content_fn = null,
};
pub const fz_document_handler = struct_fz_document_handler;
pub const FZ_MEDIA_BOX: c_int = 0;
pub const FZ_CROP_BOX: c_int = 1;
pub const FZ_BLEED_BOX: c_int = 2;
pub const FZ_TRIM_BOX: c_int = 3;
pub const FZ_ART_BOX: c_int = 4;
pub const FZ_UNKNOWN_BOX: c_int = 5;
pub const fz_box_type = c_uint;
pub extern fn fz_box_type_from_string(name: [*c]const u8) fz_box_type;
pub extern fn fz_string_from_box_type(box: fz_box_type) [*c]const u8;
pub fn fz_make_location(arg_chapter: c_int, arg_page: c_int) callconv(.c) fz_location {
    var chapter = arg_chapter;
    _ = &chapter;
    var page = arg_page;
    _ = &page;
    var loc: fz_location = fz_location{
        .chapter = chapter,
        .page = page,
    };
    _ = &loc;
    return loc;
}
pub const FZ_LAYOUT_KINDLE_W: c_int = 260;
pub const FZ_LAYOUT_KINDLE_H: c_int = 346;
pub const FZ_LAYOUT_KINDLE_EM: c_int = 9;
pub const FZ_LAYOUT_US_POCKET_W: c_int = 306;
pub const FZ_LAYOUT_US_POCKET_H: c_int = 495;
pub const FZ_LAYOUT_US_POCKET_EM: c_int = 10;
pub const FZ_LAYOUT_US_TRADE_W: c_int = 396;
pub const FZ_LAYOUT_US_TRADE_H: c_int = 612;
pub const FZ_LAYOUT_US_TRADE_EM: c_int = 11;
pub const FZ_LAYOUT_UK_A_FORMAT_W: c_int = 312;
pub const FZ_LAYOUT_UK_A_FORMAT_H: c_int = 504;
pub const FZ_LAYOUT_UK_A_FORMAT_EM: c_int = 10;
pub const FZ_LAYOUT_UK_B_FORMAT_W: c_int = 366;
pub const FZ_LAYOUT_UK_B_FORMAT_H: c_int = 561;
pub const FZ_LAYOUT_UK_B_FORMAT_EM: c_int = 10;
pub const FZ_LAYOUT_UK_C_FORMAT_W: c_int = 382;
pub const FZ_LAYOUT_UK_C_FORMAT_H: c_int = 612;
pub const FZ_LAYOUT_UK_C_FORMAT_EM: c_int = 11;
pub const FZ_LAYOUT_A5_W: c_int = 420;
pub const FZ_LAYOUT_A5_H: c_int = 595;
pub const FZ_LAYOUT_A5_EM: c_int = 11;
pub const FZ_DEFAULT_LAYOUT_W: c_int = 420;
pub const FZ_DEFAULT_LAYOUT_H: c_int = 595;
pub const FZ_DEFAULT_LAYOUT_EM: c_int = 11;
const enum_unnamed_52 = c_uint;
pub const FZ_PERMISSION_PRINT: c_int = 112;
pub const FZ_PERMISSION_COPY: c_int = 99;
pub const FZ_PERMISSION_EDIT: c_int = 101;
pub const FZ_PERMISSION_ANNOTATE: c_int = 110;
pub const FZ_PERMISSION_FORM: c_int = 102;
pub const FZ_PERMISSION_ACCESSIBILITY: c_int = 121;
pub const FZ_PERMISSION_ASSEMBLE: c_int = 97;
pub const FZ_PERMISSION_PRINT_HQ: c_int = 104;
pub const fz_permission = c_uint;
pub const fz_process_opened_page_fn = fn (ctx: [*c]fz_context, page: [*c]fz_page, state: ?*anyopaque) callconv(.c) ?*anyopaque;
pub extern fn fz_register_document_handler(ctx: [*c]fz_context, handler: [*c]const fz_document_handler) void;
pub extern fn fz_register_document_handlers(ctx: [*c]fz_context) void;
pub extern fn fz_recognize_document(ctx: [*c]fz_context, magic: [*c]const u8) [*c]const fz_document_handler;
pub extern fn fz_recognize_document_content(ctx: [*c]fz_context, filename: [*c]const u8) [*c]const fz_document_handler;
pub extern fn fz_recognize_document_stream_content(ctx: [*c]fz_context, stream: [*c]fz_stream, magic: [*c]const u8) [*c]const fz_document_handler;
pub extern fn fz_open_document(ctx: [*c]fz_context, filename: [*c]const u8) [*c]fz_document;
pub extern fn fz_open_accelerated_document(ctx: [*c]fz_context, filename: [*c]const u8, accel: [*c]const u8) [*c]fz_document;
pub extern fn fz_open_document_with_stream(ctx: [*c]fz_context, magic: [*c]const u8, stream: [*c]fz_stream) [*c]fz_document;
pub extern fn fz_open_document_with_buffer(ctx: [*c]fz_context, magic: [*c]const u8, buffer: [*c]fz_buffer) [*c]fz_document;
pub extern fn fz_open_accelerated_document_with_stream(ctx: [*c]fz_context, magic: [*c]const u8, stream: [*c]fz_stream, accel: [*c]fz_stream) [*c]fz_document;
pub extern fn fz_document_supports_accelerator(ctx: [*c]fz_context, doc: [*c]fz_document) c_int;
pub extern fn fz_save_accelerator(ctx: [*c]fz_context, doc: [*c]fz_document, accel: [*c]const u8) void;
pub extern fn fz_output_accelerator(ctx: [*c]fz_context, doc: [*c]fz_document, accel: [*c]fz_output) void;
pub extern fn fz_new_document_of_size(ctx: [*c]fz_context, size: c_int) ?*anyopaque;
pub extern fn fz_keep_document(ctx: [*c]fz_context, doc: [*c]fz_document) [*c]fz_document;
pub extern fn fz_drop_document(ctx: [*c]fz_context, doc: [*c]fz_document) void;
pub extern fn fz_needs_password(ctx: [*c]fz_context, doc: [*c]fz_document) c_int;
pub extern fn fz_authenticate_password(ctx: [*c]fz_context, doc: [*c]fz_document, password: [*c]const u8) c_int;
pub extern fn fz_load_outline(ctx: [*c]fz_context, doc: [*c]fz_document) [*c]fz_outline;
pub extern fn fz_new_outline_iterator(ctx: [*c]fz_context, doc: [*c]fz_document) [*c]fz_outline_iterator;
pub extern fn fz_is_document_reflowable(ctx: [*c]fz_context, doc: [*c]fz_document) c_int;
pub extern fn fz_layout_document(ctx: [*c]fz_context, doc: [*c]fz_document, w: f32, h: f32, em: f32) void;
pub extern fn fz_make_bookmark(ctx: [*c]fz_context, doc: [*c]fz_document, loc: fz_location) fz_bookmark;
pub extern fn fz_lookup_bookmark(ctx: [*c]fz_context, doc: [*c]fz_document, mark: fz_bookmark) fz_location;
pub extern fn fz_count_pages(ctx: [*c]fz_context, doc: [*c]fz_document) c_int;
pub extern fn fz_resolve_link_dest(ctx: [*c]fz_context, doc: [*c]fz_document, uri: [*c]const u8) fz_link_dest;
pub extern fn fz_format_link_uri(ctx: [*c]fz_context, doc: [*c]fz_document, dest: fz_link_dest) [*c]u8;
pub extern fn fz_resolve_link(ctx: [*c]fz_context, doc: [*c]fz_document, uri: [*c]const u8, xp: [*c]f32, yp: [*c]f32) fz_location;
pub extern fn fz_last_page(ctx: [*c]fz_context, doc: [*c]fz_document) fz_location;
pub extern fn fz_next_page(ctx: [*c]fz_context, doc: [*c]fz_document, loc: fz_location) fz_location;
pub extern fn fz_previous_page(ctx: [*c]fz_context, doc: [*c]fz_document, loc: fz_location) fz_location;
pub extern fn fz_clamp_location(ctx: [*c]fz_context, doc: [*c]fz_document, loc: fz_location) fz_location;
pub extern fn fz_location_from_page_number(ctx: [*c]fz_context, doc: [*c]fz_document, number: c_int) fz_location;
pub extern fn fz_page_number_from_location(ctx: [*c]fz_context, doc: [*c]fz_document, loc: fz_location) c_int;
pub extern fn fz_load_page(ctx: [*c]fz_context, doc: [*c]fz_document, number: c_int) [*c]fz_page;
pub extern fn fz_count_chapters(ctx: [*c]fz_context, doc: [*c]fz_document) c_int;
pub extern fn fz_count_chapter_pages(ctx: [*c]fz_context, doc: [*c]fz_document, chapter: c_int) c_int;
pub extern fn fz_load_chapter_page(ctx: [*c]fz_context, doc: [*c]fz_document, chapter: c_int, page: c_int) [*c]fz_page;
pub extern fn fz_load_links(ctx: [*c]fz_context, page: [*c]fz_page) [*c]fz_link;
pub extern fn fz_new_page_of_size(ctx: [*c]fz_context, size: c_int, doc: [*c]fz_document) [*c]fz_page;
pub extern fn fz_bound_page(ctx: [*c]fz_context, page: [*c]fz_page) fz_rect;
pub extern fn fz_bound_page_box(ctx: [*c]fz_context, page: [*c]fz_page, box: fz_box_type) fz_rect;
pub extern fn fz_run_page(ctx: [*c]fz_context, page: [*c]fz_page, dev: [*c]fz_device, transform: fz_matrix, cookie: [*c]fz_cookie) void;
pub extern fn fz_run_page_contents(ctx: [*c]fz_context, page: [*c]fz_page, dev: [*c]fz_device, transform: fz_matrix, cookie: [*c]fz_cookie) void;
pub extern fn fz_run_page_annots(ctx: [*c]fz_context, page: [*c]fz_page, dev: [*c]fz_device, transform: fz_matrix, cookie: [*c]fz_cookie) void;
pub extern fn fz_run_page_widgets(ctx: [*c]fz_context, page: [*c]fz_page, dev: [*c]fz_device, transform: fz_matrix, cookie: [*c]fz_cookie) void;
pub extern fn fz_keep_page(ctx: [*c]fz_context, page: [*c]fz_page) [*c]fz_page;
pub extern fn fz_keep_page_locked(ctx: [*c]fz_context, page: [*c]fz_page) [*c]fz_page;
pub extern fn fz_drop_page(ctx: [*c]fz_context, page: [*c]fz_page) void;
pub extern fn fz_page_presentation(ctx: [*c]fz_context, page: [*c]fz_page, transition: [*c]fz_transition, duration: [*c]f32) [*c]fz_transition;
pub extern fn fz_page_label(ctx: [*c]fz_context, page: [*c]fz_page, buf: [*c]u8, size: c_int) [*c]const u8;
pub extern fn fz_has_permission(ctx: [*c]fz_context, doc: [*c]fz_document, p: fz_permission) c_int;
pub extern fn fz_lookup_metadata(ctx: [*c]fz_context, doc: [*c]fz_document, key: [*c]const u8, buf: [*c]u8, size: c_int) c_int;
pub extern fn fz_set_metadata(ctx: [*c]fz_context, doc: [*c]fz_document, key: [*c]const u8, value: [*c]const u8) void;
pub extern fn fz_document_output_intent(ctx: [*c]fz_context, doc: [*c]fz_document) [*c]fz_colorspace;
pub extern fn fz_page_separations(ctx: [*c]fz_context, page: [*c]fz_page) ?*fz_separations;
pub extern fn fz_page_uses_overprint(ctx: [*c]fz_context, page: [*c]fz_page) c_int;
pub extern fn fz_create_link(ctx: [*c]fz_context, page: [*c]fz_page, bbox: fz_rect, uri: [*c]const u8) [*c]fz_link;
pub extern fn fz_delete_link(ctx: [*c]fz_context, page: [*c]fz_page, link: [*c]fz_link) void;
pub extern fn fz_process_opened_pages(ctx: [*c]fz_context, doc: [*c]fz_document, process_openend_page: ?*const fz_process_opened_page_fn, state: ?*anyopaque) ?*anyopaque;
pub extern fn fz_new_display_list_from_page(ctx: [*c]fz_context, page: [*c]fz_page) ?*fz_display_list;
pub extern fn fz_new_display_list_from_page_number(ctx: [*c]fz_context, doc: [*c]fz_document, number: c_int) ?*fz_display_list;
pub extern fn fz_new_display_list_from_page_contents(ctx: [*c]fz_context, page: [*c]fz_page) ?*fz_display_list;
pub extern fn fz_new_pixmap_from_display_list(ctx: [*c]fz_context, list: ?*fz_display_list, ctm: fz_matrix, cs: [*c]fz_colorspace, alpha: c_int) [*c]fz_pixmap;
pub extern fn fz_new_pixmap_from_page(ctx: [*c]fz_context, page: [*c]fz_page, ctm: fz_matrix, cs: [*c]fz_colorspace, alpha: c_int) [*c]fz_pixmap;
pub extern fn fz_new_pixmap_from_page_number(ctx: [*c]fz_context, doc: [*c]fz_document, number: c_int, ctm: fz_matrix, cs: [*c]fz_colorspace, alpha: c_int) [*c]fz_pixmap;
pub extern fn fz_new_pixmap_from_page_contents(ctx: [*c]fz_context, page: [*c]fz_page, ctm: fz_matrix, cs: [*c]fz_colorspace, alpha: c_int) [*c]fz_pixmap;
pub extern fn fz_new_pixmap_from_display_list_with_separations(ctx: [*c]fz_context, list: ?*fz_display_list, ctm: fz_matrix, cs: [*c]fz_colorspace, seps: ?*fz_separations, alpha: c_int) [*c]fz_pixmap;
pub extern fn fz_new_pixmap_from_page_with_separations(ctx: [*c]fz_context, page: [*c]fz_page, ctm: fz_matrix, cs: [*c]fz_colorspace, seps: ?*fz_separations, alpha: c_int) [*c]fz_pixmap;
pub extern fn fz_new_pixmap_from_page_number_with_separations(ctx: [*c]fz_context, doc: [*c]fz_document, number: c_int, ctm: fz_matrix, cs: [*c]fz_colorspace, seps: ?*fz_separations, alpha: c_int) [*c]fz_pixmap;
pub extern fn fz_new_pixmap_from_page_contents_with_separations(ctx: [*c]fz_context, page: [*c]fz_page, ctm: fz_matrix, cs: [*c]fz_colorspace, seps: ?*fz_separations, alpha: c_int) [*c]fz_pixmap;
pub extern fn fz_fill_pixmap_from_display_list(ctx: [*c]fz_context, list: ?*fz_display_list, ctm: fz_matrix, pix: [*c]fz_pixmap) [*c]fz_pixmap;
pub extern fn fz_new_stext_page_from_page(ctx: [*c]fz_context, page: [*c]fz_page, options: [*c]const fz_stext_options) [*c]fz_stext_page;
pub extern fn fz_new_stext_page_from_page_number(ctx: [*c]fz_context, doc: [*c]fz_document, number: c_int, options: [*c]const fz_stext_options) [*c]fz_stext_page;
pub extern fn fz_new_stext_page_from_chapter_page_number(ctx: [*c]fz_context, doc: [*c]fz_document, chapter: c_int, number: c_int, options: [*c]const fz_stext_options) [*c]fz_stext_page;
pub extern fn fz_new_stext_page_from_display_list(ctx: [*c]fz_context, list: ?*fz_display_list, options: [*c]const fz_stext_options) [*c]fz_stext_page;
pub extern fn fz_new_buffer_from_stext_page(ctx: [*c]fz_context, text: [*c]fz_stext_page) [*c]fz_buffer;
pub extern fn fz_new_buffer_from_page(ctx: [*c]fz_context, page: [*c]fz_page, options: [*c]const fz_stext_options) [*c]fz_buffer;
pub extern fn fz_new_buffer_from_page_number(ctx: [*c]fz_context, doc: [*c]fz_document, number: c_int, options: [*c]const fz_stext_options) [*c]fz_buffer;
pub extern fn fz_new_buffer_from_display_list(ctx: [*c]fz_context, list: ?*fz_display_list, options: [*c]const fz_stext_options) [*c]fz_buffer;
pub extern fn fz_search_page(ctx: [*c]fz_context, page: [*c]fz_page, needle: [*c]const u8, hit_mark: [*c]c_int, hit_bbox: [*c]fz_quad, hit_max: c_int) c_int;
pub extern fn fz_search_page_number(ctx: [*c]fz_context, doc: [*c]fz_document, number: c_int, needle: [*c]const u8, hit_mark: [*c]c_int, hit_bbox: [*c]fz_quad, hit_max: c_int) c_int;
pub extern fn fz_search_chapter_page_number(ctx: [*c]fz_context, doc: [*c]fz_document, chapter: c_int, page: c_int, needle: [*c]const u8, hit_mark: [*c]c_int, hit_bbox: [*c]fz_quad, hit_max: c_int) c_int;
pub extern fn fz_search_display_list(ctx: [*c]fz_context, list: ?*fz_display_list, needle: [*c]const u8, hit_mark: [*c]c_int, hit_bbox: [*c]fz_quad, hit_max: c_int) c_int;
pub extern fn fz_new_display_list_from_svg(ctx: [*c]fz_context, buf: [*c]fz_buffer, base_uri: [*c]const u8, zip: [*c]fz_archive, w: [*c]f32, h: [*c]f32) ?*fz_display_list;
pub extern fn fz_new_image_from_svg(ctx: [*c]fz_context, buf: [*c]fz_buffer, base_uri: [*c]const u8, zip: [*c]fz_archive) ?*fz_image;
pub extern fn fz_new_display_list_from_svg_xml(ctx: [*c]fz_context, xmldoc: ?*fz_xml_doc, xml: ?*fz_xml, base_uri: [*c]const u8, zip: [*c]fz_archive, w: [*c]f32, h: [*c]f32) ?*fz_display_list;
pub extern fn fz_new_image_from_svg_xml(ctx: [*c]fz_context, xmldoc: ?*fz_xml_doc, xml: ?*fz_xml, base_uri: [*c]const u8, zip: [*c]fz_archive) ?*fz_image;
pub extern fn fz_write_image_as_data_uri(ctx: [*c]fz_context, out: [*c]fz_output, image: ?*fz_image) void;
pub extern fn fz_write_pixmap_as_data_uri(ctx: [*c]fz_context, out: [*c]fz_output, pixmap: [*c]fz_pixmap) void;
pub extern fn fz_append_image_as_data_uri(ctx: [*c]fz_context, out: [*c]fz_buffer, image: ?*fz_image) void;
pub extern fn fz_append_pixmap_as_data_uri(ctx: [*c]fz_context, out: [*c]fz_buffer, pixmap: [*c]fz_pixmap) void;
pub extern fn fz_new_xhtml_document_from_document(ctx: [*c]fz_context, old_doc: [*c]fz_document, opts: [*c]const fz_stext_options) [*c]fz_document;
pub extern fn fz_new_buffer_from_page_with_format(ctx: [*c]fz_context, page: [*c]fz_page, format: [*c]const u8, options: [*c]const u8, transform: fz_matrix, cookie: [*c]fz_cookie) [*c]fz_buffer;
pub const fz_document_writer = struct_fz_document_writer;
pub const fz_document_writer_begin_page_fn = fn (ctx: [*c]fz_context, wri: [*c]fz_document_writer, mediabox: fz_rect) callconv(.c) [*c]fz_device;
pub const fz_document_writer_end_page_fn = fn (ctx: [*c]fz_context, wri: [*c]fz_document_writer, dev: [*c]fz_device) callconv(.c) void;
pub const fz_document_writer_close_writer_fn = fn (ctx: [*c]fz_context, wri: [*c]fz_document_writer) callconv(.c) void;
pub const fz_document_writer_drop_writer_fn = fn (ctx: [*c]fz_context, wri: [*c]fz_document_writer) callconv(.c) void;
pub const struct_fz_document_writer = extern struct {
    begin_page: ?*const fz_document_writer_begin_page_fn = null,
    end_page: ?*const fz_document_writer_end_page_fn = null,
    close_writer: ?*const fz_document_writer_close_writer_fn = null,
    drop_writer: ?*const fz_document_writer_drop_writer_fn = null,
    dev: [*c]fz_device = null,
};
pub extern fn fz_has_option(ctx: [*c]fz_context, opts: [*c]const u8, key: [*c]const u8, val: [*c][*c]const u8) c_int;
pub extern fn fz_option_eq(a: [*c]const u8, b: [*c]const u8) c_int;
pub extern fn fz_copy_option(ctx: [*c]fz_context, val: [*c]const u8, dest: [*c]u8, maxlen: usize) usize;
pub extern fn fz_new_document_writer(ctx: [*c]fz_context, path: [*c]const u8, format: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_document_writer_with_output(ctx: [*c]fz_context, out: [*c]fz_output, format: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_document_writer_with_buffer(ctx: [*c]fz_context, buf: [*c]fz_buffer, format: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_pdf_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_pdf_writer_with_output(ctx: [*c]fz_context, out: [*c]fz_output, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_svg_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_text_writer(ctx: [*c]fz_context, format: [*c]const u8, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_text_writer_with_output(ctx: [*c]fz_context, format: [*c]const u8, out: [*c]fz_output, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_odt_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_odt_writer_with_output(ctx: [*c]fz_context, out: [*c]fz_output, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_docx_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_docx_writer_with_output(ctx: [*c]fz_context, out: [*c]fz_output, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_ps_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_ps_writer_with_output(ctx: [*c]fz_context, out: [*c]fz_output, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_pcl_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_pcl_writer_with_output(ctx: [*c]fz_context, out: [*c]fz_output, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_pclm_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_pclm_writer_with_output(ctx: [*c]fz_context, out: [*c]fz_output, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_pwg_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_pwg_writer_with_output(ctx: [*c]fz_context, out: [*c]fz_output, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_cbz_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_cbz_writer_with_output(ctx: [*c]fz_context, out: [*c]fz_output, options: [*c]const u8) [*c]fz_document_writer;
pub const fz_pdfocr_progress_fn = fn (ctx: [*c]fz_context, progress_arg: ?*anyopaque, page: c_int, percent: c_int) callconv(.c) c_int;
pub extern fn fz_new_pdfocr_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_pdfocr_writer_with_output(ctx: [*c]fz_context, out: [*c]fz_output, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_pdfocr_writer_set_progress(ctx: [*c]fz_context, writer: [*c]fz_document_writer, progress: ?*const fz_pdfocr_progress_fn, ?*anyopaque) void;
pub extern fn fz_new_jpeg_pixmap_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_png_pixmap_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_pam_pixmap_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_pnm_pixmap_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_pgm_pixmap_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_ppm_pixmap_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_pbm_pixmap_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_new_pkm_pixmap_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8) [*c]fz_document_writer;
pub extern fn fz_begin_page(ctx: [*c]fz_context, wri: [*c]fz_document_writer, mediabox: fz_rect) [*c]fz_device;
pub extern fn fz_end_page(ctx: [*c]fz_context, wri: [*c]fz_document_writer) void;
pub extern fn fz_write_document(ctx: [*c]fz_context, wri: [*c]fz_document_writer, doc: [*c]fz_document) void;
pub extern fn fz_close_document_writer(ctx: [*c]fz_context, wri: [*c]fz_document_writer) void;
pub extern fn fz_drop_document_writer(ctx: [*c]fz_context, wri: [*c]fz_document_writer) void;
pub extern fn fz_new_pixmap_writer(ctx: [*c]fz_context, path: [*c]const u8, options: [*c]const u8, default_path: [*c]const u8, n: c_int, save: ?*const fn (ctx: [*c]fz_context, pix: [*c]fz_pixmap, filename: [*c]const u8) callconv(.c) void) [*c]fz_document_writer;
pub extern var fz_pdf_write_options_usage: [*c]const u8;
pub extern var fz_svg_write_options_usage: [*c]const u8;
pub extern var fz_pcl_write_options_usage: [*c]const u8;
pub extern var fz_pclm_write_options_usage: [*c]const u8;
pub extern var fz_pwg_write_options_usage: [*c]const u8;
pub extern var fz_pdfocr_write_options_usage: [*c]const u8;
pub extern fn fz_new_document_writer_of_size(ctx: [*c]fz_context, size: usize, begin_page: ?*const fz_document_writer_begin_page_fn, end_page: ?*const fz_document_writer_end_page_fn, close: ?*const fz_document_writer_close_writer_fn, drop: ?*const fz_document_writer_drop_writer_fn) [*c]fz_document_writer;
pub const fz_band_writer = struct_fz_band_writer;
pub const fz_drop_band_writer_fn = fn (ctx: [*c]fz_context, writer: [*c]fz_band_writer) callconv(.c) void;
pub const fz_close_band_writer_fn = fn (ctx: [*c]fz_context, writer: [*c]fz_band_writer) callconv(.c) void;
pub const fz_write_header_fn = fn (ctx: [*c]fz_context, writer: [*c]fz_band_writer, cs: [*c]fz_colorspace) callconv(.c) void;
pub const fz_write_band_fn = fn (ctx: [*c]fz_context, writer: [*c]fz_band_writer, stride: c_int, band_start: c_int, band_height: c_int, samples: [*c]const u8) callconv(.c) void;
pub const fz_write_trailer_fn = fn (ctx: [*c]fz_context, writer: [*c]fz_band_writer) callconv(.c) void;
pub const struct_fz_band_writer = extern struct {
    drop: ?*const fz_drop_band_writer_fn = null,
    close: ?*const fz_close_band_writer_fn = null,
    header: ?*const fz_write_header_fn = null,
    band: ?*const fz_write_band_fn = null,
    trailer: ?*const fz_write_trailer_fn = null,
    out: [*c]fz_output = null,
    w: c_int = 0,
    h: c_int = 0,
    n: c_int = 0,
    s: c_int = 0,
    alpha: c_int = 0,
    xres: c_int = 0,
    yres: c_int = 0,
    pagenum: c_int = 0,
    line: c_int = 0,
    seps: ?*fz_separations = null,
};
pub extern fn fz_write_header(ctx: [*c]fz_context, writer: [*c]fz_band_writer, w: c_int, h: c_int, n: c_int, alpha: c_int, xres: c_int, yres: c_int, pagenum: c_int, cs: [*c]fz_colorspace, seps: ?*fz_separations) void;
pub extern fn fz_write_band(ctx: [*c]fz_context, writer: [*c]fz_band_writer, stride: c_int, band_height: c_int, samples: [*c]const u8) void;
pub extern fn fz_close_band_writer(ctx: [*c]fz_context, writer: [*c]fz_band_writer) void;
pub extern fn fz_drop_band_writer(ctx: [*c]fz_context, writer: [*c]fz_band_writer) void;
pub extern fn fz_new_band_writer_of_size(ctx: [*c]fz_context, size: usize, out: [*c]fz_output) [*c]fz_band_writer;
pub const fz_pcl_options = extern struct {
    features: c_int = 0,
    odd_page_init: [*c]const u8 = null,
    even_page_init: [*c]const u8 = null,
    tumble: c_int = 0,
    duplex_set: c_int = 0,
    duplex: c_int = 0,
    paper_size: c_int = 0,
    manual_feed_set: c_int = 0,
    manual_feed: c_int = 0,
    media_position_set: c_int = 0,
    media_position: c_int = 0,
    orientation: c_int = 0,
    page_count: c_int = 0,
};
pub extern fn fz_pcl_preset(ctx: [*c]fz_context, opts: [*c]fz_pcl_options, preset: [*c]const u8) void;
pub extern fn fz_parse_pcl_options(ctx: [*c]fz_context, opts: [*c]fz_pcl_options, args: [*c]const u8) [*c]fz_pcl_options;
pub extern fn fz_new_mono_pcl_band_writer(ctx: [*c]fz_context, out: [*c]fz_output, options: [*c]const fz_pcl_options) [*c]fz_band_writer;
pub extern fn fz_write_bitmap_as_pcl(ctx: [*c]fz_context, out: [*c]fz_output, bitmap: [*c]const fz_bitmap, pcl: [*c]const fz_pcl_options) void;
pub extern fn fz_save_bitmap_as_pcl(ctx: [*c]fz_context, bitmap: [*c]fz_bitmap, filename: [*c]u8, append: c_int, pcl: [*c]const fz_pcl_options) void;
pub extern fn fz_new_color_pcl_band_writer(ctx: [*c]fz_context, out: [*c]fz_output, options: [*c]const fz_pcl_options) [*c]fz_band_writer;
pub extern fn fz_write_pixmap_as_pcl(ctx: [*c]fz_context, out: [*c]fz_output, pixmap: [*c]const fz_pixmap, pcl: [*c]const fz_pcl_options) void;
pub extern fn fz_save_pixmap_as_pcl(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, filename: [*c]u8, append: c_int, pcl: [*c]const fz_pcl_options) void;
pub const fz_pclm_options = extern struct {
    compress: c_int = 0,
    strip_height: c_int = 0,
    page_count: c_int = 0,
};
pub extern fn fz_parse_pclm_options(ctx: [*c]fz_context, opts: [*c]fz_pclm_options, args: [*c]const u8) [*c]fz_pclm_options;
pub extern fn fz_new_pclm_band_writer(ctx: [*c]fz_context, out: [*c]fz_output, options: [*c]const fz_pclm_options) [*c]fz_band_writer;
pub extern fn fz_write_pixmap_as_pclm(ctx: [*c]fz_context, out: [*c]fz_output, pixmap: [*c]const fz_pixmap, options: [*c]const fz_pclm_options) void;
pub extern fn fz_save_pixmap_as_pclm(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, filename: [*c]u8, append: c_int, options: [*c]const fz_pclm_options) void;
pub const fz_pdfocr_options = extern struct {
    compress: c_int = 0,
    strip_height: c_int = 0,
    language: [256]u8 = @import("std").mem.zeroes([256]u8),
    datadir: [1024]u8 = @import("std").mem.zeroes([1024]u8),
    page_count: c_int = 0,
};
pub extern fn fz_parse_pdfocr_options(ctx: [*c]fz_context, opts: [*c]fz_pdfocr_options, args: [*c]const u8) [*c]fz_pdfocr_options;
pub extern fn fz_new_pdfocr_band_writer(ctx: [*c]fz_context, out: [*c]fz_output, options: [*c]const fz_pdfocr_options) [*c]fz_band_writer;
pub extern fn fz_pdfocr_band_writer_set_progress(ctx: [*c]fz_context, writer: [*c]fz_band_writer, progress_fn: ?*const fz_pdfocr_progress_fn, progress_arg: ?*anyopaque) void;
pub extern fn fz_write_pixmap_as_pdfocr(ctx: [*c]fz_context, out: [*c]fz_output, pixmap: [*c]const fz_pixmap, options: [*c]const fz_pdfocr_options) void;
pub extern fn fz_save_pixmap_as_pdfocr(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, filename: [*c]u8, append: c_int, options: [*c]const fz_pdfocr_options) void;
pub extern fn fz_save_pixmap_as_png(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, filename: [*c]const u8) void;
pub extern fn fz_write_pixmap_as_jpeg(ctx: [*c]fz_context, out: [*c]fz_output, pix: [*c]fz_pixmap, quality: c_int) void;
pub extern fn fz_save_pixmap_as_jpeg(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, filename: [*c]const u8, quality: c_int) void;
pub extern fn fz_write_pixmap_as_png(ctx: [*c]fz_context, out: [*c]fz_output, pixmap: [*c]const fz_pixmap) void;
pub extern fn fz_new_png_band_writer(ctx: [*c]fz_context, out: [*c]fz_output) [*c]fz_band_writer;
pub extern fn fz_new_buffer_from_image_as_png(ctx: [*c]fz_context, image: ?*fz_image, color_params: fz_color_params) [*c]fz_buffer;
pub extern fn fz_new_buffer_from_image_as_pnm(ctx: [*c]fz_context, image: ?*fz_image, color_params: fz_color_params) [*c]fz_buffer;
pub extern fn fz_new_buffer_from_image_as_pam(ctx: [*c]fz_context, image: ?*fz_image, color_params: fz_color_params) [*c]fz_buffer;
pub extern fn fz_new_buffer_from_image_as_psd(ctx: [*c]fz_context, image: ?*fz_image, color_params: fz_color_params) [*c]fz_buffer;
pub extern fn fz_new_buffer_from_image_as_jpeg(ctx: [*c]fz_context, image: ?*fz_image, color_params: fz_color_params, quality: c_int) [*c]fz_buffer;
pub extern fn fz_new_buffer_from_pixmap_as_png(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, color_params: fz_color_params) [*c]fz_buffer;
pub extern fn fz_new_buffer_from_pixmap_as_pnm(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, color_params: fz_color_params) [*c]fz_buffer;
pub extern fn fz_new_buffer_from_pixmap_as_pam(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, color_params: fz_color_params) [*c]fz_buffer;
pub extern fn fz_new_buffer_from_pixmap_as_psd(ctx: [*c]fz_context, pix: [*c]fz_pixmap, color_params: fz_color_params) [*c]fz_buffer;
pub extern fn fz_new_buffer_from_pixmap_as_jpeg(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, color_params: fz_color_params, quality: c_int) [*c]fz_buffer;
pub extern fn fz_save_pixmap_as_pnm(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, filename: [*c]const u8) void;
pub extern fn fz_write_pixmap_as_pnm(ctx: [*c]fz_context, out: [*c]fz_output, pixmap: [*c]fz_pixmap) void;
pub extern fn fz_new_pnm_band_writer(ctx: [*c]fz_context, out: [*c]fz_output) [*c]fz_band_writer;
pub extern fn fz_save_pixmap_as_pam(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, filename: [*c]const u8) void;
pub extern fn fz_write_pixmap_as_pam(ctx: [*c]fz_context, out: [*c]fz_output, pixmap: [*c]fz_pixmap) void;
pub extern fn fz_new_pam_band_writer(ctx: [*c]fz_context, out: [*c]fz_output) [*c]fz_band_writer;
pub extern fn fz_save_bitmap_as_pbm(ctx: [*c]fz_context, bitmap: [*c]fz_bitmap, filename: [*c]const u8) void;
pub extern fn fz_write_bitmap_as_pbm(ctx: [*c]fz_context, out: [*c]fz_output, bitmap: [*c]fz_bitmap) void;
pub extern fn fz_new_pbm_band_writer(ctx: [*c]fz_context, out: [*c]fz_output) [*c]fz_band_writer;
pub extern fn fz_save_pixmap_as_pbm(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, filename: [*c]const u8) void;
pub extern fn fz_save_bitmap_as_pkm(ctx: [*c]fz_context, bitmap: [*c]fz_bitmap, filename: [*c]const u8) void;
pub extern fn fz_write_bitmap_as_pkm(ctx: [*c]fz_context, out: [*c]fz_output, bitmap: [*c]fz_bitmap) void;
pub extern fn fz_new_pkm_band_writer(ctx: [*c]fz_context, out: [*c]fz_output) [*c]fz_band_writer;
pub extern fn fz_save_pixmap_as_pkm(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, filename: [*c]const u8) void;
pub extern fn fz_write_pixmap_as_ps(ctx: [*c]fz_context, out: [*c]fz_output, pixmap: [*c]const fz_pixmap) void;
pub extern fn fz_save_pixmap_as_ps(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, filename: [*c]u8, append: c_int) void;
pub extern fn fz_new_ps_band_writer(ctx: [*c]fz_context, out: [*c]fz_output) [*c]fz_band_writer;
pub extern fn fz_write_ps_file_header(ctx: [*c]fz_context, out: [*c]fz_output) void;
pub extern fn fz_write_ps_file_trailer(ctx: [*c]fz_context, out: [*c]fz_output, pages: c_int) void;
pub extern fn fz_save_pixmap_as_psd(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, filename: [*c]const u8) void;
pub extern fn fz_write_pixmap_as_psd(ctx: [*c]fz_context, out: [*c]fz_output, pixmap: [*c]const fz_pixmap) void;
pub extern fn fz_new_psd_band_writer(ctx: [*c]fz_context, out: [*c]fz_output) [*c]fz_band_writer;
pub const fz_pwg_options = extern struct {
    media_class: [64]u8 = @import("std").mem.zeroes([64]u8),
    media_color: [64]u8 = @import("std").mem.zeroes([64]u8),
    media_type: [64]u8 = @import("std").mem.zeroes([64]u8),
    output_type: [64]u8 = @import("std").mem.zeroes([64]u8),
    advance_distance: c_uint = 0,
    advance_media: c_int = 0,
    collate: c_int = 0,
    cut_media: c_int = 0,
    duplex: c_int = 0,
    insert_sheet: c_int = 0,
    jog: c_int = 0,
    leading_edge: c_int = 0,
    manual_feed: c_int = 0,
    media_position: c_uint = 0,
    media_weight: c_uint = 0,
    mirror_print: c_int = 0,
    negative_print: c_int = 0,
    num_copies: c_uint = 0,
    orientation: c_int = 0,
    output_face_up: c_int = 0,
    PageSize: [2]c_uint = @import("std").mem.zeroes([2]c_uint),
    separations: c_int = 0,
    tray_switch: c_int = 0,
    tumble: c_int = 0,
    media_type_num: c_int = 0,
    compression: c_int = 0,
    row_count: c_uint = 0,
    row_feed: c_uint = 0,
    row_step: c_uint = 0,
    rendering_intent: [64]u8 = @import("std").mem.zeroes([64]u8),
    page_size_name: [64]u8 = @import("std").mem.zeroes([64]u8),
};
pub extern fn fz_save_pixmap_as_pwg(ctx: [*c]fz_context, pixmap: [*c]fz_pixmap, filename: [*c]u8, append: c_int, pwg: [*c]const fz_pwg_options) void;
pub extern fn fz_save_bitmap_as_pwg(ctx: [*c]fz_context, bitmap: [*c]fz_bitmap, filename: [*c]u8, append: c_int, pwg: [*c]const fz_pwg_options) void;
pub extern fn fz_write_pixmap_as_pwg(ctx: [*c]fz_context, out: [*c]fz_output, pixmap: [*c]const fz_pixmap, pwg: [*c]const fz_pwg_options) void;
pub extern fn fz_write_bitmap_as_pwg(ctx: [*c]fz_context, out: [*c]fz_output, bitmap: [*c]const fz_bitmap, pwg: [*c]const fz_pwg_options) void;
pub extern fn fz_write_pixmap_as_pwg_page(ctx: [*c]fz_context, out: [*c]fz_output, pixmap: [*c]const fz_pixmap, pwg: [*c]const fz_pwg_options) void;
pub extern fn fz_write_bitmap_as_pwg_page(ctx: [*c]fz_context, out: [*c]fz_output, bitmap: [*c]const fz_bitmap, pwg: [*c]const fz_pwg_options) void;
pub extern fn fz_new_mono_pwg_band_writer(ctx: [*c]fz_context, out: [*c]fz_output, pwg: [*c]const fz_pwg_options) [*c]fz_band_writer;
pub extern fn fz_new_pwg_band_writer(ctx: [*c]fz_context, out: [*c]fz_output, pwg: [*c]const fz_pwg_options) [*c]fz_band_writer;
pub extern fn fz_write_pwg_file_header(ctx: [*c]fz_context, out: [*c]fz_output) void;
pub const FZ_SVG_TEXT_AS_PATH: c_int = 0;
pub const FZ_SVG_TEXT_AS_TEXT: c_int = 1;
const enum_unnamed_53 = c_uint;
pub extern fn fz_new_svg_device(ctx: [*c]fz_context, out: [*c]fz_output, page_width: f32, page_height: f32, text_format: c_int, reuse_images: c_int) [*c]fz_device;
pub extern fn fz_new_svg_device_with_id(ctx: [*c]fz_context, out: [*c]fz_output, page_width: f32, page_height: f32, text_format: c_int, reuse_images: c_int, id: [*c]c_int) [*c]fz_device;
pub const struct_fz_story = opaque {};
pub const fz_story = struct_fz_story;
pub extern fn fz_new_story(ctx: [*c]fz_context, buf: [*c]fz_buffer, user_css: [*c]const u8, em: f32, archive: [*c]fz_archive) ?*fz_story;
pub extern fn fz_story_warnings(ctx: [*c]fz_context, story: ?*fz_story) [*c]const u8;
pub extern fn fz_place_story(ctx: [*c]fz_context, story: ?*fz_story, where: fz_rect, filled: [*c]fz_rect) c_int;
pub extern fn fz_draw_story(ctx: [*c]fz_context, story: ?*fz_story, dev: [*c]fz_device, ctm: fz_matrix) void;
pub extern fn fz_reset_story(ctx: [*c]fz_context, story: ?*fz_story) void;
pub extern fn fz_drop_story(ctx: [*c]fz_context, story: ?*fz_story) void;
pub extern fn fz_story_document(ctx: [*c]fz_context, story: ?*fz_story) ?*fz_xml;
pub const fz_story_element_position = extern struct {
    depth: c_int = 0,
    heading: c_int = 0,
    id: [*c]const u8 = null,
    href: [*c]const u8 = null,
    rect: fz_rect = @import("std").mem.zeroes(fz_rect),
    text: [*c]const u8 = null,
    open_close: c_int = 0,
    rectangle_num: c_int = 0,
};
pub const fz_story_position_callback = fn (ctx: [*c]fz_context, arg: ?*anyopaque, [*c]const fz_story_element_position) callconv(.c) void;
pub extern fn fz_story_positions(ctx: [*c]fz_context, story: ?*fz_story, cb: ?*const fz_story_position_callback, arg: ?*anyopaque) void;
pub const fz_write_story_position = extern struct {
    element: fz_story_element_position = @import("std").mem.zeroes(fz_story_element_position),
    page_num: c_int = 0,
};
pub const fz_write_story_positions = extern struct {
    positions: [*c]fz_write_story_position = null,
    num: c_int = 0,
};
pub const fz_write_story_rectfn = fn (ctx: [*c]fz_context, ref: ?*anyopaque, num: c_int, filled: fz_rect, rect: [*c]fz_rect, ctm: [*c]fz_matrix, mediabox: [*c]fz_rect) callconv(.c) c_int;
pub const fz_write_story_positionfn = fn (ctx: [*c]fz_context, ref: ?*anyopaque, position: [*c]const fz_write_story_position) callconv(.c) void;
pub const fz_write_story_pagefn = fn (ctx: [*c]fz_context, ref: ?*anyopaque, page_num: c_int, mediabox: fz_rect, dev: [*c]fz_device, after: c_int) callconv(.c) void;
pub const fz_write_story_contentfn = fn (ctx: [*c]fz_context, ref: ?*anyopaque, positions: [*c]const fz_write_story_positions, buffer: [*c]fz_buffer) callconv(.c) void;
pub extern fn fz_write_story(ctx: [*c]fz_context, writer: [*c]fz_document_writer, story: ?*fz_story, rectfn: ?*const fz_write_story_rectfn, rectfn_ref: ?*anyopaque, positionfn: ?*const fz_write_story_positionfn, positionfn_ref: ?*anyopaque, pagefn: ?*const fz_write_story_pagefn, pagefn_ref: ?*anyopaque) void;
pub extern fn fz_write_stabilized_story(ctx: [*c]fz_context, writer: [*c]fz_document_writer, user_css: [*c]const u8, em: f32, contentfn: ?*const fz_write_story_contentfn, contentfn_ref: ?*anyopaque, rectfn: ?*const fz_write_story_rectfn, rectfn_ref: ?*anyopaque, pagefn: ?*const fz_write_story_pagefn, pagefn_ref: ?*anyopaque, archive: [*c]fz_archive) void;

pub const __VERSION__ = "Aro aro-zig";
pub const __Aro__ = "";
pub const __STDC__ = @as(c_int, 1);
pub const __STDC_HOSTED__ = @as(c_int, 1);
pub const __STDC_UTF_16__ = @as(c_int, 1);
pub const __STDC_UTF_32__ = @as(c_int, 1);
pub const __STDC_EMBED_NOT_FOUND__ = @as(c_int, 0);
pub const __STDC_EMBED_FOUND__ = @as(c_int, 1);
pub const __STDC_EMBED_EMPTY__ = @as(c_int, 2);
pub const __STDC_VERSION__ = @as(c_long, 201710);
pub const __GNUC__ = @as(c_int, 7);
pub const __GNUC_MINOR__ = @as(c_int, 1);
pub const __GNUC_PATCHLEVEL__ = @as(c_int, 0);
pub const __ARO_EMULATE_NO__ = @as(c_int, 0);
pub const __ARO_EMULATE_CLANG__ = @as(c_int, 1);
pub const __ARO_EMULATE_GCC__ = @as(c_int, 2);
pub const __ARO_EMULATE_MSVC__ = @as(c_int, 3);
pub const __ARO_EMULATE__ = __ARO_EMULATE_GCC__;
pub inline fn __building_module(x: anytype) @TypeOf(@as(c_int, 0)) {
    _ = &x;
    return @as(c_int, 0);
}
pub const linux = @as(c_int, 1);
pub const __linux = @as(c_int, 1);
pub const __linux__ = @as(c_int, 1);
pub const unix = @as(c_int, 1);
pub const __unix = @as(c_int, 1);
pub const __unix__ = @as(c_int, 1);
pub const __code_model_small__ = @as(c_int, 1);
pub const __amd64__ = @as(c_int, 1);
pub const __amd64 = @as(c_int, 1);
pub const __x86_64__ = @as(c_int, 1);
pub const __x86_64 = @as(c_int, 1);
pub const __SEG_GS = @as(c_int, 1);
pub const __SEG_FS = @as(c_int, 1);
pub const __seg_gs = @compileError("unable to translate macro: undefined identifier `address_space`"); // <builtin>:33:9
pub const __seg_fs = @compileError("unable to translate macro: undefined identifier `address_space`"); // <builtin>:34:9
pub const __LAHF_SAHF__ = @as(c_int, 1);
pub const __AES__ = @as(c_int, 1);
pub const __PCLMUL__ = @as(c_int, 1);
pub const __LZCNT__ = @as(c_int, 1);
pub const __RDRND__ = @as(c_int, 1);
pub const __FSGSBASE__ = @as(c_int, 1);
pub const __BMI__ = @as(c_int, 1);
pub const __BMI2__ = @as(c_int, 1);
pub const __POPCNT__ = @as(c_int, 1);
pub const __PRFCHW__ = @as(c_int, 1);
pub const __RDSEED__ = @as(c_int, 1);
pub const __ADX__ = @as(c_int, 1);
pub const __MOVBE__ = @as(c_int, 1);
pub const __FMA__ = @as(c_int, 1);
pub const __F16C__ = @as(c_int, 1);
pub const __FXSR__ = @as(c_int, 1);
pub const __XSAVE__ = @as(c_int, 1);
pub const __XSAVEOPT__ = @as(c_int, 1);
pub const __XSAVEC__ = @as(c_int, 1);
pub const __XSAVES__ = @as(c_int, 1);
pub const __CLFLUSHOPT__ = @as(c_int, 1);
pub const __SGX__ = @as(c_int, 1);
pub const __INVPCID__ = @as(c_int, 1);
pub const __CRC32__ = @as(c_int, 1);
pub const __AVX2__ = @as(c_int, 1);
pub const __AVX__ = @as(c_int, 1);
pub const __SSE4_2__ = @as(c_int, 1);
pub const __SSE4_1__ = @as(c_int, 1);
pub const __SSSE3__ = @as(c_int, 1);
pub const __SSE3__ = @as(c_int, 1);
pub const __SSE2__ = @as(c_int, 1);
pub const __SSE__ = @as(c_int, 1);
pub const __SSE_MATH__ = @as(c_int, 1);
pub const __MMX__ = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 = @as(c_int, 1);
pub const __SIZEOF_FLOAT128__ = @as(c_int, 16);
pub const _LP64 = @as(c_int, 1);
pub const __LP64__ = @as(c_int, 1);
pub const __FLOAT128__ = @as(c_int, 1);
pub const __ORDER_LITTLE_ENDIAN__ = @as(c_int, 1234);
pub const __ORDER_BIG_ENDIAN__ = @as(c_int, 4321);
pub const __ORDER_PDP_ENDIAN__ = @as(c_int, 3412);
pub const __BYTE_ORDER__ = __ORDER_LITTLE_ENDIAN__;
pub const __LITTLE_ENDIAN__ = @as(c_int, 1);
pub const __ELF__ = @as(c_int, 1);
pub const __ATOMIC_RELAXED = @as(c_int, 0);
pub const __ATOMIC_CONSUME = @as(c_int, 1);
pub const __ATOMIC_ACQUIRE = @as(c_int, 2);
pub const __ATOMIC_RELEASE = @as(c_int, 3);
pub const __ATOMIC_ACQ_REL = @as(c_int, 4);
pub const __ATOMIC_SEQ_CST = @as(c_int, 5);
pub const __ATOMIC_BOOL_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_CHAR_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_WINT_T_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_SHORT_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_INT_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_LONG_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_LLONG_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_POINTER_LOCK_FREE = @as(c_int, 1);
pub const __WINT_UNSIGNED__ = @as(c_int, 1);
pub const __CHAR_BIT__ = @as(c_int, 8);
pub const __BOOL_WIDTH__ = @as(c_int, 8);
pub const __SCHAR_MAX__ = @as(c_int, 127);
pub const __SCHAR_WIDTH__ = @as(c_int, 8);
pub const __SHRT_MAX__ = @as(c_int, 32767);
pub const __SHRT_WIDTH__ = @as(c_int, 16);
pub const __INT_MAX__ = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_WIDTH__ = @as(c_int, 32);
pub const __LONG_MAX__ = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __LONG_WIDTH__ = @as(c_int, 64);
pub const __LONG_LONG_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __LONG_LONG_WIDTH__ = @as(c_int, 64);
pub const __WCHAR_MAX__ = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __WCHAR_WIDTH__ = @as(c_int, 32);
pub const __WINT_MAX__ = __helpers.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __WINT_WIDTH__ = @as(c_int, 32);
pub const __INTMAX_MAX__ = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INTMAX_WIDTH__ = @as(c_int, 64);
pub const __SIZE_MAX__ = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __SIZE_WIDTH__ = @as(c_int, 64);
pub const __UINTMAX_MAX__ = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINTMAX_WIDTH__ = @as(c_int, 64);
pub const __PTRDIFF_MAX__ = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __PTRDIFF_WIDTH__ = @as(c_int, 64);
pub const __INTPTR_MAX__ = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INTPTR_WIDTH__ = @as(c_int, 64);
pub const __UINTPTR_MAX__ = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINTPTR_WIDTH__ = @as(c_int, 64);
pub const __SIG_ATOMIC_MAX__ = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __SIG_ATOMIC_WIDTH__ = @as(c_int, 32);
pub const __BITINT_MAXWIDTH__ = __helpers.promoteIntLiteral(c_int, 65535, .decimal);
pub const __SIZEOF_FLOAT__ = @as(c_int, 4);
pub const __SIZEOF_DOUBLE__ = @as(c_int, 8);
pub const __SIZEOF_LONG_DOUBLE__ = @as(c_int, 10);
pub const __SIZEOF_SHORT__ = @as(c_int, 2);
pub const __SIZEOF_INT__ = @as(c_int, 4);
pub const __SIZEOF_LONG__ = @as(c_int, 8);
pub const __SIZEOF_LONG_LONG__ = @as(c_int, 8);
pub const __SIZEOF_POINTER__ = @as(c_int, 8);
pub const __SIZEOF_PTRDIFF_T__ = @as(c_int, 8);
pub const __SIZEOF_SIZE_T__ = @as(c_int, 8);
pub const __SIZEOF_WCHAR_T__ = @as(c_int, 4);
pub const __SIZEOF_WINT_T__ = @as(c_int, 4);
pub const __SIZEOF_INT128__ = @as(c_int, 16);
pub const __INTPTR_TYPE__ = c_long;
pub const __UINTPTR_TYPE__ = c_ulong;
pub const __INTMAX_TYPE__ = c_long;
pub const __INTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `L`"); // <builtin>:146:9
pub const __INTMAX_C = __helpers.L_SUFFIX;
pub const __UINTMAX_TYPE__ = c_ulong;
pub const __UINTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `UL`"); // <builtin>:149:9
pub const __UINTMAX_C = __helpers.UL_SUFFIX;
pub const __PTRDIFF_TYPE__ = c_long;
pub const __SIZE_TYPE__ = c_ulong;
pub const __WCHAR_TYPE__ = c_int;
pub const __WINT_TYPE__ = c_uint;
pub const __CHAR16_TYPE__ = c_ushort;
pub const __CHAR32_TYPE__ = c_uint;
pub const __INT8_TYPE__ = i8;
pub const __INT8_FMTd__ = "hhd";
pub const __INT8_FMTi__ = "hhi";
pub const __INT8_C_SUFFIX__ = "";
pub inline fn __INT8_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const __INT16_TYPE__ = c_short;
pub const __INT16_FMTd__ = "hd";
pub const __INT16_FMTi__ = "hi";
pub const __INT16_C_SUFFIX__ = "";
pub inline fn __INT16_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const __INT32_TYPE__ = c_int;
pub const __INT32_FMTd__ = "d";
pub const __INT32_FMTi__ = "i";
pub const __INT32_C_SUFFIX__ = "";
pub inline fn __INT32_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const __INT64_TYPE__ = c_long;
pub const __INT64_FMTd__ = "ld";
pub const __INT64_FMTi__ = "li";
pub const __INT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `L`"); // <builtin>:175:9
pub const __INT64_C = __helpers.L_SUFFIX;
pub const __UINT8_TYPE__ = u8;
pub const __UINT8_FMTo__ = "hho";
pub const __UINT8_FMTu__ = "hhu";
pub const __UINT8_FMTx__ = "hhx";
pub const __UINT8_FMTX__ = "hhX";
pub const __UINT8_C_SUFFIX__ = "";
pub inline fn __UINT8_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const __UINT8_MAX__ = @as(c_int, 255);
pub const __INT8_MAX__ = @as(c_int, 127);
pub const __UINT16_TYPE__ = c_ushort;
pub const __UINT16_FMTo__ = "ho";
pub const __UINT16_FMTu__ = "hu";
pub const __UINT16_FMTx__ = "hx";
pub const __UINT16_FMTX__ = "hX";
pub const __UINT16_C_SUFFIX__ = "";
pub inline fn __UINT16_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const __UINT16_MAX__ = __helpers.promoteIntLiteral(c_int, 65535, .decimal);
pub const __INT16_MAX__ = @as(c_int, 32767);
pub const __UINT32_TYPE__ = c_uint;
pub const __UINT32_FMTo__ = "o";
pub const __UINT32_FMTu__ = "u";
pub const __UINT32_FMTx__ = "x";
pub const __UINT32_FMTX__ = "X";
pub const __UINT32_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `U`"); // <builtin>:200:9
pub const __UINT32_C = __helpers.U_SUFFIX;
pub const __UINT32_MAX__ = __helpers.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __INT32_MAX__ = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __UINT64_TYPE__ = c_ulong;
pub const __UINT64_FMTo__ = "lo";
pub const __UINT64_FMTu__ = "lu";
pub const __UINT64_FMTx__ = "lx";
pub const __UINT64_FMTX__ = "lX";
pub const __UINT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `UL`"); // <builtin>:209:9
pub const __UINT64_C = __helpers.UL_SUFFIX;
pub const __UINT64_MAX__ = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __INT64_MAX__ = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_LEAST8_TYPE__ = i8;
pub const __INT_LEAST8_MAX__ = @as(c_int, 127);
pub const __INT_LEAST8_WIDTH__ = @as(c_int, 8);
pub const INT_LEAST8_FMTd__ = "hhd";
pub const INT_LEAST8_FMTi__ = "hhi";
pub const __UINT_LEAST8_TYPE__ = u8;
pub const __UINT_LEAST8_MAX__ = @as(c_int, 255);
pub const UINT_LEAST8_FMTo__ = "hho";
pub const UINT_LEAST8_FMTu__ = "hhu";
pub const UINT_LEAST8_FMTx__ = "hhx";
pub const UINT_LEAST8_FMTX__ = "hhX";
pub const __INT_FAST8_TYPE__ = i8;
pub const __INT_FAST8_MAX__ = @as(c_int, 127);
pub const __INT_FAST8_WIDTH__ = @as(c_int, 8);
pub const INT_FAST8_FMTd__ = "hhd";
pub const INT_FAST8_FMTi__ = "hhi";
pub const __UINT_FAST8_TYPE__ = u8;
pub const __UINT_FAST8_MAX__ = @as(c_int, 255);
pub const UINT_FAST8_FMTo__ = "hho";
pub const UINT_FAST8_FMTu__ = "hhu";
pub const UINT_FAST8_FMTx__ = "hhx";
pub const UINT_FAST8_FMTX__ = "hhX";
pub const __INT_LEAST16_TYPE__ = c_short;
pub const __INT_LEAST16_MAX__ = @as(c_int, 32767);
pub const __INT_LEAST16_WIDTH__ = @as(c_int, 16);
pub const INT_LEAST16_FMTd__ = "hd";
pub const INT_LEAST16_FMTi__ = "hi";
pub const __UINT_LEAST16_TYPE__ = c_ushort;
pub const __UINT_LEAST16_MAX__ = __helpers.promoteIntLiteral(c_int, 65535, .decimal);
pub const UINT_LEAST16_FMTo__ = "ho";
pub const UINT_LEAST16_FMTu__ = "hu";
pub const UINT_LEAST16_FMTx__ = "hx";
pub const UINT_LEAST16_FMTX__ = "hX";
pub const __INT_FAST16_TYPE__ = c_short;
pub const __INT_FAST16_MAX__ = @as(c_int, 32767);
pub const __INT_FAST16_WIDTH__ = @as(c_int, 16);
pub const INT_FAST16_FMTd__ = "hd";
pub const INT_FAST16_FMTi__ = "hi";
pub const __UINT_FAST16_TYPE__ = c_ushort;
pub const __UINT_FAST16_MAX__ = __helpers.promoteIntLiteral(c_int, 65535, .decimal);
pub const UINT_FAST16_FMTo__ = "ho";
pub const UINT_FAST16_FMTu__ = "hu";
pub const UINT_FAST16_FMTx__ = "hx";
pub const UINT_FAST16_FMTX__ = "hX";
pub const __INT_LEAST32_TYPE__ = c_int;
pub const __INT_LEAST32_MAX__ = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_LEAST32_WIDTH__ = @as(c_int, 32);
pub const INT_LEAST32_FMTd__ = "d";
pub const INT_LEAST32_FMTi__ = "i";
pub const __UINT_LEAST32_TYPE__ = c_uint;
pub const __UINT_LEAST32_MAX__ = __helpers.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const UINT_LEAST32_FMTo__ = "o";
pub const UINT_LEAST32_FMTu__ = "u";
pub const UINT_LEAST32_FMTx__ = "x";
pub const UINT_LEAST32_FMTX__ = "X";
pub const __INT_FAST32_TYPE__ = c_int;
pub const __INT_FAST32_MAX__ = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_FAST32_WIDTH__ = @as(c_int, 32);
pub const INT_FAST32_FMTd__ = "d";
pub const INT_FAST32_FMTi__ = "i";
pub const __UINT_FAST32_TYPE__ = c_uint;
pub const __UINT_FAST32_MAX__ = __helpers.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const UINT_FAST32_FMTo__ = "o";
pub const UINT_FAST32_FMTu__ = "u";
pub const UINT_FAST32_FMTx__ = "x";
pub const UINT_FAST32_FMTX__ = "X";
pub const __INT_LEAST64_TYPE__ = c_long;
pub const __INT_LEAST64_MAX__ = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_LEAST64_WIDTH__ = @as(c_int, 64);
pub const INT_LEAST64_FMTd__ = "ld";
pub const INT_LEAST64_FMTi__ = "li";
pub const __UINT_LEAST64_TYPE__ = c_ulong;
pub const __UINT_LEAST64_MAX__ = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const UINT_LEAST64_FMTo__ = "lo";
pub const UINT_LEAST64_FMTu__ = "lu";
pub const UINT_LEAST64_FMTx__ = "lx";
pub const UINT_LEAST64_FMTX__ = "lX";
pub const __INT_FAST64_TYPE__ = c_long;
pub const __INT_FAST64_MAX__ = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_FAST64_WIDTH__ = @as(c_int, 64);
pub const INT_FAST64_FMTd__ = "ld";
pub const INT_FAST64_FMTi__ = "li";
pub const __UINT_FAST64_TYPE__ = c_ulong;
pub const __UINT_FAST64_MAX__ = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const UINT_FAST64_FMTo__ = "lo";
pub const UINT_FAST64_FMTu__ = "lu";
pub const UINT_FAST64_FMTx__ = "lx";
pub const UINT_FAST64_FMTX__ = "lX";
pub const __FLT16_DENORM_MIN__ = @as(f16, 5.9604644775390625e-8);
pub const __FLT16_HAS_DENORM__ = "";
pub const __FLT16_DIG__ = @as(c_int, 3);
pub const __FLT16_DECIMAL_DIG__ = @as(c_int, 5);
pub const __FLT16_EPSILON__ = @as(f16, 9.765625e-4);
pub const __FLT16_HAS_INFINITY__ = "";
pub const __FLT16_HAS_QUIET_NAN__ = "";
pub const __FLT16_MANT_DIG__ = @as(c_int, 11);
pub const __FLT16_MAX_10_EXP__ = @as(c_int, 4);
pub const __FLT16_MAX_EXP__ = @as(c_int, 16);
pub const __FLT16_MAX__ = @as(f16, 6.5504e+4);
pub const __FLT16_MIN_10_EXP__ = -@as(c_int, 4);
pub const __FLT16_MIN_EXP__ = -@as(c_int, 13);
pub const __FLT16_MIN__ = @as(f16, 6.103515625e-5);
pub const __FLT_DENORM_MIN__ = @as(f32, 1.40129846e-45);
pub const __FLT_HAS_DENORM__ = "";
pub const __FLT_DIG__ = @as(c_int, 6);
pub const __FLT_DECIMAL_DIG__ = @as(c_int, 9);
pub const __FLT_EPSILON__ = @as(f32, 1.19209290e-7);
pub const __FLT_HAS_INFINITY__ = "";
pub const __FLT_HAS_QUIET_NAN__ = "";
pub const __FLT_MANT_DIG__ = @as(c_int, 24);
pub const __FLT_MAX_10_EXP__ = @as(c_int, 38);
pub const __FLT_MAX_EXP__ = @as(c_int, 128);
pub const __FLT_MAX__ = @as(f32, 3.40282347e+38);
pub const __FLT_MIN_10_EXP__ = -@as(c_int, 37);
pub const __FLT_MIN_EXP__ = -@as(c_int, 125);
pub const __FLT_MIN__ = @as(f32, 1.17549435e-38);
pub const __DBL_DENORM_MIN__ = @as(f64, 4.9406564584124654e-324);
pub const __DBL_HAS_DENORM__ = "";
pub const __DBL_DIG__ = @as(c_int, 15);
pub const __DBL_DECIMAL_DIG__ = @as(c_int, 17);
pub const __DBL_EPSILON__ = @as(f64, 2.2204460492503131e-16);
pub const __DBL_HAS_INFINITY__ = "";
pub const __DBL_HAS_QUIET_NAN__ = "";
pub const __DBL_MANT_DIG__ = @as(c_int, 53);
pub const __DBL_MAX_10_EXP__ = @as(c_int, 308);
pub const __DBL_MAX_EXP__ = @as(c_int, 1024);
pub const __DBL_MAX__ = @as(f64, 1.7976931348623157e+308);
pub const __DBL_MIN_10_EXP__ = -@as(c_int, 307);
pub const __DBL_MIN_EXP__ = -@as(c_int, 1021);
pub const __DBL_MIN__ = @as(f64, 2.2250738585072014e-308);
pub const __LDBL_DENORM_MIN__ = @as(c_longdouble, 3.64519953188247460253e-4951);
pub const __LDBL_HAS_DENORM__ = "";
pub const __LDBL_DIG__ = @as(c_int, 18);
pub const __LDBL_DECIMAL_DIG__ = @as(c_int, 21);
pub const __LDBL_EPSILON__ = @as(c_longdouble, 1.08420217248550443401e-19);
pub const __LDBL_HAS_INFINITY__ = "";
pub const __LDBL_HAS_QUIET_NAN__ = "";
pub const __LDBL_MANT_DIG__ = @as(c_int, 64);
pub const __LDBL_MAX_10_EXP__ = @as(c_int, 4932);
pub const __LDBL_MAX_EXP__ = @as(c_int, 16384);
pub const __LDBL_MAX__ = @as(c_longdouble, 1.18973149535723176502e+4932);
pub const __LDBL_MIN_10_EXP__ = -@as(c_int, 4931);
pub const __LDBL_MIN_EXP__ = -@as(c_int, 16381);
pub const __LDBL_MIN__ = @as(c_longdouble, 3.36210314311209350626e-4932);
pub const __FLT_EVAL_METHOD__ = @as(c_int, 0);
pub const __FLT_RADIX__ = @as(c_int, 2);
pub const __DECIMAL_DIG__ = __LDBL_DECIMAL_DIG__;
pub const __pic__ = @as(c_int, 2);
pub const __PIC__ = @as(c_int, 2);
pub const __GLIBC_MINOR__ = @as(c_int, 39);
pub const MUDPF_FITZ_H = "";
pub const MUPDF_FITZ_VERSION_H = "";
pub const FZ_VERSION = "1.23.10";
pub const FZ_VERSION_MAJOR = @as(c_int, 1);
pub const FZ_VERSION_MINOR = @as(c_int, 23);
pub const FZ_VERSION_PATCH = @as(c_int, 10);
pub const FZ_CONFIG_H = "";
pub const FZ_ENABLE_SPOT_RENDERING = @as(c_int, 1);
pub const FZ_PLOTTERS_N = @as(c_int, 1);
pub const FZ_PLOTTERS_G = @as(c_int, 1);
pub const FZ_PLOTTERS_RGB = @as(c_int, 1);
pub const FZ_PLOTTERS_CMYK = @as(c_int, 1);
pub const FZ_ENABLE_PDF = @as(c_int, 1);
pub const FZ_ENABLE_XPS = @as(c_int, 1);
pub const FZ_ENABLE_SVG = @as(c_int, 1);
pub const FZ_ENABLE_CBZ = @as(c_int, 1);
pub const FZ_ENABLE_IMG = @as(c_int, 1);
pub const FZ_ENABLE_HTML = @as(c_int, 1);
pub const FZ_ENABLE_EPUB = @as(c_int, 1);
pub const FZ_ENABLE_OCR_OUTPUT = @as(c_int, 1);
pub const FZ_ENABLE_ODT_OUTPUT = @as(c_int, 1);
pub const FZ_ENABLE_DOCX_OUTPUT = @as(c_int, 1);
pub const FZ_ENABLE_JPX = @as(c_int, 1);
pub const FZ_ENABLE_JS = @as(c_int, 1);
pub const FZ_ENABLE_ICC = @as(c_int, 1);
pub const OCR_DISABLED = "";
pub const MUPDF_FITZ_SYSTEM_H = "";
pub const PACIFY_VALGRIND = "";
pub const __STDC_VERSION_STDDEF_H__ = @as(c_long, 202311);
pub const NULL = __helpers.cast(?*anyopaque, @as(c_int, 0));
pub const offsetof = @compileError("unable to translate macro: undefined identifier `__builtin_offsetof`"); // /usr/local/zig-x86_64-linux-0.17.0-dev.269+ebff43698/lib/compiler/aro/include/stddef.h:18:9
pub const __STDC_VERSION_STDARG_H__ = @as(c_int, 0);
pub const va_start = @compileError("unable to translate macro: undefined identifier `__builtin_va_start`"); // /usr/local/zig-x86_64-linux-0.17.0-dev.269+ebff43698/lib/compiler/aro/include/stdarg.h:12:9
pub const va_end = @compileError("unable to translate macro: undefined identifier `__builtin_va_end`"); // /usr/local/zig-x86_64-linux-0.17.0-dev.269+ebff43698/lib/compiler/aro/include/stdarg.h:14:9
pub const va_arg = @compileError("unable to translate macro: undefined identifier `__builtin_va_arg`"); // /usr/local/zig-x86_64-linux-0.17.0-dev.269+ebff43698/lib/compiler/aro/include/stdarg.h:15:9
pub const __va_copy = @compileError("unable to translate macro: undefined identifier `__builtin_va_copy`"); // /usr/local/zig-x86_64-linux-0.17.0-dev.269+ebff43698/lib/compiler/aro/include/stdarg.h:18:9
pub const va_copy = @compileError("unable to translate macro: undefined identifier `__builtin_va_copy`"); // /usr/local/zig-x86_64-linux-0.17.0-dev.269+ebff43698/lib/compiler/aro/include/stdarg.h:22:9
pub const __GNUC_VA_LIST = @as(c_int, 1);
pub const _SETJMP_H = @as(c_int, 1);
pub const _FEATURES_H = @as(c_int, 1);
pub const __KERNEL_STRICT_NAMES = "";
pub inline fn __GNUC_PREREQ(maj: anytype, min: anytype) @TypeOf(((__GNUC__ << @as(c_int, 16)) + __GNUC_MINOR__) >= ((maj << @as(c_int, 16)) + min)) {
    _ = &maj;
    _ = &min;
    return ((__GNUC__ << @as(c_int, 16)) + __GNUC_MINOR__) >= ((maj << @as(c_int, 16)) + min);
}
pub inline fn __glibc_clang_prereq(maj: anytype, min: anytype) @TypeOf(@as(c_int, 0)) {
    _ = &maj;
    _ = &min;
    return @as(c_int, 0);
}
pub const __GLIBC_USE = @compileError("unable to translate macro: undefined identifier `__GLIBC_USE_`"); // /usr/include/features.h:188:9
pub const _DEFAULT_SOURCE = @as(c_int, 1);
pub const __GLIBC_USE_ISOC2X = @as(c_int, 0);
pub const __USE_ISOC11 = @as(c_int, 1);
pub const __USE_POSIX_IMPLICITLY = @as(c_int, 1);
pub const _POSIX_SOURCE = @as(c_int, 1);
pub const _POSIX_C_SOURCE = @as(c_long, 200809);
pub const __USE_POSIX = @as(c_int, 1);
pub const __USE_POSIX2 = @as(c_int, 1);
pub const __USE_POSIX199309 = @as(c_int, 1);
pub const __USE_POSIX199506 = @as(c_int, 1);
pub const __USE_XOPEN2K = @as(c_int, 1);
pub const __USE_ISOC95 = @as(c_int, 1);
pub const __USE_ISOC99 = @as(c_int, 1);
pub const __USE_XOPEN2K8 = @as(c_int, 1);
pub const _ATFILE_SOURCE = @as(c_int, 1);
pub const __WORDSIZE = @as(c_int, 64);
pub const __WORDSIZE_TIME64_COMPAT32 = @as(c_int, 1);
pub const __SYSCALL_WORDSIZE = @as(c_int, 64);
pub const __TIMESIZE = __WORDSIZE;
pub const __USE_MISC = @as(c_int, 1);
pub const __USE_ATFILE = @as(c_int, 1);
pub const __USE_FORTIFY_LEVEL = @as(c_int, 0);
pub const __GLIBC_USE_DEPRECATED_GETS = @as(c_int, 0);
pub const __GLIBC_USE_DEPRECATED_SCANF = @as(c_int, 0);
pub const __GLIBC_USE_C2X_STRTOL = @as(c_int, 0);
pub const _STDC_PREDEF_H = @as(c_int, 1);
pub const __STDC_IEC_559__ = @as(c_int, 1);
pub const __STDC_IEC_60559_BFP__ = @as(c_long, 201404);
pub const __STDC_IEC_559_COMPLEX__ = @as(c_int, 1);
pub const __STDC_IEC_60559_COMPLEX__ = @as(c_long, 201404);
pub const __STDC_ISO_10646__ = @as(c_long, 201706);
pub const __GNU_LIBRARY__ = @as(c_int, 6);
pub const __GLIBC__ = @as(c_int, 2);
pub inline fn __GLIBC_PREREQ(maj: anytype, min: anytype) @TypeOf(((__GLIBC__ << @as(c_int, 16)) + __GLIBC_MINOR__) >= ((maj << @as(c_int, 16)) + min)) {
    _ = &maj;
    _ = &min;
    return ((__GLIBC__ << @as(c_int, 16)) + __GLIBC_MINOR__) >= ((maj << @as(c_int, 16)) + min);
}
pub const _SYS_CDEFS_H = @as(c_int, 1);
pub const __glibc_has_attribute = @compileError("unable to translate macro: undefined identifier `__has_attribute`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:45:10
pub inline fn __glibc_has_builtin(name: anytype) @TypeOf(__builtin.has_builtin(name)) {
    _ = &name;
    return __builtin.has_builtin(name);
}
pub const __glibc_has_extension = @compileError("unable to translate macro: undefined identifier `__has_extension`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:55:10
pub const __LEAF = @compileError("unable to translate macro: undefined identifier `__leaf__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:65:11
pub const __LEAF_ATTR = @compileError("unable to translate macro: undefined identifier `__leaf__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:66:11
pub const __THROW = @compileError("unable to translate macro: undefined identifier `__nothrow__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:79:11
pub const __THROWNL = @compileError("unable to translate macro: undefined identifier `__nothrow__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:80:11
pub const __NTH = @compileError("unable to translate macro: undefined identifier `__nothrow__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:81:11
pub const __NTHNL = @compileError("unable to translate macro: undefined identifier `__nothrow__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:82:11
pub const __COLD = @compileError("unable to translate macro: undefined identifier `__cold__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:102:11
pub inline fn __P(args: anytype) @TypeOf(args) {
    _ = &args;
    return args;
}
pub inline fn __PMT(args: anytype) @TypeOf(args) {
    _ = &args;
    return args;
}
pub const __CONCAT = @compileError("unable to translate C expr: unexpected token '##'"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:131:9
pub const __STRING = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:132:9
pub const __ptr_t = ?*anyopaque;
pub const __BEGIN_DECLS = "";
pub const __END_DECLS = "";
pub inline fn __bos(ptr: anytype) @TypeOf(__builtin.object_size(ptr, __USE_FORTIFY_LEVEL > @as(c_int, 1))) {
    _ = &ptr;
    return __builtin.object_size(ptr, __USE_FORTIFY_LEVEL > @as(c_int, 1));
}
pub inline fn __bos0(ptr: anytype) @TypeOf(__builtin.object_size(ptr, @as(c_int, 0))) {
    _ = &ptr;
    return __builtin.object_size(ptr, @as(c_int, 0));
}
pub inline fn __glibc_objsize0(__o: anytype) @TypeOf(__bos0(__o)) {
    _ = &__o;
    return __bos0(__o);
}
pub inline fn __glibc_objsize(__o: anytype) @TypeOf(__bos(__o)) {
    _ = &__o;
    return __bos(__o);
}
pub const __warnattr = @compileError("unable to translate macro: undefined identifier `__warning__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:212:10
pub const __errordecl = @compileError("unable to translate macro: undefined identifier `__error__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:213:10
pub const __flexarr = @compileError("unable to translate C expr: unexpected token '['"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:225:10
pub const __glibc_c99_flexarr_available = @as(c_int, 1);
pub const __REDIRECT = @compileError("unable to translate C expr: unexpected token '__asm__'"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:256:10
pub const __REDIRECT_NTH = @compileError("unable to translate C expr: unexpected token '__asm__'"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:263:11
pub const __REDIRECT_NTHNL = @compileError("unable to translate C expr: unexpected token '__asm__'"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:265:11
pub const __ASMNAME = @compileError("unable to translate macro: undefined identifier `__USER_LABEL_PREFIX__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:268:10
pub inline fn __ASMNAME2(prefix: anytype, cname: anytype) @TypeOf(__STRING(prefix) ++ cname) {
    _ = &prefix;
    _ = &cname;
    return __STRING(prefix) ++ cname;
}
pub const __REDIRECT_FORTIFY = __REDIRECT;
pub const __REDIRECT_FORTIFY_NTH = __REDIRECT_NTH;
pub const __attribute_malloc__ = @compileError("unable to translate macro: undefined identifier `__malloc__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:298:10
pub const __attribute_alloc_size__ = @compileError("unable to translate macro: undefined identifier `__alloc_size__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:306:10
pub const __attribute_alloc_align__ = @compileError("unable to translate macro: undefined identifier `__alloc_align__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:315:10
pub const __attribute_pure__ = @compileError("unable to translate macro: undefined identifier `__pure__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:325:10
pub const __attribute_const__ = @compileError("unable to translate C expr: unexpected token '__attribute__'"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:332:10
pub const __attribute_maybe_unused__ = @compileError("unable to translate macro: undefined identifier `__unused__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:338:10
pub const __attribute_used__ = @compileError("unable to translate macro: undefined identifier `__used__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:347:10
pub const __attribute_noinline__ = @compileError("unable to translate macro: undefined identifier `__noinline__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:348:10
pub const __attribute_deprecated__ = @compileError("unable to translate macro: undefined identifier `__deprecated__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:356:10
pub const __attribute_deprecated_msg__ = @compileError("unable to translate macro: undefined identifier `__deprecated__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:366:10
pub const __attribute_format_arg__ = @compileError("unable to translate macro: undefined identifier `__format_arg__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:379:10
pub const __attribute_format_strfmon__ = @compileError("unable to translate macro: undefined identifier `__format__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:389:10
pub const __attribute_nonnull__ = @compileError("unable to translate macro: undefined identifier `__nonnull__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:401:11
pub inline fn __nonnull(params: anytype) @TypeOf(__attribute_nonnull__(params)) {
    _ = &params;
    return __attribute_nonnull__(params);
}
pub const __returns_nonnull = @compileError("unable to translate macro: undefined identifier `__returns_nonnull__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:414:10
pub const __attribute_warn_unused_result__ = @compileError("unable to translate macro: undefined identifier `__warn_unused_result__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:423:10
pub const __wur = "";
pub const __always_inline = @compileError("unable to translate macro: undefined identifier `__always_inline__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:441:10
pub const __attribute_artificial__ = @compileError("unable to translate macro: undefined identifier `__artificial__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:450:10
pub const __extern_inline = @compileError("unable to translate C expr: unexpected token 'extern'"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:472:11
pub const __extern_always_inline = @compileError("unable to translate C expr: unexpected token 'extern'"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:473:11
pub const __fortify_function = __extern_always_inline ++ __attribute_artificial__;
pub const __va_arg_pack = @compileError("unable to translate macro: undefined identifier `__builtin_va_arg_pack`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:484:10
pub const __va_arg_pack_len = @compileError("unable to translate macro: undefined identifier `__builtin_va_arg_pack_len`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:485:10
pub const __restrict_arr = @compileError("unable to translate C expr: unexpected token '__restrict'"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:512:10
pub inline fn __glibc_unlikely(cond: anytype) @TypeOf(__builtin.expect(cond, @as(c_int, 0))) {
    _ = &cond;
    return __builtin.expect(cond, @as(c_int, 0));
}
pub inline fn __glibc_likely(cond: anytype) @TypeOf(__builtin.expect(cond, @as(c_int, 1))) {
    _ = &cond;
    return __builtin.expect(cond, @as(c_int, 1));
}
pub const __attribute_nonstring__ = "";
pub inline fn __attribute_copy__(arg: anytype) void {
    _ = &arg;
    return;
}
pub const __LDOUBLE_REDIRECTS_TO_FLOAT128_ABI = @as(c_int, 0);
pub inline fn __LDBL_REDIR1(name: anytype, proto: anytype, alias: anytype) @TypeOf(name ++ proto) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return name ++ proto;
}
pub inline fn __LDBL_REDIR(name: anytype, proto: anytype) @TypeOf(name ++ proto) {
    _ = &name;
    _ = &proto;
    return name ++ proto;
}
pub inline fn __LDBL_REDIR1_NTH(name: anytype, proto: anytype, alias: anytype) @TypeOf(name ++ proto ++ __THROW) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return name ++ proto ++ __THROW;
}
pub inline fn __LDBL_REDIR_NTH(name: anytype, proto: anytype) @TypeOf(name ++ proto ++ __THROW) {
    _ = &name;
    _ = &proto;
    return name ++ proto ++ __THROW;
}
pub inline fn __LDBL_REDIR2_DECL(name: anytype) void {
    _ = &name;
    return;
}
pub inline fn __LDBL_REDIR_DECL(name: anytype) void {
    _ = &name;
    return;
}
pub inline fn __REDIRECT_LDBL(name: anytype, proto: anytype, alias: anytype) @TypeOf(__REDIRECT(name, proto, alias)) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return __REDIRECT(name, proto, alias);
}
pub inline fn __REDIRECT_NTH_LDBL(name: anytype, proto: anytype, alias: anytype) @TypeOf(__REDIRECT_NTH(name, proto, alias)) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return __REDIRECT_NTH(name, proto, alias);
}
pub const __glibc_macro_warning1 = @compileError("unable to translate macro: undefined identifier `_Pragma`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:653:10
pub const __glibc_macro_warning = @compileError("unable to translate macro: undefined identifier `GCC`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:654:10
pub const __HAVE_GENERIC_SELECTION = @as(c_int, 1);
pub inline fn __fortified_attr_access(a: anytype, o: anytype, s: anytype) void {
    _ = &a;
    _ = &o;
    _ = &s;
    return;
}
pub inline fn __attr_access(x: anytype) void {
    _ = &x;
    return;
}
pub inline fn __attr_access_none(argno: anytype) void {
    _ = &argno;
    return;
}
pub inline fn __attr_dealloc(dealloc: anytype, argno: anytype) void {
    _ = &dealloc;
    _ = &argno;
    return;
}
pub const __attr_dealloc_free = "";
pub const __attribute_returns_twice__ = @compileError("unable to translate macro: undefined identifier `__returns_twice__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:718:10
pub const __stub___compat_bdflush = "";
pub const __stub_chflags = "";
pub const __stub_fchflags = "";
pub const __stub_gtty = "";
pub const __stub_revoke = "";
pub const __stub_setlogin = "";
pub const __stub_sigreturn = "";
pub const __stub_stty = "";
pub const _BITS_SETJMP_H = @as(c_int, 1);
pub const __jmp_buf_tag_defined = @as(c_int, 1);
pub const ____sigset_t_defined = "";
pub const _SIGSET_NWORDS = __helpers.div(@as(c_int, 1024), @as(c_int, 8) * __helpers.sizeof(c_ulong));
pub inline fn sigsetjmp(env: anytype, savemask: anytype) @TypeOf(__sigsetjmp(env, savemask)) {
    _ = &env;
    _ = &savemask;
    return __sigsetjmp(env, savemask);
}
pub const _STDIO_H = @as(c_int, 1);
pub const __need_size_t = "";
pub const __need_NULL = "";
pub const __need___va_list = "";
pub const _BITS_TYPES_H = @as(c_int, 1);
pub const __S16_TYPE = c_short;
pub const __U16_TYPE = c_ushort;
pub const __S32_TYPE = c_int;
pub const __U32_TYPE = c_uint;
pub const __SLONGWORD_TYPE = c_long;
pub const __ULONGWORD_TYPE = c_ulong;
pub const __SQUAD_TYPE = c_long;
pub const __UQUAD_TYPE = c_ulong;
pub const __SWORD_TYPE = c_long;
pub const __UWORD_TYPE = c_ulong;
pub const __SLONG32_TYPE = c_int;
pub const __ULONG32_TYPE = c_uint;
pub const __S64_TYPE = c_long;
pub const __U64_TYPE = c_ulong;
pub const _BITS_TYPESIZES_H = @as(c_int, 1);
pub const __SYSCALL_SLONG_TYPE = __SLONGWORD_TYPE;
pub const __SYSCALL_ULONG_TYPE = __ULONGWORD_TYPE;
pub const __DEV_T_TYPE = __UQUAD_TYPE;
pub const __UID_T_TYPE = __U32_TYPE;
pub const __GID_T_TYPE = __U32_TYPE;
pub const __INO_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __INO64_T_TYPE = __UQUAD_TYPE;
pub const __MODE_T_TYPE = __U32_TYPE;
pub const __NLINK_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSWORD_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __OFF_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __OFF64_T_TYPE = __SQUAD_TYPE;
pub const __PID_T_TYPE = __S32_TYPE;
pub const __RLIM_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __RLIM64_T_TYPE = __UQUAD_TYPE;
pub const __BLKCNT_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __BLKCNT64_T_TYPE = __SQUAD_TYPE;
pub const __FSBLKCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSBLKCNT64_T_TYPE = __UQUAD_TYPE;
pub const __FSFILCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSFILCNT64_T_TYPE = __UQUAD_TYPE;
pub const __ID_T_TYPE = __U32_TYPE;
pub const __CLOCK_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __TIME_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __USECONDS_T_TYPE = __U32_TYPE;
pub const __SUSECONDS_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __SUSECONDS64_T_TYPE = __SQUAD_TYPE;
pub const __DADDR_T_TYPE = __S32_TYPE;
pub const __KEY_T_TYPE = __S32_TYPE;
pub const __CLOCKID_T_TYPE = __S32_TYPE;
pub const __TIMER_T_TYPE = ?*anyopaque;
pub const __BLKSIZE_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __FSID_T_TYPE = @compileError("unable to translate macro: undefined identifier `__val`"); // /usr/include/x86_64-linux-gnu/bits/typesizes.h:73:9
pub const __SSIZE_T_TYPE = __SWORD_TYPE;
pub const __CPU_MASK_TYPE = __SYSCALL_ULONG_TYPE;
pub const __OFF_T_MATCHES_OFF64_T = @as(c_int, 1);
pub const __INO_T_MATCHES_INO64_T = @as(c_int, 1);
pub const __RLIM_T_MATCHES_RLIM64_T = @as(c_int, 1);
pub const __STATFS_MATCHES_STATFS64 = @as(c_int, 1);
pub const __KERNEL_OLD_TIMEVAL_MATCHES_TIMEVAL64 = @as(c_int, 1);
pub const __FD_SETSIZE = @as(c_int, 1024);
pub const _BITS_TIME64_H = @as(c_int, 1);
pub const __TIME64_T_TYPE = __TIME_T_TYPE;
pub const _____fpos_t_defined = @as(c_int, 1);
pub const ____mbstate_t_defined = @as(c_int, 1);
pub const _____fpos64_t_defined = @as(c_int, 1);
pub const ____FILE_defined = @as(c_int, 1);
pub const __FILE_defined = @as(c_int, 1);
pub const __struct_FILE_defined = @as(c_int, 1);
pub const __getc_unlocked_body = @compileError("TODO postfix inc/dec expr"); // /usr/include/x86_64-linux-gnu/bits/types/struct_FILE.h:102:9
pub const __putc_unlocked_body = @compileError("TODO postfix inc/dec expr"); // /usr/include/x86_64-linux-gnu/bits/types/struct_FILE.h:106:9
pub const _IO_EOF_SEEN = @as(c_int, 0x0010);
pub inline fn __feof_unlocked_body(_fp: anytype) @TypeOf((_fp.*._flags & _IO_EOF_SEEN) != @as(c_int, 0)) {
    _ = &_fp;
    return (_fp.*._flags & _IO_EOF_SEEN) != @as(c_int, 0);
}
pub const _IO_ERR_SEEN = @as(c_int, 0x0020);
pub inline fn __ferror_unlocked_body(_fp: anytype) @TypeOf((_fp.*._flags & _IO_ERR_SEEN) != @as(c_int, 0)) {
    _ = &_fp;
    return (_fp.*._flags & _IO_ERR_SEEN) != @as(c_int, 0);
}
pub const _IO_USER_LOCK = __helpers.promoteIntLiteral(c_int, 0x8000, .hex);
pub const __cookie_io_functions_t_defined = @as(c_int, 1);
pub const _VA_LIST_DEFINED = "";
pub const __off_t_defined = "";
pub const __ssize_t_defined = "";
pub const _IOFBF = @as(c_int, 0);
pub const _IOLBF = @as(c_int, 1);
pub const _IONBF = @as(c_int, 2);
pub const BUFSIZ = @as(c_int, 8192);
pub const EOF = -@as(c_int, 1);
pub const SEEK_SET = @as(c_int, 0);
pub const SEEK_CUR = @as(c_int, 1);
pub const SEEK_END = @as(c_int, 2);
pub const P_tmpdir = "/tmp";
pub const L_tmpnam = @as(c_int, 20);
pub const TMP_MAX = __helpers.promoteIntLiteral(c_int, 238328, .decimal);
pub const _BITS_STDIO_LIM_H = @as(c_int, 1);
pub const FILENAME_MAX = @as(c_int, 4096);
pub const L_ctermid = @as(c_int, 9);
pub const FOPEN_MAX = @as(c_int, 16);
pub const __attr_dealloc_fclose = __attr_dealloc(fclose, @as(c_int, 1));
pub const _BITS_FLOATN_H = "";
pub const __HAVE_FLOAT128 = @as(c_int, 1);
pub const __HAVE_DISTINCT_FLOAT128 = @as(c_int, 1);
pub const __HAVE_FLOAT64X = @as(c_int, 1);
pub const __HAVE_FLOAT64X_LONG_DOUBLE = @as(c_int, 1);
pub const __f128 = @compileError("unable to translate macro: undefined identifier `f128`"); // /usr/include/x86_64-linux-gnu/bits/floatn.h:65:12
pub const __CFLOAT128 = @compileError("unable to translate: invalid numeric type"); // /usr/include/x86_64-linux-gnu/bits/floatn.h:77:12
pub const _BITS_FLOATN_COMMON_H = "";
pub const __HAVE_FLOAT16 = @as(c_int, 0);
pub const __HAVE_FLOAT32 = @as(c_int, 1);
pub const __HAVE_FLOAT64 = @as(c_int, 1);
pub const __HAVE_FLOAT32X = @as(c_int, 1);
pub const __HAVE_FLOAT128X = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT16 = __HAVE_FLOAT16;
pub const __HAVE_DISTINCT_FLOAT32 = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT64 = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT32X = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT64X = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT128X = __HAVE_FLOAT128X;
pub const __HAVE_FLOAT128_UNLIKE_LDBL = (__HAVE_DISTINCT_FLOAT128 != 0) and (__LDBL_MANT_DIG__ != @as(c_int, 113));
pub const __HAVE_FLOATN_NOT_TYPEDEF = @as(c_int, 1);
pub const __f32 = @compileError("unable to translate macro: undefined identifier `f32`"); // /usr/include/x86_64-linux-gnu/bits/floatn-common.h:93:12
pub const __f64 = @compileError("unable to translate macro: undefined identifier `f64`"); // /usr/include/x86_64-linux-gnu/bits/floatn-common.h:105:12
pub const __f32x = @compileError("unable to translate macro: undefined identifier `f32x`"); // /usr/include/x86_64-linux-gnu/bits/floatn-common.h:113:12
pub const __f64x = @compileError("unable to translate macro: undefined identifier `f64x`"); // /usr/include/x86_64-linux-gnu/bits/floatn-common.h:125:12
pub const __CFLOAT32 = @compileError("unable to translate: invalid numeric type"); // /usr/include/x86_64-linux-gnu/bits/floatn-common.h:151:12
pub const __CFLOAT64 = @compileError("unable to translate: invalid numeric type"); // /usr/include/x86_64-linux-gnu/bits/floatn-common.h:163:12
pub const __CFLOAT32X = @compileError("unable to translate: invalid numeric type"); // /usr/include/x86_64-linux-gnu/bits/floatn-common.h:171:12
pub const __CFLOAT64X = @compileError("unable to translate: invalid numeric type"); // /usr/include/x86_64-linux-gnu/bits/floatn-common.h:183:12
pub const MUPDF_FITZ_EXPORT_H = "";
pub const FZ_FUNCTION = "";
pub const FZ_DATA = "";
pub const __CLANG_STDINT_H = "";
pub const _STDINT_H = @as(c_int, 1);
pub const _BITS_WCHAR_H = @as(c_int, 1);
pub const __WCHAR_MAX = __WCHAR_MAX__;
pub const __WCHAR_MIN = -__WCHAR_MAX - @as(c_int, 1);
pub const _BITS_STDINT_INTN_H = @as(c_int, 1);
pub const _BITS_STDINT_UINTN_H = @as(c_int, 1);
pub const _BITS_STDINT_LEAST_H = @as(c_int, 1);
pub const __intptr_t_defined = "";
pub const INT8_MIN = -@as(c_int, 128);
pub const INT16_MIN = -@as(c_int, 32767) - @as(c_int, 1);
pub const INT32_MIN = -__helpers.promoteIntLiteral(c_int, 2147483647, .decimal) - @as(c_int, 1);
pub const INT64_MIN = -__INT64_C(__helpers.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INT8_MAX = @as(c_int, 127);
pub const INT16_MAX = @as(c_int, 32767);
pub const INT32_MAX = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const INT64_MAX = __INT64_C(__helpers.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINT8_MAX = @as(c_int, 255);
pub const UINT16_MAX = __helpers.promoteIntLiteral(c_int, 65535, .decimal);
pub const UINT32_MAX = __helpers.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const UINT64_MAX = __UINT64_C(__helpers.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const INT_LEAST8_MIN = -@as(c_int, 128);
pub const INT_LEAST16_MIN = -@as(c_int, 32767) - @as(c_int, 1);
pub const INT_LEAST32_MIN = -__helpers.promoteIntLiteral(c_int, 2147483647, .decimal) - @as(c_int, 1);
pub const INT_LEAST64_MIN = -__INT64_C(__helpers.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INT_LEAST8_MAX = @as(c_int, 127);
pub const INT_LEAST16_MAX = @as(c_int, 32767);
pub const INT_LEAST32_MAX = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const INT_LEAST64_MAX = __INT64_C(__helpers.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINT_LEAST8_MAX = @as(c_int, 255);
pub const UINT_LEAST16_MAX = __helpers.promoteIntLiteral(c_int, 65535, .decimal);
pub const UINT_LEAST32_MAX = __helpers.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const UINT_LEAST64_MAX = __UINT64_C(__helpers.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const INT_FAST8_MIN = -@as(c_int, 128);
pub const INT_FAST16_MIN = -__helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const INT_FAST32_MIN = -__helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const INT_FAST64_MIN = -__INT64_C(__helpers.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INT_FAST8_MAX = @as(c_int, 127);
pub const INT_FAST16_MAX = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const INT_FAST32_MAX = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const INT_FAST64_MAX = __INT64_C(__helpers.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINT_FAST8_MAX = @as(c_int, 255);
pub const UINT_FAST16_MAX = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const UINT_FAST32_MAX = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const UINT_FAST64_MAX = __UINT64_C(__helpers.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const INTPTR_MIN = -__helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const INTPTR_MAX = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const UINTPTR_MAX = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const INTMAX_MIN = -__INT64_C(__helpers.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INTMAX_MAX = __INT64_C(__helpers.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINTMAX_MAX = __UINT64_C(__helpers.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const PTRDIFF_MIN = -__helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const PTRDIFF_MAX = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const SIG_ATOMIC_MIN = -__helpers.promoteIntLiteral(c_int, 2147483647, .decimal) - @as(c_int, 1);
pub const SIG_ATOMIC_MAX = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const SIZE_MAX = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const WCHAR_MIN = __WCHAR_MIN;
pub const WCHAR_MAX = __WCHAR_MAX;
pub const WINT_MIN = @as(c_uint, 0);
pub const WINT_MAX = __helpers.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub inline fn INT8_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub inline fn INT16_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub inline fn INT32_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const INT64_C = __helpers.L_SUFFIX;
pub inline fn UINT8_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub inline fn UINT16_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const UINT32_C = __helpers.U_SUFFIX;
pub const UINT64_C = __helpers.UL_SUFFIX;
pub const INTMAX_C = __helpers.L_SUFFIX;
pub const UINTMAX_C = __helpers.UL_SUFFIX;
pub const __need_wchar_t = "";
pub const _STDLIB_H = @as(c_int, 1);
pub const WNOHANG = @as(c_int, 1);
pub const WUNTRACED = @as(c_int, 2);
pub const WSTOPPED = @as(c_int, 2);
pub const WEXITED = @as(c_int, 4);
pub const WCONTINUED = @as(c_int, 8);
pub const WNOWAIT = __helpers.promoteIntLiteral(c_int, 0x01000000, .hex);
pub const __WNOTHREAD = __helpers.promoteIntLiteral(c_int, 0x20000000, .hex);
pub const __WALL = __helpers.promoteIntLiteral(c_int, 0x40000000, .hex);
pub const __WCLONE = __helpers.promoteIntLiteral(c_int, 0x80000000, .hex);
pub inline fn __WEXITSTATUS(status: anytype) @TypeOf((status & __helpers.promoteIntLiteral(c_int, 0xff00, .hex)) >> @as(c_int, 8)) {
    _ = &status;
    return (status & __helpers.promoteIntLiteral(c_int, 0xff00, .hex)) >> @as(c_int, 8);
}
pub inline fn __WTERMSIG(status: anytype) @TypeOf(status & @as(c_int, 0x7f)) {
    _ = &status;
    return status & @as(c_int, 0x7f);
}
pub inline fn __WSTOPSIG(status: anytype) @TypeOf(__WEXITSTATUS(status)) {
    _ = &status;
    return __WEXITSTATUS(status);
}
pub inline fn __WIFEXITED(status: anytype) @TypeOf(__WTERMSIG(status) == @as(c_int, 0)) {
    _ = &status;
    return __WTERMSIG(status) == @as(c_int, 0);
}
pub inline fn __WIFSIGNALED(status: anytype) @TypeOf((__helpers.cast(i8, (status & @as(c_int, 0x7f)) + @as(c_int, 1)) >> @as(c_int, 1)) > @as(c_int, 0)) {
    _ = &status;
    return (__helpers.cast(i8, (status & @as(c_int, 0x7f)) + @as(c_int, 1)) >> @as(c_int, 1)) > @as(c_int, 0);
}
pub inline fn __WIFSTOPPED(status: anytype) @TypeOf((status & @as(c_int, 0xff)) == @as(c_int, 0x7f)) {
    _ = &status;
    return (status & @as(c_int, 0xff)) == @as(c_int, 0x7f);
}
pub inline fn __WIFCONTINUED(status: anytype) @TypeOf(status == __W_CONTINUED) {
    _ = &status;
    return status == __W_CONTINUED;
}
pub inline fn __WCOREDUMP(status: anytype) @TypeOf(status & __WCOREFLAG) {
    _ = &status;
    return status & __WCOREFLAG;
}
pub inline fn __W_EXITCODE(ret: anytype, sig: anytype) @TypeOf((ret << @as(c_int, 8)) | sig) {
    _ = &ret;
    _ = &sig;
    return (ret << @as(c_int, 8)) | sig;
}
pub inline fn __W_STOPCODE(sig: anytype) @TypeOf((sig << @as(c_int, 8)) | @as(c_int, 0x7f)) {
    _ = &sig;
    return (sig << @as(c_int, 8)) | @as(c_int, 0x7f);
}
pub const __W_CONTINUED = __helpers.promoteIntLiteral(c_int, 0xffff, .hex);
pub const __WCOREFLAG = @as(c_int, 0x80);
pub inline fn WEXITSTATUS(status: anytype) @TypeOf(__WEXITSTATUS(status)) {
    _ = &status;
    return __WEXITSTATUS(status);
}
pub inline fn WTERMSIG(status: anytype) @TypeOf(__WTERMSIG(status)) {
    _ = &status;
    return __WTERMSIG(status);
}
pub inline fn WSTOPSIG(status: anytype) @TypeOf(__WSTOPSIG(status)) {
    _ = &status;
    return __WSTOPSIG(status);
}
pub inline fn WIFEXITED(status: anytype) @TypeOf(__WIFEXITED(status)) {
    _ = &status;
    return __WIFEXITED(status);
}
pub inline fn WIFSIGNALED(status: anytype) @TypeOf(__WIFSIGNALED(status)) {
    _ = &status;
    return __WIFSIGNALED(status);
}
pub inline fn WIFSTOPPED(status: anytype) @TypeOf(__WIFSTOPPED(status)) {
    _ = &status;
    return __WIFSTOPPED(status);
}
pub inline fn WIFCONTINUED(status: anytype) @TypeOf(__WIFCONTINUED(status)) {
    _ = &status;
    return __WIFCONTINUED(status);
}
pub const __ldiv_t_defined = @as(c_int, 1);
pub const __lldiv_t_defined = @as(c_int, 1);
pub const RAND_MAX = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const EXIT_FAILURE = @as(c_int, 1);
pub const EXIT_SUCCESS = @as(c_int, 0);
pub const MB_CUR_MAX = __ctype_get_mb_cur_max();
pub const _SYS_TYPES_H = @as(c_int, 1);
pub const __u_char_defined = "";
pub const __ino_t_defined = "";
pub const __dev_t_defined = "";
pub const __gid_t_defined = "";
pub const __mode_t_defined = "";
pub const __nlink_t_defined = "";
pub const __uid_t_defined = "";
pub const __pid_t_defined = "";
pub const __id_t_defined = "";
pub const __daddr_t_defined = "";
pub const __key_t_defined = "";
pub const __clock_t_defined = @as(c_int, 1);
pub const __clockid_t_defined = @as(c_int, 1);
pub const __time_t_defined = @as(c_int, 1);
pub const __timer_t_defined = @as(c_int, 1);
pub const __BIT_TYPES_DEFINED__ = @as(c_int, 1);
pub const _ENDIAN_H = @as(c_int, 1);
pub const _BITS_ENDIAN_H = @as(c_int, 1);
pub const __LITTLE_ENDIAN = @as(c_int, 1234);
pub const __BIG_ENDIAN = @as(c_int, 4321);
pub const __PDP_ENDIAN = @as(c_int, 3412);
pub const _BITS_ENDIANNESS_H = @as(c_int, 1);
pub const __BYTE_ORDER = __LITTLE_ENDIAN;
pub const __FLOAT_WORD_ORDER = __BYTE_ORDER;
pub inline fn __LONG_LONG_PAIR(HI: anytype, LO: anytype) @TypeOf(HI) {
    _ = &HI;
    _ = &LO;
    return blk: {
        _ = &LO;
        break :blk HI;
    };
}
pub const LITTLE_ENDIAN = __LITTLE_ENDIAN;
pub const BIG_ENDIAN = __BIG_ENDIAN;
pub const PDP_ENDIAN = __PDP_ENDIAN;
pub const BYTE_ORDER = __BYTE_ORDER;
pub const _BITS_BYTESWAP_H = @as(c_int, 1);
pub inline fn __bswap_constant_16(x: anytype) __uint16_t {
    _ = &x;
    return __helpers.cast(__uint16_t, ((x >> @as(c_int, 8)) & @as(c_int, 0xff)) | ((x & @as(c_int, 0xff)) << @as(c_int, 8)));
}
pub inline fn __bswap_constant_32(x: anytype) @TypeOf(((((x & __helpers.promoteIntLiteral(c_uint, 0xff000000, .hex)) >> @as(c_int, 24)) | ((x & __helpers.promoteIntLiteral(c_uint, 0x00ff0000, .hex)) >> @as(c_int, 8))) | ((x & @as(c_uint, 0x0000ff00)) << @as(c_int, 8))) | ((x & @as(c_uint, 0x000000ff)) << @as(c_int, 24))) {
    _ = &x;
    return ((((x & __helpers.promoteIntLiteral(c_uint, 0xff000000, .hex)) >> @as(c_int, 24)) | ((x & __helpers.promoteIntLiteral(c_uint, 0x00ff0000, .hex)) >> @as(c_int, 8))) | ((x & @as(c_uint, 0x0000ff00)) << @as(c_int, 8))) | ((x & @as(c_uint, 0x000000ff)) << @as(c_int, 24));
}
pub inline fn __bswap_constant_64(x: anytype) @TypeOf(((((((((x & @as(c_ulonglong, 0xff00000000000000)) >> @as(c_int, 56)) | ((x & @as(c_ulonglong, 0x00ff000000000000)) >> @as(c_int, 40))) | ((x & @as(c_ulonglong, 0x0000ff0000000000)) >> @as(c_int, 24))) | ((x & @as(c_ulonglong, 0x000000ff00000000)) >> @as(c_int, 8))) | ((x & @as(c_ulonglong, 0x00000000ff000000)) << @as(c_int, 8))) | ((x & @as(c_ulonglong, 0x0000000000ff0000)) << @as(c_int, 24))) | ((x & @as(c_ulonglong, 0x000000000000ff00)) << @as(c_int, 40))) | ((x & @as(c_ulonglong, 0x00000000000000ff)) << @as(c_int, 56))) {
    _ = &x;
    return ((((((((x & @as(c_ulonglong, 0xff00000000000000)) >> @as(c_int, 56)) | ((x & @as(c_ulonglong, 0x00ff000000000000)) >> @as(c_int, 40))) | ((x & @as(c_ulonglong, 0x0000ff0000000000)) >> @as(c_int, 24))) | ((x & @as(c_ulonglong, 0x000000ff00000000)) >> @as(c_int, 8))) | ((x & @as(c_ulonglong, 0x00000000ff000000)) << @as(c_int, 8))) | ((x & @as(c_ulonglong, 0x0000000000ff0000)) << @as(c_int, 24))) | ((x & @as(c_ulonglong, 0x000000000000ff00)) << @as(c_int, 40))) | ((x & @as(c_ulonglong, 0x00000000000000ff)) << @as(c_int, 56));
}
pub const _BITS_UINTN_IDENTITY_H = @as(c_int, 1);
pub inline fn htobe16(x: anytype) @TypeOf(__bswap_16(x)) {
    _ = &x;
    return __bswap_16(x);
}
pub inline fn htole16(x: anytype) @TypeOf(__uint16_identity(x)) {
    _ = &x;
    return __uint16_identity(x);
}
pub inline fn be16toh(x: anytype) @TypeOf(__bswap_16(x)) {
    _ = &x;
    return __bswap_16(x);
}
pub inline fn le16toh(x: anytype) @TypeOf(__uint16_identity(x)) {
    _ = &x;
    return __uint16_identity(x);
}
pub inline fn htobe32(x: anytype) @TypeOf(__bswap_32(x)) {
    _ = &x;
    return __bswap_32(x);
}
pub inline fn htole32(x: anytype) @TypeOf(__uint32_identity(x)) {
    _ = &x;
    return __uint32_identity(x);
}
pub inline fn be32toh(x: anytype) @TypeOf(__bswap_32(x)) {
    _ = &x;
    return __bswap_32(x);
}
pub inline fn le32toh(x: anytype) @TypeOf(__uint32_identity(x)) {
    _ = &x;
    return __uint32_identity(x);
}
pub inline fn htobe64(x: anytype) @TypeOf(__bswap_64(x)) {
    _ = &x;
    return __bswap_64(x);
}
pub inline fn htole64(x: anytype) @TypeOf(__uint64_identity(x)) {
    _ = &x;
    return __uint64_identity(x);
}
pub inline fn be64toh(x: anytype) @TypeOf(__bswap_64(x)) {
    _ = &x;
    return __bswap_64(x);
}
pub inline fn le64toh(x: anytype) @TypeOf(__uint64_identity(x)) {
    _ = &x;
    return __uint64_identity(x);
}
pub const _SYS_SELECT_H = @as(c_int, 1);
pub const __FD_ZERO = @compileError("unable to translate macro: undefined identifier `__i`"); // /usr/include/x86_64-linux-gnu/bits/select.h:25:9
pub const __FD_SET = @compileError("unable to translate C expr: expected ')' instead got '|='"); // /usr/include/x86_64-linux-gnu/bits/select.h:32:9
pub const __FD_CLR = @compileError("unable to translate C expr: expected ')' instead got '&='"); // /usr/include/x86_64-linux-gnu/bits/select.h:34:9
pub inline fn __FD_ISSET(d: anytype, s: anytype) @TypeOf((__FDS_BITS(s)[@as(usize, @intCast(__FD_ELT(d)))] & __FD_MASK(d)) != @as(c_int, 0)) {
    _ = &d;
    _ = &s;
    return (__FDS_BITS(s)[@as(usize, @intCast(__FD_ELT(d)))] & __FD_MASK(d)) != @as(c_int, 0);
}
pub const __sigset_t_defined = @as(c_int, 1);
pub const __timeval_defined = @as(c_int, 1);
pub const _STRUCT_TIMESPEC = @as(c_int, 1);
pub const __suseconds_t_defined = "";
pub const __NFDBITS = @as(c_int, 8) * __helpers.cast(c_int, __helpers.sizeof(__fd_mask));
pub inline fn __FD_ELT(d: anytype) @TypeOf(__helpers.div(d, __NFDBITS)) {
    _ = &d;
    return __helpers.div(d, __NFDBITS);
}
pub inline fn __FD_MASK(d: anytype) __fd_mask {
    _ = &d;
    return __helpers.cast(__fd_mask, @as(c_ulong, 1) << __helpers.rem(d, __NFDBITS));
}
pub inline fn __FDS_BITS(set: anytype) @TypeOf(set.*.__fds_bits) {
    _ = &set;
    return set.*.__fds_bits;
}
pub const FD_SETSIZE = __FD_SETSIZE;
pub const NFDBITS = __NFDBITS;
pub inline fn FD_SET(fd: anytype, fdsetp: anytype) @TypeOf(__FD_SET(fd, fdsetp)) {
    _ = &fd;
    _ = &fdsetp;
    return __FD_SET(fd, fdsetp);
}
pub inline fn FD_CLR(fd: anytype, fdsetp: anytype) @TypeOf(__FD_CLR(fd, fdsetp)) {
    _ = &fd;
    _ = &fdsetp;
    return __FD_CLR(fd, fdsetp);
}
pub inline fn FD_ISSET(fd: anytype, fdsetp: anytype) @TypeOf(__FD_ISSET(fd, fdsetp)) {
    _ = &fd;
    _ = &fdsetp;
    return __FD_ISSET(fd, fdsetp);
}
pub inline fn FD_ZERO(fdsetp: anytype) @TypeOf(__FD_ZERO(fdsetp)) {
    _ = &fdsetp;
    return __FD_ZERO(fdsetp);
}
pub const __blksize_t_defined = "";
pub const __blkcnt_t_defined = "";
pub const __fsblkcnt_t_defined = "";
pub const __fsfilcnt_t_defined = "";
pub const _BITS_PTHREADTYPES_COMMON_H = @as(c_int, 1);
pub const _THREAD_SHARED_TYPES_H = @as(c_int, 1);
pub const _BITS_PTHREADTYPES_ARCH_H = @as(c_int, 1);
pub const __SIZEOF_PTHREAD_MUTEX_T = @as(c_int, 40);
pub const __SIZEOF_PTHREAD_ATTR_T = @as(c_int, 56);
pub const __SIZEOF_PTHREAD_RWLOCK_T = @as(c_int, 56);
pub const __SIZEOF_PTHREAD_BARRIER_T = @as(c_int, 32);
pub const __SIZEOF_PTHREAD_MUTEXATTR_T = @as(c_int, 4);
pub const __SIZEOF_PTHREAD_COND_T = @as(c_int, 48);
pub const __SIZEOF_PTHREAD_CONDATTR_T = @as(c_int, 4);
pub const __SIZEOF_PTHREAD_RWLOCKATTR_T = @as(c_int, 8);
pub const __SIZEOF_PTHREAD_BARRIERATTR_T = @as(c_int, 4);
pub const __LOCK_ALIGNMENT = "";
pub const __ONCE_ALIGNMENT = "";
pub const _BITS_ATOMIC_WIDE_COUNTER_H = "";
pub const _THREAD_MUTEX_INTERNAL_H = @as(c_int, 1);
pub const __PTHREAD_MUTEX_HAVE_PREV = @as(c_int, 1);
pub const __PTHREAD_MUTEX_INITIALIZER = @compileError("unable to translate C expr: unexpected token '{'"); // /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:56:10
pub const _RWLOCK_INTERNAL_H = "";
pub const __PTHREAD_RWLOCK_ELISION_EXTRA = @compileError("unable to translate C expr: unexpected token '{'"); // /usr/include/x86_64-linux-gnu/bits/struct_rwlock.h:40:11
pub inline fn __PTHREAD_RWLOCK_INITIALIZER(__flags: anytype) @TypeOf(__flags) {
    _ = &__flags;
    return blk: {
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = &__PTHREAD_RWLOCK_ELISION_EXTRA;
        _ = @as(c_int, 0);
        break :blk __flags;
    };
}
pub const __ONCE_FLAG_INIT = @compileError("unable to translate C expr: unexpected token '{'"); // /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:113:9
pub const __have_pthread_attr_t = @as(c_int, 1);
pub const _ALLOCA_H = @as(c_int, 1);
pub const __COMPAR_FN_T = "";
pub const _STRING_H = @as(c_int, 1);
pub const __GLIBC_USE_LIB_EXT2 = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_BFP_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_BFP_EXT_C2X = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_FUNCS_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_FUNCS_EXT_C2X = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_TYPES_EXT = @as(c_int, 0);
pub const _BITS_TYPES_LOCALE_T_H = @as(c_int, 1);
pub const _BITS_TYPES___LOCALE_T_H = @as(c_int, 1);
pub const _STRINGS_H = @as(c_int, 1);
pub const MEMENTO_H = "";
pub const MEMENTO_UNDERLYING_MALLOC = malloc;
pub const MEMENTO_UNDERLYING_FREE = free;
pub const MEMENTO_UNDERLYING_REALLOC = realloc;
pub const MEMENTO_UNDERLYING_CALLOC = calloc;
pub const MEMENTO_MAXALIGN = __helpers.sizeof(c_int);
pub const MEMENTO_PREFILL = @as(c_int, 0xa6);
pub const MEMENTO_POSTFILL = @as(c_int, 0xa7);
pub const MEMENTO_ALLOCFILL = @as(c_int, 0xa8);
pub const MEMENTO_FREEFILL = @as(c_int, 0xa9);
pub const TRACK_USAGE_H = "";
pub const TRACK_LABEL = @compileError("unable to translate C expr: unexpected token 'do'"); // /usr/include/mupdf/fitz/track-usage.h:52:9
pub const TRACK_FN = @compileError("unable to translate C expr: unexpected token 'do'"); // /usr/include/mupdf/fitz/track-usage.h:53:9
pub inline fn nelem(x: anytype) @TypeOf(__helpers.div(__helpers.sizeof(x), __helpers.sizeof(x[@as(usize, @intCast(@as(c_int, 0)))]))) {
    _ = &x;
    return __helpers.div(__helpers.sizeof(x), __helpers.sizeof(x[@as(usize, @intCast(@as(c_int, 0)))]));
}
pub const FZ_PI = @as(f32, 3.14159265);
pub const FZ_RADIAN = @as(f32, 57.2957795);
pub const FZ_DEGREE = @as(f32, 0.017453292);
pub const FZ_SQRT2 = @as(f32, 1.41421356);
pub const FZ_LN2 = @as(f32, 0.69314718);
pub const HAVE_SIGSETJMP = @as(c_int, 1);
pub inline fn fz_setjmp(BUF: anytype) @TypeOf(sigsetjmp(BUF, @as(c_int, 0))) {
    _ = &BUF;
    return sigsetjmp(BUF, @as(c_int, 0));
}
pub inline fn fz_longjmp(BUF: anytype, VAL: anytype) @TypeOf(siglongjmp(BUF, VAL)) {
    _ = &BUF;
    _ = &VAL;
    return siglongjmp(BUF, VAL);
}
pub const S_ISDIR = @compileError("unable to translate macro: undefined identifier `S_IFDIR`"); // /usr/include/mupdf/fitz/system.h:182:9
pub const @"inline" = @compileError("unable to translate C expr: unexpected token '__inline'"); // /usr/include/mupdf/fitz/system.h:199:9
pub const fz_forceinline = @compileError("unable to translate C expr: unexpected token 'inline'"); // /usr/include/mupdf/fitz/system.h:206:9
pub const FZ_RESTRICT = @compileError("unable to translate C expr: unexpected token '__restrict'"); // /usr/include/mupdf/fitz/system.h:215:9
pub const FZ_NORETURN = @compileError("unable to translate macro: undefined identifier `noreturn`"); // /usr/include/mupdf/fitz/system.h:222:9
pub const FZ_UNUSED = @compileError("unable to translate macro: undefined identifier `__unused__`"); // /usr/include/mupdf/fitz/system.h:234:9
pub const FZ_PRINTFLIKE = @compileError("unable to translate macro: undefined identifier `__format__`"); // /usr/include/mupdf/fitz/system.h:244:9
pub const FZ_MEMORY_BLOCK_ALIGN_MOD = __helpers.sizeof(?*anyopaque);
pub const FZ_POINTER_ALIGN_MOD = @as(c_int, 4);
pub const MUPDF_FITZ_CONTEXT_H = "";
pub const MUPDF_FITZ_MATH_H = "";
pub const _ASSERT_H = @as(c_int, 1);
pub const __ASSERT_VOID_CAST = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/assert.h:40:10
pub const _ASSERT_H_DECLS = "";
pub const assert = @compileError("unable to translate macro: undefined identifier `__FILE__`"); // /usr/include/assert.h:118:11
pub const __ASSERT_FUNCTION = @compileError("unable to translate C expr: unexpected token '__extension__'"); // /usr/include/assert.h:140:12
pub const static_assert = @compileError("unable to translate C expr: unexpected token '_Static_assert'"); // /usr/include/assert.h:158:10
pub inline fn FZ_EXPAND(A: anytype) @TypeOf(A + (A >> @as(c_int, 7))) {
    _ = &A;
    return A + (A >> @as(c_int, 7));
}
pub inline fn FZ_COMBINE(A: anytype, B: anytype) @TypeOf((A * B) >> @as(c_int, 8)) {
    _ = &A;
    _ = &B;
    return (A * B) >> @as(c_int, 8);
}
pub inline fn FZ_COMBINE2(A: anytype, B: anytype, C: anytype, D: anytype) @TypeOf(((A * B) + (C * D)) >> @as(c_int, 8)) {
    _ = &A;
    _ = &B;
    _ = &C;
    _ = &D;
    return ((A * B) + (C * D)) >> @as(c_int, 8);
}
pub inline fn FZ_BLEND(SRC: anytype, DST: anytype, AMOUNT: anytype) @TypeOf((((SRC - DST) * AMOUNT) + (DST << @as(c_int, 8))) >> @as(c_int, 8)) {
    _ = &SRC;
    _ = &DST;
    _ = &AMOUNT;
    return (((SRC - DST) * AMOUNT) + (DST << @as(c_int, 8))) >> @as(c_int, 8);
}
pub inline fn DIV_BY_ZERO(a: anytype, b: anytype, min: anytype, max: anytype) @TypeOf(if (__helpers.cast(bool, @intFromBool(a < @as(c_int, 0)) ^ @intFromBool(b < @as(c_int, 0)))) min else max) {
    _ = &a;
    _ = &b;
    _ = &min;
    _ = &max;
    return if (__helpers.cast(bool, @intFromBool(a < @as(c_int, 0)) ^ @intFromBool(b < @as(c_int, 0)))) min else max;
}
pub const FZ_MIN_INF_RECT = __helpers.cast(c_int, __helpers.promoteIntLiteral(c_int, 0x80000000, .hex));
pub const FZ_MAX_INF_RECT = __helpers.cast(c_int, __helpers.promoteIntLiteral(c_int, 0x7fffff80, .hex));
pub const FZ_VERBOSE_EXCEPTIONS = @as(c_int, 0);
pub inline fn fz_var(@"var": anytype) @TypeOf(fz_var_imp(__helpers.cast(?*anyopaque, &@"var"))) {
    _ = &@"var";
    return fz_var_imp(__helpers.cast(?*anyopaque, &@"var"));
}
pub const fz_try = @compileError("unable to translate C expr: unexpected token 'if'"); // /usr/include/mupdf/fitz/context.h:61:9
pub const fz_always = @compileError("unable to translate C expr: unexpected token 'while'"); // /usr/include/mupdf/fitz/context.h:62:9
pub const fz_catch = @compileError("unable to translate C expr: unexpected token 'while'"); // /usr/include/mupdf/fitz/context.h:63:9
pub const FITZ_DEBUG_LOCKING = "";
pub inline fn fz_new_context(alloc: anytype, locks: anytype, max_store: anytype) @TypeOf(fz_new_context_imp(alloc, locks, max_store, FZ_VERSION)) {
    _ = &alloc;
    _ = &locks;
    _ = &max_store;
    return fz_new_context_imp(alloc, locks, max_store, FZ_VERSION);
}
pub const fz_malloc_struct = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/mupdf/fitz/context.h:602:9
pub const fz_malloc_struct_array = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/mupdf/fitz/context.h:611:9
pub const fz_malloc_array = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/mupdf/fitz/context.h:620:9
pub const fz_realloc_array = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/mupdf/fitz/context.h:622:9
pub const FZ_JMPBUF_ALIGN = @as(c_int, 32);
pub const MUPDF_FITZ_OUTPUT_H = "";
pub const MUPDF_FITZ_BUFFER_H = "";
pub const MUPDF_FITZ_STRING_H = "";
pub const FZ_REPLACEMENT_CHARACTER = __helpers.promoteIntLiteral(c_int, 0xFFFD, .hex);
pub const MUPDF_FITZ_STREAM_H = "";
pub const MUPDF_FITZ_LOG_H = "";
pub const MUPDF_FITZ_CRYPT_H = "";
pub const FZ_AES_DECRYPT = @as(c_int, 0);
pub const FZ_AES_ENCRYPT = @as(c_int, 1);
pub const MUPDF_FITZ_GETOPT_H = "";
pub const MUPDF_FITZ_HASH_H = "";
pub const FZ_HASH_TABLE_KEY_LENGTH = @as(c_int, 48);
pub const MUPDF_FITZ_POOL_H = "";
pub const MUPDF_FITZ_TREE_H = "";
pub const FITZ_BIDI_H = "";
pub const MUPDF_FITZ_XML_H = "";
pub const MUPDF_FITZ_ARCHIVE_H = "";
pub const fz_new_derived_archive = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/mupdf/fitz/archive.h:368:9
pub const MUPDF_FITZ_COMPRESS_H = "";
pub const MUPDF_FITZ_COMPRESSED_BUFFER_H = "";
pub const MUPDF_FITZ_FILTER_H = "";
pub const MUPDF_FITZ_STORE_H = "";
pub const FZ_INIT_STORABLE = @compileError("unable to translate macro: undefined identifier `S`"); // /usr/include/mupdf/fitz/store.h:86:9
pub const FZ_INIT_KEY_STORABLE = @compileError("unable to translate macro: undefined identifier `KS`"); // /usr/include/mupdf/fitz/store.h:94:9
pub const FZ_LOG_STORE = @compileError("unable to translate C expr: unexpected token 'do'"); // /usr/include/mupdf/fitz/store.h:437:9
pub const FZ_LOG_DUMP_STORE = @compileError("unable to translate C expr: unexpected token 'do'"); // /usr/include/mupdf/fitz/store.h:438:9
pub const MUPDF_FITZ_COLOR_H = "";
pub const MUPDF_FITZ_PIXMAP_H = "";
pub const MUPDF_FITZ_SEPARATION_H = "";
pub const MUPDF_FITZ_BITMAP_H = "";
pub const MUPDF_FITZ_IMAGE_H = "";
pub const fz_new_derived_image = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/mupdf/fitz/image.h:210:9
pub const MUPDF_FITZ_SHADE_H = "";
pub const MUPDF_FITZ_FONT_H = "";
pub const MUPDF_FITZ_PATH_H = "";
pub const MUPDF_FITZ_TEXT_H = "";
pub inline fn FZ_LANG_TAG2(c1: anytype, c2: anytype) @TypeOf(((c1 - 'a') + @as(c_int, 1)) + (((c2 - 'a') + @as(c_int, 1)) * @as(c_int, 27))) {
    _ = &c1;
    _ = &c2;
    return ((c1 - 'a') + @as(c_int, 1)) + (((c2 - 'a') + @as(c_int, 1)) * @as(c_int, 27));
}
pub inline fn FZ_LANG_TAG3(c1: anytype, c2: anytype, c3: anytype) @TypeOf((((c1 - 'a') + @as(c_int, 1)) + (((c2 - 'a') + @as(c_int, 1)) * @as(c_int, 27))) + ((((c3 - 'a') + @as(c_int, 1)) * @as(c_int, 27)) * @as(c_int, 27))) {
    _ = &c1;
    _ = &c2;
    _ = &c3;
    return (((c1 - 'a') + @as(c_int, 1)) + (((c2 - 'a') + @as(c_int, 1)) * @as(c_int, 27))) + ((((c3 - 'a') + @as(c_int, 1)) * @as(c_int, 27)) * @as(c_int, 27));
}
pub const MUPDF_FITZ_GLYPH_H = "";
pub const MUPDF_FITZ_DEVICE_H = "";
pub const fz_new_derived_device = @compileError("unable to translate macro: undefined identifier `ctx`"); // /usr/include/mupdf/fitz/device.h:329:9
pub const MUPDF_FITZ_DISPLAY_LIST_H = "";
pub const MUPDF_FITZ_STRUCTURED_TEXT_H = "";
pub const MUPDF_FITZ_TYPES_H = "";
pub const MUPDF_FITZ_TRANSITION_H = "";
pub const MUPDF_FITZ_GLYPH_CACHE_H = "";
pub const MUPDF_FITZ_LINK_H = "";
pub const fz_new_derived_link = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/mupdf/fitz/link.h:99:9
pub const MUPDF_FITZ_OUTLINE_H = "";
pub const fz_new_derived_outline_iter = @compileError("unable to translate macro: undefined identifier `ctx`"); // /usr/include/mupdf/fitz/outline.h:206:9
pub const MUPDF_FITZ_DOCUMENT_H = "";
pub const fz_new_derived_document = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/mupdf/fitz/document.h:507:9
pub const fz_new_derived_page = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/mupdf/fitz/document.h:712:9
pub const FZ_META_FORMAT = "format";
pub const FZ_META_ENCRYPTION = "encryption";
pub const FZ_META_INFO = "info:";
pub const FZ_META_INFO_TITLE = "info:Title";
pub const FZ_META_INFO_AUTHOR = "info:Author";
pub const FZ_META_INFO_SUBJECT = "info:Subject";
pub const FZ_META_INFO_KEYWORDS = "info:Keywords";
pub const FZ_META_INFO_CREATOR = "info:Creator";
pub const FZ_META_INFO_PRODUCER = "info:Producer";
pub const FZ_META_INFO_CREATIONDATE = "info:CreationDate";
pub const FZ_META_INFO_MODIFICATIONDATE = "info:ModDate";
pub const MUPDF_FITZ_UTIL_H = "";
pub const MUPDF_FITZ_WRITER_H = "";
pub const fz_new_derived_document_writer = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/mupdf/fitz/writer.h:72:9
pub const MUPDF_FITZ_BAND_WRITER_H = "";
pub const fz_new_band_writer = @compileError("unable to translate macro: undefined identifier `ctx`"); // /usr/include/mupdf/fitz/band-writer.h:114:9
pub const MUPDF_FITZ_WRITE_PIXMAP_H = "";
pub const MUPDF_FITZ_OUTPUT_SVG_H = "";
pub const MUPDF_FITZ_STORY_H = "";
pub const MUPDF_FITZ_STORY_WRITER_H = "";
pub const __jmp_buf_tag = struct___jmp_buf_tag;
pub const _G_fpos_t = struct__G_fpos_t;
pub const _G_fpos64_t = struct__G_fpos64_t;
pub const _IO_marker = struct__IO_marker;
pub const _IO_codecvt = struct__IO_codecvt;
pub const _IO_wide_data = struct__IO_wide_data;
pub const _IO_FILE = struct__IO_FILE;
pub const _IO_cookie_io_functions_t = struct__IO_cookie_io_functions_t;
pub const timeval = struct_timeval;
pub const timespec = struct_timespec;
pub const __pthread_internal_list = struct___pthread_internal_list;
pub const __pthread_internal_slist = struct___pthread_internal_slist;
pub const __pthread_mutex_s = struct___pthread_mutex_s;
pub const __pthread_rwlock_arch_t = struct___pthread_rwlock_arch_t;
pub const __pthread_cond_s = struct___pthread_cond_s;
pub const random_data = struct_random_data;
pub const drand48_data = struct_drand48_data;
pub const __locale_struct = struct___locale_struct;
