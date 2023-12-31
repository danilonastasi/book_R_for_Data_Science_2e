
#####  R. version: 4.3.2 2023/10/31  #####

##### from the book "R for Data Science" #####
##### Oreilly & Associates Inc; 2nd edition (July 18, 2023) #####

#####    code tested on 12/29/2023   #####


##### 5  Data tidying #####


##### 5.1 Introduction #####

# In this chapter, you will learn a consistent way to organize your data in R using a 
# system called tidy data. Getting your data into this format requires some work up front, 
# but that work pays off in the long term. Once you have tidy data and the tidy tools 
# provided by packages in the tidyverse, you will spend much less time munging data from one 
# representation to another, allowing you to spend more time on the data questions you 
# care about.


##### 5.1.1 Prerequisites ######

# In this chapter, we’ll focus on tidyr, a package that provides a bunch of tools to help 
# tidy up your messy datasets. tidyr is a member of the core tidyverse.

library(tidyverse)


##### 5.2 Tidy data #####

# You can represent the same underlying data in multiple ways. The example below shows 
# the same data organized in three different ways. Each dataset shows the same values 
# of four variables: country, year, population, and number of documented cases of TB 
# (tuberculosis), but each dataset organizes the values in a different way.

table1

table2

table3

# One of them, table1, will be much easier to work with inside the tidyverse 
# because it’s tidy.

# There are three interrelated rules that make a dataset tidy:

  # Each variable is a column; each column is a variable.
  # Each observation is a row; each row is an observation.
  # Each value is a cell; each cell is a single value.

# dplyr, ggplot2, and all the other packages in the tidyverse are designed to work with 
# tidy data. Here are a few small examples showing how you might work with table1.

# Compute rate per 10,000
table1 |>
  mutate(rate = cases / population * 10000)   # add a new column

# Compute total cases per year
table1 |> 
  group_by(year) |>    # we group year and we work for year column
  summarize(total_cases = sum(cases))  # we sum all cases per year, adding 
                                       # the column total_cases

# Visualize changes over time
ggplot(table1, aes(x = year, y = cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country, shape = country)) +
  scale_x_continuous(breaks = c(1999, 2000)) # x-axis breaks at 1999 and 2000

# in Brazil we have the major increasement of cases from 1999 to 2000


##### 5.3 Lengthening data #####

# tidyr provides two functions for pivoting data: pivot_longer() and pivot_wider(). 
# We’ll first start with pivot_longer() because it’s the most common case. Let’s dive 
# into some examples.


##### 5.3.1 Data in column names #####

# The billboard dataset records the billboard rank of songs in the year 2000:

billboard

# In this dataset, each observation is a song. The first three columns (artist, track 
# and date.entered) are variables that describe the song. Then we have 76 columns 
# (wk1-wk76) that describe the rank of the song in each week1. Here, the column names 
# are one variable (the week) and the cell values are another (the rank).

# To tidy this data, we’ll use pivot_longer():

billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week",  # "week"  quoted because those are new variables we’re creating
    values_to = "rank"  # "rank"     "      "        "        "        "          "
  )

# we have finally more rows and less columns

# After the data, there are three key arguments:

  # - cols specifies which columns need to be pivoted, i.e. which columns aren’t variables. 
  #   This argument uses the same syntax as select() so here we could use !c(artist, track, 
  #   date.entered) or starts_with("wk").
  # - names_to names the variable stored in the column names, we named that variable week.
  # - values_to names the variable stored in the cell values, we named that variable rank.

# Now let’s turn our attention to the resulting, longer data frame. What happens if a 
# song is in the top 100 for less than 76 weeks? Take 2 Pac’s “Baby Don’t Cry”, 
# for example. The above output suggests that it was only in the top 100 for 7 weeks, 
# and all the remaining weeks are filled in with missing values. These NAs don’t really 
# represent unknown observations; they were forced to exist by the structure of the 
# dataset2, so we can ask pivot_longer() to get rid of them by setting 
# values_drop_na = TRUE:

billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank",
    values_drop_na = TRUE
  )

# The number of rows is now much lower, indicating that many rows with NAs were dropped.

# You might also wonder what happens if a song is in the top 100 for more than 76 weeks? 
# We can’t tell from this data, but you might guess that additional columns 
# wk77, wk78, … would be added to the dataset.

# This data is now tidy, but we could make future computation a bit easier by converting 
# values of week from character strings to numbers 
# using mutate() and readr::parse_number(). parse_number() is a handy function 
# that will extract the first number from a string, ignoring all other text.

billboard_longer <- billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank",
    values_drop_na = TRUE
  ) |> 
  mutate(
    week = parse_number(week) # will extract the first number from a string, 
                              # ignoring all other text.
  )

billboard_longer

# Now that we have all the week numbers in one variable and all the rank values in 
# another, we’re in a good position to visualize how song ranks vary over time. 
# The code is shown below and the result is in Figure 5.2. We can see that very few 
# songs stay in the top 100 for more than 20 weeks.

billboard_longer |> 
  ggplot(aes(x = week, y = rank, group = track)) + 
  geom_line(alpha = 0.25) + 
  scale_y_reverse()


##### 5.3.2 How does pivoting work? #####

# Now that you’ve seen how we can use pivoting to reshape our data, let’s take a little 
# time to gain some intuition about what pivoting does to the data. Let’s start with a 
# very simple dataset to make it easier to see what’s happening. Suppose we have three 
# patients with ids A, B, and C, and we take two blood pressure measurements on each 
# patient. We’ll create the data with tribble(), a handy function for constructing 
# small tibbles by hand:

df <- tribble(
  ~id,  ~bp1, ~bp2,
   "A",  100,  120,
   "B",  140,  115,
   "C",  120,  125
)

# We want our new dataset to have three variables: id (already exists), measurement 
# (the column names), and value (the cell values). To achieve this, we need to 
# pivot df longer:

df |> 
  pivot_longer(
    cols = bp1:bp2,
    names_to = "measurement",
    values_to = "value"
  )


##### 5.3.3 Many variables in column names #####

# A more challenging situation occurs when you have multiple pieces of information 
# crammed into the column names, and you would like to store these in separate new 
# variables. For example, take the who2 dataset, the source of table1 and friends 
# that you saw above:

who2

# This dataset, collected by the World Health Organisation, records information about 
# tuberculosis diagnoses. There are two columns that are already variables and are easy 
# to interpret: country and year. They are followed by 56 columns like sp_m_014, 
# ep_m_4554, and rel_m_3544. If you stare at these columns for long enough, you’ll 
# notice there’s a pattern. Each column name is made up of three pieces separated 
# by _. The first piece, sp/rel/ep, describes the method used for the diagnosis, 
# he second piece, m/f is the gender (coded as a binary variable in this dataset), 
# and the third piece, 014/1524/2534/3544/4554/5564/65 is the age range 
# (014 represents 0-14, for example).

# So in this case we have six pieces of information recorded in who2: the country and 
# the year (already columns); the method of diagnosis, the gender category, and the 
# age range category (contained in the other column names); and the count of patients 
# in that category (cell values). To organize these six pieces of information in six 
# separate columns, we use pivot_longer() with a vector of column names for names_to 
# and instructors for splitting the original variable names into pieces for names_sep 
# as well as a column name for values_to:

who2 |> 
  pivot_longer(
    cols = !(country:year),
    names_to = c("diagnosis", "gender", "age"), 
    names_sep = "_",
    values_to = "count"
  )

# An alternative to names_sep is names_pattern, which you can use to extract variables 
# from more complicated naming scenarios, once you’ve learned about regular expressions 
# in Chapter 15.


##### 5.3.4 Data and variable names in the column headers #####

# The next step up in complexity is when the column names include a mix of variable 
# values and variable names. For example, take the household dataset:

household

# This dataset contains data about five families, with the names and dates of birth of up 
# to two children. The new challenge in this dataset is that the column names contain the 
# names of two variables (dob, name) and the values of another (child, with values 1 or 2). 
# To solve this problem we again need to supply a vector to names_to but this time we 
# use the special ".value" sentinel; this isn’t the name of a variable but a unique 
# value that tells pivot_longer() to do something different. This overrides the usual 
# values_to argument to use the first component of the pivoted column name as a variable 
# name in the output.

household |> 
  pivot_longer(
    cols = !family, 
    names_to = c(".value", "child"), 
    names_sep = "_", 
    values_drop_na = TRUE
  )

# We again use values_drop_na = TRUE, since the shape of the input forces the creation 
# of explicit missing variables (e.g., for families with only one child).


##### 5.4 Widening data #####

# So far we’ve used pivot_longer() to solve the common class of problems where values 
# have ended up in column names. Next we’ll pivot (HA HA) to pivot_wider(), which makes 
# datasets wider by increasing columns and reducing rows and helps when one observation 
# is spread across multiple rows. This seems to arise less commonly in the wild, but 
# it does seem to crop up a lot when dealing with governmental data.

# We’ll start by looking at cms_patient_experience, a dataset from the Centers of 
# Medicare and Medicaid services that collects data about patient experiences:

cms_patient_experience

# The core unit being studied is an organization, but each organization is spread 
# across six rows, with one row for each measurement taken in the survey organization. 
# We can see the complete set of values for measure_cd and measure_title by 
# using distinct():

cms_patient_experience |> 
  distinct(measure_cd, measure_title)

# Neither of these columns will make particularly great variable names: measure_cd doesn’t 
# hint at the meaning of the variable and measure_title is a long sentence containing 
# spaces. We’ll use measure_cd as the source for our new column names for now, but in a 
# real analysis you might want to create your own variable names that are both short and 
# meaningful.

# pivot_wider() has the opposite interface to pivot_longer(): instead of choosing new 
# column names, we need to provide the existing columns that define the values 
# (values_from) and the column name (names_from):

cms_patient_experience |> 
  pivot_wider(
    names_from = measure_cd,
    values_from = prf_rate
  )

# The output doesn’t look quite right; we still seem to have multiple rows for each 
# organization. That’s because, we also need to tell pivot_wider() which column or 
# columns have values that uniquely identify each row; in this case those are the 
# variables starting with "org":

cms_patient_experience |> 
  pivot_wider(
    id_cols = starts_with("org"),
    names_from = measure_cd,
    values_from = prf_rate
  )

# This gives us the output that we’re looking for.


##### 5.4.1 How does pivot_wider() work? #####

# To understand how pivot_wider() works, let’s again start with a very simple dataset. 
# This time we have two patients with ids A and B, we have three blood pressure 
# measurements on patient A and two on patient B:

df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "B",        "bp1",    140,
  "B",        "bp2",    115, 
  "A",        "bp2",    120,
  "A",        "bp3",    105
)

# We’ll take the values from the value column and the names from the measurement column:

df |> 
  pivot_wider(
    names_from = measurement,
    values_from = value
  )

# To begin the process pivot_wider() needs to first figure out what will go in the 
# rows and columns. The new column names will be the unique values of measurement.

df |> 
  distinct(measurement) |> 
  pull()

# By default, the rows in the output are determined by all the variables that aren’t 
# going into the new names or values. These are called the id_cols. Here there is only 
# one column, but in general there can be any number.

df |> 
  select(-measurement, -value) |> 
  distinct()

# pivot_wider() then combines these results to generate an empty data frame:

df |> 
  select(-measurement, -value) |> 
  distinct() |> 
  mutate(x = NA, y = NA, z = NA)

# It then fills in all the missing values using the data in the input. In this case, 
# not every cell in the output has a corresponding value in the input as there’s no 
# third blood pressure measurement for patient B, so that cell remains missing. We’ll 
# come back to this idea that pivot_wider() can “make” missing values in Chapter 18.

# You might also wonder what happens if there are multiple rows in the input that 
# correspond to one cell in the output. The example below has two rows that correspond 
# to id “A” and measurement “bp1”:

df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "A",        "bp1",    102,
  "A",        "bp2",    120,
  "B",        "bp1",    140, 
  "B",        "bp2",    115
)

# If we attempt to pivot this we get an output that contains list-columns, which you’ll 
# learn more about in Chapter 23:

df |>
  pivot_wider(
    names_from = measurement,
    values_from = value
  )
# we get a warning

# Since you don’t know how to work with this sort of data yet, you’ll want to follow 
# the hint in the warning to figure out where the problem is:

df |> 
  group_by(id, measurement) |> 
  summarize(n = n(), .groups = "drop") |> 
  filter(n > 1)

# It’s then up to you to figure out what’s gone wrong with your data and either repair 
# the underlying damage or use your grouping and summarizing skills to ensure that 
# each combination of row and column values only has a single row.


##### 5.5 Summary #####

# The examples we presented here are a selection of those from 
# vignette("pivot", package = "tidyr"), so if you encounter a problem that this chapter 
# doesn’t help you with, that vignette is a good place to try next.

# We didn’t actually define what a variable is (and it’s surprisingly hard to do so). 
# It’s totally fine to be pragmatic and to say a variable is whatever makes your analysis 
# easiest. So if you’re stuck figuring out how to do some computation, consider 
# switching up the organisation of your data; don’t be afraid to untidy, transform, 
# and re-tidy as needed!

# If you enjoyed this chapter and want to learn more about the underlying theory, 
# you can learn more about the history and theoretical underpinnings in the 
# Tidy Data paper published in the Journal of Statistical Software.




