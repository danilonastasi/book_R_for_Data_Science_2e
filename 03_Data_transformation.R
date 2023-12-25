
#####  R. version: 4.3.2 2023/10/31  #####

##### from the book "R for Data Science" #####
##### Oreilly & Associates Inc; 2nd edition (July 18, 2023) #####

#####    code tested on _________   #####


##### 3  Data transformation #####

##### 3.1 Introduction #####

# this chapter introduces you to data transformation using the dplyr package 
# and a new dataset on flights that departed from New York City in 2013.


##### 3.1.1 Prerequisites #####

# In this chapter we’ll focus on the dplyr package, another core member of the tidyverse. 
# We’ll illustrate the key ideas using data from the nycflights13 package, and use ggplot2 
# to help us understand the data.

# install.packages("nycflights13")
library(nycflights13)
library(tidyverse)

# Take careful note of the conflicts message that’s printed when you load the tidyverse. 
# It tells you that dplyr overwrites some functions in base R. If you want to use the 
# base version of these functions after loading dplyr, you’ll need to use their full 
# names: stats::filter() and stats::lag(). So far we’ve mostly ignored which package a 
# function comes from because most of the time it doesn’t matter. However, knowing the 
# package can help you find help and find related functions, so when we need to be precise 
# about which package a function comes from, we’ll use the same syntax 
# as R: packagename::functionname().


##### 3.1.2 nycflights1 #####

# To explore the basic dplyr verbs, we’re going to use nycflights13::flights. This dataset 
# contains all 336,776 flights that departed from New York City in 2013. The data comes 
# from the US Bureau of Transportation Statistics, and is documented in ?flights.

flights

# flights is a tibble, a special type of data frame used by the tidyverse to avoid some 
# common gotchas. The most important difference between tibbles and data frames is the way 
# tibbles print; they are designed for large datasets, so they only show the first few 
# rows and only the columns that fit on one screen. There are a few options to see 
# everything. If you’re using RStudio, the most convenient is probably View(flights), 
# which will open an interactive scrollable and filterable view. Otherwise you can use: 

print(flights, width = Inf) # to show all columns 

# or use 

glimpse(flights)

# In both views, the variables names are followed by abbreviations that tell you the 
# type of each variable: <int> is short for integer, <dbl> is short for double 
# (aka real numbers), <chr> for character (aka strings), and <dttm> for date-time. 
# These are important because the operations you can perform on a column depend so much 
# on its “type”.


##### 3.1.3 dplyr basics #####

# You’re about to learn the primary dplyr verbs (functions) which will allow you to 
# solve the vast majority of your data manipulation challenges. But before we discuss 
# their individual differences, it’s worth stating what they have in common:

   # 1. The first argument is always a data frame.
   # 2. The subsequent arguments typically describe which columns to operate on, using the variable names (without quotes).
   # 3. The output is always a new data frame.

# Because each verb does one thing well, solving complex problems will usually require 
# combining multiple verbs, and we’ll do so with the pipe, |>. We’ll discuss the pipe more 
# in Section 3.4, but in brief, the pipe takes the thing on its left and passes it along 
# to the function on its right so that x |> f(y) is equivalent to f(x, y), 
# and x |> f(y) |> g(z) is equivalent to g(f(x, y), z). The easiest way to pronounce the 
# pipe is “then”. That makes it possible to get a sense of the following code even though 
# you haven’t yet learned the details:

flights |>
  filter(dest == "IAH") |> 
  group_by(year, month, day) |> 
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )

# dplyr’s verbs are organized into four groups based on what they operate on: rows, 
# columns, groups, or tables. In the following sections you’ll learn the most important 
# verbs for rows, columns, and groups, then we’ll come back to the join verbs that work 
# on tables in Chapter 19. Let’s dive in!


##### 3.2 Rows #####


##### 3.2.1 filter() #####

# filter() allows you to keep rows based on the values of the columns1. The first argument 
# is the data frame. The second and subsequent arguments are the conditions that must be 
# true to keep the row. For example, we could find all flights that departed more 
# than 120 minutes (two hours) late:

flights |> 
  filter(dep_delay > 120)

# As well as > (greater than), you can use >= (greater than or equal to), < (less than), 
# <= (less than or equal to), == (equal to), and != (not equal to). You can also combine 
# conditions with & or , to indicate “and” (check for both conditions) or with | to 
# indicate “or” (check for either condition):

# Flights that departed on January 1
flights |> 
  filter(month == 1 & day == 1)

# Flights that departed in January or February
flights |> 
  filter(month == 1 | month == 2)

# There’s a useful shortcut when you’re combining | and ==: %in%. It keeps rows where 
# the variable equals one of the values on the right:

# A shorter way to select flights that departed in January or February
flights |> 
  filter(month %in% c(1, 2))

# When you run filter() dplyr executes the filtering operation, creating a new data frame, 
# and then prints it. It doesn’t modify the existing flights dataset because dplyr 
# functions never modify their inputs. To save the result, you need to use the assignment 
# operator, <-:

jan1 <- flights |> 
  filter(month == 1 & day == 1)


##### 3.2.2 Common mistakes #####

# When you’re starting out with R, the easiest mistake to make is to use = 
# instead of == when testing for equality. filter() will let you know when this happens:

flights |> 
  filter(month = 1)  # we receive error because is not ==

# Another mistakes is you write “or” statements like you would in English:
flights |> 
  filter(month == 1 | 2)  # not the right code. Watch row 121 of this file

# This “works”, in the sense that it doesn’t throw an error, but it doesn’t do what you 
# want because | first checks the condition month == 1 and then checks the condition 2, 
# which is not a sensible condition to check. We’ll learn more about what’s happening here 
# and why in Section 15.6.2.


##### 3.2.3 arrange() #####

# arrange() changes the order of the rows based on the value of the columns. It takes a 
# data frame and a set of column names (or more complicated expressions) to order by. 
# If you provide more than one column name, each additional column will be used to break 
# ties in the values of preceding columns. For example, the following code sorts by the 
# departure time, which is spread over four columns. We get the earliest years first, 
# then within a year the earliest months, etc.

flights |> 
  arrange(year, month, day, dep_delay)

# You can use desc() on a column inside of arrange() to re-order the data frame based 
# on that column in descending (big-to-small) order. For example, this code orders 
# flights from most to least delayed:

flights |> 
  arrange(desc(dep_delay))


##### 3.2.4 distinct() #####

# distinct() finds all the unique rows in a dataset, so in a technical sense, it primarily 
# operates on the rows. Most of the time, however, you’ll want the distinct combination of 
# some variables, so you can also optionally supply column names:

# Remove duplicate rows, if any
flights |> 
  distinct()

# Find all unique origin and destination pairs
flights |> 
  distinct(origin, dest)

# Alternatively, if you want to the keep other columns when filtering for unique rows, 
# you can use the .keep_all = TRUE option.

flights |> 
  distinct(origin, dest, .keep_all = TRUE)

# It’s not a coincidence that all of these distinct flights are on January 1: distinct() 
# will find the first occurrence of a unique row in the dataset and discard the rest.

# If you want to find the number of occurrences instead, you’re better off swapping 
# distinct() for count(), and with the sort = TRUE argument you can arrange them in 
# descending order of number of occurrences. You’ll learn more about count in 
# Section 13.3.

flights |>
  count(origin, dest, sort = TRUE)


##### 3.2.5 Exercises #####

# 3. Sort flights to find the fastest flights. (Hint: Try including a math calculation 
#    inside of your function.)

print(flights |>
      arrange(distance/air_time), width = Inf)

# 4. Was there a flight on every day of 2013?

print(flights |>   
      distinct(day, month), width = Inf)

# 6. Does it matter what order you used filter() and arrange() if you’re using both? 
#    Why/why not? Think about the results and how much work the functions would have to do.

print(flights |>  
      arrange(desc(dep_delay)) |> filter(month == 7), width = Inf)

print(flights |>  
      filter(month == 7) |> arrange(desc(dep_delay)), width = Inf)

       # the result does't change


##### 3.3 Columns #####















