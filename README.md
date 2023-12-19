# Data analysis files and for the 2023 study "*No sensory visual imagery in aphantasia? An intricate question when it comes to priming*"

This folder contains all the files - data and code - necessary to reproduce the analysis presented in the article "*No sensory visual imagery in aphantasia? An intricate question when it comes to priming*". 

Opening the `.RProj` (R project) file in RStudio will automatically open it in the folder containg this file as the working directory and ease considerably the work and navigation in this "project" (the folder containing all the relevant files).

Several analyses needed large amounts of time (e.g. the power analyses took an hour per simulation, fitting and comparing all GLMMs takes several minutes even with parallel processing), so their outputs have been stored in `.RDS` files for reproducibility and ease of use. The `.RDS` files are in the `analyses-results/` folder. These files are loaded in the main code file generating the report, `analysis-report.qmd`, but the initial computations are not re-done upon rendering the report (intially for easier editing). 

The report has been rendered in `.docx` format for use with Word and in HTML to read it in a browser. The Word report does not include the R code sections detailing the computations that generated the code, as these can be rather long. These are instead included in the HTML page, where they are "folded" by default, but can be revealed (and optionnaly copied for re-use if need be). We recommend reading the report on the HTML page for greater confort and interactivity.