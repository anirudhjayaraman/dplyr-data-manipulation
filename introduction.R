# INTRODUCTION TO dplyr AND tbls
# Load the dplyr package
library(dplyr)

# Load the hflights package
library(hflights)

# Call both head() and summary() on hflights
head(hflights)
summary(hflights)


# Convert the hflights data.frame into a hflights tbl
hflights <- tbl_df(hflights)

# Display the hflights tbl
hflights

# Create the object carriers, containing only the UniqueCarrier variable of hflights
carriers <- hflights$UniqueCarrier


# Use lut to translate the UniqueCarrier column of hflights and before doing so
# glimpse hflights to see the UniqueCarrier variablle
glimpse(hflights)

lut <- c("AA" = "American", "AS" = "Alaska", "B6" = "JetBlue", "CO" = "Continental", 
         "DL" = "Delta", "OO" = "SkyWest", "UA" = "United", "US" = "US_Airways", 
         "WN" = "Southwest", "EV" = "Atlantic_Southeast", "F9" = "Frontier", 
         "FL" = "AirTran", "MQ" = "American_Eagle", "XE" = "ExpressJet", "YV" = "Mesa")
hflights$UniqueCarrier <- lut[hflights$UniqueCarrier]
# Now glimpse hflights to see the change in the UniqueCarrier variable
glimpse(hflights)

# Fill up empty entries of CancellationCode with 'E'
# To do so, first index the empty entries in CancellationCode
cancellationEmpty <- hflights$CancellationCode == ""
# Assign 'E' to the empty entries
hflights$CancellationCode[cancellationEmpty] <- 'E'

# Use a new lookup table to create a vector of code labels. Assign the vector to the CancellationCode column of hflights
lut = c('A' = 'carrier', 'B' = 'weather', 'C' = 'FFA', 'D' = 'security', 'E' = 'not cancelled')
hflights$CancellationCode <- lut[hflights$CancellationCode]

# Inspect the resulting raw values of your variables
glimpse(hflights)
