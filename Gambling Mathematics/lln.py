import random
import matplotlib.pyplot as plt

def simulate_coin_game(trials=10000):
    balance = 0
    history = []

    for _ in range(trials):
        outcome = random.choice(["heads", "tails"])
        if outcome == "heads":
            balance += 1
        else:
            balance -= 1
        history.append(balance)

    return history

# Simulate multiple runs
fig, axes = plt.subplots(2, 2, figsize=(12, 10))

# Plot 1: Cumulative Balance
results1 = simulate_coin_game()
axes[0, 0].plot(results1)
axes[0, 0].set_title("Cumulative Balance Over Time")
axes[0, 0].set_xlabel("Number of Games")
axes[0, 0].set_ylabel("Net Earnings")
axes[0, 0].grid(True)
axes[0, 0].axhline(0, color='red', linestyle='--')

# Plot 2: Average Profit per Game (LLN)
average1 = [bal / (i + 1) for i, bal in enumerate(results1)]
axes[0, 1].plot(average1)
axes[0, 1].set_title("Law of Large Numbers: Average Profit per Game")
axes[0, 1].set_xlabel("Number of Games")
axes[0, 1].set_ylabel("Average Profit")
axes[0, 1].grid(True)
axes[0, 1].axhline(0, color='red', linestyle='--')

# Plot 3: Multiple simulation runs comparison
results2 = simulate_coin_game()
results3 = simulate_coin_game()
axes[1, 0].plot(results1, label='Run 1', alpha=0.7)
axes[1, 0].plot(results2, label='Run 2', alpha=0.7)
axes[1, 0].plot(results3, label='Run 3', alpha=0.7)
axes[1, 0].set_title("Multiple Simulation Runs")
axes[1, 0].set_xlabel("Number of Games")
axes[1, 0].set_ylabel("Net Earnings")
axes[1, 0].legend()
axes[1, 0].grid(True)
axes[1, 0].axhline(0, color='red', linestyle='--')

# Plot 4: Average convergence comparison
average2 = [bal / (i + 1) for i, bal in enumerate(results2)]
average3 = [bal / (i + 1) for i, bal in enumerate(results3)]
axes[1, 1].plot(average1, label='Run 1', alpha=0.7)
axes[1, 1].plot(average2, label='Run 2', alpha=0.7)
axes[1, 1].plot(average3, label='Run 3', alpha=0.7)
axes[1, 1].set_title("Average Convergence Comparison")
axes[1, 1].set_xlabel("Number of Games")
axes[1, 1].set_ylabel("Average Profit")
axes[1, 1].legend()
axes[1, 1].grid(True)
axes[1, 1].axhline(0, color='red', linestyle='--')

plt.tight_layout()
plt.savefig('lln_multiple_plots.png', dpi=300, bbox_inches='tight')
plt.show()