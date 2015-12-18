# SELECT AND MUTATE

hflights[c('ActualElapsedTime','ArrDelay','DepDelay')]
# Equivalently, using dplyr:
select(hflights, ActualElapsedTime, ArrDelay, DepDelay)

# Print out a tbl with the four columns of hflights related to delay
select(hflights, ActualElapsedTime, AirTime, ArrDelay, DepDelay)

# Print out hflights, nothing has changed!
hflights

# Print out the columns Origin up to Cancelled of hflights
select(hflights, Origin:Cancelled)

# Find the most concise way to select: columns Year up to and 
# including DayOfWeek, columns ArrDelay up to and including Diverted
# Answer to last question: be concise! 
# You may want to examine the order of hflight's column names before you 
# begin with names()
names(hflights)
select(hflights, -(DepTime:AirTime))

# Helper functions used with dplyr

# Print out a tbl containing just ArrDelay and DepDelay
select(hflights, ArrDelay, DepDelay)
# Use a combination of helper functions and variable names to print out 
# only the UniqueCarrier, FlightNum, TailNum, Cancelled, and CancellationCode 
# columns of hflights
select(hflights, UniqueCarrier, FlightNum, contains("Tail"), contains("Cancel"))

# Find the most concise way to return the following columns with select and its 
# helper functions: DepTime, ArrTime, ActualElapsedTime, AirTime, ArrDelay, 
# DepDelay. Use only helper functions
select(hflights, ends_with("Time"), ends_with("Delay"))

# Some comparisons to basic R
# both hflights and dplyr are available

ex1r <- hflights[c("TaxiIn","TaxiOut","Distance")]
ex1d <- select(hflights, TaxiIn, TaxiOut, Distance) 

ex2r <- hflights[c("Year","Month","DayOfWeek","DepTime","ArrTime")]
ex2d <- select(hflights, Year:ArrTime, -DayofMonth)

ex3r <- hflights[c("TailNum","TaxiIn","TaxiOut")]
ex3d <- select(hflights, TailNum, contains("Taxi"))

# mutate

# Add the new variable ActualGroundTime to a copy of hflights and save the result as g1.
g1 <- mutate(hflights, ActualGroundTime = ActualElapsedTime - AirTime)

# Add the new variable GroundTime to a g1. Save the result as g2.
g2 <- mutate(g1, GroundTime = TaxiIn + TaxiOut)

# Add the new variable AverageSpeed to g2. Save the result as g3.
g3 <- mutate(g2, AverageSpeed = Distance / AirTime * 60)

# Print out g3
g3

# Add a second variable loss_percent to the dataset: m1
m1 <- mutate(hflights, loss = ArrDelay - DepDelay, 
             loss_percent = ((ArrDelay - DepDelay)/DepDelay)*100)

# mutate() allows you to use a new variable while creating a next variable 
# in the same call
# Copy and adapt the previous command to reduce redendancy: m2
m2 <- mutate(hflights, loss = ArrDelay - DepDelay, 
             loss_percent = (loss/DepDelay) * 100 )

# Add the three variables as described in the third instruction: m3
m3 <- mutate(hflights, TotalTaxi = TaxiIn + TaxiOut, 
             ActualGroundTime = ActualElapsedTime - AirTime, 
             Diff = TotalTaxi - ActualGroundTime)
