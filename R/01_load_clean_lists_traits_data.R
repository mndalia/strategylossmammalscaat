#Carregando os dados----
#Mamiferos da Caatinga----
library(googlesheets4)
datlistmam <- read_sheet(ss="https://docs.google.com/spreadsheets/d/17r2wn1nD07B7LY8vvGQe_t0pxUcPSUO1Q0JnNlEZ-xQ/edit?usp=sharing",
                         col_names = F)
                         

#Mamiferos caçados----
datlisthunt <- read_sheet("",
                          col_names = F)

#Traços Ecológicos----
dattraits <- read.csv("https://raw.githubusercontent.com/03rcooke/hyper_pca/master/data/trait.csv")

#Verificando e limpando dados brutos----
#Checando Classes----
str(datlistmam)
str(datlisthunt)
str(dattraits)

#### Checando colunas e linhas----
nrow(datlistmam)
head(datlistmam)
nrow(datlisthunt)
head(datlisthunt)
nrow(dattraits)
head(dattraits)

#Checando duplicados e NA----
any(duplicated(datlistmam)) 
any(is.na(datlistmam)) 
any(duplicated(datlisthunt)) 
any(is.na(datlisthunt)) 
any(duplicated(dattraits)) 
any(is.na(dattraits)) 


sub(" ","_", dattraits$binomial)
  

