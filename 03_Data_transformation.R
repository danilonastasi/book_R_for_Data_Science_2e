
#####  R. version: 4.3.2 2023/10/31  #####

##### from the book "R for Data Science" #####
##### Oreilly & Associates Inc; 2nd edition (July 18, 2023) #####

#####    code tested on 12/27/2023   #####


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

       # the result doesn't change


##### 3.3 Columns #####


##### 3.3.1 mutate() #####

# The job of mutate() is to add new columns that are calculated from the existing columns. 
# In the transform chapters, you’ll learn a large set of functions that you can use to 
# manipulate different types of variables. For now, we’ll stick with basic algebra, 
# which allows us to compute the gain, how much time a delayed flight made up in the air, 
# and the speed in miles per hour:

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60
  )

# By default, mutate() adds new columns on the right hand side of your dataset, 
# which makes it difficult to see what’s happening here. We can use the .before 
# argument to instead add the variables to the left hand side2:

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 1
  )

# The . is a sign that .before is an argument to the function, not the name of a third 
# new variable we are creating. You can also use .after to add after a variable, and 
# in both .before and .after you can use the variable name instead of a position. 
# For example, we could add the new variables after day:

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .after = day
  )

# Alternatively, you can control which variables are kept with the .keep argument. 
# A particularly useful argument is "used" which specifies that we only keep the columns 
# that were involved or created in the mutate() step. For example, the following output 
# will contain only the variables dep_delay, arr_delay, air_time, gain, hours, and 
# gain_per_hour.

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,
    .keep = "used"
  )

# Note that since we haven’t assigned the result of the above computation back to 
# flights, the new variables gain, hours, and gain_per_hour will only be printed but 
# will not be stored in a data frame. And if we want them to be available in a data 
# frame for future use, we should think carefully about whether we want the result to be 
# assigned back to flights, overwriting the original data frame with many more variables, 
# or to a new object. Often, the right answer is a new object that is named informatively
# to indicate its contents, e.g., delay_gain, but you might also have good reasons for 
# overwriting flights.


##### 3.3.2 select() #####

# It’s not uncommon to get datasets with hundreds or even thousands of variables. 
# In this situation, the first challenge is often just focusing on the variables you’re 
# interested in. select() allows you to rapidly zoom in on a useful subset using 
# operations based on the names of the variables:

# Select columns by name:
flights |> 
  select(year, month, day)

# Select all columns between year and day (inclusive):
flights |> 
  select(year:day)

# Select all columns except those from year to day (inclusive):
flights |> 
  select(!year:day)

# Historically this operation was done with - instead of !, so you’re likely to see 
# that in the wild. These two operators serve the same purpose but with subtle differences 
# in behavior. We recommend using ! because it reads as “not” and combines well 
# with & and |.

# Select all columns that are characters:
flights |> 
  select(where(is.character))

# There are a number of helper functions you can use within select():
   # starts_with("abc"): matches names that begin with “abc”.
   # ends_with("xyz"): matches names that end with “xyz”.
   # contains("ijk"): matches names that contain “ijk”.
   # num_range("x", 1:3): matches x1, x2 and x3.

# See ?select for more details. Once you know regular expressions (the topic of Chapter 15) 
# you’ll also be able to use matches() to select variables that match a pattern.

# You can rename variables as you select() them by using =. The new name appears on the 
# left hand side of the =, and the old variable appears on the right hand side:

flights |> 
  select(tail_num = tailnum)  # creates a copy


##### 3.3.3. rename #####

# If you want to keep all the existing variables and just want to rename a few, you can 
# use rename() instead of select():

flights |> 
  rename(tail_num = tailnum)

# If you have a bunch of inconsistently named columns and it would be painful to fix 
# them all by hand, check out janitor::clean_names() which provides some useful 
# automated cleaning.


##### 3.3.4 relocate() #####

# Use relocate() to move variables around. You might want to collect related variables 
# together or move important variables to the front. By default relocate() moves 
# variables to the front:

flights |> 
  relocate(time_hour, air_time)

# You can also specify where to put them using the .before and .after arguments, 
# just like in mutate():

flights |> 
  relocate(year:dep_time, .after = time_hour)
flights |> 
  relocate(starts_with("arr"), .before = dep_time)


##### 3.3.5 Exercises #####

# 2. Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, 
# and arr_delay from flights.

flights |> 
  select(starts_with("dep"), starts_with("arr"))

flights |> 
  select(starts_with(c("dep", "arr")))

flights |> 
  select(dep_time, dep_delay, arr_time, arr_delay)

# 4. What does the any_of() function do? Why might it be helpful in conjunction with 
# this vector?

variables <- c("year", "month", "day", "dep_delay", "arr_delay")
flights |> 
  select(any_of(variables))

# 5. Does the result of running the following code surprise you? How do the select 
# helpers deal with upper and lower case by default? How can you change that default?

flights |> select(contains("TIME"))

# 6. Rename air_time to air_time_min to indicate units of measurement and move it to 
# the beginning of the data frame.

flights |> 
  mutate(
    air_time_min = air_time * 60,
    .before = 1
  )


##### 3.4 The pipe #####

# We’ve shown you simple examples of the pipe above, but its real power arises when 
# you start to combine multiple verbs. For example, imagine that you wanted to find 
# the fast flights to Houston’s IAH airport: you need to combine filter(), mutate(), 
# select(), and arrange():

flights |> 
  filter(dest == "IAH") |> 
  mutate(speed = distance / air_time * 60) |> 
  select(year:day, dep_time, carrier, flight, speed) |> 
  arrange(desc(speed))

# To add the pipe to your code, we recommend using the built-in keyboard shortcut 
# Ctrl/Cmd + Shift + M. You’ll need to make one change to your RStudio options to 
# use |> instead of %>% as shown in Figure 3.1; more on %>% shortly.

# magrittr
# If you’ve been using the tidyverse for a while, you might be familiar with the %>% pipe 
# provided by the magrittr package. The magrittr package is included in the core tidyverse, 
# so you can use %>% whenever you load the tidyverse:

# For simple cases, |> and %>% behave identically. So why do we recommend the base pipe? 
# Firstly, because it’s part of base R, it’s always available for you to use, even when 
# you’re not using the tidyverse. 


##### 3.5 Groups #####


##### 3.5.1 group_by() #####

# Use group_by() to divide your dataset into groups meaningful for your analysis:

flights |> 
  group_by(month)

# group_by() doesn’t change the data but, if you look closely at the output, you’ll notice 
# that the output indicates that it is “grouped by” month (Groups: month [12]). This means 
# subsequent operations will now work “by month”. group_by() adds this grouped feature 
# (referred to as class) to the data frame, which changes the behavior of the subsequent 
# verbs applied to the data.


##### 3.5.2 summarize() #####

# The most important grouped operation is a summary, which, if being used to calculate a 
# single summary statistic, reduces the data frame to have a single row for each group. 
# In dplyr, this operation is performed by summarize()3, as shown by the following example, 
# which computes the average departure delay by month:

flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay)
  )

# N.B. Uhoh! Something has gone wrong and all of our results are NAs (pronounced “N-A”), 
# R’s symbol for missing value. This happened because some of the observed flights had 
# missing data in the delay column, and so when we calculated the mean including those 
# values, we got an NA result. We’ll come back to discuss missing values in detail in 
# Chapter 18, but for now we’ll tell the mean() function to ignore all missing values 
# by setting the argument na.rm to TRUE:

flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE)
  )

# You can create any number of summaries in a single call to summarize(). You’ll learn 
# various useful summaries in the upcoming chapters, but one very useful summary is n(), 
# which returns the number of rows in each group:

flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), 
    n = n()
  )

# Means and counts can get you a surprisingly long way in data science!


##### 3.5.3 The slice_ functions #####

# There are five handy functions that allow you extract specific rows within each group:

   # df |> slice_head(n = 1) takes the first row from each group.
   # df |> slice_tail(n = 1) takes the last row in each group.
   # df |> slice_min(x, n = 1) takes the row with the smallest value of column x.
   # df |> slice_max(x, n = 1) takes the row with the largest value of column x.
   # df |> slice_sample(n = 1) takes one random row.

# You can vary n to select more than one row, or instead of n =, you can use prop = 0.1 
# to select (e.g.) 10% of the rows in each group. For example, the following code finds 
# the flights that are most delayed upon arrival at each destination:

flights |> 
  group_by(dest) |> 
  slice_max(arr_delay, n = 1) |>
  relocate(dest)

# Note that there are 105 destinations but we get 108 rows here. What’s up? slice_min() 
# and slice_max() keep tied values so n = 1 means give us all rows with the highest value. 
# If you want exactly one row per group you can set with_ties = FALSE.

# This is similar to computing the max delay with summarize(), but you get the whole 
# corresponding row (or rows if there’s a tie) instead of the single summary statistic.

flights |> 
  group_by(dest) |> 
  slice_max(arr_delay, n = 1, with_ties = FALSE) |>
  relocate(dest)


##### 3.5.4 Grouping by multiple variables #####

# You can create groups using more than one variable. For example, we could make a group 
# for each date.

daily <- flights |>  
  group_by(year, month, day)

daily

# When you summarize a tibble grouped by more than one variable, each summary peels off 
# the last group. In hindsight, this wasn’t a great way to make this function work, but 
# it’s difficult to change without breaking existing code. To make it obvious what’s 
# happening, dplyr displays a message that tells you how you can change this behavior:

daily_flights <- daily |> 
  summarize(n = n())
#> `summarise()` has grouped output by 'year', 'month'. You can override using
#> the `.groups` argument.

# If you’re happy with this behavior, you can explicitly request it in order to suppress 
# the message:

daily_flights <- daily |> 
  summarize(
    n = n(), 
    .groups = "drop_last"
  )

# Alternatively, change the default behavior by setting a different value, e.g., "drop" 
# to drop all grouping or "keep" to preserve the same groups.


##### 3.5.5 Ungrouping #####

# You might also want to remove grouping from a data frame without using summarize(). 
# You can do this with ungroup().

daily |> 
  ungroup()

# Now let’s see what happens when you summarize an ungrouped data frame.

daily |> 
  ungroup() |>
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), 
    flights = n()
  )

# You get a single row back because dplyr treats all the rows in an ungrouped data 
# frame as belonging to one group.


##### 3.5.6 .by  #####

# dplyr 1.1.0 includes a new, experimental, syntax for per-operation grouping, 
# the .by argument. group_by() and ungroup() aren’t going away, but you can now also 
# use the .by argument to group within a single operation:

# Or if you want to group by multiple variables:

flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE), 
    n = n(),
    .by = c(origin, dest)
  )

# .by works with all verbs and has the advantage that you don’t need to use the .groups 
# argument to suppress the grouping message or ungroup() when you’re done.

# We didn’t focus on this syntax in this chapter because it was very new when we wrote 
# the book. We did want to mention it because we think it has a lot of promise and it’s 
# likely to be quite popular. You can learn more about it in the dplyr 1.1.0 blog post.


##### 3.5.7 Exercises #####

# 1. Which carrier has the worst average delays? Challenge: can you disentangle the 
#    effects of bad airports vs. bad carriers? Why/why not? (Hint: think about 
#    flights |> group_by(carrier, dest) |> summarize(n()))

flights |> 
   group_by(carrier) |>
   summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), 
    n = n()) |>
   arrange(desc(avg_delay))

flights |> 
   group_by(carrier) |>
   summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), 
    n = n()) |>
    slice_max(avg_delay, n = 1, with_ties = FALSE) |>
    relocate(carrier) # |>
   # arrange(desc(avg_delay))

flights |> 
   group_by(origin, dest) |>
   summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), 
    n = n()) |>
   arrange(desc(avg_delay))

# 2. Find the flights that are most delayed upon departure from each destination.

flights |> 
   select(dest, origin, dep_delay, flight, carrier) |>
   group_by(dest) |>
   slice_max(dep_delay, n = 1, with_ties = FALSE) |>
   arrange(desc(dep_delay))

# 3. How do delays vary over the course of the day. Illustrate your answer with a plot.

hr_delay <- flights |>
   group_by(hour) |>
   summarize(
      avg_delay = mean(dep_delay, na.rm = TRUE), 
      n = n()) # |>
   # arrange(desc(avg_delay))

ggplot(hr_delay, aes(x = hour, y = avg_delay)) + 
    geom_point(size = 2) +
    geom_smooth() +
labs(
    title = "How do delays vary over the course of the day?",
    subtitle = "comparing hours ( 5:00 to 23:00) and average delay (minutes)",
    x = "hours", y = "average delay (minutes)"
  )

# ggplot(hr_delay, aes(x = hour, y = avg_delay)) + 
 #   geom_point(aes(color = n)) +
 #   geom_smooth()

# hr_delay_agg <- aggregate(dep_delay ~ hour, data=flights, sum) # I sum all the values 
                                                   # (dep_delay that have the same hour

# 4. What happens if you supply a negative n to slice_min() and friends?

flights |> 
  group_by(dest) |> 
  slice_min(arr_delay, n = -1) |>  # we get all flights rows but sorted by minimum
                                   # arr_delay
  relocate(dest)

# 5. Explain what count() does in terms of the dplyr verbs you just learned. 
#    What does the sort argument to count() do?

   # count() finds all the unique rows in a dataset, removing duplicate rows, so in a 
   # technical sense, it primarily operates on the rows.

   # Will find the first occurrence of a unique row in the dataset and discard the rest.

   # count() permits you to find the number of occurrences, and with the 
   # sort = TRUE argument  you can arrange them in descending order of number 
   # of occurrences.

# 6. Suppose we have the following tiny data frame:

df <- tibble(
  x = 1:5,
  y = c("a", "b", "a", "a", "b"),
  z = c("K", "K", "L", "L", "K")
)

# a. Write down what you think the output will look like, then check if you were 
# correct, and describe what group_by() does.
##### answer: we get a data frame 5 x 3 with 3 variables in columns x, y, z

df |>
  group_by(y)

# b. Write down what you think the output will look like, then check if you were 
# correct, and describe what arrange() does. Also comment on how it’s different 
# from the group_by() in part (a)?
##### answer: same result as above but we select the group y

df |>
  arrange(y)

# Write down what you think the output will look like, then check if you were correct, 
# and describe what the pipeline does.
##### answer: we sort the data frame by the variable y

df |>
  group_by(y) |>
  summarize(mean_x = mean(x))

# Write down what you think the output will look like, then check if you were correct, 
# and describe what the pipeline does. Then, comment on what the message says.
##### answer: we select the group y and we calculate for y the average value of x
#####         associated to the same value of y, we semplify the data frame

df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))

# Write down what you think the output will look like, then check if you were correct, 
# and describe what the pipeline does. How is the output different from the one in part (d).
##### answer: we do the same as above but this time we operate for y and z combinations

df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x), .groups = "drop")

# Write down what you think the outputs will look like, then check if you were correct, 
# and describe what each pipeline does. How are the outputs of the two pipelines different?
##### answer: same result as above but we drop all groups

df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))  # we get a tibble 3 x 3

df |>
  group_by(y, z) |>
  mutate(mean_x = mean(x)) # same result as above but we get a tibble 5 x 4

