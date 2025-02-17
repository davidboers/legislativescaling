# Legislative scaling visualizations

This is an R project that creates illuminating visualizations of voting patterns in legislative institutions. The procedure utilizes a multidimensional scaling (MDS) algorithm to plot legislators on a 2-D plane, where legislators with similar voting patterns are placed together. 

# Algorithms

Wikipedia has a detailed article about MDS [here](https://en.wikipedia.org/wiki/Multidimensional_scaling). 

The package also makes use of the [k-means clustering](https://en.m.wikipedia.org/wiki/K-means_clustering) algorithm to group legislators with similar voting patterns together.

# R specifications

Written in R version 4.4.1 on a Windows 11 machine. 

_insert package specs_

# Databases

This repository contains the following databases inside `data/`:

* `2023_24_ga_senate.rda`: Georgia State Senate for 2023-24 session.
* `2023_24_ga_house.rda`: Georgia State House for 2023-24 session.
* `2023_spc_ga_senate.rda`: Georgia State Senate for 2023 special session.
* `2023_spc_ga_house.rda`: Georgia State House for 2023 special session.
* `2025_26_ga_senate.rda`: Georgia State Senate for 2025-26 session.
* `2025_26_ga_house.rda`: Georgia State House for 2025-26 session.

_Congress_

# Todo list

* Party whip
* Yes/no/abstain count
* K-means clustering
