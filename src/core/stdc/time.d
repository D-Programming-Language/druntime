/**
 * D header file for C99.
 *
 * $(C_HEADER_DESCRIPTION pubs.opengroup.org/onlinepubs/009695399/basedefs/_time.h.html, _time.h)
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License: Distributed under the
 *      $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0).
 *    (See accompanying file LICENSE)
 * Authors:   Sean Kelly,
 *            Alex Rønne Petersen
 * Source:    $(DRUNTIMESRC core/stdc/_time.d)
 * Standards: ISO/IEC 9899:1999 (E)
 */

module core.stdc.time;

public import platform_dependent.core.stdc.time: tm, time_t, clock_t, CLOCKS_PER_SEC, clock;
private import core.stdc.config;

extern (C):
@trusted: // There are only a few functions here that use unsafe C strings.
nothrow:
@nogc:

///
pure double  difftime(time_t time1, time_t time0); // MT-Safe
///
@system time_t  mktime(scope tm* timeptr); // @system: MT-Safe env locale
///
time_t  time(scope time_t* timer);

///
@system char*   asctime(const scope tm* timeptr); // @system: MT-Unsafe race:asctime locale
///
@system char*   ctime(const scope time_t* timer); // @system: MT-Unsafe race:tmbuf race:asctime env locale
///
@system tm*     gmtime(const scope time_t* timer); // @system: MT-Unsafe race:tmbuf env locale
///
@system tm*     localtime(const scope time_t* timer); // @system: MT-Unsafe race:tmbuf env locale
///
@system size_t  strftime(scope char* s, size_t maxsize, const scope char* format, const scope tm* timeptr); // @system: MT-Safe env locale
