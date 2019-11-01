# kernel density estimation
pc_raw_mi_d1 <- pc_mi_d1 %>% 
  # extract first two principal components
  dplyr::select(., binomial, Comp.1_mean, Comp.2_mean) %>% 
  tibble::column_to_rownames(var = "binomial")

# optimal bandwidth estimation
hpi_mi_d1 <- Hpi(x = pc_raw_mi_d1)

# kernel density estimation   ---- 
est_mi_d1 <- kde(x = pc_raw_mi_d1, H = hpi_mi_d1, compute.cont = TRUE)  

den_mi_d1 <- list(est_mi_d1$eval.points[[1]], est_mi_d1$eval.points[[2]], est_mi_d1$estimate)
names(den_mi_d1) <- c("x", "y", "z")
dimnames(den_mi_d1$z) <- list(den_mi_d1$x, den_mi_d1$y)
dcc_mi_d1 <- melt(den_mi_d1$z)

# source: kernel function
source("code/2.1.3-kernel-function.R")

# 0.5 probability kernel
cl_50_mi_d1 <- cl(df = den_mi_d1, prob = 0.50)
# 0.95 probability kernel
cl_95_mi_d1 <- cl(df = den_mi_d1, prob = 0.95)
# 0.99 probability kernel
cl_99_mi_d1 <- cl(df = den_mi_d1, prob = 0.99)