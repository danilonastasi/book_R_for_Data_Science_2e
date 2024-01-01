
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

# When you run read_csv(), it prints out a message telling you the number of rows and 
# columns of data, the delimiter that was used, and the column specifications (names of 
# columns organized by the type of data the column contains). It also prints out some 
# information about retrieving the full column specification and how to quiet this message. 
# This message is an integral part of readr, and we’ll return to it in Section 7.3.


##### 7.2.1 Practical advice #####

# Once you read data in, the first step usually involves transforming it in some way to 
# make it easier to work with in the rest of your analysis. Let’s take another look at 
# the students data with that in mind.

students

# In the favourite.food column, there are a bunch of food items, and then the character 
# string N/A, which should have been a real NA that R will recognize as “not available”. 
# This is something we can address using the na argument. By default, read_csv() 
# only recognizes empty strings ("") in this dataset as NAs, we want it to also recognize 
# the character string "N/A".

students <- read_csv("data/students.csv", na = c("N/A", ""))

students

# You might also notice that the Student ID and Full Name columns are surrounded by 
# backticks. That’s because they contain spaces, breaking R’s usual rules for variable 
# names; they’re non-syntactic names. To refer to these variables, you need to surround 
# them with backticks, `:

students |> 
  rename(
    student_id = `Student ID`,
    full_name = `Full Name`
  )

# An alternative approach is to use janitor::clean_names() to use some heuristics to 
# turn them all into snake case at once. The janitor package is not part of the tidyverse, 
# but it offers handy functions for data cleaning and works well within data pipelines 
# that use |>.

students |> janitor::clean_names

# Another common task after reading in data is to consider variable types. For example, 
# meal_plan is a categorical variable with a known set of possible values, which in R 
# should be represented as a factor:

students |>
  janitor::clean_names() |>
  mutate(meal_plan = factor(meal_plan))

# Note that the values in the meal_plan variable have stayed the same, but the type of 
# variable denoted underneath the variable name has changed from character (<chr>) to 
# factor (<fct>). You’ll learn more about factors in Chapter 16.

# Before you analyze these data, you’ll probably want to fix the age and id columns. 
# Currently, age is a character variable because one of the observations is typed out 
# as five instead of a numeric 5. We discuss the details of fixing this issue in 
# Chapter 20.

students <- students |>
  janitor::clean_names() |>
  mutate(
    meal_plan = factor(meal_plan),
    age = parse_number(if_else(age == "five", "5", age))
  )

students

# A new function here is if_else(), which has three arguments. The first argument test 
# should be a logical vector. The result will contain the value of the second argument, 
# yes, when test is TRUE, and the value of the third argument, no, when it is FALSE. 
# Here we’re saying if age is the character string "five", make it "5", and if not leave 
# it as age. You will learn more about if_else() and logical vectors in Chapter 12.


##### 7.2.2 Other arguments #####

# There are a couple of other important arguments that we need to mention, and they’ll be 
# easier to demonstrate if we first show you a handy trick: read_csv() can read text strings 
# that you’ve created and formatted like a CSV file:

read_csv(
  "a,b,c
  1,2,3
  4,5,6"
)

# Usually, read_csv() uses the first line of the data for the column names, which is a very 
# common convention. But it’s not uncommon for a few lines of metadata to be included at 
# the top of the file. You can use skip = n to skip the first n lines or use comment = "#" 
# to drop all lines that start with (e.g.) #:

read_csv(
  "The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3",
  skip = 2
)

read_csv(
  "# A comment I want to skip
  x,y,z
  1,2,3",
  comment = "#"
)

# In other cases, the data might not have column names. You can use col_names = FALSE to 
# tell read_csv() not to treat the first row as headings and instead label them 
# sequentially from X1 to Xn:

read_csv(
  "1,2,3
  4,5,6",
  col_names = FALSE
)

# Alternatively, you can pass col_names a character vector which will be used as the 
# column names:

read_csv(
  "1,2,3
  4,5,6",
  col_names = c("x", "y", "z")
)

# These arguments are all you need to know to read the majority of CSV files that 
# you’ll encounter in practice. (For the rest, you’ll need to carefully inspect 
# your .csv file and read the documentation for read_csv()’s many other arguments.)


##### 7.2.3 Other file types #####

# Once you’ve mastered read_csv(), using readr’s other functions is straightforward; 
# it’s just a matter of knowing which function to reach for:

  # read_csv2() # reads semicolon-separated files. These use ; instead of , to 
              # separate fields and are common in countries that use , as the 
              # decimal marker.

  # read_tsv() # reads tab-delimited files.

  # read_delim() # reads in files with any delimiter, attempting to automatically 
               # guess the delimiter if you don’t specify it.

  # read_fwf() # reads fixed-width files. You can specify fields by their widths 
             # with fwf_widths() or by their positions with fwf_positions().

  # read_table() # reads a common variation of fixed-width files where columns 
               # are separated by white space.

  # read_log() # reads Apache-style log files.

















