# Talisker
## Personality Kit: Runtime Start-up

### Introduction

When performing a native build, this project produces the initialisation and
finalisation objects which are linked into executables and shared libraries.

The objects contain the program entry-point, to which control is passed by
the kernel (for static executables) or the dynamic loader. They ensure that
the runtime is initialised properly and that the correct arguments are
passed to `main()`.

### Build types

* A *freestanding* build is an error, because a freestanding target by definition has no kernel and minimal runtime support.
* A *native* build will produce the objects listed below.
* A *hosted* build is a no-op, because the host operating system already provides an implementation.

A native build can be selected by passing the appropriate native host type to
`configure`, e.g.:—

```
$ ./configure --host=x86_64-none-linux
```

This assumes that an `x86_64-none-linux` toolchain is available. Alternatively,
a host can be coerced into its native equivalent via `--enable-native`, which
applies the appropriate compiler and linker flags required to produce native
binaries with a hosted toolchain.

For example, on an `x86_64-pc-linux-gnu` host, the following will produce
objects compiled for `x86_64-none-linux`:

```
$ ./configure --enable-native
```

Note that this only works if the native form of the host type is supported.
For example, you can't build for `i686-pc-linux-gnu` using `--enable-native`
because `i686-none-linux` is not currently a supported platform.

### Installed objects

Objects are installed in the `PlatformKit.framework` binary directory (typically
accessed as `PlatformKit.framework/Contents/[host-type]/`, but canonically
`PlatformKit.framework/Contents/Versions/[version]/[host-type]`.

Installation is not performed by this sub-project; instead, the PlatformKit
build logic takes care of it for us.

Variants are generated for static, dynamic, and position-independent
executables (PIE), and for debug and profiled versions of each. Each
variant has an initialisation and matching finilisation object.

The naming convention is:

```
rtsu-(init|fini)_(s|d|p)(_debug|_profile).o
```

For example, `rtsu-init_s.o` and its corresponding `rtsu-fini_s.o` are the
non-debugging variants for statically-compiled executables. Meanwhile,
`rtsu-init_d_debug.o` and `rtsu-fini_d_debug.o` are for the debugging
versions of dynamically-linked executables.

### Using the objects

In a normal hosted environment, the compiler ensures that the C library's
own initialisation and finalisation objects are supplied to the linker
automatically. GCC and Clang allow you to specify `-nostartfiles`, which
inhibits this behaviour, and allows you to specify your own objects at the
beginning and end of the list instead. For example:—

```
$ clang -o myprog -nostartfiles /path/to/rtsu-init_d.o main.o utils.o /path/to/rtsu-fini_d.o
```

Note that typically you will also need to inhibit the linking of the
default C library (via `-nostdlib`) and link against Personality Kit
instead. Generally using runtime start-up files which do not correspond
to the C library in use will not work.

### Process initialisation

The Runtime Start-up objects expect to be used in conjunction with Personality
Kit. They provide a system-specific symbol, typically `start` or `_start`,
which matches the name of the default entry-point symbol on that system.

On systems which are flexible with symbol naming,
`Talisker.PersonalityKit.__main()` will be invoked, which is expected to pass
control on to the application-provided `main()`. On systems which do not
have such flexible naming, the function will be named `__tal_main()` instead.

This function is provided by Personality Kit. A mock version is included in
the `Tests` directory in order to minimise external dependencies.

If control is returned by `Talisker.PersonalityKit.__main()` to `start`, then
a call is made to `Talisker.PersonalityKit.Executive._exit()` to terminate the
process, and if that returns for any reason a `hlt` instruction (or equivalent)
will be issued to forcibly abort the process.

### Supported host types

#### x86-64

* `x86_64-none-darwin`: XNU (Mac OS X/Darwin)
* `x86_64-none-linux`: Linux

### Licence

Licensed according to the terms of the [Apache License, 2.0](LICENSE-2.0).
