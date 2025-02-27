using BinaryBuilder

name = "object_store_ffi"
version = v"0.4.2"

sources = [
    # https://github.com/RelationalAI/object_store_ffi/commit/567d7762e9f9c3efd0a39b1ac531f4012dfb7151
    GitSource("https://github.com/RelationalAI/object_store_ffi.git", "567d7762e9f9c3efd0a39b1ac531f4012dfb7151")
]

# Bash recipe for building across all platforms
script = raw"""
cd ${WORKSPACE}/srcdir/object_store_ffi/
cargo rustc --release --lib --crate-type=cdylib
install -Dvm 755 "target/${rust_target}/release/libobject_store_ffi.${dlext}" "${libdir}/libobject_store_ffi.${dlext}"
"""

# We could potentially support more platforms, if required.
# Except perhaps i686 Windows and Musl systems.
platforms = [
    Platform("aarch64", "macos"),
    Platform("x86_64",  "linux"),
    Platform("x86_64",  "macos"),
    Platform("aarch64", "linux"),
]

# The products that we will ensure are always built
products = [
    LibraryProduct("libobject_store_ffi", :libobject_store_ffi),
]

# Dependencies that must be installed before this package can be built
dependencies = Dependency[
]

# Build the tarballs
build_tarballs(
    ARGS, name, version, sources, script, platforms, products, dependencies;
    compilers=[:c, :rust], julia_compat="1.6", preferred_gcc_version=v"5",
)
