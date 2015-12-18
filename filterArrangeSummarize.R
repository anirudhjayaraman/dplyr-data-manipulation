# FILTER() --------------------------------------------------------------------------

# Print out all flights in hflights that traveled 3000 or more miles
filter(hflights, Distance > 3000)

# All flights flown by one of JetBlue, Southwest, or Delta
filter(hflights, UniqueCarrier %in% c('JetBlue', 'Southwest', 'Delta'))

# All flights where taxiing took longer than flying
filter(hflights, TaxiIn + TaxiOut > AirTime)

# Combining tests using boolean operators

# All flights that departed before 5am or arrived after 10pm
filter(hflights, DepTime < 500 | ArrTime > 2200 )

# All flights that departed late but arrived ahead of schedule
filter(hflights, DepDelay > 0 & ArrDelay < 0)

# All cancelled weekend flights
filter(hflights, DayOfWeek %in% c(6,7) & Cancelled == 1)

# All flights that were cancelled after being delayed
filter(hflights, Cancelled == 1, DepDelay > 0)

# Summarizing Exercise
# Select the flights that had JFK as their destination: c1
c1 <- filter(hflights, Dest == 'JFK')

# Combine the Year, Month and DayofMonth variables to create a Date column: c2
c2 <- mutate(c1, Date = paste(Year, Month, DayofMonth, sep = "-"))

# Print out a selection of columns of c2
select(c2, Date, DepTime, ArrTime, TailNum)

# How many weekend flights flew a distance of more than 1000 miles 
# but had a total taxiing time below 15 minutes?
nrow(filter(hflights, DayOfWeek %in% c(6,7), Distance > 1000, TaxiIn + TaxiOut < 15)) 


# ARRANGE() --------------------------------------------------------------------------

# Definition of dtc
dtc <- filter(hflights, Cancelled == 1, !is.na(DepDelay))

# Arrange dtc by departure delays
arrange(dtc, DepDelay)

# Arrange dtc so that cancellation reasons are grouped
arrange(dtc, CancellationCode)

# Arrange dtc according to carrier and departure delays
arrange(dtc, UniqueCarrier, DepDelay)

# Arrange according to carrier and decreasing departure delays
arrange(hflights, UniqueCarrier, desc(DepDelay))

# Arrange flights by total delay (normal order).
arrange(hflights, DepDelay + ArrDelay)

# Keep flights leaving to DFW before 8am and arrange according to decreasing AirTime 
arrange(filter(hflights, Dest == 'DFW', DepTime < 800), desc(AirTime))

# list containing only TailNum of flights that departed too late, sorted by 
# total taxiing time
# First select a threshold for departure delay by finding max DepDelay
max(filter(select(hflights, DepDelay), !is.na(DepDelay)))
select(arrange(filter(hflights, DepDelay > 360), TaxiIn + TaxiOut), TailNum)

# SUMMARISE() -----------------------------------------------------------------------

# Print out a summary with variables min_dist and max_dist
summarize(hflights, min_dist = min(Distance), max_dist = max(Distance))

# Print out a summary with variable max_div
summarize(filter(hflights, Diverted == 1), max_div = max(Distance))

# Remove rows that have NA ArrDelay: temp1
temp1 <- filter(hflights, !is.na(ArrDelay))

# Generate summary about ArrDelay column of temp1
summarise(temp1, earliest = min(ArrDelay), average = mean(ArrDelay), 
          latest = max(ArrDelay), sd = sd(ArrDelay))

# Keep rows that have no NA TaxiIn and no NA TaxiOut: temp2
temp2 <- filter(hflights, !is.na(TaxiIn), !is.na(TaxiOut))

# Print the maximum taxiing difference of temp2 with summarise()
summarise(temp2, max_taxi_diff = max(abs(TaxiIn - TaxiOut)))

# Generate summarizing statistics for hflights
summarise(hflights, n_obs = n(), n_carrier = n_distinct(UniqueCarrier), 
          n_dest = n_distinct(Dest), dest100 = nth(Dest, 100))

# Filter hflights to keep all American Airline flights: aa
aa <- filter(hflights, UniqueCarrier == "American")

# Generate summarizing statistics for aa 
summarise(aa, n_flights = n(), n_canc = sum(Cancelled), 
          p_canc = 100*(n_canc/n_flights), avg_delay = mean(ArrDelay, na.rm = TRUE))
