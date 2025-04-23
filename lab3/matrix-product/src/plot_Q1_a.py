import pandas as pd
import matplotlib.pyplot as plt
import re

# Charger les données depuis results.txt
data = []
with open("results.txt", "r") as file:
    lines = file.readlines()
    for i in range(0, len(lines), 7):  # Chaque bloc de résultats contient 7 lignes
        m = int(re.search(r"M=(\d+)", lines[i]).group(1))
        n = int(re.search(r"N=(\d+)", lines[i]).group(1))
        k = int(re.search(r"K=(\d+)", lines[i]).group(1))
        avg_duration = float(re.search(r"Average duration: ([\d.]+)", lines[i + 1]).group(1))
        duration_stddev = float(re.search(r"Duration standard deviation: ([\d.]+)", lines[i + 2]).group(1))
        avg_gflops = float(re.search(r"Average performance: ([\d.]+)", lines[i + 3]).group(1))
        gflops_stddev = float(re.search(r"Performance standard deviation: ([\d.]+)", lines[i + 4]).group(1))
        threads = int(re.search(r"Number of threads: (\d+)", lines[i + 5]).group(1))
        data.append([m, n, k, avg_duration, duration_stddev, avg_gflops, gflops_stddev, threads])

# Convertir les données en DataFrame
df = pd.DataFrame(data, columns=["M", "N", "K", "Time_ms", "Time_stddev", "GFLOPs", "GFLOPs_stddev", "Threads"])

# Filtrer pour la taille fixe (strong scaling)
df = df[(df["M"] == 512) & (df["N"] == 512) & (df["K"] == 512)]
df = df.sort_values("Threads")

# Calculer le speedup (T1 / Tn)
t1 = df[df["Threads"] == 1]["Time_ms"].values[0]
df["Speedup"] = t1 / df["Time_ms"]

# (1) Performance
plt.figure(figsize=(8, 5))
plt.plot(df["Threads"], df["GFLOPs"], 'o-', label="GFLOP/s", color='blue')
for x, y in zip(df["Threads"], df["GFLOPs"]):
    plt.text(x, y + 0.0002, f"{y:.4f}", ha='center', va='bottom', fontsize=8)  # Décalage vertical
plt.errorbar(df["Threads"], df["GFLOPs"], yerr=df["GFLOPs_stddev"], fmt='o-', label="GFLOP/s error bar", capsize=5, ecolor='red')
plt.xlabel("Nombre de threads")
plt.ylabel("Performance (GFLOP/s)")
plt.title("Performance du produit matriciel naïf (M=N=K=512, LayoutRight A, B, C)")
plt.grid(True)
plt.legend()
plt.xlim(left=0)
plt.ylim(bottom=0)
plt.tight_layout()
plt.savefig("performance_runtime_naive_512_LayoutRight_ABC.png")
plt.show()

# (2) Temps d'exécution
plt.figure(figsize=(8, 5))
plt.plot(df["Threads"], df["Time_ms"], 'o-', color='blue', label="Temps (ms)")
for x, y in zip(df["Threads"], df["Time_ms"]):
    plt.text(x, y + 50, f"{y:.2f}", ha='center', va='bottom', fontsize=8)  # Décalage vertical
plt.errorbar(df["Threads"], df["Time_ms"], yerr=df["Time_stddev"], fmt='o-', label="Temps (ms) error bar", capsize=5, ecolor='red')
plt.xlabel("Nombre de threads")
plt.ylabel("Temps d'exécution (ms)")
plt.title("Temps d'exécution vs Threads (M=N=K=512, code naïf, LayoutRight A, B, C)")
plt.grid(True)
plt.legend()
plt.xlim(left=0)
plt.ylim(bottom=0)
plt.tight_layout()
plt.savefig("runtime_vs_threads_naive_512_LayoutRight_ABC.png")
plt.show()

# (3) Speedup
plt.figure(figsize=(8, 5))
plt.plot(df["Threads"], df["Speedup"], 'o-', color='green', label="Speedup")
plt.plot(df["Threads"], df["Threads"], '--', color='gray', label="Speedup idéal")  # Ligne idéale
for x, y in zip(df["Threads"], df["Speedup"]):
    plt.text(x, y + 0.025, f"{y:.2f}", ha='center', va='bottom', fontsize=8)  # Décalage vertical
plt.xlabel("Nombre de threads")
plt.ylabel("Speedup")
plt.title("Strong Scaling: Speedup vs Threads (M=N=K=512, code naïf, LayoutRight A, B, C)")
plt.grid(True)
plt.legend()
plt.xlim(left=0)
plt.ylim(0, 2)
plt.tight_layout()
plt.savefig("strong_scaling_speedup_naive_512_LayoutRight_ABC.png")
plt.show()
