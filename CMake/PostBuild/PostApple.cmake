    set_target_properties(${EXECUTABLE_NAME}
            PROPERTIES
            MACOSX_BUNDLE_BUNDLE_NAME ${EXECUTABLE_NAME}
            MACOSX_BUNDLE_COPYRIGHT "Copyright © 1995-2009, ${EXECUTABLE_NAME} , All Rights Reserved."
            MACOSX_BUNDLE_GUI_IDENTIFIER "${EXECUTABLE_NAME}.grahamhill.dev"
            MACOSX_BUNDLE_ICON_FILE "myAppImage.icns"
            MACOSX_BUNDLE_BUNDLE_VERSION 1.0
            MACOSX_BUNDLE_SHORT_VERSION_STRING 1.0
            MACOSX_BUNDLE TRUE
            XCODE_ATTRIBUTE_ENABLE_HARDENED_RUNTIME YES
            XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "dev.grahamhill.${EXECUTABLE_NAME}"
            BUILD_WITH_INSTALL_RPATH TRUE
            INSTALL_RPATH "@executable_path/../Frameworks"
    )

#Copies, relinks the frameworks file, adds folders in App bundle
    add_custom_command(TARGET ${EXECUTABLE_NAME} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E make_directory
            "${CMAKE_CURRENT_BINARY_DIR}/${EXECUTABLE_NAME}.app/Contents/Frameworks/"

            COMMAND ${CMAKE_COMMAND} -E make_directory
            "${CMAKE_CURRENT_BINARY_DIR}/${EXECUTABLE_NAME}.app/Contents/Resources/"

            COMMAND ${CMAKE_COMMAND} -E make_directory
            "${CMAKE_CURRENT_BINARY_DIR}/${EXECUTABLE_NAME}.app/Contents/Resources/vulkan/icd.d/"


            COMMAND ${CMAKE_COMMAND} -E copy
            "$ENV{HOME}/VulkanSDK/${VULKANVERSION}/macOS/lib/${VULKAN_LIB}"
            "${CMAKE_CURRENT_BINARY_DIR}/${EXECUTABLE_NAME}.app/Contents/Frameworks/libvulkan.1.dylib"

            COMMAND ${CMAKE_COMMAND} -E copy
            "$ENV{HOME}/VulkanSDK/${VULKANVERSION}/macOS/lib/${VULKAN_LIB}"
            "${CMAKE_CURRENT_BINARY_DIR}/${EXECUTABLE_NAME}.app/Contents/Frameworks/${VULKAN_LIB}"

            COMMAND ${CMAKE_COMMAND} -E copy
            "$ENV{HOME}/VulkanSDK/${VULKANVERSION}/macOS/lib/libMoltenVK.dylib"
            "${CMAKE_CURRENT_BINARY_DIR}/${EXECUTABLE_NAME}.app/Contents/Frameworks/libMoltenVK.dylib"

            COMMAND ${CMAKE_COMMAND} -E copy
            "${CMAKE_CURRENT_SOURCE_DIR}/MoltenVK_icd.json"
            "${CMAKE_CURRENT_BINARY_DIR}/${EXECUTABLE_NAME}.app/Contents/Resources/vulkan/icd.d/MoltenVK_icd.json"


            COMMAND install_name_tool -change
            "@rpath/libvulkan.1.dylib"
            "@executable_path/../Frameworks/libvulkan.1.dylib"
            "${CMAKE_CURRENT_BINARY_DIR}/${EXECUTABLE_NAME}.app/Contents/MacOS/${PROJECT_NAME}"
    )


    # Use file(GLOB ...) to get the list of files matching the wildcard pattern
    file(GLOB SOURCE_FILES "${SOURCE_DIR}/${SOURCE_PATTERN}")

    # Iterate over the list of source files and add a custom command for each one
foreach(SOURCE_FILE ${SOURCE_FILES})
    # Get the file name from the full path
    get_filename_component(FILE_NAME ${SOURCE_FILE} NAME)
    # Define the destination file path
    set(DESTINATION_FILE "${DESTINATION_DIR}/${FILE_NAME}")
    message(STATUS "${DESTINATION_FILE}")
    message(STATUS "${SOURCE_FILE}")

    # Add a custom command to copy the file after building the target
    add_custom_command(
    TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy
    "${SOURCE_FILE}"
    "${DESTINATION_FILE}"
    )
endforeach()

if(CODE_SIGN)
    add_custom_command(TARGET ${EXECUTABLE_NAME} POST_BUILD
    COMMAND /usr/bin/codesign --deep --force --verify --verbose --sign
    ${SIGN_ID}
    "${CMAKE_CURRENT_BINARY_DIR}/${EXECUTABLE_NAME}.app"
    COMMENT "Signing the app bundle"
    )
endif ()