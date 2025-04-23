import os
import subprocess

M = N = K = 512  # Dimensions de la matrice
executable = "../build/src/top.matrix_product"  # Chemin vers l'exécutable
thread_counts = list(range(1, 9))  # de 1 à 8 threads

for num_threads in thread_counts:
    os.environ["KOKKOS_NUM_THREADS"] = str(num_threads)
    print(f"Running with {num_threads} threads...")
    subprocess.run([executable, str(M), str(N), str(K)])
