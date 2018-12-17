include(vcpkg_common_functions)

set(PLPLOT_VERSION 5.14.0)
set(PLPLOT_HASH 08baada17c2a0166b6fe134bb15d4896aa8a4f3d1b51b7e22fd774df16ea7f2972b1fb93eaeb6f401372a38576ef4490ad45656b3dffabed6f3ef0e7719919e9)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/plplot-${PLPLOT_VERSION})

vcpkg_download_distfile(ARCHIVE
    URLS "https://sourceforge.net/projects/plplot/files/plplot/${PLPLOT_VERSION}%20Source/plplot-${PLPLOT_VERSION}.tar.gz/download"
    FILENAME "plplot-${PLPLOT_VERSION}.tar.gz"
    SHA512 ${PLPLOT_HASH}
)
vcpkg_extract_source_archive(${ARCHIVE})

set(BUILD_with_wxwidgets OFF)
if("wxwidgets" IN_LIST FEATURES)
  set(BUILD_with_wxwidgets ON)
endif()

# Patch build scripts
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES "${CMAKE_CURRENT_LIST_DIR}/install-interface-include-directories.patch"
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DENABLE_tcl=OFF
        -DPL_HAVE_QHULL=OFF
        -DENABLE_qt=OFF
        -DPLPLOT_USE_QT5=OFF
        -DENABLE_ocaml=OFF
        -DPL_DOUBLE=ON
        -DENABLE_wxwidgets=${ENABLE_wxwidgets}
        -DPLD_wxpng=${ENABLE_wxwidgets}
        -DPLD_wxwidgets=${ENABLE_wxwidgets}
        -DENABLE_DYNDRIVERS=OFF
        -DDATA_DIR=${CURRENT_PACKAGES_DIR}/share/plplot
    OPTIONS_DEBUG
        -DDRV_DIR=${CURRENT_PACKAGES_DIR}/debug/bin
    OPTIONS_RELEASE
        -DDRV_DIR=${CURRENT_PACKAGES_DIR}/bin
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/plplot)

# Patch config scripts
vcpkg_apply_patches(
    SOURCE_PATH ${CURRENT_PACKAGES_DIR}
    PATCHES "${CMAKE_CURRENT_LIST_DIR}/modify-install-prefix-in-config-file.cmake"
)

# Remove unnecessary tool
file(REMOVE
    ${CURRENT_PACKAGES_DIR}/debug/bin/pltek.exe
)

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools)
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/plplot)

file(RENAME
    ${CURRENT_PACKAGES_DIR}/bin/pltek.exe
    ${CURRENT_PACKAGES_DIR}/tools/plplot/pltek.exe
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    message(STATUS "Static build: Removing the full bin directory.")
    file(REMOVE_RECURSE
        ${CURRENT_PACKAGES_DIR}/debug/bin
        ${CURRENT_PACKAGES_DIR}/bin
    )
endif()

# Remove unwanted and duplicate directories
file(REMOVE_RECURSE
        ${CURRENT_PACKAGES_DIR}/debug/include
)

file(INSTALL
    ${SOURCE_PATH}/Copyright
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/plplot
    RENAME copyright
)

vcpkg_copy_pdbs()

file(REMOVE_RECURSE
    ${CURRENT_PACKAGES_DIR}/debug/share
)
