library(tidyverse)
library(inspectdf)
library(forcats)
pacman::p_load(dplyr, plyr, readr, tibble, FD, ade4, cowplot,
               mice, reshape2, tidyr, ks, hypervolume, alphahull,
               purrr, TTR, plotrix, agricolae, psych)

dattraitcaat <- readr::read_csv("data/processed/processed_traits_mam_caat.csv")
pcomp_diet <- readr::read_csv("data/processed/processed_pcomp_diet.csv")

tr <- dplyr::select(dattraitcaat, -contains("diet")) %>% 
  # add PCoA diet data
  dplyr::left_join(pcomp_diet, by = "sp") %>% 
  # reorder variables + drop pc_diet2
  dplyr::select(everything(), diet_pc1 = A1, -A2)
  
#renomeando coluna
tr_mam <- dplyr::rename(tr, binomial = sp)
  


#### Mammal trait imputation
## phylogenetic data

# load: t_pem_mam 
t_pem_mam <- readRDS("data/raw/df_t_pem_mam.rds")
# phylogenetic eigenvectors matched to binomialecies names - 
#using mammal supertree from Fritz et al., 2009 
#"Geographical variation in predictors of mammalian extinction risk: big is bad, but only in the tropics"

# join trait and phylogenetic data (use first ten eigenvectors - Penone et al., 2014)
tr_mam <- dplyr::left_join(tr_mam, t_pem_mam, by = "binomial")

# missing data pattern
mice::md.pattern(dplyr::select(tr_mam, -binomial, -c(V_1:V_10)))

# run multiple imputation
tr_mi <- mice(tr_mam, m = 25, maxit = 100, seed = 20)
# method = pmm predictive mean matching

# summary of multiple imputation results including predictor matrix (which variables were used to predict missing values)
summary(tr_mi)

tr_mi<- lapply(1:25, function(x) {
  out <- mice::complete(tr_mi, action = x) %>% 
    dplyr::select(binomial:diet_pc1)
})

# save: tr_mi
saveRDS(tr_mi, "data/processed/tr_mi.rds")



