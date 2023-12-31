
#####  R. version: 4.3.2 2023/10/31  #####
##### RStudio - 2023.12.0 - Build 369 ######

##### from the book "R for Data Science" #####
##### Oreilly & Associates Inc; 2nd edition (July 18, 2023) #####

#####    code tested on 12/30/2023   #####


##### 6.1 Scripts #####

# To give yourself more room to work, use the script editor (RStudio). Open it up by clicking 
# the File menu, selecting New File, then R script, or using the keyboard 
# shortcut Cmd/Ctrl + Shift + N.


##### 6.1.1 Running code #####

# The script editor is an excellent place for building complex ggplot2 plots or long 
# sequences of dplyr manipulations. The key to using the script editor effectively is to 
# memorize one of the most important keyboard shortcuts: Cmd/Ctrl + Enter. This executes 
# the current R expression in the console. For example, take the code below.

library(dplyr)
library(nycflights13)

not_cancelled <- flights |> 
  filter(!is.na(dep_delay)█, !is.na(arr_delay))

not_cancelled |> 
  group_by(year, month, day) |> 
  summarize(mean = mean(dep_delay))

# If your cursor is at █, pressing Cmd/Ctrl + Enter will run the complete command that 
# generates not_cancelled. It will also move the cursor to the following statement 
# (beginning with not_cancelled |>). That makes it easy to step through your complete 
# script by repeatedly pressing Cmd/Ctrl + Enter.

# Instead of running your code expression-by-expression, you can also execute the complete 
# script in one step with Cmd/Ctrl + Shift + S. Doing this regularly is a great way to 
# ensure that you’ve captured all the important parts of your code in the script.

# We recommend you always start your script with the packages you need. That way, if you 
# share your code with others, they can easily see which packages they need to install. 
# Note, however, that you should never include install.packages() in a script you share. 
# It’s inconsiderate to hand off a script that will change something on their computer if 
# they’re not being careful!

# When working through future chapters, we highly recommend starting in the script editor 
# and practicing your keyboard shortcuts. Over time, sending code to the console in this 
# way will become so natural that you won’t even think about it.


##### 6.1.2 RStudio diagnostics #####

# In the script editor, RStudio will highlight syntax errors with a red squiggly line 
# and a cross in the sidebar.

# Hover over the cross to see what the problem is.

# RStudio will also let you know about potential problems.


##### 6.1.3 Saving and naming #####

# RStudio automatically saves the contents of the script editor when you quit, and 
# automatically reloads it when you re-open. Nevertheless, it’s a good idea to avoid 
# Untitled1, Untitled2, Untitled3, and so on and instead save your scripts and to give 
# them informative names.

# It might be tempting to name your files code.R or myscript.R, but you should think a 
# bit harder before choosing a name for your file. Three important principles for 
# file naming are as follows:

  # 1. File names should be machine readable: avoid spaces, symbols, and special characters. 
  #    Don’t rely on case sensitivity to distinguish files.
  # 2. File names should be human readable: use file names to describe what’s in the file.
  # 3. File names should play well with default ordering: start file names with numbers 
  #    so that alphabetical sorting puts them in the order they get used.


##### 6.2 Projects #####

# One day, you will need to quit R, go do something else, and return to your analysis later. 
# One day, you will be working on multiple analyses simultaneously and you want to keep 
# them separate. One day, you will need to bring data from the outside world into R and 
# send numerical results and figures from R back out into the world.

# To handle these real life situations, you need to make two decisions:

  # 1. What is the source of truth? What will you save as your lasting record of 
  #    what happened?
  # 2. Where does your analysis live?


##### 6.2.1 What is the source of truth? #####

# As a beginner, it’s okay to rely on your current Environment to contain all the objects 
# you have created throughout your analysis. However, to make it easier to work on larger 
# projects or collaborate with others, your source of truth should be the R scripts. 
# With your R scripts (and your data files), you can recreate the environment. With only 
# your environment, it’s much harder to recreate your R scripts: you’ll either have to 
# retype a lot of code from memory (inevitably making mistakes along the way) or 
# you’ll have to carefully mine your R history.

# To help keep your R scripts as the source of truth for your analysis, we highly recommend 
# that you instruct RStudio not to preserve your workspace between sessions. You can do 
# this either by running usethis::use_blank_slate() -> 
# -> (If you don’t have usethis installed, you can install it with install.packages("usethis") 
# or by mimicking the options shown in Figure 6.2. 
# This will cause you some short-term pain, because now when you 
# restart RStudio, it will no longer remember the code that you ran last time nor will 
# the objects you created or the datasets you read be available to use. But this short-term 
# pain saves you long-term agony because it forces you to capture all important procedures 
# in your code. There’s nothing worse than discovering three months after the fact that 
# you’ve only stored the results of an important calculation in your environment, 
# not the calculation itself in your code.

# There is a great pair of keyboard shortcuts that will work together to make sure you’ve 
# captured the important parts of your code in the editor:

  # 1. Press Cmd/Ctrl + Shift + 0/F10 to restart R.
  # 2. Press Cmd/Ctrl + Shift + S to re-run the current script.

# We collectively use this pattern hundreds of times a week.

# Alternatively, if you don’t use keyboard shortcuts, you can go to Session > Restart R 
# and then highlight and re-run your current script.


##### 6.2.2 Where does your analysis live? #####

# R has a powerful notion of the working directory. This is where R looks for files that 
# you ask it to load, and where it will put any files that you ask it to save. 
# RStudio shows your current working directory at the top of the console:

# And you can print this out in R code by running getwd():

getwd()

# As a beginning R user, it’s OK to let your working directory be your home directory, 
# documents directory, or any other weird directory on your computer. But you’re seven 
# chapters into this book, and you’re no longer a beginner. Very soon now you should 
# evolve to organizing your projects into directories and, when working on a project, 
# set R’s working directory to the associated directory.

# You can set the working directory from within R but we do not recommend it:

setwd("/path/to/my/CoolProject")

# There’s a better way; a way that also puts you on the path to managing your R work 
# like an expert. That way is the RStudio project.


##### 6.2.3 RStudio projects #####

# Keeping all the files associated with a given project (input data, R scripts, analytical 
# results, and figures) together in one directory is such a wise and common practice that 
# RStudio has built-in support for this via projects. Let’s make a project for you to use 
# while you’re working through the rest of this book. Click File > New Project, then follow 
# the steps shown in Figure 6.3:

# file --> new project --> new directory --> new project --> directory name: r4ds , 
# create project as subdirectory of: "read next rows"

# Call your project r4ds (R for data science) and think carefully about which subdirectory 
# you put the project in. If you don’t store it somewhere sensible, it will be hard to 
# find it in the future!

# Once this process is complete, you’ll get a new RStudio project just for this book. 
# Check that the “home” of your project is the current working directory:

getwd()

# Now enter the following commands in the script editor, and save the file, calling it 
# “diamonds.R”. Then, create a new folder called “data”. You can do this by clicking on 
# the “New Folder” button in the Files pane in RStudio. Finally, run the complete script 
# which will save a PNG and CSV file into your project directory. Don’t worry about the 
# details, you’ll learn them later in the book.

library(tidyverse)

ggplot(diamonds, aes(x = carat, y = price)) + 
  geom_hex()
ggsave("diamonds.png")

write_csv(diamonds, "data/diamonds.csv")

# Quit RStudio. Inspect the folder associated with your project — notice the .Rproj file. 
# Double-click that file to re-open the project. Notice you get back to where you left off: 
# it’s the same working directory and command history, and all the files you were working 
# on are still open. Because you followed our instructions above, you will, however, have 
# a completely fresh environment, guaranteeing that you’re starting with a clean slate.

# In your favorite OS-specific way, search your computer for diamonds.png and you will find 
# the PNG (no surprise) but also the script that created it (diamonds.R). This is a huge win! 
# One day, you will want to remake a figure or just understand where it came from. 
# If you rigorously save figures to files with R code and never with the mouse or the 
# clipboard, you will be able to reproduce old work with ease!


##### 6.2.4 Relative and absolute paths #####

# Once you’re inside a project, you should only ever use relative paths not absolute paths. 
# What’s the difference? A relative path is relative to the working directory, i.e. the 
# project’s home. When Hadley wrote data/diamonds.csv above it was a shortcut 
# for /Users/hadley/Documents/r4ds/data/diamonds.csv. But importantly, if Mine ran this 
# code on her computer, it would point to /Users/Mine/Documents/r4ds/data/diamonds.csv. 
# This is why relative paths are important: they’ll work regardless of where the R project 
# folder ends up.

# Absolute paths point to the same place regardless of your working directory. They look a 
# little different depending on your operating system. On Windows they start with a drive 
# letter (e.g., C:) or two backslashes (e.g., \\servername) and on Mac/Linux they start 
# with a slash “/” (e.g., /users/hadley). You should never use absolute paths in your 
# scripts, because they hinder sharing: no one else will have exactly the same directory 
# configuration as you.

# There’s another important difference between operating systems: how you separate the 
# components of the path. Mac and Linux uses slashes (e.g., data/diamonds.csv) and Windows 
# uses backslashes (e.g., data\diamonds.csv). R can work with either type (no matter what 
# platform you’re currently using), but unfortunately, backslashes mean something special 
# to R, and to get a single backslash in the path, you need to type two backslashes! That 
# makes life frustrating, so we recommend always using the Linux/Mac style with forward 
# slashes.











