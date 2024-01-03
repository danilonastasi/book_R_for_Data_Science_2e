
#####  R. version: 4.3.2 2023/10/31  #####
##### RStudio - 2023.12.0 - Build 369 ######

##### from the book "R for Data Science" #####
##### Oreilly & Associates Inc; 2nd edition (July 18, 2023) #####

#####    code tested on ______   #####


##### 8  Workflow: getting help #####


##### 8.1 Google is your friend #####

# (If the error message isn’t in English, run 
# Sys.setenv(LANGUAGE = "en") 
# and re-run the code; you’re more likely to find help for English 
# error messages.)

# If Google doesn’t help, try Stack Overflow. Start by spending a little time 
# searching for an existing answer, including [R], to restrict your search to 
# questions and answers that use R.


##### 8.2 Making a reprex #####

# If your googling doesn’t find anything useful, it’s a really good idea to 
# prepare a reprex, short for minimal reproducible example. A good reprex makes it 
# easier for other people to help you, and often you’ll figure out the problem 
# yourself in the course of making it. There are two parts to creating a reprex:

  # - First, you need to make your code reproducible. This means that you need to 
  #   capture everything, i.e. include any library() calls and create all necessary 
  #   objects. The easiest way to make sure you’ve done this is using the reprex 
  #   package.

  # - Second, you need to make it minimal. Strip away everything that is not directly 
  #   related to your problem. This usually involves creating a much smaller and 
  #   simpler R object than the one you’re facing in real life or even using 
  #   built-in data.

# That sounds like a lot of work! And it can be, but it has a great payoff:

  # - 80% of the time, creating an excellent reprex reveals the source of your problem. 
  #   It’s amazing how often the process of writing up a self-contained and minimal 
  #   example allows you to answer your own question.

  # - The other 20% of the time, you will have captured the essence of your problem 
  #   in a way that is easy for others to play with. This substantially improves your 
  #   chances of getting help!

# When creating a reprex by hand, it’s easy to accidentally miss something, meaning 
# your code can’t be run on someone else’s computer. Avoid this problem by using the 
# reprex package, which is installed as part of the tidyverse. Let’s say you copy 
# this code onto your clipboard (or, on RStudio Server or Cloud, select it):

y <- 1:4
mean(y)

# Then call reprex(), where the default output is formatted for GitHub:

# reprex::reprex()  # initially I got an error, let's try installing the package

# install.packages("reprex")
library(reprex)

y <- 1:4
mean(y)

reprex() # now it works, copied in clipboard using RStudio not R

# A nicely rendered HTML preview will display in RStudio’s Viewer (if you’re in RStudio) 
# or your default browser otherwise. The reprex is automatically copied to your clipboard 
# (on RStudio Server or Cloud, you will need to copy this yourself):

``` r
y <- 1:4
mean(y)
#> [1] 2.5
```

# This text is formatted in a special way, called Markdown, which can be pasted to sites 
# like StackOverflow or Github and they will automatically render it to look like code. 
# Here’s what that Markdown would look like rendered on GitHub:

y <- 1:4
mean(y)
#> [1] 2.5

# Anyone else can copy, paste, and run this immediately.

# There are three things you need to include to make your example reproducible: 
# required packages, data, and code.

  # 1. Packages should be loaded at the top of the script so it’s easy to see 
  #    which ones the example needs. This is a good time to check that you’re 
  #    using the latest version of each package; you may have discovered a bug 
  #    that’s been fixed since you installed or last updated the package. For packages 
  #    in the tidyverse, the easiest way to check is to run 
       
         tidyverse_update()

  # 2. The easiest way to include data is to use dput() to generate the R code needed 
  #    to recreate it. For example, to recreate the mtcars dataset in R, perform the 
  #    following steps:

  #     1. Run dput(mtcars) in R
  #     2. Copy the output
  #     3. In reprex, type mtcars <-, then paste.

  #     Try to use the smallest subset of your data that still reveals the problem.

  # 3. Spend a little bit of time ensuring that your code is easy for others to read:

  #    - Make sure you’ve used spaces and your variable names are concise yet 
  #      informative.
  #    - Use comments to indicate where your problem lies.
  #    - Do your best to remove everything that is not related to the problem.

  #    The shorter your code is, the easier it is to understand and the easier 
  #    it is to fix.

# Finish by checking that you have actually made a reproducible example by starting 
# a fresh R session and copying and pasting your script


##### 8.3 Investing in yourself #####

# You should also spend some time preparing yourself to solve problems before 
# they occur. Investing a little time in learning R each day will pay off 
# handsomely in the long run. One way is to follow what the tidyverse team is 
# doing on the tidyverse blog. To keep up with the R community more broadly, 
# we recommend reading R Weekly: it’s a community effort to aggregate the most 
# interesting news in the R community each week.



