
#####  R. version: 4.3.2 2023/10/31  #####
##### RStudio - 2023.12.0 - Build 369 ######

##### from the book "R for Data Science" #####
##### Oreilly & Associates Inc; 2nd edition (July 18, 2023) #####

#####    code tested on ______   #####


##### 7.1.1 Prerequisites #####

# In this chapter, you’ll learn how to load flat files in R with the readr package, 
# which is part of the core tidyverse.

library(tidyverse)


##### 7.2 Reading data from a file #####

# To begin, we’ll focus on the most common rectangular data file type: CSV, which is 
# short for comma-separated values. The first row, commonly called the header row, 
# gives the column names, and the following six rows provide the data. The columns 
# are separated, aka delimited, by commas.

# We can read this file into R using read_csv(). The first argument is the most 
# important: the path to the file. You can think about the path as the address of the 
# file: the file is called students.csv and that it lives in the data folder.

students <- read_csv("data/students.csv")

# The code above will work if you have the students.csv file in a data folder in your 
# project. You can download the students.csv file from https://pos.it/r4ds-students-csv 
# or you can read it directly from that URL with:

students <- read_csv("https://pos.it/r4ds-students-csv")





