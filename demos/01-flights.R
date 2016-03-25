# QUESTION: Which NYC airport has the longest delays for a given day of the week?

library(nycflights13) # data
library(dplyr)        # cleaning functions
library(ggplot2)      # plotting functions
library(lubridate)    # date-time processing

# Make a new data frame named delays. Make it like this:
#   take flights and then
#   mutate it to create a new date variable
#     and a new weekday variable, then
#   select just the origin, date, weekday, and dep_delay columns, then
#   filter out the rows where dep_delay equals NA
delays <-
  flights %>%
  mutate(date = ymd(paste(year, month, day)), 
         weekday = wday(date, label = TRUE, abbr = FALSE)) %>% 
  select(origin, date, weekday, dep_delay) %>%
  filter(!is.na(dep_delay)) 

# MOTIVATION: Delays fluctuate throughout the year

# Make a new data frame named year. Make it like this:
#   take delays and then
#   group its rows into unique combinations of origin and date, then 
#   summarise the data by calculating the mean dep_delay for each group
year <-
  delays %>% 
  group_by(origin, date) %>% 
  summarise(mean_delay = mean(dep_delay))

# Plot the mean departure delay over time by airport
ggplot(year, aes(x = date, y = mean_delay, color = origin)) + 
  geom_point(alpha = 0.2) +
  geom_smooth(se = FALSE) +
  ggtitle("Smoothed daily mean delays") + 
  ylab("Mean delay (m)") + 
  theme_bw()


# METHOD: Choose a day of the week and aggregate delays by airport

# Pick a day of the week
dow <- "Saturday"

# Make a new data frame named weekday. Make it like this:
#   take delays and then
#   filter out rows where weekday does not equal the day above, then
#   group its rows by origin, then 
#   summarise the data by calculating the mean dep_delay for each group
weekday <- 
  delays %>%
  filter(weekday == dow) %>%
  group_by(origin) %>%
  summarise(mean_delay = mean(dep_delay))

# RESULTS: Newark has the longest delay, LaGuardia the least

# Plot the mean delay by airport for the selected day of the week
ggplot(weekday, aes(x = origin)) + 
  geom_bar(aes(weight = mean_delay)) +
  ggtitle(paste("Expected", dow, "departure delay", sep = " ")) + 
  ylab("Mean delay (m)") +
  xlab("")

# A table of mean delays
weekday

# Which airport has the shortest mean departure delay on Saturday?
c("EWR" = "Newark", "JFK" = "JFK", "LGA" = "LaGuardia")[[weekday$origin[which.min(weekday$mean_delay)]]]

# How long is that mean delay?
round(min(weekday$mean_delay), 2)
