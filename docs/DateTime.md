# DateTime

## Dependencies
* [BlitzMaxNG](https://blitzmax.org)
* Module [bmx.datetime](../README.md)

## Threadsafe
Has not been evaluated

## Description

Struct DateTime is the basic data structure with an API that supports basic date and time operations.

**Internal Operations**

THIS IS EXPERIMENTAL AND VERY LIKELY TO CHANGE

Field bmxdatetime:Long is used internally to hold date information. It is NOT the same as a unix timestamp but is instead referenced as an array of bytes:

bmxtime using binary nibble notation:

```YYYYYYYY.YYYYYYYY.ooooMMMM.dqqDDDDD.xxxxxxxx.xxxHHHHH.xxMMMMMM.xxSSSSSS```

This gives us a total date range of +/-32768 years around the Epoch of 1 JAN 4713 BCE which should be more than enough.
The Date or Time can be extracted as an Int and used on their own if required.

Where:
* Y - Year
* M - Month
* D - Day
* H - Hour
* M - Minute
* S - Second
* o - Options (RESERVED)
* q - Quarter (RESERVED)
* d - Double Dating
* x - Not used

**Options:**

A value from (0 to 15) used to identify vague dates that are used for historic or genealogy purposes.

* 00 - 0000 - Exact date
* 01 - 0001 - About or Circa
* 02 - 0010 - Estimated (When additional information is available)
* 03 - 0011 - Calculated (When calculated from another vague date)
* 04 - 0100 - Before
* 05 - 0101 - After
* 06 to 15 are reserved

'*About*' is used when a date is Fairly certain
'*Estimated*' is used when a date parameter is based on a guess (For example you know a groom was about 21)
'*Calculated*' is used when a date is calculated from another (For example: 'Died on 14 Aug 1985 age 62' is '~14 Aug 1923')

**Quarter:**

A Quarter is commonly used in Genealogy to index a document based on the Quarter of the year in which it was generated, for example 1967Q2 references the months Apr, May and Jun of 1967.

This field requires that the month field be 0

* 0 - Q1 - Jan, Feb or Mar
* 1 - Q2 - Apr, May, Jun
* 2 - Q3 - Jul, Aug, Sep
* 3 - Q4 - Oct, Nov, Dec

**Double Dating:**
Dates between 1 Jan and 24 Mar are often recorded using a mechanism called "Double Dating". This is required when the Julian Calendar, which starts on 25 March is used.

The Gregorian calendar was accepted at different times by various countries between Oct 1522 (Venice) and Sep 1752 (England) when the first day of the year was changed to 1 Jan.

## Example
```
Import bmx.datetime

Local time:Long = DateTime.now()
```

## API
* Function [DateTime.now()](DateTime_now.md)
* Method [new()][DateTime_new.md]
* Method year()
* Method month()
* Method day()
* Method hour()
* Method minute()
* Method second()
* Method yearday()
* Method weekday()
* Method toString()
* Method isQuarter()

## Further Reading
* [BlitzMaxNG](https://blitzmax.org)
* Module [bmx.datetime](../README.md)
