source(file = "R/03_trait_imputation.R")

### z-transformation ####

# function to z-transform data
scale_z <- function(x){
  (x - mean(x, na.rm=TRUE))/sd(x, na.rm=TRUE)
}

## tr_mi_z ##

# z-transform trait data
tr_mi_z <- lapply(1:25, function(x) {
  tr_mi[[x]] %>%
    # scale (zero mean and unit variance) all traits
    dplyr::mutate_at(vars(body_mass_median:diet_pc1), funs(scale_z)) %>% 
    # convert to true dataframe
    as.data.frame
})

tr_mi_z_d1 <- lapply(1:25, function(x) {
  tr_mi_z[[x]] %>% 
    # add species names to rownames
    tibble::column_to_rownames(var = "binomial") 
})

# run pca
prin_mi_d1 <- lapply(1:25, function(x) {
  princomp((tr_mi_z_d1[[x]]), cor = TRUE, scores = TRUE)
})

comp_var <- lapply(1:25, function(x) {prin_mi_d1[[x]]$sdev^2}) %>% 
  dplyr::bind_cols() %>% 
  dplyr::mutate_all(as.numeric) %>% 
  dplyr::mutate(mean = apply(.[1:25], 1, mean))

comp_var$mean/sum(comp_var$mean)

comp_var$V2/sum(comp_var$V2)

pc_mi_d1 <- lapply(1:25, function(x) {
  # pca scores
  as.data.frame(prin_mi_d1[[x]]$scores) %>% 
    tibble::rownames_to_column("binomial") %>% 
    # add identifier for each imputation dataset
    dplyr::mutate(., mi = paste0("mi_", x))
}) %>% 
  dplyr::bind_rows()

# function to rescale data from 0-1
rescale3 <- function(x){(x-min(x, na.rm = TRUE))/(max(x, na.rm = TRUE)-min(x, na.rm = TRUE))}

pc_mi_d1 <- pc_mi_d1 %>% 
  # convert long to wide
  tidyr::gather(key, value, -binomial, -mi) %>% 
  tidyr::unite(col, key, mi) %>% 
  tidyr::spread(col, value) %>% 
  # calculate mean per species for principal components
  dplyr::mutate(Comp.1_mean = apply(dplyr::select(., contains("Comp.1")), 1, mean)) %>% 
  dplyr::mutate(Comp.2_mean = apply(dplyr::select(., contains("Comp.2")), 1, mean)) %>% 
  dplyr::mutate(Comp.3_mean = apply(dplyr::select(., contains("Comp.3")), 1, mean)) %>% 
  dplyr::mutate(Comp.4_mean = apply(dplyr::select(., contains("Comp.4")), 1, mean)) %>% 
  dplyr::mutate(Comp.5_mean = apply(dplyr::select(., contains("Comp.5")), 1, mean))

# loadings
pcload_mi_d1 <- lapply(1:25, function(x) {
  # extract pca loadings
  as.data.frame(unclass(prin_mi_d1[[x]]$loadings)) %>% 
    tibble::rownames_to_column("trait") %>% 
    # add identifier for each imputation dataset
    dplyr::mutate(., mi = paste0("mi_", x))
}) %>% 
  dplyr::bind_rows()

pcload_mi_d1 <- pcload_mi_d1 %>% 
  # convert long to wide
  tidyr::gather(key, value, -trait, -mi) %>% 
  tidyr::unite(col, key, mi) %>% 
  tidyr::spread(col, value) %>% 
  # calculate mean per species for principal components
  dplyr::mutate(Comp.1_mean = apply(dplyr::select(., contains("Comp.1")), 1, mean)) %>% 
  dplyr::mutate(Comp.2_mean = apply(dplyr::select(., contains("Comp.2")), 1, mean)) %>% 
  dplyr::mutate(Comp.3_mean = apply(dplyr::select(., contains("Comp.3")), 1, mean)) %>% 
  dplyr::mutate(Comp.4_mean = apply(dplyr::select(., contains("Comp.4")), 1, mean)) %>% 
  dplyr::mutate(Comp.5_mean = apply(dplyr::select(., contains("Comp.5")), 1, mean))

# scalar to adjust arrow size
sc_mi <- 7

pcload_mi_d1_sc <- pcload_mi_d1 %>% 
  # rescale for arrow sizes
  dplyr::mutate_at(vars(contains("Comp")), funs(.*sc_mi)) %>% 
  # posh names
  mutate(trait = c("Body mass", "Diet", 
                   "Habitat breadth", "Litter/clutch size"))



# save principal component data
write.csv(pc_mi_d1, file = "data/processed/pc.csv", row.names = FALSE)
