vcpkg_fail_port_install(ON_ARCH "arm" ON_TARGET "uwp")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO strukturag/libde265
    REF ae99d397cea0612523b174ae5b96dc8845ee482f # v1.0.8+
    SHA512 88a2e54ec7073796b033c4cf217a95472f37c98c41a0fc1265cf72a914884f54840bd21d46d89da0245e83eb13fa47f31c365496bb9d6492115daac42e8a2c93
    HEAD_REF master
    PATCHES
        fix-libde265-headers.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/libde265/)
vcpkg_copy_tools(TOOL_NAMES dec265 enc265 AUTO_CLEAN)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
