vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO  strukturag/libheif 
    REF 56c8a2613370562fc330af2c70c1510aa5fd9ff6 #v1.12.0
    SHA512 11ac7f32d1f49963046b1a4479a41f39004475211563ba7f41b2398f07f7b4d90339ea663e528b3cc80deeef1fff374987208d48b447116a806564ef05487e97
    HEAD_REF master
    PATCHES gdk-pixbuf.patch heif-static.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DWITH_EXAMPLES=OFF
)
vcpkg_install_cmake()
vcpkg_copy_pdbs()

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/libheif/)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
