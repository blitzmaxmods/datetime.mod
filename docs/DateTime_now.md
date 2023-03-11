# DateTime.now()

## Syntax
```DateTime.now:Long()``` 

## Description

[DateTime][2].now() is a static function of the [DateTime][2] Struct and returns the number of seconds since the Unix Epoch (1 Jan 1970). It is commonly refererred to as UnixTime or a Unix Timestamp.

## Return Value
[DateTime][2].now() returns a signed Long

## Dependencies
* [BlitzMaxNG][0]

## Threadsafe
Has not been evaluated

## Example
```
Import bmx.datetime

Local time:Long = DateTime.now()
```

## Further Reading
* Module [bmx.datetime][1]
* [Struct DateTime][2]

[0]: https://blitzmax.org "BlitzMaxNG"
[1]: README.md "bmx.datetime"
[2]: https://github.com/blitzmaxmods/datetime.mod/docs/DateTime.md "Struct DateTime"