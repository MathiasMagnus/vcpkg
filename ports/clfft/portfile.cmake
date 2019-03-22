include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO MathiasMagnus/clFFT
    REF cache-fix
    SHA512 485c76a16ca2a8b4c5a04a554825fb75599695a9f1ebed56ed5c6dc9e61154db923ddb467ad6a04f6d26993cb0b8696236d2ee87dd4a98a0b1ddcab1d62177f1
    HEAD_REF cache-fix
)

if(NOT VCPKG_CMAKE_SYSTEM_NAME) # Empty when Windows
  vcpkg_apply_patches(
      SOURCE_PATH ${SOURCE_PATH}
      PATCHES ${CMAKE_CURRENT_LIST_DIR}/cmake.win.patch
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

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(COPY
        ${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake
    DESTINATION
        ${CURRENT_PACKAGES_DIR}/share/${PORT}
)
