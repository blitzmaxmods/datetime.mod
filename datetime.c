/*
**	Date, Time and Timestamp functions for BlitzMax
**	(c) Copyright Si Dunford [Scaremonger], March 2023
*/

//#include <stdlib.h>
#include <time.h>
//#include <sys/time.h>
//#include <locale.h>
#include <brl.mod/blitz.mod/blitz.h>

extern int getdate_err;
/* 
	C DEFINITIONS

	time_t time(time_t *t)
	time_t mktime(struct tm *timeptr)
	double difftime(time_t time1, time_t time2)
	struct tm *localtime_r( const time_t *timer, struct tm *buf );
	struct tm *gmtime_r(const time_t *time, struct tm *result);
	void tzset(void)
	char *strptime(const char * __restrict__ buf, const char * __restrict__ fmt, struct tm * __restrict__ tm);
	
*/

/*/	VERSION 0.00
*/

//	Get current microsecs
BBLONG MicroSecs(void) {
	struct timeval tv;
	gettimeofday( &tv, NULL );							// THREAD SAFETY UNKNOWN
	return (( (BBLONG)tv.tv_sec )*1000 )+( tv.tv_usec/1000 );
	/*return (( (long)tv.tv_sec )*1000 )*/;
}

//	Get Miliseconds as a double with nanosecond resolution	
double Milli(void) {
	struct timeval tv;
	gettimeofday( &tv, NULL );							// THREAD SAFETY UNKNOWN
	return (tv.tv_sec+(double)tv.tv_usec/1000000.0);
}

//	Get UNIXTIME adjusted for localtime
BBLONG timestamp_now() {
	time_t timestamp = time( NULL );					// Threadsafe
	struct tm timeinfo;
//	localtime_r( &timestamp, &timeinfo );				// Threadsafe
	gmtime_r( &timestamp, &timeinfo );					// Threadsafe
	return mktime( &timeinfo );							// Threadsafe
};

//	Difference between two Timestamps
BBDOUBLE timestamp_diff( BBLONG start, BBLONG finish ) {
	return difftime( finish, start );					// Threadsafe
};

/*/	VERSION 0.01
*/

/*/	DEPRECIATED IN VERSION 0.02
*

//	TIMESTAMP to DATETIME
void timestamp_to_datetime( BBLONG timestamp, struct tm *timeinfo ) {
//	localtime_r( &timestamp, timeinfo );				// Threadsafe
	gmtime_r( &timestamp, timeinfo );					// Threadsafe
};

//	DATETIME to TIMESTAMP
BBLONG datetime_to_timestamp( struct tm *timeinfo ) {
	return mktime( timeinfo );							// Threadsafe
};

//	STRING to DATETIME
BBINT string_to_datetime( char *string, char *format, struct tm *timeinfo ){
	int err;
	err = strptime( string, format, timeinfo );	
	return err;
};
*/

/*/	VERSION 0.02
*/

//	V0.2, UNION alloing fields to be accessed individually
typedef union overlap_s {
    uint64_t u64;
    //uint32_t u32[2];	// Not used
	//int32_t  s32[2];	// Not used
	//uint16_t u16[4];	// Not used
	int16_t  s16[4];
    uint8_t  u08[8]; 
    //int8_t   s08[8];	// Not used 
} overlap_t;

//	V0.2, TIMESTAMP to BMXDATETIME
void timestamp_to_bmxdatetime( BBLONG timestamp, overlap_t *bmxdatetime ) {

	struct tm timeinfo;
//	localtime_r( &timestamp, &timeinfo );				// Threadsafe
	gmtime_r( &timestamp, &timeinfo );					// Threadsafe
	
	uint8_t dst;
	if( timeinfo.tm_isdst == 0 ) {
		dst = 0x00;
	} else if( timeinfo.tm_isdst > 0 ) {
		dst = 0x40;
	} else {
		dst = 0xC0;
	};
	bmxdatetime->u64    = 0;	
	bmxdatetime->s16[0] = timeinfo.tm_year;
	bmxdatetime->u08[2] = timeinfo.tm_mon+1;
	bmxdatetime->u08[3] = timeinfo.tm_mday;
	bmxdatetime->u08[5] = timeinfo.tm_hour | dst;
	bmxdatetime->u08[6] = timeinfo.tm_min;
	bmxdatetime->u08[7] = timeinfo.tm_sec;
};

//	V0.2, BMAXDATETIME TO TIMESTAMP
BBLONG bmxdatetime_to_timestamp( overlap_t *bmxdatetime ) {

	struct tm timeinfo;
	
	timeinfo.tm_year = bmxdatetime->s16[0];	
	if( bmxdatetime->u08[2] & 0x0f > 0 ) {
		timeinfo.tm_mon = ( bmxdatetime->u08[2] & 0x0f ) -1;
	};
	timeinfo.tm_mday = bmxdatetime->u08[3] & 0x1f;
	timeinfo.tm_hour = bmxdatetime->u08[5] & 0x1f;
	timeinfo.tm_min = bmxdatetime->u08[6];
	timeinfo.tm_sec = bmxdatetime->u08[7];

	uint8_t dst = bmxdatetime->u08[5] & 0xc0;
	if( dst == 0xc0 ) {
		timeinfo.tm_isdst = -1;
	} else {
		timeinfo.tm_isdst = dst >> 6;
	};

	return mktime( &timeinfo );							// Threadsafe
	
};



