cmake_minimum_required (VERSION 3.0)
project (morecurves)

add_subdirectory (mclib)
add_subdirectory (mclua)
add_subdirectory (lua)

add_executable (${PROJECT_NAME} main.cpp)

target_include_directories (${PROJECT_NAME}
    PRIVATE ${CMAKE_CURRENT_LIST_DIR}
)

target_link_libraries (${PROJECT_NAME}
    PRIVATE morecurves_slib
    PRIVATE morecurves_slua
    PRIVATE lua
)

install (TARGETS ${PROJECT_NAME} DESTINATION bin)
