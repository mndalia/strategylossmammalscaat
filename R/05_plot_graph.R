library(tidyverse)
library(inspectdf)
library(forcats)
pacman::p_load(dplyr, plyr, readr, tibble, FD, ade4, cowplot,
               mice, reshape2, tidyr, ks, hypervolume, alphahull,
               purrr, TTR, plotrix, agricolae, psych)


dcc_mi_d1 <- read.csv("data/processed/processed_pca_data.csv")
datlisthunt <- read.csv("data/raw/mam_list_hunt.csv")
pc_mi_d1 <- read.csv("data/processed/pc.csv")
pcload_mi_d1_sc <- read.csv("data/processed/pcload_mi_d1_sc.csv")


pc_mi_hunt <- plyr::join(pc_mi_d1, datlisthunt, type = "inner")

# colour palette
col_pal <- colorRampPalette(c("orange", "yellow", "white"))(200)

# plot
pca_plot_mi_d1 <- ggplot(dcc_mi_d1, aes(x = Var1, y = Var2)) +
  # coloured probabilty background
  geom_raster(aes(fill = value)) +
  scale_fill_gradientn(colours = rev(col_pal)) +
  # points for species
  geom_point(data = pc_mi_d1, aes(x = Comp.1_mean, y = Comp.2_mean), size = 2.5,
             alpha = 0.5, colour = "darkgrey") +
  geom_point(data = pc_mi_hunt, aes(x = Comp.1_mean, y = Comp.2_mean), size = 0.7,
            alpha = 1, colour = "red") +
  # add arrows
  geom_segment(data = pcload_mi_d1_sc, aes(x = 0, y = 0, 
                                           xend = Comp.1_mean, yend = Comp.2_mean), 
               arrow = arrow(length = unit(0.2, "cm")), colour = "black", 
               alpha = 0.7) +
  # add dashed arrows ends
  geom_segment(data = pcload_mi_d1_sc, aes(x = 0, y = 0,
                                           xend = -Comp.1_mean, yend = -Comp.2_mean), 
               lty = 5, colour = "darkgrey") +
  # add arrow labels
  geom_text(data = pcload_mi_d1_sc, 
            aes(x = Comp.1_mean, y = Comp.2_mean, label = trait), 
            size = 4, nudge_x = c(0, 0, 0, 0, -0.2), 
            nudge_y = c(0.2, -0.2, -0.2, -0.2, 0.2)) +
  # axis labels - see comp_var
  labs(x = "PC1 (38.9%)", y = "PC2 (17.3%)") +
  #retirando legenda
  guides(fill=FALSE) +
  # edit plot
  theme_classic(base_size = 13)

# display plot
pca_plot_mi_d1

ggsave(plot = pca_plot_mi_d1, 
       filename = "output/figures/Fig_02_pca.png",
       width = 10, height = 8)


#### ---------------------------