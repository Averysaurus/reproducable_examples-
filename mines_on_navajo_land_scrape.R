
# there may be some grumbling in the console when you run these, its loading packages up. 
if (!require("pdftools")) install.packages("pdftools")
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("plyr")) install.packages("plyr")
if (!require("fs")) install.packages("fs")

# loading libraries from package. 
library(pdftools)
library(tidyverse)
library(plyr)
library(fs)


### Import corpus of pdf text ##
# designate file path
PATH <- "~/Desktop/mines"
file_paths <- fs::dir_ls(PATH)
## go to Session > Set Working Directory > Choose Directory and choose the folder where the pdfs are. then look down there in the console window, find the directory and paste into where PATH is, in between the "quotes".

# empty variable 
file_contents <- list()

# function to import all pdf text 
for (i in seq_along(file_paths)){
  file_contents[[i]] <- pdftools::pdf_text(
    file_paths[[i]]
  )
}

# unlist file pdf data. 
file_contents_unlist <- paste(unlist(file_contents), collapse = " ")

# create lines to parse strings.
file_contents_lines <- 
  file_contents_unlist %>% 
  readr::read_lines() %>% 
  str_squish()


### Scraping 

mine_id <- file_contents_lines %>% 
  str_subset("(Mine ID: \\w+)") %>% 
  str_replace_all("Mine ID: ", "") %>% 
  str_squish()
mine_id <- paste(unique(mine_id), collapse = ' ') %>% 
  str_split(" ")

mine_id_df<- data.frame(mine_id)

map_id <-
  file_contents_lines %>% 
  str_subset("(Map ID:.\\w+)") %>% 
  str_replace_all("Map ID: ", '') %>% 
  str_squish() 
map_id_df <- data.frame(map_id)
  

cerlis <-
  file_contents_lines %>% 
  str_subset("(CERCLIS: \\w+)") %>% 
  str_replace_all("CERCLIS: ", '') %>% 
  str_squish() 
cerlis_df <- data.frame(cerlis)

namlrp_num <-
  file_contents_lines %>% 
  str_subset("(Navajo Abandoned Mine Land Reclamation Program: \\w+\\S+)") %>% 
  str_replace_all("Navajo Abandoned Mine Land Reclamation Program:", '') %>% 
  str_squish() 
namlrp_num_df <- data.frame(namlrp_num)

county <-
  file_contents_lines %>% 
  str_subset("(County: \\w+)") %>% 
  str_replace_all("Navajo Abandoned Mine Land Reclamation Program:", '') %>% 
  str_squish() 
county_df <- data.frame(county)


### Table Values ### Works when a text-based table is present is articles.. 
# Could error if values equal <1000..  

n_reads <- 
  file_contents_lines %>% 
  str_subset("(Number of Readings \\d+\\S\\d+)") %>% 
  str_extract("\\d+[:punct:]\\d+") %>% 
  str_squish() 

n_reads_df <- data.frame(n_reads)

gam_max <- 
  file_contents_lines %>% 
  str_subset("(Maximum \\S+\\s\\d+\\S\\d+)") %>% 
  str_extract("\\d+[:punct:]\\d+") %>% 
  str_squish() 

gam_max_df <- data.frame(gam_max)

gam_min <- 
  file_contents_lines %>% 
  str_subset("(Minimum \\S+\\s\\d+\\S\\d+)") %>% 
  str_extract("\\d+[:punct:]\\d+") %>% 
  str_squish() 

gam_min_df <- data.frame(gam_min)

gam_mean <- 
  file_contents_lines %>% 
  str_subset("(Mean \\S+\\s\\d+\\S\\d+)") %>% 
  str_extract("\\d+[:punct:]\\d+") %>% 
  str_squish() 

gam_mean_df <- data.frame(gam_mean)

gam_median <- 
  file_contents_lines %>% 
  str_subset("(Median \\S+\\s\\d+\\S\\d+)") %>% 
  str_extract("\\d+[:punct:]\\d+") %>% 
  str_squish() 

gam_median_df <- data.frame(gam_median)

sig_of_readings <- 
  file_contents_lines %>% 
  str_subset("(Standard Deviation \\d+\\S\\d+)") %>% 
  str_extract("\\d+[:punct:]\\d+") %>% 
  str_squish() 

sig_of_readings_df <- data.frame(sig_of_readings)


  
# mine coordinates
m_lat_long <- file_contents_lines %>% 
  str_subset("[ 0-9]+[[:punct:]][0-9]+\\sN.[[:punct:]]\\s[[:punct:]][0-9]+[[:punct:]][0-9]+\\s\\D") %>% 
  str_replace('Lat/Long: ', '') %>% 
  str_replace(' / ', ',') %>% 
  str_replace('N', '') %>% 
  str_replace('W', '') %>% 
  str_replace(' ,', ',') %>% 
  str_split(" ")

# has commas, needs functional formatting to data.frame. 
lat_long_col_df <- plyr::ldply(m_lat_long)

full_table_df <- cbind(mine_id, map_id_df, cerlis_df, namlrp_num, n_reads_df, gam_max_df, gam_min_df, gam_mean_df, gam_median_df, sig_of_readings_df, lat_long_col_df )

#write a csv with the full data. SHould be in the folder where the pdfs are. 
write.csv(full_table_df, "mine_tables.csv")



