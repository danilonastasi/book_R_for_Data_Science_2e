
#####  R. version: 4.3.2 2023/10/31  #####

##### from the book "R for Data Science" #####
##### Oreilly & Associates Inc; 2nd edition (July 18, 2023) #####



##### 2  Workflow: basics #####

##### 2.1 Coding basics #####

# You can combine multiple elements into a vector with c():
primes <- c(2, 3, 5, 7, 11, 13)

# And basic arithmetic on vectors is applied to every element of of the vector:
primes * 2
#> [1]  4  6 10 14 22 26
primes - 1
#> [1]  1  2  4  6 10 12


##### 2.2 Comments #####

# Use comments to explain the why of your code, not the how or the what. The what and how 
# of your code are always possible to figure out, even if it might be tedious, by carefully 
# reading it. If you describe every step in the comments, and then change the code, you will 
# have to remember to update the comments as well or it will be confusing when you return 
# to your code in the future.


##### 2.3 What’s in a name? #####

# Object names must start with a letter and can only contain letters, numbers, _, and .. 
# You want your object names to be descriptive, so you’ll need to adopt a convention for 
# multiple words. 


##### 2.4 Calling functions #####

# R has a large collection of built-in functions that are called like this:

function_name(argument1 = value1, argument2 = value2, ...) 

# Type the name of the first argument, from, and set it equal to 1. Then, type the name 
# of the second argument, to, and set it equal to 10. Finally, hit return.

seq(from = 1, to = 10)
#>  [1]  1  2  3  4  5  6  7  8  9 10

# We often omit the names of the first several arguments in function calls, so we can 
# rewrite this as follows:
seq(1, 10)
#>  [1]  1  2  3  4  5  6  7  8  9 10




