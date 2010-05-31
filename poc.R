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

# Note that this command does nothing in the script...
sql(paste("select * from", tablename,"where Date < '2005-01-05';"))

cat(sprintf("Price table
    %d rows
    %d stocks
    %d dates from %s to %s
  ",
  sql("SELECT COUNT(*) FROM dummytable;"),
  sql("SELECT COUNT(DISTINCT Symbol) FROM dummytable;"),
  sql("SELECT COUNT(DISTINCT Date)  FROM dummytable;"),
  sql("SELECT MIN(Date) FROM dummytable;"),
  sql("SELECT MAX(Date) FROM dummytable;")
))

date.range <- sqlDateRange(tablename, "GSPC")
cat(sprintf("Date Range from %s to %s\n",
  date.range[1], date.range[2]))


# Close the connection
dbDisconnect(global_SQL_con)

