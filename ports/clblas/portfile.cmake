include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO MathiasMagnus/clBLAS
    REF cache-fix
    SHA512 3655e92699fd491434c70ff78badb2b3cf315f17e3fa207dc2778ffd216236e6d2ff25426151f64c0ee3b4b85a03b50b5e65dd4638cd4acbc8a2617067d1cfd7
    HEAD_REF cache-fix
)

# v2.12 has a very old FindOpenCL.cmake using OPENCL_ vs. OpenCL_ var names
# conflicting with the built-in, more modern FindOpenCL.cmake
file(
    REMOVE ${SOURCE_PATH}/src/FindOpenCL.cmake
)

if(NOT VCPKG_CMAKE_SYSTEM_NAME) # Empty when Windows
  vcpkg_apply_patches(
      SOURCE_PATH ${SOURCE_PATH}
      PATCHES ${CMAKE_CURRENT_LIST_DIR}/cmake.win.patch
  )
endif()
if(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "Linux")
  vcpkg_apply_patches(
      SOURCE_PATH ${SOURCE_PATH}
      PATCHES ${CMAKE_CURRENT_LIST_DIR}/cmake.linux.patch
  )
endif()

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

if(NOT VCPKG_CMAKE_SYSTEM_NAME) # Empty when Windows
  vcpkg_fixup_cmake_targets(CONFIG_PATH "CMake")
endif()
if(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "Linux")
  vcpkg_fixup_cmake_targets(CONFIG_PATH "lib/cmake/clBLAS")
endif()

vcpkg_copy_pdbs()
