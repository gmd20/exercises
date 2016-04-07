//#include <winsock2.h>
//#include <ws2tcpip.h>

#pragma comment(lib,  "Ws2_32.lib")


#include <inttypes.h>
#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <list>
#include <vector>
#include <random>

//#include <boost/shared_ptr.hpp>
//#include <boost/weak_ptr.hpp>
#include <boost/xpressive/xpressive.hpp>


#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdio.h>
#include "pugixml.hpp"

#ifdef _WIN32
#include <Windows.h>
void my_gettimeofday(struct timeval *tp)
{
	uint64_t  intervals;
	FILETIME  ft;

	GetSystemTimeAsFileTime(&ft);

	/*
	* A file time is a 64-bit value that represents the number
	* of 100-nanosecond intervals that have elapsed since
	* January 1, 1601 12:00 A.M. UTC.
	*
	* Between January 1, 1970 (Epoch) and January 1, 1601 there were
	* 134744 days,
	* 11644473600 seconds or
	* 11644473600,000,000,0 100-nanosecond intervals.
	*
	* See also MSKB Q167296.
	*/

	intervals = ((uint64_t)ft.dwHighDateTime << 32) | ft.dwLowDateTime;
	intervals -= 116444736000000000;

	tp->tv_sec = (long)(intervals / 10000000);
	tp->tv_usec = (long)((intervals % 10000000) / 10);
}
#else
#include <sys/time.h>
#define my_gettimeofday(tp)  (void) gettimeofday(tp, NULL);
#endif

// 返回微秒时间差异
unsigned long long time_stamp_usec()
{
	enum { kUsecPerSec = 1000 * 1000 };
	struct timeval tp;
	my_gettimeofday(&tp);
	return ((unsigned long long)tp.tv_sec) * kUsecPerSec + (unsigned long long ) tp.tv_usec;
}

void print_time_diff(unsigned long long t0, unsigned long long t1, int n)
{
	std::cout << "执行次数(n):\t" << n  << std::endl
			  << "总耗时(微秒):\t " << t1 - t0 << std::endl
	          << "平均耗时（微秒）" << (double)(t1 - t0)/(double)n << std::endl;
}

#include <ratio>
#include <chrono>
inline uint64_t get_time_usec(void)
{ /* get system time in microseconds intervals since the epoch */
	using namespace std::chrono;
	high_resolution_clock::time_point tp1 = high_resolution_clock::now();
	microseconds usec = duration_cast<microseconds>(tp1.time_since_epoch());
	return usec.count();
}

using namespace std;


class Random10
{
public:
	Random10(int seed) :distribution_(0, 9)
	{
		generator_.seed(seed);
	}

	int Get()
	{
		return distribution_(generator_);
	}

private:
	std::mt19937 generator_;
	std::uniform_int_distribution<int> distribution_;
};

//----------------------------------------------


//-----------------------------------------------




int main(int argc, char** argv)
{ 
	char *buf = new char[8192];
	// random address
	static std::string source_addr = "123456789";
	static std::string destination_addr = "9876543210";
	static Random10 random_10((int)time_stamp_usec());
	int d1 = random_10.Get();
	int d2 = random_10.Get();
	int d3 = random_10.Get();
	int d4 = random_10.Get();
	source_addr[d1] = '0' + d4;
	destination_addr[d3] = '0' + d2;






again:
  int d1;
  cin >> d1;


  //goto again;
  

	stringstream sstream;
	unsigned long long total_counter = 0;
	int kLoopCount = 10000 * 1000;
	int i, j;
	unsigned long long t0, t1;
	//----------------------------------
	t0 = get_time_usec();
	for (i = 0; i < kLoopCount; i++) {


	}
	t1 = get_time_usec();
	print_time_diff(t0, t1, kLoopCount);
	//----------------------------------
	t0 = get_time_usec();
	for (i = 0; i < kLoopCount; i++) {

	}
	t1 = get_time_usec();
	print_time_diff(t0, t1, kLoopCount);
	//----------------------------------

	std::cout << total_counter << std::endl;
	goto again;

	int aaa;
	cin >> aaa;
	cout << aaa;
	return 0;
}
