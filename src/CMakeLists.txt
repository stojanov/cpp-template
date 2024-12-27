add_subdirectory(lib)

add_executable(entry_point)

target_sources(entry_point PUBLIC ./main.cpp)

target_link_libraries(entry_point PRIVATE lib)
