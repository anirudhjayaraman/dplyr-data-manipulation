# %>% OPERATOR ----------------------------------------------------------------------

# with %>% operator
hflights %>% 
  mutate(diff = TaxiOut - TaxiIn) %>% 
  filter(!is.na(diff)) %>% 
  summarise(avg = mean(diff))

# without %>% operator
# arguments get further and further apart
summarize(filter(mutate(hflights, diff = TaxiOut - TaxiIn),!is.na(diff)),
          avg = mean(diff))


# with %>% operator
d <- hflights %>% 
  select(Dest, UniqueCarrier, Distance, ActualElapsedTime) %>% 
  mutate(RealTime = ActualElapsedTime + 100, mph = Distance/RealTime*60)

# without %>% operator
d <- mutate(select(hflights, Dest, UniqueCarrier, Distance, ActualElapsedTime),
       RealTime = ActualElapsedTime + 100, mph = Distance/RealTime*60)

# Filter and summarise d
d %>% 
  filter(!is.na(mph), mph < 70) %>% 
  summarise(n_less = n(), n_dest = n_distinct(Dest), 
            min_dist = min(Distance), max_dist = max(Distance))

# Let's define preferable flights as flights that are 150% faster than driving, 
# i.e. that travel 105 mph or greater in real time. Also, assume that cancelled or 
# diverted flights are less preferable than driving. 


# ADVANCED PIPING EXERCISES
# Use one single piped call to print a summary with the following variables:
  
# n_non - the number of non-preferable flights in hflights,
# p_non - the percentage of non-preferable flights in hflights,
# n_dest - the number of destinations that non-preferable flights traveled to,
# min_dist - the minimum distance that non-preferable flights traveled,
# max_dist - the maximum distance that non-preferable flights traveled

hflights %>% 
  mutate(RealTime = ActualElapsedTime + 100, mph = Distance/RealTime*60) %>%
  filter(mph < 105 | Cancelled == 1 | Diverted == 1) %>%
  summarise(n_non = n(), p_non = 100*n_non/nrow(hflights), n_dest = n_distinct(Dest),
            min_dist = min(Distance), max_dist = max(Distance))

# Use summarise() to create a summary of hflights with a single variable, n, 
# that counts the number of overnight flights. These flights have an arrival 
# time that is earlier than their departure time. Only include flights that have 
# no NA values for both DepTime and ArrTime in your count.

hflights %>%
  mutate(overnight = (ArrTime < DepTime)) %>%
  filter(overnight == TRUE) %>%
  summarise(n = n())

# group_by() -------------------------------------------------------------------------

# Generate a per-carrier summary of hflights with the following variables: n_flights, 
# the number of flights flown by the carrier; n_canc, the number of cancelled flights; 
# p_canc, the percentage of cancelled flights; avg_delay, the average arrival delay of 
# flights whose delay does not equal NA. Next, order the carriers in the summary from 
# low to high by their average arrival delay. Use percentage of flights cancelled to 
# break any ties. Which airline scores best based on these statistics?

hflights %>% 
  group_by(UniqueCarrier) %>% 
  summarise(n_flights = n(), n_canc = sum(Cancelled), p_canc = 100*n_canc/n_flights, 
            avg_delay = mean(ArrDelay, na.rm = TRUE)) %>% arrange(avg_delay)

# Generate a per-day-of-week summary of hflights with the variable avg_taxi, 
# the average total taxiing time. Pipe this summary into an arrange() call such 
# that the day with the highest avg_taxi comes first.

hflights %>% 
  group_by(DayOfWeek) %>% 
  summarize(avg_taxi = mean(TaxiIn + TaxiOut, na.rm = TRUE)) %>% 
  arrange(desc(avg_taxi))

# Combine group_by with mutate-----

# First, discard flights whose arrival delay equals NA. Next, create a by-carrier 
# summary with a single variable: p_delay, the proportion of flights which are 
# delayed at arrival. Next, create a new variable rank in the summary which is a 
# rank according to p_delay. Finally, arrange the observations by this new rank
hflights %>% 
  filter(!is.na(ArrDelay)) %>% 
  group_by(UniqueCarrier) %>% 
  summarise(p_delay = sum(ArrDelay >0)/n()) %>% 
  mutate(rank = rank(p_delay)) %>% 
  arrange(rank) 

# n a similar fashion, keep flights that are delayed (ArrDelay > 0 and not NA). 
# Next, create a by-carrier summary with a single variable: avg, the average delay 
# of the delayed flights. Again add a new variable rank to the summary according to 
# avg. Finally, arrange by this rank variable.
hflights %>% 
  filter(!is.na(ArrDelay), ArrDelay > 0) %>% 
  group_by(UniqueCarrier) %>% 
  summarise(avg = mean(ArrDelay)) %>% 
  mutate(rank = rank(avg)) %>% 
  arrange(rank)

# Advanced group_by exercises-------------------------------------------------------

# Which plane (by tail number) flew out of Houston the most times? How many times?
# Name the column with this frequency n. Assign the result to adv1. To answer this 
# question precisely, you will have to filter() as a final step to end up with only 
# a single observation in adv1.
# Which plane (by tail number) flew out of Houston the most times? How many times? adv1
adv1 <- hflights %>% 
  group_by(TailNum) %>% 
  summarise(n = n()) %>%
  filter(n == max(n))

# How many airplanes only flew to one destination from Houston? adv2
# How many airplanes only flew to one destination from Houston? 
# Save the resulting dataset in adv2, that contains only a single column, 
# named nplanes and a single row.
adv2 <- hflights %>%
  group_by(TailNum) %>%
  summarise(n_dest = n_distinct(Dest)) %>%
  filter(n_dest == 1) %>%
  summarise(nplanes = n())

# Find the most visited destination for each carrier and save your solution to adv3. 
# Your solution should contain four columns:
# UniqueCarrier and Dest,
# n, how often a carrier visited a particular destination,
# rank, how each destination ranks per carrier. rank should be 1 for every row, 
# as you want to find the most visited destination for each carrier.

adv3 <- hflights %>%
  group_by(UniqueCarrier, Dest) %>%
  summarise(n = n()) %>%
  mutate(rank = rank(desc(n))) %>%
  filter(rank == 1)

# Find the carrier that travels to each destination the most: adv4
# For each destination, find the carrier that travels to that destination the most. 
# Store the result in adv4. Again, your solution should contain 4 columns: 
# Dest, UniqueCarrier, n and rank.

adv4 <- hflights %>%
  group_by(Dest, UniqueCarrier) %>%
  summarise(n = n()) %>%
  mutate(rank = rank(desc(n))) %>%
  filter(rank == 1)
  
