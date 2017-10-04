### Reporting on key findings.

library(dplyr)

## load data ####
bikes <-
  read.csv("../data/processed/bikes1516.csv")

## change between years ####
bikes2015 <-
  bikes %>%
  dplyr::select(year, noOfBikes) %>%
  dplyr::filter(year == 2015) %>%
  .$noOfBikes %>%
  sum(., na.rm = T)

bikes2016 <-
  bikes %>%
  dplyr::select(year, noOfBikes) %>%
  dplyr::filter(year == 2016) %>%
  .$noOfBikes %>%
  sum(., na.rm = T)

print(paste(round((bikes2016 / bikes2015 - 1) * 100, 1),
            "% increase from 2015 to 2016?"))
