# DateTime.now()

## Syntax
```DateTime.now:Long()``` 

## Description

DateTime.now() is a static function of the Struct [DateTime](DateTime.md) and returns the number of seconds since the Unix Epoch (1 Jan 1970). It is commonly refererred to as UnixTime or a Unix Timestamp.

## Return Value
DateTime.now() returns a signed Long

## Dependencies
* [BlitzMaxNG](https://blitzmax.org)

## Threadsafe
Has not been evaluated

## Example
```
Import bmx.datetime

Local time:Long = DateTime.now()
```

## Further Reading
* [BlitzMaxNG](https://blitzmax.org)
* Module [bmx.datetime](../README.md)
* Struct [DateTime](DateTime.md)
