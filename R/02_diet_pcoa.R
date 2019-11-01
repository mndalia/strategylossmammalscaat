#abrindo pacotes ----
if (!require("pacman")) install.packages("pacman")
pacman::p_load(dplyr, plyr, readr, tibble, FD, ade4, cowplot, mice, reshape2, tidyr, ks, hypervolume, alphahull, purrr, TTR, plotrix, agricolae, psych)

#abrindo dados ----
dattraitcaat <- readr::read_csv("data/processed/processed_traits_mam_caat.csv")

#selecionando dados ----
diet_all <- dattraitcaat %>% 
  # select diet data
  dplyr::select(sp, contains("diet")) %>% 
  # drop species with missing data: 1178
  dplyr::filter(!is.na(diet_inv)) %>%   
  # add species names to rownames (needed for gowdis function)
  tibble::column_to_rownames(var = "sp") %>% 
  as.data.frame()


#calculate species x species gower distance matrix based on traits
diet_gd <- FD::gowdis(diet_all)

# perform principal coordinates analysis (PCoA)
diet_pco <- ade4::dudi.pco(diet_gd, scannf = FALSE)

pc_diet <- diet_pco$tab

summary(diet_pco)
# Projected inertia Ax1 = 31.887
# Projected inertia Ax2 = 17.347

#principle component axes
pcomp_diet <- as.data.frame(diet_pco$tab[,1:2]) %>% 
  tibble::rownames_to_column(var = "sp")

# diet category projection
n <- nrow(diet_all)
points_stand <- scale(diet_pco$tab[,1:2])
S <- cov(diet_all, points_stand)
U <- S %*% diag((diet_pco$eig[1:2]/(n-1))^(-0.5))
colnames(U) <- colnames(diet_pco$tab[,1:2])

#diet categoires (see Wilman et al., 2014)
U <- as.data.frame(U) %>% 
  mutate(trait = c("Inv", "Vend", "Vect", "Vfish", "Vunk", "Scav", "Fruit", "Nect", "Seed", "Planto"))
# Inv - Invertebrates # Vend - Vertebrate endotherms # Vect - Vertebrate ectotherms # Vfish - Fish # Vunk - Vertebrate unknown or general # Scav - Scavenge # Fruit - Fruit # Nect - Nectar # Seed - Seeds # Planto - Other plant material

# scale diet category arrows
mult <- min(
  (max(pcomp_diet$A2) - min(pcomp_diet$A2)/(max(U$A2)-min(U$A2))),
  (max(pcomp_diet$A1) - min(pcomp_diet$A1)/(max(U$A1)-min(U$A1)))
)

U <- U %>% 
  mutate(v1 = 0.0003 * mult * A1) %>% 
  mutate(v2 = 0.0003 * mult * A2)



# plot diet PCoA
pcoa_diet <- ggplot(pcomp_diet, aes(A1, A2)) +
  # set up plot
  geom_hline(yintercept = 0, size = 0.2, lty = 2, colour = "grey") + 
  geom_vline(xintercept = 0, size = 0.2, lty = 2, colour = "grey") +
  # add origin lines
  #geom_text(alpha = 0.4, size = 1, aes(label = bsp))
  geom_point() +
  # add species
  coord_equal() +
  geom_segment(data = U, aes(x = 0, y = 0, xend = v1, yend = v2), 
               arrow = arrow(length = unit(0.2, "cm")), colour = "darkgrey") +
  # add arrows
  geom_text(data = U, aes(x = v1, y = v2, label = trait), size = 4, colour = "darkgrey",
            nudge_y = c(rep(0, 6), 0.005, 0.005, 0.0005, -0.004), 
            nudge_x = c(0.005, rep(0, 7), -0.009, 0)) +
  # add arrow labels
  labs(x = "PC1 (31.9%)", y = "PC2 (17.3%)") +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text = element_text(colour = "black"),
        legend.position = "none",
        text = element_text(size = 20))

pcoa_diet

