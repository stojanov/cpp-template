#!/bin/bash

c_compiler="/usr/lib64/ccache/clang"
cxx_compiler="/usr/lib64/ccache/clang++"

if [ $# -gt 0 ]; then
    if echo "$1" | grep -qi "debug"; then
        build_type="Debug"
    elif echo "$1" | grep -qi "release"; then
        build_type="Release"
    elif [ "$1" == "--d" ]; then
        build_type="Debug"
    elif [ "$1" == "--r" ]; then
        build_type="Release"
    else
        build_type="Debug"
    fi
else
    build_type="Debug"
fi

# add cmake presets in the future
if [ "$build_type" == "Debug" ]; then

    if cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE="$build_type" -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_C_COMPILER="$c_compiler" -DCMAKE_CXX_COMPILER="$cxx_compiler"; then
        if [ ! -f ./compile_commands.json ]; then
            ln -s ./build/compile_commands.json ./compile_commands.json
        fi
    fi
else
    cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE="$build_type"
fi


