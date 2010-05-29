# Basic SQL interface code.

# I use a single database connection, so I do not want to
# give the connection argument each time.
# Furthermore, when the result has a single column, I want
# a vector, not a data.frame.
sql <- function (s) {
  res <- dbGetQuery(global_SQL_con, s)
  if (!is.null(res)) {
    if (is.data.frame(res) & ncol(res) == 1) {
      res <- res[,1]
    }
  }
  drop(res)
}


sqlCreateDailyOHLCTable <- function( x.table ) {
	# Create a table (called x.table) to hold the OHLC data
	#	x.table	[STRING]
	#
	if( !dbExistsTable(global_SQL_con, x.table) ) {
		# The table doesn't already exist
		sql(paste("CREATE TABLE ", x.table, "(",
			"Date		DATE,",
            "Symbol		CHAR(10),",
            "Open		REAL,",
			"High		REAL,",
			"Low		REAL,",
			"Close		REAL,",
			"Volume		BIGINT,",
			"Adjusted	REAL",
			");"
		))
	}
}


sqlWriteOHLC <- function( x.table, x.symbol ) {
	# Write the data for the symbol x.symbol into table x.table
	#	x.table		[STRING]
	#	x.symbol	[STRING]
	#
	dbWriteTable(global_SQL_con, x.table,
		cbind( x.symbol, as.data.frame(get(x.symbol)) ),
		append = TRUE)
}
