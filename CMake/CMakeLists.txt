set(GLFW_DIR ${CMAKE_CURRENT_SOURCE_DIR}/Submodules/external/glfw)
add_subdirectory(${GLFW_DIR} binary_dir EXCLUDE_FROM_ALL)
include_directories(${GLFW_DIR}/include)

include(${CMAKE_CURRENT_SOURCE_DIR}/Submodules/CMakeLists.txt)

if(APPLE)
    message(STATUS "Apple macOS App Bundle Build")
    include(${CMAKE_CURRENT_SOURCE_DIR}/CMake/PlatformApple.cmake)


elseif(UNIX AND NOT APPLE )
    message(STATUS "Linux/Unix Build")
    include(${CMAKE_CURRENT_SOURCE_DIR}/CMake/PlatformLinux.cmake)


elseif(NOT UNIX AND NOT APPLE)
    message("Windows Build")
    include(${CMAKE_CURRENT_SOURCE_DIR}/CMake/PlatformWindows.cmake)


endif()