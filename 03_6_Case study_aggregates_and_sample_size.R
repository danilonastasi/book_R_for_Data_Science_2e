
#####  R. version: 4.3.2 2023/10/31  #####

##### from the book "R for Data Science" #####
##### Oreilly & Associates Inc; 2nd edition (July 18, 2023) #####

#####    code tested on 12/29/2023   #####


##### 3.6 Case study: aggregates and sample size #####

# Whenever you do any aggregation, it’s always a good idea to include a count (n()). 
# That way, you can ensure that you’re not drawing conclusions based on very small 
# amounts of data. We’ll demonstrate this with some baseball data from the Lahman package. 
# Specifically, we will compare what proportion of times a player gets a hit (H) vs. the 
# number of times they try to put the ball in play (AB):

install.packages("Lahman")
library(Lahman)
glimpse(Batting)
head(Batting, 20)

batters <- Lahman::Batting |> 
  group_by(playerID) |> 
  summarize(
    performance = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    n = sum(AB, na.rm = TRUE)
  )
batters

# When we plot the skill of the batter (measured by the batting average, performance) 
# against the number of opportunities to hit the ball (measured by times at bat, n), 
# you see two patterns:

  # 1. The variation in performance is larger among players with fewer at-bats. The shape 
     # of this plot is very characteristic: whenever you plot a mean (or other summary 
     # statistics) vs. group size, you’ll see that the variation decreases as the sample 
     # size increases4.
     
  # 2. There’s a positive correlation between skill (performance) and opportunities to hit 
     # the ball (n) because teams want to give their best batters the most opportunities 
     # to hit the ball.

batters |> 
  filter(n > 100) |> 
  ggplot(aes(x = n, y = performance)) +
  geom_point(alpha = 1 / 10) + 
  geom_smooth(se = FALSE)
