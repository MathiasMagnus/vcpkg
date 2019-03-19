include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO MathiasMagnus/clBLAS
    REF cache-fix
    SHA512 fb8cba9b310f76be192e0dcc4c42cee3569c9b21830498c1e29c18257272f7cdb6448172d0eda7f4fac4e29362ab48c240033190d57b7bf9b57f1512701b49a8
    HEAD_REF cache-fix
)

# v2.12 has a very old FindOpenCL.cmake using OPENCL_ vs. OpenCL_ var names
# conflicting with the built-in, more modern FindOpenCL.cmake
file(
    REMOVE ${SOURCE_PATH}/src/FindOpenCL.cmake
)

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/cmake.patch
)

vcpkg_find_acquire_program(PYTHON3)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}/src
    PREFER_NINJA
    OPTIONS
        -DBUILD_TEST=OFF
        -DBUILD_KTEST=OFF
        -DSUFFIX_LIB=
        -DPYTHON_EXECUTABLE=${PYTHON3}
)

vcpkg_install_cmake()
if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(INSTALL
        "${SOURCE_PATH}/LICENSE"
    DESTINATION
        ${CURRENT_PACKAGES_DIR}/share/clblas
    RENAME copyright
)

file(REMOVE
        ${CURRENT_PACKAGES_DIR}/debug/bin/clBLAS-tune.pdb
        ${CURRENT_PACKAGES_DIR}/debug/bin/clBLAS-tune.exe
        ${CURRENT_PACKAGES_DIR}/bin/clBLAS-tune.exe
        ${CURRENT_PACKAGES_DIR}/debug/bin/concrt140d.dll
        ${CURRENT_PACKAGES_DIR}/debug/bin/msvcp140d.dll
        ${CURRENT_PACKAGES_DIR}/debug/bin/vcruntime140d.dll
)

vcpkg_fixup_cmake_targets(CONFIG_PATH "CMake")

vcpkg_copy_pdbs()
