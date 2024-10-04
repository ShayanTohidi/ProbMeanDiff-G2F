# ProbMeanDiff-G2F

These datasets are constructed based on yearly phenotypic datasets in [G2F](https://www.genomes2fields.org/resources/). Thus, we end up with a lot of complete datasets with replication.

## Introduction

Selecting the best crop cultivars is one of the main steps in the plant breeding process. Previously, it was common to use the mean yield of each cultivar and then pick those with high values. However, because there might be significant interaction effects between cultivars and environments (genotype-by-environment effect or G$`\times`$E), the mean-based ranking can be misleading when this is larger than the main effect. It means that the sizeable mean yield of a cultivar might be due to a favorable environment, not the capability of that cultivar. Hence, rather than the mean yield of cultivars, their stability across the target environments is essential.

Many stability statistics in the agriculture literature capture the stability of cultivars to rank them. Still, each measures a single aspect of the stability (risk) while considering all is preferable. There is another method called probabilistic ranking that, in a pair of cultivars, selects one with a higher probability of outperforming the other in the set of target environments. The distributions needed in this method are created using bootstrap resampling. The main question here is whether this method addresses both mean yield and stability or not!

A new method has been developed to check if stabilities can fill the gap between mean-based and probabilistic ranking methods. If yes, which one is more impactful, and if no, what that stability implies.

## Goal

To approach that goal, we need a considerable number of real datasets with the following characteristics:
* They should be complete, meaning all cultivars must be planted in all environments.
* There should be greater than or equal to 2 replications for each cultivar planted in each environment.
* They should be single-year, multi-year, and multi-location to capture all types of variability.
* Different combinations of relatively small and large numbers of cultivars and environments are desired, except both being small.

Having a bunch of datasets with these properties helps us verify and validate our method.
