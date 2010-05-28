# Proof Of Concept - Example code

global_dbDriver <- "SQLite"
global_dbname   <- "dummy.dbms"

library(quantmod)
library(RSQLite)

source("rf-sql.R")


# Pull S&P500 index data from Yahoo! Finance
getSymbols("^GSPC", from="2005-01-01", to="2009-12-31")
getSymbols("^IXIC", from="2005-01-01", to="2009-12-31")


# Connect to the DB

if (exists("global_SQL_con")) {
  try( dbDisconnect(global_SQL_con) )
}

global_SQL_con <- dbConnect(
  dbDriver(global_dbDriver),
  dbname = global_dbname
)

# Create the table
tablename <- "dummytable"
sqlCreateDailyOHLCTable( tablename )

# Write data to the table
sqlWriteOHLC(tablename, "GSPC")
sqlWriteOHLC(tablename, "IXIC")

# Select some data
sql(paste("select * from", tablename,"where Date < '2005-01-05';"))

# Close the connection
dbDisconnect(global_SQL_con)

