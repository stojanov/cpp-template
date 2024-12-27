cmake_minimum_required(VERSION 3.31)

project(cpp-template)

set(CMAKE_EXPORT_COMPILE_COMMANDS
    ON
    CACHE INTERNAL "")

set(CMAKE_CXX_STANDARD 23)

option(FORCE_COLORED_OUTPUT
       "Always produce ANSI-colored output (GNU/Clang only)." ON)
option(ENABLE_SANITIZER "Enable addess sanitizer" ON)

if(${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU")
  message("Using GCC compiler")
  set(USING_GCC 1)
  add_compile_options(-fmodules-ts)
  # add_compile_options(-stdlib=libstdc++) add_link_options(-stdlib=libstdc++)
elseif(${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang")
  message("Using Clangd compiler")
  add_compile_options(-stdlib=libc++)
  add_link_options(-stdlib=libc++)
  set(USING_CLANG 1)
elseif(${CMAKE_CXX_COMPILER_ID} STREQUAL "MSVC")
  message("Using msvc compiler")
  set(USING_MSVC 1)
endif()

if(${FORCE_COLORED_OUTPUT})
  if(USING_GCC)
    add_compile_options(-fdiagnostics-color=always)
  elseif(USING_CLANG)
    add_compile_options(-fcolor-diagnostics)
  endif()
endif()

if(ENABLE_SANITIZER)
  message("AddressSanitizer has been enabled")
  add_compile_options(-fsanitize=address -fno-sanitize=alignment
                      -fsanitize=enum -fsanitize=leak)
  if(ENABLE_SANITIZER_THREAD)
    add_compile_options(-fsanitize=undefined -fno-sanitize=alignment
                        -fsanitize=enum -fsanitize=thread)
  endif()

  link_libraries(-fsanitize=address -fno-sanitize=alignment -fsanitize=enum
                 -fsanitize=leak)

  if(ENABLE_SANITIZER AND ENABLE_SANITIZER_THREAD)
    message(
      FATAL_ERROR
        "ENABLE_SANITIZER and ENABLE_SANITIZER_THREAD can not be used together!"
    )
  endif()
endif()

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  if(USING_MSVC)
    add_compile_options(/W4)
  elseif(USING_GCC)
    add_compile_options(-Wextra -Wpedantic -Weffc++)
  elseif(USING_CLANGD)
    # TODO
  endif()

  add_compile_definitions(DEBUG_BUILD)
else()
  add_compile_definitions(RELEASE_BUILD)
  # enable link time optimizations
  set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
endif()

include($ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake)

add_subdirectory(src)
