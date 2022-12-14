""" create a scatterplot of dice overlap vs transformation smoothness.
    """
import matplotlib.pyplot as plt
import seaborn as sns
from argparse import ArgumentParser
import pickle
import numpy as np
from .config import *
import os
from matplotlib.ticker import FormatStrFormatter


def load_data_for_model(dataset, loss_function):
    # load data
    with open(args.cache_file_name, 'rb') as f:
        test_results = pickle.load(f)
    if dataset not in test_results.keys():
        return None, None
    if loss_function not in test_results[dataset].keys():
        return None, None
    dice = test_results[dataset][loss_function]["dice_overlap"].mean(axis=0)
    smoothness = test_results[dataset][loss_function]["jacobian_determinant_log_var"].mean(
        axis=0)
    folding = test_results[dataset][loss_function]["jacobian_determinant_negative"].mean(
        axis=0)
    return dice, smoothness


def main(args):

    # set up sup-plots
    fig = plt.figure(figsize=(8, 3))
    axs = fig.subplots(1, len(DATASET_ORDER))
    plt.subplots_adjust(bottom=0.33)

    for i, dataset in enumerate(DATASET_ORDER):
        for loss_function in LOSS_FUNTION_ORDER:
            dice, smoothness = load_data_for_model(dataset, loss_function)
            if dice is None:
                continue
            # read lam, score
            handle = axs[i].scatter(
                dice, smoothness, color=LOSS_FUNTION_CONFIG[loss_function]["primary_color"], marker=LOSS_FUNTION_CONFIG[loss_function]["marker"], s=80)
            axs[i].set_title(PLOT_CONFIG[dataset]["display_name"], fontsize=18)
            LOSS_FUNTION_CONFIG[loss_function]["handle"] = handle

    # add labels
    fig.text(0.5, 0.2, "Test Mean Dice Overlap",
             ha="center", va="center", fontsize=16)
    fig.text(
        0.06, 0.58, "$\sigma^2(\log |J_{\Phi}|)$", ha="center", va="center", rotation="vertical", fontsize=16)

    # add legend
    handles = [
        LOSS_FUNTION_CONFIG[loss_function]["handle"] for loss_function in LOSS_FUNTION_ORDER
    ]
    labels = [
        LOSS_FUNTION_CONFIG[loss_function]["display_name"]
        for loss_function in LOSS_FUNTION_ORDER
    ]
    fig.legend(handles, labels, loc="lower center",
               ncol=len(handles), handlelength=1.5, columnspacing=1.5)

    # configure axis precision
    for ax in axs:
        ax.yaxis.set_major_formatter(FormatStrFormatter('%.2f'))
        ax.xaxis.set_major_formatter(FormatStrFormatter('%.2f'))
        ax.set_ylim(ymin=0, ymax=0.6)

    os.makedirs("./out/plots/", exist_ok=True)
    plt.savefig("./out/plots/smoothness_vs_dice_overlap.pdf")
    plt.savefig("./out/plots/smoothness_vs_dice_overlap.png")


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument(
        '--cache_file_name', type=str, default='./src/plots/cache.pickl', help='File with test results.')
    args = parser.parse_args()
    main(args)
