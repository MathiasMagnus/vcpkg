include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO MathiasMagnus/clFFT
    REF cache-fix
    SHA512 19e9a4e06f76ae7c7808d1188677d5553c43598886a75328b7801ab2ca68e35206839a58fe2f958a44a6f7c83284dc9461cd0e21c37d1042bf82e24aad066be8
    HEAD_REF cache-fix
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

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}/src
    PREFER_NINJA
    OPTIONS
        -DBUILD_LOADLIBRARIES=OFF
        -DBUILD_EXAMPLES=OFF
        -DSUFFIX_LIB=
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(INSTALL
        "${SOURCE_PATH}/LICENSE"
    DESTINATION
        ${CURRENT_PACKAGES_DIR}/share/clfft/copyright
)

if(NOT VCPKG_CMAKE_SYSTEM_NAME) # Empty when Windows
  vcpkg_fixup_cmake_targets(CONFIG_PATH "CMake")
endif()
if(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "Linux")
  vcpkg_fixup_cmake_targets(CONFIG_PATH "lib/cmake/clFFT")
endif()

vcpkg_copy_pdbs()