cmake_minimum_required (VERSION 3.0)
project (morecurves_slua)

add_library (${PROJECT_NAME} STATIC mc_lua.cpp mc_lua.h)

target_include_directories (${PROJECT_NAME}
    PUBLIC ${CMAKE_CURRENT_LIST_DIR}
)

target_link_libraries (${PROJECT_NAME}
    PRIVATE morecurves_slib
    PUBLIC lua
)
