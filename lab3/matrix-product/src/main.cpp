#include <cassert>
#include <cstdlib>

#include <Kokkos_Core.hpp>
#include <fmt/core.h>
#include <chrono>
#include <fstream>
#include <cstdlib> // pour std::getenv
#include <numeric>
#include <cmath>
#include <vector>

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

    constexpr int num_runs = 5;
    std::vector<double> durations;
    std::vector<double> gflops_values;

    for (int run = 0; run < num_runs; ++run) {
      Kokkos::fence();
      auto start = std::chrono::high_resolution_clock::now();
      matrix_product(alpha, A, B, beta, C);
      Kokkos::fence();
      auto end = std::chrono::high_resolution_clock::now();

      auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
      durations.push_back(duration);

      double flops = 2.0 * m * n * k;
      double gflops = flops / (duration * 1e6); // Convert ms to seconds and FLOPs to GFLOPs
      gflops_values.push_back(gflops);
      fmt::print("Run {} took {} ms, Performance: {:.4f} GFLOP/s\n", run + 1, duration, gflops);
    }
    // Calculer la moyenne et l'écart-type
    double average_duration = std::accumulate(durations.begin(), durations.end(), 0.0) / num_runs;
    double average_gflops = std::accumulate(gflops_values.begin(), gflops_values.end(), 0.0) / num_runs;

    double duration_stddev = std::sqrt(std::accumulate(durations.begin(), durations.end(), 0.0,
      [average_duration](double sum, double val) { return sum + (val - average_duration) * (val - average_duration); }) / num_runs);

    double gflops_stddev = std::sqrt(std::accumulate(gflops_values.begin(), gflops_values.end(), 0.0,
      [average_gflops](double sum, double val) { return sum + (val - average_gflops) * (val - average_gflops); }) / num_runs);

    
    fmt::print("Average matrix product time, from naive code, over {} runs: {} ms\n", num_runs, average_duration);
    fmt::print("Average performance: {:.4f} GFLOP/s\n", average_gflops);

    const char* env_threads = std::getenv("KOKKOS_NUM_THREADS");
    int num_threads = env_threads ? std::atoi(env_threads) : Kokkos::DefaultExecutionSpace().concurrency();


    // Save results to a file for plotting
    std::ofstream results_file("results.txt", std::ios::app);
    if (results_file.is_open()) {
      results_file << "Matrix dimensions: M=" << m << ", N=" << n << ", K=" << k << "\n";
      results_file << "Average duration: " << average_duration << " ms\n";
      results_file << "Duration standard deviation: " << duration_stddev << " ms\n";
      results_file << "Average performance: " << average_gflops << " GFLOP/s\n";
      results_file << "Performance standard deviation: " << gflops_stddev << " GFLOP/s\n";
      results_file << "Number of threads: " << num_threads << "\n";
      results_file << "----------------------------------------\n";
      results_file.close();
    } else {
      fmt::print("Error: Unable to open results file for writing.\n");
    }
  }
  Kokkos::finalize();
  return 0;
}
