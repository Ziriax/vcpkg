include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO thadhouse/allwpilib
    REF v2019.42.42
    SHA512 fd8d1030bffe67912c09e6dd9aedd71be10a5994aae9d371eb7a0b0faa67bc2743a16d9c31a4472f933819d3d109c676d506df7ca6df46ca68ec92290d3a8a47
    HEAD_REF vcpkgrelease
    PATCHES
      0001-Update-cmake-find-to-support-vcpkg-libuv.patch
      0001-Fix-Gray-to-BGR-conversion-in-CameraServer.patch
)

set(WITHOUT_JAVA ON)
set(WITHOUT_CSCORE ON)
set(WITHOUT_ALLWPILIB ON)

if ("cameraserver" IN_LIST FEATURES)
  set(WITHOUT_CSCORE OFF)
endif()

if ("allwpilib" IN_LIST FEATURES)
  set(WITHOUT_ALLWPILIB OFF)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA

    OPTIONS
      -DWITHOUT_JAVA=${WITHOUT_JAVA}
      -DWITHOUT_CSCORE=${WITHOUT_CSCORE}
      -DWITHOUT_ALLWPILIB=${WITHOUT_ALLWPILIB}
      -DUSE_VCPKG_LIBUV=ON
      -DFLAT_INSTALL_WPILIB=ON
)
vcpkg_install_cmake()

file(COPY ${CURRENT_PACKAGES_DIR}/wpilib/include/ntcore/ DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(COPY ${CURRENT_PACKAGES_DIR}/wpilib/include/wpiutil/ DESTINATION ${CURRENT_PACKAGES_DIR}/include)
if (NOT WITHOUT_ALLWPILIB)
file(COPY ${CURRENT_PACKAGES_DIR}/wpilib/include/wpilibc/ DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(COPY ${CURRENT_PACKAGES_DIR}/wpilib/include/hal/gen/ DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(COPY ${CURRENT_PACKAGES_DIR}/wpilib/include/hal/ DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/gen)
endif()
if (NOT WITHOUT_CSCORE)
file(COPY ${CURRENT_PACKAGES_DIR}/wpilib/include/cameraserver/ DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(COPY ${CURRENT_PACKAGES_DIR}/wpilib/include/cscore/ DESTINATION ${CURRENT_PACKAGES_DIR}/include)
endif()

if(NOT VCPKG_LIBRARY_LINKAGE STREQUAL "static")
  file(COPY ${CURRENT_PACKAGES_DIR}/wpilib/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/bin FILES_MATCHING PATTERN "*.dll")
  file(COPY ${CURRENT_PACKAGES_DIR}/debug/wpilib/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin FILES_MATCHING PATTERN "*.dll")

  file(COPY ${CURRENT_PACKAGES_DIR}/wpilib/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/bin FILES_MATCHING PATTERN "*.so")
  file(COPY ${CURRENT_PACKAGES_DIR}/debug/wpilib/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin FILES_MATCHING PATTERN "*.so")

  file(COPY ${CURRENT_PACKAGES_DIR}/wpilib/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/bin FILES_MATCHING PATTERN "*.dylib")
  file(COPY ${CURRENT_PACKAGES_DIR}/debug/wpilib/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin FILES_MATCHING PATTERN "*.dylib")
endif()

file(COPY ${CURRENT_PACKAGES_DIR}/wpilib/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/lib FILES_MATCHING PATTERN "*.lib")
file(COPY ${CURRENT_PACKAGES_DIR}/debug/wpilib/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib FILES_MATCHING PATTERN "*.lib")

file(COPY ${CURRENT_PACKAGES_DIR}/wpilib/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/lib FILES_MATCHING PATTERN "*.a")
file(COPY ${CURRENT_PACKAGES_DIR}/debug/wpilib/lib/ DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib FILES_MATCHING PATTERN "*.a")

vcpkg_copy_pdbs()

file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/wpilib RENAME copyright)
