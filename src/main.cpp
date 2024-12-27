#include <iostream>

import lib;

int main(int argc, char *argv[]) {
    std::print(std::cout, "Hello {}", lib::add(40, 2));

    return 0;
}
