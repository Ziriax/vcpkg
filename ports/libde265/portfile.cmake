vcpkg_fail_port_install(ON_ARCH "arm" ON_TARGET "uwp")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO strukturag/libde265
    REF v1.0.8
    SHA512 0007138cb5da0d4cad1e118c01de249580f39c387a11f490d1e1f63ad0968ee2f7951e54580f298b3dbe31e5a3d1a7fa04454e11cbb82beaf8a9aaf56f5532ed
    HEAD_REF master
    PATCHES
      remove-de265-version.patch
      remove-examples.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
    -DUSE_HDF5=ON
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/libde265/)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
