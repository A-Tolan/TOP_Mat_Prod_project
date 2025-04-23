#include <cassert>
#include <cstdlib>

#include <Kokkos_Core.hpp>
#include <fmt/core.h>
#include <chrono>

using Matrix = Kokkos::View<double**, Kokkos::LayoutRight>;

template <class MatrixType>
auto matrix_init(MatrixType& M) -> void {
  static_assert(2 == MatrixType::rank(), "View must be of rank 2");

  Kokkos::parallel_for(
    "init",
    M.extent(0),
    KOKKOS_LAMBDA(int i) {
      for (int j = 0; j < int(M.extent(1)); ++j) {
        M(i, j) = drand48();
      }
    }
  );
}

template <class AMatrixType, class BMatrixType, class CMatrixType>
auto matrix_product(double alpha, AMatrixType const& A, BMatrixType const& B, double beta, CMatrixType& C) -> void {
  static_assert(
    AMatrixType::rank() == 2 && BMatrixType::rank() == 2 && CMatrixType::rank() == 2, "Views must be of rank 2"
  );
  assert(A.extent(0) == C.extent(0));
  assert(B.extent(1) == C.extent(1));
  assert(A.extent(1) == B.extent(0));

  Kokkos::parallel_for(
    "dgemm_kernel",
    A.extent(0),
    KOKKOS_LAMBDA(int i) {
      for (int j = 0; j < int(B.extent(1)); ++j) {
        double acc = 0.0;
        for (int k = 0; k < int(A.extent(1)); ++k) {
          acc += alpha * A(i, k) * B(k, j);
        }
        C(i, j) *= beta + acc;
      }
    }
  );
}

auto main(int argc, char* argv[]) -> int {
  if (argc < 4) {
    fmt::print("Usage: {} <M> <N> <K>\n", argv[0]);
    return -1;
  }
  int m = std::atoi(argv[1]);
  int n = std::atoi(argv[2]);
  int k = std::atoi(argv[3]);

  // Known seed for deterministic RNG
  srand48(42);

  Kokkos::initialize(argc, argv);
  {
    auto A = Matrix("A", m, k);
    auto B = Matrix("B", k, n);
    auto C = Matrix("C", m, n);

    double alpha = drand48();
    matrix_init(A);
    matrix_init(B);
    double beta = drand48();
    matrix_init(C);

    constexpr int num_runs = 3;
    double total_duration = 0.0;

    for (int run = 0; run < num_runs; ++run) {
      Kokkos::fence();
      auto start = std::chrono::high_resolution_clock::now();
      matrix_product(alpha, A, B, beta, C);
      Kokkos::fence();
      auto end = std::chrono::high_resolution_clock::now();

      auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
      total_duration += duration;

      double flops = 2.0 * m * n * k;
      double gflops = flops / (duration * 1e6); // Convert ms to seconds and FLOPs to GFLOPs
      fmt::print("Run {} took {} ms, Performance: {:.2f} GFLOP/s\n", run + 1, duration, gflops);
    }
    auto average_duration = static_cast<int>(std::round(total_duration / num_runs));
    double average_gflops = (2.0 * m * n * k) / (average_duration * 1e6); // Convert ms to seconds and FLOPs to GFLOPs
    fmt::print("Average matrix product time, from naive code, over {} runs: {} ms\n", num_runs, average_duration);
    fmt::print("Average performance: {:.2f} GFLOP/s\n", average_gflops);
  }
  Kokkos::finalize();
  return 0;
}
