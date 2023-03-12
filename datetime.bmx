
'	Datetime module for Blitzmax
'	(c) Copyright Si Dunford [Scaremonger], Feb 2023
'	Version 0.2

SuperStrict

'Module bmx.datetime

Framework pub.stdc		' strftime_(), putenv_%( str$ ), getenv_$( env$ )
Import brl.blitz		' TRuntimeException
Import "datetime.c"

Extern	' datetime.c

	' V0.0, CURRENT LOCALE TIMESTAMP
	Function timestamp_now:Long() = "timestamp_now"

	' V0.1, DIFFERENCE BETWEEN TWO TIMESTAMPS
	Function timestamp_diff:Double( Start:Long, Finish:Long ) = "timestamp_diff"
		
Rem DEPRECIATED IN V0.2
	' V0.1, TIMESTAMP TO DATETIME
	Function timestamp_to_datetime( TimeStamp:Long, TimeInfo:DateTime Var) = "timestamp_to_datetime"
	' V0.1, DATETIME TO TIMESTAMP
	Function datetime_to_timestamp:Long( TimeInfo:DateTime Var ) = "datetime_to_timestamp"
	' V0.1, STRING TO DATETIME
	Function string_to_datetime:Int( datestr$z, dateformat$z, TimeInfo:DateTime Var ) = "string_to_datetime"
END REM

	' V0.2, TIMESTAMP TO BMXDATETIME
	Function timestamp_to_bmxdatetime( TimeStamp:Long, bmxdatetime:Byte Ptr) = "timestamp_to_bmxdatetime"

	' V0.2, BMXDATETIME TO TIMESTAMP
	Function bmxdatetime_to_timestamp:Long ( bmxdatetime:Byte Ptr) = "bmxdatetime_to_timestamp"

End Extern

Const EPOCH:Int = -4713 * 365		' Julian calendar started on 1 Jan 4713 BCE

Const DT_DATETIME:String         = "%Y-%m-%d %H:%M:%S"
Const DT_DATE:String             = "%Y-%m-%d"
Const DT_TIME:String             = "%H:%M:%S"
Const DT_DATESTR:String          = "%d %b %Y"

Const DT_AMERICAN:String         = "%m %d %Y"
Const DT_BRITISH:String          = "%d %m %Y"

' MySQL Date Datatypes
Const MYSQL_DATE:String          = DT_DATE
Const MYSQL_DATETIME:String      = DT_DATETIME
Const MYSQL_TIMESTAMP:String     = DT_DATETIME
Const MYSQL_YEAR:String          = "%Y"

' Microsoft SQL Server Date Datatypes
Const MSSQL_DATE:String          = DT_DATE
Const MSSQL_DATETIME:String      = DT_DATETIME
Const MSSQL_TIMESTAMP:String     = "%"			' Custom support, see DateTime.Format()
Const MSSQL_SMALLDATETIME:String = DT_DATETIME

Const DT_SECONDS:Int = 1
Const DT_MINUTES:Int = DT_SECONDS*60
Const DT_HOURS:Int   = DT_MINUTES*60
Const DT_DAYS:Int    = DT_HOURS*24
'Const DT_MONTHS:Int  = 0	' Needs some special calculations
'Const DT_YEARS:Int   = 0	' Needs some special calculations

' bmxdatetime options
Const DT_OPT_CIRCA:Int = $10
Const DT_OPT_ABT:Int = $10
Const DT_OPT_EST:Int = $20
Const DT_OPT_CALC:Int = $30
Const DT_OPT_BEF:Int = $40
Const DT_OPT_AFT:Int = $50

' Get current Timestamp ( Functionally the same as DateTime.now() )
Function Timestamp:Long()
	Return timestamp_now()
End Function

' DateTime exception
Type TDateTimeError Extends TRuntimeException
End Type

' DateTime structure
Struct DateTime

	'V0.2 - Date and Time
	Field bmxdatetime:Byte[8]

	' Create a new blank DateTime
	Method New()
	'	Local timestamp:Long = timestamp_now()
	'	timestamp_to_datetime( timestamp, Self )
	'	timestamp_to_bmxtime( timestamp, bmxtime )
'		Return Self
	End Method
	
	' Create a new DateTime from a Timestamp
	Method New( timestamp:Long )
	'	timestamp_to_datetime( timestamp, Self )
		timestamp_to_bmxdatetime( timestamp, bmxdatetime )
	End Method

	' Create a new DateTime from a string
	Method New( timestr:String, dateformat:String = DT_DATETIME )
	'	Local err:Int = string_to_datetime( timestr, dateformat, Self )
	'	If err=0; Throw New TDateTimeError( "Failed to convert timestring")
	End Method

	' GET/SET datetime using broken down values
	Method getDate( year:Int Var, month:Int Var, day:Int Var, hour:Int Var, minute:Int Var, second:Int Var )
		year   = Int Ptr(bmxdatetime)[0]
		month  = (Byte Ptr(Bmxdatetime)[2]) & $0F
		day    = (Byte Ptr(Bmxdatetime)[3]) & $1F
		hour   = (Byte Ptr(Bmxdatetime)[5]) & $1F
		minute = (Byte Ptr(Bmxdatetime)[6]) & $3F
		second = (Byte Ptr(Bmxdatetime)[7]) & $3F
	End Method
	Method setDate:DateTime( year:Int, month:Int=0, day:Int=0, hour:Int=0, minute:Int=0, second:Int=0 )
		If month<0 Or month>12; Throw New TDateTimeError( "Invalid Month '"+month+"'" )
		If day<1 Or day>31; Throw New TDateTimeError( "Invalid Day '"+day+"'" )
		If hour<0 Or hour>24; Throw New TDateTimeError( "Invalid Hour '"+hour+"'" )
		If minute<0 Or minute>60; Throw New TDateTimeError( "Invalid Minute '"+minute+"'" )
		If second<0 Or second>=62; Throw New TDateTimeError( "Invalid Second '"+second+"'" )
		Int Ptr(bmxdatetime)[0]  = Int(year)
		Byte Ptr(bmxdatetime)[2] = ( Byte Ptr(bmxdatetime)[2] & $F0 ) | Byte( month ) & $0F	
		Byte Ptr(bmxdatetime)[3] = ( Byte Ptr(bmxdatetime)[3] & $E0 ) | Byte( day ) & $1F
		Byte Ptr(bmxdatetime)[5] = Byte( hour )
		Byte Ptr(bmxdatetime)[6] = Byte( minute )
		Byte Ptr(bmxdatetime)[7] = Byte( second )
		' Zero the quarter and datedouble flags
		Byte Ptr(bmxdatetime)[3] = ( Byte Ptr(bmxdatetime)[3] & $1F )
		Return Self
	End Method
		
	' GET/SET time using broken down values
	Method getTime( hour:Int Var, minute:Int Var, second:Int Var )
		hour   = (Byte Ptr(Bmxdatetime)[5]) & $1F
		minute = (Byte Ptr(Bmxdatetime)[6]) & $3F
		second = (Byte Ptr(Bmxdatetime)[7]) & $3F
	End Method
	' Note second allows for up to 2x extra leap seconds
	Method setTime:DateTime( hour:Int, minute:Int, second:Int )
		If hour<0 Or hour>=24; Throw New TDateTimeError( "Invalid Hour '"+hour+"'" )
		If minute<0 Or minute>60; Throw New TDateTimeError( "Invalid Minute '"+minute+"'" )
		If second<0 Or second>=62; Throw New TDateTimeError( "Invalid Second '"+second+"'" )
		Byte Ptr(bmxdatetime)[5] = Byte( hour )
		Byte Ptr(bmxdatetime)[6] = Byte( minute )
		Byte Ptr(bmxdatetime)[7] = Byte( second )
		Return Self
	End Method

	' Get and Set date using bmxdate
	Method getDate:Int()
		Return Int Ptr(bmxdatetime)[0]
	End Method
	Method setDate( bmxdate:Int )
		Int Ptr(bmxdatetime)[0] = bmxdate
	End Method

	' Get/Set Time using bmxtime
	Method getTime:Int()
		Return Int Ptr(bmxdatetime)[1]
	End Method
	Method setTime( bmxtime:Int )
		Int Ptr(bmxdatetime)[1] = bmxtime
	End Method
		
	Method year:Int()
		Return Int Ptr(Bmxdatetime)[0]
	End Method
	Method year(value:Int)
		Short Ptr(bmxdatetime)[0] = Short(value)-1900
	End Method

	Method month:Int()
		Return (Byte Ptr(Bmxdatetime)[2]) & $0F
	End Method
	Method month( value:Int, quarter:Int=0 )
		If value<0 Or value>12; Throw New TDateTimeError( "Invalid Month '"+value+"'" )

		' Update Month and Quarter fields
		Byte Ptr(bmxdatetime)[2] = ( Byte Ptr(bmxdatetime)[2] & $F0 ) | Byte( value ) & $0F
		Byte Ptr(bmxdatetime)[3] = ( Byte Ptr(bmxdatetime)[3] & $9F ) | Byte( quarter ) Shl 5 & $60
			
	End Method

	Method day:Int()
		Return (Byte Ptr(Bmxdatetime)[3]) & $1F
	End Method
	Method day(value:Int)
		If value<1 Or value>31; Throw New TDateTimeError( "Invalid Day of Month '"+value+"'" )
		Byte Ptr(bmxdatetime)[3] = ( Byte Ptr(bmxdatetime)[3] & $E0 ) | Byte( value ) & $1F
	End Method

	Method hour:Int()
		Return (Byte Ptr(Bmxdatetime)[5]) & $1F
	End Method
	Method hour(value:Int)
		If value<0 Or value>=60; Throw New TDateTimeError( "Invalid Hour '"+value+"'" )
		Byte Ptr(bmxdatetime)[5] = Byte( value )
	End Method

	Method minute:Int()
		Return (Byte Ptr(Bmxdatetime)[6]) & $3F
	End Method
	Method minute(value:Int)
		If value<0 Or value>=60; Throw New TDateTimeError( "Invalid Minute '"+value+"'" )
		Byte Ptr(bmxdatetime)[6] = Byte( value )
	End Method

	Method second:Int()
		Return (Byte Ptr(Bmxdatetime)[7]) & $3F
	End Method
	Method second(value:Int)
		If value<0 Or value>=60; Throw New TDateTimeError( "Invalid Second '"+value+"'" )
		Byte Ptr(bmxdatetime)[7] = Byte( value )
	End Method

	Method yearday:Int()
'		Return _yearday
	End Method
	Method weekday:Int()
'		Return _weekday
	End Method

	Method quarter:Int()
		Return ((Byte Ptr(Bmxdatetime)[3]) & $60 ) Shr 5 + 1
	End Method
	Method quarter( value:Int )
		Byte Ptr(bmxdatetime)[3] = ( Byte Ptr(bmxdatetime)[3] & $9F ) | Byte( value-1 ) Shl 5 & $60
	End Method

	' Get/Set Options
	Method options:Int()
		Return (Byte Ptr(Bmxdatetime)[2]) & $F0
	End Method
	Method options(value:Int)
		Byte Ptr(bmxdatetime)[2] = ( Byte Ptr(bmxdatetime)[2] & $0F ) | Byte( value ) And $F0
	End Method
	
	' Check if date is a doubledate
	Method isDoubleDate:Int()
		Return ((Byte Ptr(Bmxdatetime)[3]) & $80 ) = $80
	End Method

	' If Month is zero, then month is represented as a quarter
	Method isQuarter:Int()
		Return ((Byte Ptr(Bmxdatetime)[2]) & $0F ) = $00
	End Method

'	Method isDSTValid:Int();Return _dst>=0;		End Method	' Is DST known
'	Method isDST:Int();		Return _dst>0;		End Method	' If Valid, in operation?
	
	' Add a predefined interval
	Method addInterval( quantity:Int, interval:Int )
		'Local timestamp:Long = datetime_to_timestamp( Self )
		'timestamp :+ ( quantity * interval)
		'timestamp_to_datetime( timestamp, Self )
	End Method

	' Add a manual interval
	Method addInterval( interval:Int )
		'Local timestamp:Long = datetime_to_timestamp( Self )
		'timestamp :+ interval
		'timestamp_to_datetime( timestamp, Self )
	End Method
	
	' Difference between two DateTime values
	Method diff:Long( against:DateTime, interval:Int=-1 )
		'Local time1:Long = datetime_to_timestamp( Self )
		'Local time2:Long = datetime_to_timestamp( against )
		'Local seconds:Long = timestamp_diff( time1, time2 )
		'If interval>0; Return seconds/interval
		'Return seconds
	End Method
	
	' Valildate date by converting to Timestamp and back again.
	' This validates, but also updates yearday and weekday
	'Method _update()
	'	' DateTime to Timestamp
	'	Local timestamp:Long = datetime_to_timestamp( Self )
	'	' Timestamp to Datetime
	'	timestamp_to_datetime( timestamp, Self )
	'End Method
	
	Method format:String( dateformat:String = DT_DATETIME )
		Return DateTime.toString( Self, dateformat )
	End Method

	' Return Month name
	Method MonthName:String( shortname:Int = True )
		' Identify if we are using Quarters (Month is zero)
		Local month:Int = (Byte Ptr(Bmxdatetime)[2]) & $0F
		If month = 0
			' We have a quarter month definition!
			Return "Q"+ (((Byte Ptr(Bmxdatetime)[3]) & $60 ) Shr 5 + 1)
		ElseIf shortname
			Return DateTime.toString( Self, "%b" )
		Else
			Return DateTime.toString( Self, "%B" )
		End If
	End Method
	
	' Return locales Day name
	Method DayName:String( shortname:Int = True )
		If shortname
			Return DateTime.toString( Self, "%a" )
		Else
			Return DateTime.toString( Self, "%A" )
		End If
	End Method

	' Return locales morning or afternoon
	Method AMPM:String()
		Return DateTime.toString( Self, "%p" )
	End Method
	
	' Return BMXTIME as a timestamp
	Method timestamp:Long()
		Return bmxdatetime_to_timestamp( bmxdatetime )
	End Method
		
	' DATETIME to STRING
	Function toString:String( timeinfo:DateTime, dateformat:String = DT_DATETIME )
		' Custom MSSQL_TIMESTAMP Support uses "%" and returns timestamp as a string
		If dateformat="%"
			' Convert to TIMESTAMP
	'		Local timestamp:Long = datetime_to_timestamp( timeinfo )
	'		Return String(timestamp)	
		End If
	'	' Convert to string
	'	Local buff:Byte[256]
	'	strftime_( buff, 256, dateformat, Varptr( timeinfo ) )
	'	Return String.FromCString(buff)
	End Function

	' TIMESTAMP to STRING
	Function toString:String( timestamp:Long, dateformat:String = DT_DATETIME )
		' Custom MSSQL_TIMESTAMP Support uses "%" and returns timestamp as a string
		If dateformat="%"
			Return String(timestamp)
		End If
		' Convert to DATETIME
	'	Local dateinfo:DateTime = New DateTime( timestamp )
		' Convert to string
	'	Local buff:Byte[256]
	'	strftime_( buff, 256, dateformat, Varptr( dateinfo ) )
	'	Return String.FromCString(buff)
	End Function
	
	' Get the current Timestamp 
	Function Now:Long()
		Return timestamp_now()
	End Function	

	' Difference between two Timestamps
	Function TimeDiff:Long( start:Long, finish:Long )
		Return timestamp_diff( start, finish )
	End Function

	' DEBUGGING
	Method reveal:String()
		'Print "Y: "+ year()
		Local s:String = Right("00"+day(),2)+"-"+Right("00"+month(),2)+"-"+Right("0000"+year(),4)+" "
		s:+ Right("00"+hour(),2)+":"+Right("00"+minute(),2)+":"+Right("00"+second(),2)+" "
		s:+ "("+dayname()+","+monthname()+") "
		s:+ "o="+options()+", d="+ ["FALSE","TRUE"][isdoubledate()]+", q="+quarter()
		Return s
	End Method

	Method toBin:String()
		Local s:String	'="LONG: "+Bin(Int(bmxdatetime))+":"+Bin(Int(bmxdatetime Shr 32 ))+"~nBMX:  "
		's:+Bin(Short Ptr[0])[16..]+"."
		For Local bit:Int = 0 Until Len(bmxdatetime)
			s:+Bin(Byte Ptr(bmxdatetime)[bit])[24..]+"."
		Next
		Return s
	End Method
	
End Struct


