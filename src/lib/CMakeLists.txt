add_library(lib)

target_sources(lib PUBLIC FILE_SET CXX_MODULES BASE_DIRS
                          ${CMAKE_SOURCE_DIR}/src FILES ./lib.cxx)
