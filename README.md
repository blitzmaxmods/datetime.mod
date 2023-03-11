# Blitzmax DateTime Module
VERSION 0.1 - BETA

# SANDBOX
This should be a link to the [README][0] and this should be a link to the [DateTime][two] mdoule.

## Further Reading
* [bmx.datetime][0]
* [Struct DateTime][two]

[0]: README.md "DateTime Module"
[two]: https://github.com/blitzmaxmods/datetime.mod/docs/DateTime.md "Struct DateTime"


**NOTE**

This version is a beta release and although it may be functionally complete it may not have been thorougly tested and coule contain bugs.
Use at your own risk.
 
## Installation

Unzip and Copy datetime.mod folder into BlitzMax/mod/bmx.mod/

On Linux:
    Open a terminal in Blitzmax/mod/bmx.mod/datetime.mod
    ./compile.sh

On Windows
    Open a command prompt and change directory to Blitzmax\mod\bmx.mod\datetime.mod
    cd /d C:\Blitzmax\mod\bmx.mod\datetime.mod
    compile.bat

## Examples

Please refer to Blitzmax/mod/bmx.mod/datetime.mod/Examples/

## Date basics

This system, like many others uses two types of date value "Timestamp" and "DateTime".

**TimeStamp**

This is held in a Long datatype and represents the number of seconds since the Epoch (1900). It is also known as Unixtime.
Negative values represent dates before 1900.

**DateTime**

This is a struct that matches the C datatype "tm" but has been extended with functionality for dealing with times and dates.

## Comparisons

|Description              |BlitzMax|Python|Javascript|
|-------------------------|----------------|------|----------|
| Current Timestamp       | DateTime.now()<br>(Seconds) | datetime.datetime.now()<br>(Seconds) | DateTime.now()<br>(Millisecs) | 
| New date object         | new DateTime()<br>new DateTime(timestamp) | | |new Date()<br>new Date(date string)<br>new Date(year,month)<br>new Date(year,month,day)<br>new Date(year,month,day,hours)<br>new Date(year,month,day,hours,minutes)<br>new Date(year,month,day,hours,minutes,seconds)<br>new Date(year,month,day,hours,minutes,seconds,ms)<br>new Date(milliseconds) |
| Date object to String   |             | | x.strftime(format) | x.toLocaleString()<br>x.toString() |
| Get four digit year     | x.year()    | | x.getFullYear() |
| Get month number (1-12) | x.month()   | | x.getMonth() |
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

# CHANGE LOG

14 FEB 2023  V0.00  Draft
09 MAR 2023  V0.01  Draft
10 MAR 2023  V0.10  Beta   Fixed issue in tm structure giving stack and segmentation faults.

