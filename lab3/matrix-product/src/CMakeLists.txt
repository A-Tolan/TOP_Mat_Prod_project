add_executable(top.matrix_product)
target_sources(top.matrix_product PRIVATE main.cpp)
target_compile_options(top.matrix_product PRIVATE -Wall -Wextra -Wpedantic -g -pg)
target_link_libraries(top.matrix_product PRIVATE Kokkos::kokkos fmt::fmt)
