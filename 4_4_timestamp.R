# 7.1 strptime() converts string to POSIXlt -------------------------------

# convert strings to time objects by specified format
safefood.df$ltime <- strptime(safefood.df$timestamp, "%m %e %Y")
class(safefood.df$ltime)



# 7.2 Accessing features of timestamps ------------------------------------

# safefood.df$ltime$hour
safefood.df$ltime$mday
safefood.df$ltime$month
safefood.df$ltime$year # year since 1900
safefood.df$ltime$wday # 0~6 day of the week
safefood.df$ltime$yday # 0~365 day of the year
safefood.df$ltime$zone # ChungYuan Standard Time
class(as.Date("2017-01-01"))
class(as.POSIXct("2017-01-08"))




# 7.3 Convert number to POSIXct and time zone -----------------------------

# time zone converter
# http://www.timezoneconverter.com/cgi-bin/zoneinfo?tz=America/New_York

z <- 7.343736909722223e5
as.POSIXct((z - 719529)*86400, origin = "1970-01-01", tz = "UTC")
as.POSIXlt((z - 719529)*86400, origin = "1970-01-01", tz = "Asia/Taipei")

z <- 1509343484914
as.POSIXct(z/1000, origin="1970-01-01", tz="Asia/Taipei")

as.POSIXct(Sys.time(), tz="CST")
as.POSIXct(Sys.time(), tz="Asia/Taipei")
as.POSIXlt(Sys.time(), tz="CST")
as.POSIXlt(Sys.time(), tz="America/New_York")
as.POSIXlt(Sys.time(), tz="Asia/Taipei")
as.POSIXlt(Sys.time(), tz="Asia/Tokyo")
# GMT: Greenwich Mean Time (is not verified scientifically)
# UTC: Coordinated Universal Time (closed to GMT in most of circumstance)
class(safefood.df$ltime)	# POSIXlt
safefood.df$ctime <- as.POSIXct(safefood.df$ltime) # POSIXct

months(safefood.df$ctime)
weekdays(safefood.df$ltime)
sort(safefood.df$ctime)
sort(safefood.df$ltime)



# 7.4 Set locale of time --------------------------------------------------

Sys.setlocale(category = "LC_ALL", locale = "C")



# 7.5 Convert a POSIXct to a string ---------------------------------------

format(safefood.df$ctime, "%m-%d-%Y")



# 7.6 Access system time --------------------------------------------------

# Access system time and date
Sys.time()
Sys.Date()

# measure code running time
start <- proc.time()
# your code here
proc.time() - start
