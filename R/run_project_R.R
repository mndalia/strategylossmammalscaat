# Script to run all project code
# Note: Refresh R session before running this script

# Start----
# 1. Run all scripts again on a fresh R section---------------------------------
# 1.1 Load and clean data----
source(file = "R/01_load_clean_traits_data.R")

# 1.2 Fit models----
source(file = "R/02_diet_pcoa.R")

# 1.3 Plot figures----
source(file = "R/03_trait_imputation.R")

source(file = "R/04_ztransform_pca.R")
      
source(file = "R/05_plot_graph.R")
