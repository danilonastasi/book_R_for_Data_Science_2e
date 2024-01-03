
#####  R. version: 4.3.2 2023/10/31  #####
##### RStudio - 2023.12.0 - Build 369 ######

##### from the book "R for Data Science" #####
##### Oreilly & Associates Inc; 2nd edition (July 18, 2023) #####

#####    code tested on 01/03/2024   #####


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

# students <- read_csv("data/students.csv", na = c("N/A", "")) # error missing the 
                                                        # file in data/students.csv
students <- read_csv("https://pos.it/r4ds-students-csv", na = c("N/A", ""))

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

# install.packages("janitor")
library(janitor)
students |> janitor::clean_names()  

# Another common task after reading in data is to consider variable types. For example, 
# meal_plan is a categorical variable with a known set of possible values, which in R 
# should be represented as a factor:

students |>
  janitor::clean_names() |> # we don't need this function anymore
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
  skip = 2   # we skip "the first line of metadata" and "the second line of metadata"
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


##### 7.3 Controlling column types #####


##### 7.3.1 Guessing types #####

# readr uses a heuristic to figure out the column types. For each column, it 
# pulls the values of 1,000^2 rows spaced evenly from the first row to the 
# last, ignoring missing values. It then works through the following questions:

  # - Does it contain only F, T, FALSE, or TRUE (ignoring case)? If so, it’s 
  #   a logical.
  # - Does it contain only numbers (e.g., 1, -4.5, 5e6, Inf)? If so, it’s a 
  #   number.
  # - Does it match the ISO8601 standard? If so, it’s a date or date-time. 
  #   (We’ll return to date-times in more detail in Section 17.2).
  # - Otherwise, it must be a string

# You can see that behavior in action in this simple example:

read_csv("
  logical,numeric,date,string
  TRUE,1,2021-01-15,abc
  false,4.5,2021-02-15,def
  T,Inf,2021-02-16,ghi
")

# This heuristic works well if you have a clean dataset, but in real life, 
# you’ll encounter a selection of weird and beautiful failures.


##### 7.3.2 Missing values, column types, and problems #####

# The most common way column detection fails is that a column contains 
# unexpected values, and you get a character column instead of a more 
# specific type. One of the most common causes for this is a missing value, 
# recorded using something other than the NA that readr expects.

# Take this simple 1 column CSV file as an example:

simple_csv <- "
  x
  10
  .
  20
  30"

# If we read it without any additional arguments, x becomes a character 
# column:

read_csv(simple_csv)

# In this very small case, you can easily see the missing value .. But what 
# happens if you have thousands of rows with only a few missing values 
# represented by .s sprinkled among them? One approach is to tell readr that 
# x is a numeric column, and then see where it fails. You can do that with the 
# col_types argument, which takes a named list where the names match the 
# column names in the CSV file:

df <- read_csv(
  simple_csv, 
  col_types = list(x = col_double())
)

# Now read_csv() reports that there was a problem, and tells us we can 
# find out more with problems():

problems(df)

# This tells us that there was a problem in row 3, col 1 where readr 
# expected a double but got a .. That suggests this dataset uses . 
# for missing values. So then we set na = ".", the automatic guessing 
# succeeds, giving us the numeric column that we want:

read_csv(simple_csv, na = ".")


##### 7.3.3 Column types #####

# readr provides a total of nine column types for you to use:

  # - col_logical() and col_double() read logicals and real numbers. They’re 
  #   relatively rarely needed (except as above), since readr will usually guess them 
  #   for you.
  # - col_integer() reads integers. We seldom distinguish integers and doubles in 
  #   this book because they’re functionally equivalent, but reading integers explicitly 
  #   can occasionally be useful because they occupy half the memory of doubles.
  # - col_character() reads strings. This can be useful to specify explicitly 
  #   when you have a column that is a numeric identifier, i.e., long series of 
  #   digits that identifies an object but doesn’t make sense to apply mathematical 
  #   operations to. Examples include phone numbers, social security numbers, credit card 
  #   numbers, etc.
  # - col_factor(), col_date(), and col_datetime() create factors, dates, and date-times 
  #   respectively; you’ll learn more about those when we get to those data types in 
  #   Chapter 16 and Chapter 17.
  # - col_number() is a permissive numeric parser that will ignore non-numeric components, 
  #   and is particularly useful for currencies. You’ll learn more about it in Chapter 13.
  # - col_skip() skips a column so it’s not included in the result, which can be useful for 
  #   speeding up reading the data if you have a large CSV file and you only want to use 
  #   some of the columns.

# It’s also possible to override the default column by switching from list() to cols() and 
# specifying .default:

another_csv <- "
x,y,z
1,2,3"

read_csv(
  another_csv, 
  col_types = cols(.default = col_character())
)

# Another useful helper is cols_only() which will read in only the columns you specify:

read_csv(
  another_csv,
  col_types = cols_only(x = col_character())
)


##### 7.4 Reading data from multiple files #####

# Sometimes your data is split across multiple files instead of being contained in a single 
# file. For example, you might have sales data for multiple months, with each month’s data 
# in a separate file: 01-sales.csv for January, 02-sales.csv for February, and 03-sales.csv 
# for March. With read_csv() you can read these data in at once and stack them on top of each 
# other in a single data frame.

sales_files <- c("data/01-sales.csv", "data/02-sales.csv", "data/03-sales.csv")
read_csv(sales_files, id = "file")

# Once again, the code above will work if you have the CSV files in a data folder in your 
# project. You can download these files from https://pos.it/r4ds-01-sales, 
# https://pos.it/r4ds-02-sales, and https://pos.it/r4ds-03-sales or you can read them 
# directly with:

sales_files <- c(
  "https://pos.it/r4ds-01-sales",
  "https://pos.it/r4ds-02-sales",
  "https://pos.it/r4ds-03-sales"
)
read_csv(sales_files, id = "file")

# The id argument adds a new column called file to the resulting data frame that 
# identifies the file the data come from. This is especially helpful in circumstances 
# where the files you’re reading in do not have an identifying column that can help you 
# trace the observations back to their original sources.

# If you have many files you want to read in, it can get cumbersome to write out their 
# names as a list. Instead, you can use the base list.files() function to find the files 
# for you by matching a pattern in the file names. You’ll learn more about these patterns 
# in Chapter 15.

sales_files <- list.files("data", pattern = "sales\\.csv$", full.names = TRUE)
sales_files


##### 7.5 Writing to a file #####

# readr also comes with two useful functions for writing data back to disk: write_csv() 
# and write_tsv(). The most important arguments to these functions are x (the data frame 
# to save) and file (the location to save it). You can also specify how missing values 
# are written with na, and if you want to append to an existing file.

write_csv(students, "students.csv")

# Now let’s read that csv file back in. Note that the variable type information that 
# you just set up is lost when you save to CSV because you’re starting over with reading 
# from a plain text file again:

students

write_csv(students, "students-2.csv")
read_csv("students-2.csv")

# This makes CSVs a little unreliable for caching interim results—you need to recreate 
# the column specification every time you load in. There are two main alternatives:

  # 1. write_rds() and read_rds() are uniform wrappers around the base functions 
  #    readRDS() and saveRDS(). These store data in R’s custom binary format 
  #    called RDS. This means that when you reload the object, you are loading 
  #    the exact same R object that you stored.

       write_rds(students, "students.rds")
       read_rds("students.rds")

  # 2. The arrow package allows you to read and write parquet files, a fast binary 
  #    file format that can be shared across programming languages. We’ll return 
  #    to arrow in more depth in Chapter 22.

       library(arrow)
       write_parquet(students, "students.parquet")
       read_parquet("students.parquet")

# Parquet tends to be much faster than RDS and is usable outside of R, but does 
# require the arrow package.


##### 7.6 Data entry #####

# Sometimes you’ll need to assemble a tibble “by hand” doing a little data entry in your
# R script. There are two useful functions to help you do this which differ in whether 
# you layout the tibble by columns or by rows. tibble() works by column:

tibble(
  x = c(1, 2, 5), 
  y = c("h", "m", "g"),
  z = c(0.08, 0.83, 0.60)
)

# Laying out the data by column can make it hard to see how the rows are related, so an 
# alternative is tribble(), short for transposed tibble, which lets you lay out your 
# data row by row. tribble() is customized for data entry in code: column headings start 
# with ~ and entries are separated by commas. This makes it possible to lay out small 
# amounts of data in an easy to read form:

tribble(
  ~x, ~y, ~z,
  1, "h", 0.08,
  2, "m", 0.83,
  5, "g", 0.60
)












