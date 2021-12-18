# JPMorgan - Causality-Informed Fairness Treatments of Unfair AI Systems 

This repository is for the Columbia DSI captsone project titled Causality-Informed Fairness Treatments of Unfair AI Systems in collaboration with JP Morgan.

## Goal

The goal of this project is to develop a research framework that would enable us to efficiently explore the literature on causality-based approaches to fairness. Specifically, we explored the following questions:

>How does a particular fairness technique perform across a variety of metrics?.
>
>For a given metric, how do various fairness techniques compare?
>
>Do certain fairness techniques lend themselves better to certain real-world problems, datasets, or causal models?

We  generate a synthetic dataset that would satisfy the following conditions:
>The data generating process (DGP) is fully specified on the basis of a causal graph.
> 
>And, for ease of interpretation, the DGP would have only one sensitive variable.

For this final project, we produce and work with such a synthetic dataset. By using a fully specified DGP and a corresponding dataset (rather than a real world dataset), we have full control over variables and directed paths that govern fairness. As a result: 


>We can guarantee that our DGP is inherently unfair (with respect to only 1 variable).
>
>We can subsequently explore the effectiveness of a variety of fair-inference techniques on mitigating unfairness, which is the goal of this project. 


## Code 
[![js-standard-style](https://img.shields.io/badge/code%20style-standard-brightgreen.svg?style=flat)](https://github.com/feross/standard)


We use Python and R for the coding part. The code structure is as follows:

For the R code we modify the following implementation
```
@inproceedings{nabi18fair,
title = {Fair Inference on Outcomes},
author = { Razieh Nabi and Ilya Shpitser},
booktitle = {Proceedings of the Thirty Second Conference on Association for the Advancement of Artificial Intelligence (AAAI-32nd)},
year = { 2018 }, 
publisher = { AAAI Press }
}
```

## Repository Organisation

```
dsi-capstone-f21:.
|   .gitignore
|   .Rhistory
|   README.md
|
+---datasets
|       Counter_Test_df.csv
|       Full_Test_df.csv
|       Full_Training_df.csv
|       intervantion.csv
|       law_data.csv
|       no_intervention.csv
|
+---notebooks
|       Baseline_Models.ipynb
|       compute_pse.R
|       constrained_mle.R
|       Evaluate Counterfactual Fairness for Path-Specific Fairness Prediction Output.ipynb
|       Evaluation metrics_ demographic parity equality of opportunity.ipynb
|       Evaluation_metrics_demographic_parity_equality_of_opportunity.ipynb
|       Metrics Sync.ipynb
|       Models.ipynb
|       probabalistic_graphical_model_example.ipynb
|       Synthetic Data_Model Result for Report2.ipynb
|       Toy Dataset and Fair Classifier.ipynb
|
\---R_codes
        evaluate_performance.R
        fit_models.R
        main.R
```

## Datasets

