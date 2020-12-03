import pandas as pd
from matplotlib import pyplot as plt
import numpy as np
import os, sys, json, argparse
from summary_utils import *

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--pmaj_results_csv', required=True, nargs='+')
    parser.add_argument('--pmaj', type=float, required=True, nargs='+')
    parser.add_argument('--scr_results_csv', required=True, nargs='+')
    parser.add_argument('--scr', type=float, required=True, nargs='+')
    args = parser.parse_args()

    pmaj_to_dfs = {}
    for pmaj, path in zip(args.pmaj, args.pmaj_results_csv):
        pmaj_to_dfs[pmaj] = pd.read_csv(path)

    scr_to_dfs = {}
    for scr, path in zip(args.scr, args.scr_results_csv):
        scr_to_dfs[scr] = pd.read_csv(path)

    figure_distribution_props(pmaj_to_dfs, scr_to_dfs, 'distribution_props.png')

def figure_distribution_props(pmaj_to_dfs, scr_to_dfs, outpath):
    # Figure Params
    plt.rcParams.update({'font.size': 14, 'lines.linewidth':4, 'lines.markersize':12, 
                         'xtick.labelsize':15, 'ytick.labelsize':15, 'axes.labelsize':20,
                         'axes.titlesize': 20, 'hatch.linewidth':3, 'legend.fontsize':16,
                         'axes.ymargin':-0})
    plt.set_cmap('tab20')
    # Figure
    fig, ax = plt.subplots(1, 2, 
                           figsize=(12,4.5), sharex=False, sharey='row')
    # 
    curves = []
    labels = []
    c_list = [0,1,2]
    for train in [True, False]:
        for i, (scr, df) in enumerate(scr_to_dfs.items()):
            curve, = plot_error_vs_overparam(fig, ax[0], df, 'oversample', 
                                             robust=True,
                                             train=train,
                                             color=plt.cm.get_cmap('tab20').colors[c_list[i]*2+train])
            if not train:
                curves.append(curve)
                labels.append(r'$r_{\mathsf{s:c}}=$'+str(scr))
            
    # Corr
    c_list = [4,7,0,9]
    for train in [True, False]:
        for i, (pmaj, df) in enumerate(pmaj_to_dfs.items()):
            curve, = plot_error_vs_overparam(fig, ax[1], df, 'oversample',
                                             robust=True,
                                             train=train,
                                             color=plt.cm.get_cmap('tab20').colors[c_list[i]*2+train])
            if not train:
                curves.append(curve)
                labels.append(r'$p_{maj}=$'+str(pmaj))

    # Legend
    ax[0].legend(handles=curves[:3], labels=labels[:3], ncol=1, loc='upper right')
    ax[1].legend(handles=curves[3:], labels=labels[3:], ncol=1, loc='upper left',bbox_to_anchor=(1.0,1.03))
    # axes
    ax[0].set_ylabel('Worst-Group Error')
    ax[0].set_xlabel('Parameter Count')
    ax[1].set_xlabel('Parameter Count')

    fig.tight_layout()
    fig.subplots_adjust(right=0.9)
    # Axes
    plt.autoscale(enable=False, axis='y', tight=True)
    # Save
    plt.savefig(outpath, bbox_inches = "tight", dpi=fig.dpi)

if __name__=='__main__':
    main()
