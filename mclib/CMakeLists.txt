cmake_minimum_required (VERSION 3.0)
project (morecurves_slib)

add_library (${PROJECT_NAME} STATIC mc_lib.cpp mc_lib.h)

target_include_directories (${PROJECT_NAME}
    PUBLIC ${CMAKE_CURRENT_LIST_DIR}
)
