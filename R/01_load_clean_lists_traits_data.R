# Script to load and clean raw data set 
# Mauricio Dalia
# Last update:
# Source of the original dataset: 

# Start----
# Packages ----------------------------------------------------------------
library(tidyverse)
library(inspectdf)
library(forcats)
library(plyr)

#Carregando os dados----
#Mamiferos da Caatinga----
datlistmam <- read.csv("data/raw/mam_caat.csv", header = F)
head(datlistmam)
datlistmam2 <- dplyr::rename(datlistmam, 
                            sp = V1
)
str(datlistmam2)
na_check <- inspectdf::inspect_na(datlistmam2)
na_check
any(duplicated(datlistmam2)) 
write.csv(x = datlistmam2, 
          file = "data/processed/processed_list_mam_caat.csv", 
          row.names = FALSE)
datlistmam_p <- read.csv("data/processed/processed_list_mam_caat.csv")

#Mamiferos caçados----
datlisthunt <- read.csv("data/raw/mam_list_hunt.csv")

#Traços Ecológicos----
dattraits <- read.table("data/raw/traits.txt", sep = ",", header = T)
head(dattraits)
dattraits2 <- dplyr::rename(dattraits, 
                             sp = binomial
)
write.csv(x = dattraits2, 
          file = "data/processed/processed_traits.csv", 
          row.names = FALSE)
dattraits_p <- read.csv("data/processed/processed_traits.csv")


#Extraindo dados
dattraitcaat <- plyr::join(datlistmam_p, dattraits_p,
     type = "inner")

write.csv(x = dattraitcaat, 
          file = "data/processed/processed_traits_mam_caat.csv", 
          row.names = FALSE)

