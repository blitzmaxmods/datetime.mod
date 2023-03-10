# Blitzmax DateTime module
VERSION 0.1

## Installation

Copy datetime.mod into BlitzMax/mod/bmx.mod/

## Date basics

This system, like many others uses two types of date value "Timestamp" and "DateTime".

*TimeStamp*
This is held in a Long datatype and represents the number of seconds since the Epoch (1900). It is also known as Unixtime.
Negative values represent dates before 1900. 

*DateTime*
This is a struct that matches the C datatype "tm" but has been extended with functionality for dealing with times and dates

## Comparisons

|Description              |BlitzMax|Python|Javascript|
|-------------------------|----------------|------|----------|
| Current Timestamp       | DateTime.now()<br>(Seconds) | datetime.datetime.now()<br>(Seconds) | DateTime.now()<br>(Millisecs) | 
| New date object         | new DateTime()<br>new DateTime(timestamp) | | |new Date()<br>new Date(date string)<br>new Date(year,month)<br>new Date(year,month,day)<br>new Date(year,month,day,hours)<br>new Date(year,month,day,hours,minutes)<br>new Date(year,month,day,hours,minutes,seconds)<br>new Date(year,month,day,hours,minutes,seconds,ms)<br>new Date(milliseconds) |
| Date object to String   |             | | x.strftime(format) | x.toLocaleString()<br>x.toString() |
| Get four digit year     | x.year()    | | x.getFullYear() |
| Get month number (0-11) | x.month()   | | x.getMonth() |
| Get day number (1-31)   | x.day()     | | x.getDate() |
| Get hour (0-23)         | x.hour()    | | x.getHours() |
| Get minute (0-59)       | x.minute()  | | x.getMinutes() |
| Get second (0-59)       | x.second()  | | x.getSeconds()	|
| Get millisecond (0-999) |             | | x.getMilliseconds() |	
| Get weekday (0-6)       | x.weekday() | | x.getDay() |
| Get yearday (0-365)     | x.yearday() | |  |
| Get time                |             | | x.getTime() |
| Set four digit year     | x.year(value) | | x.setFullYear() |
| Set month number (0-11) | x.month(value)   | | x.getMonth() |
| Set day number (1-31)   | x.day(value)     | | x.getDate() |
| Set hour (0-23)         | x.hour(value)   | | x.getHours() |
| Set minute (0-59)       | x.minute(value) | | x.getMinutes() |
| Set second (0-59)       | x.second(value) | | x.getSeconds()	|

