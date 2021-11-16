/**
 * D header file for C99.
 *
 * $(C_HEADER_DESCRIPTION pubs.opengroup.org/onlinepubs/009695399/basedefs/_wchar.h.html, _wchar.h)
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Authors:   Sean Kelly
 * Source:    $(LINK2 https://github.com/dlang/druntime/blob/master/src/core/stdc/wchar_.d, _wchar_.d)
 * Documentation: https://dlang.org/phobos/core_stdc_wchar_.html
 * Standards: ISO/IEC 9899:1999 (E)
 */

module core.stdc.wchar_;

import core.stdc.config;
import core.stdc.stdarg; // for va_list
import core.stdc.stdio;  // for FILE, not exposed per spec
public import core.stdc.stddef;  // for wchar_t
public import core.stdc.time;    // for tm
public import core.stdc.stdint;  // for WCHAR_MIN, WCHAR_MAX

extern (C):
@system:
nothrow:
@nogc:

version (CRuntime_Glibc)
{
    ///
    struct mbstate_t
    {
        int __count;
        union ___value
        {
            wint_t __wch = 0;
            char[4] __wchb;
        }
        ___value __value;
    }
}
else version (FreeBSD)
{
    ///
    union __mbstate_t // <sys/_types.h>
    {
        char[128]   _mbstate8 = 0;
        long        _mbstateL;
    }

    ///
    alias mbstate_t = __mbstate_t;
}
else version (NetBSD)
{
    ///
    union __mbstate_t
    {
        int64_t   __mbstateL;
        char[128] __mbstate8;
    }

    ///
    alias mbstate_t = __mbstate_t;
}
else version (OpenBSD)
{
    ///
    union __mbstate_t
    {
        char[128] __mbstate8 = 0;
        int64_t   __mbstateL;
    }

    ///
    alias mbstate_t = __mbstate_t;
}
else version (DragonFlyBSD)
{
    ///
    union __mbstate_t                   // <sys/stdint.h>
    {
        char[128]   _mbstate8 = 0;
        long        _mbstateL;
    }

    ///
    alias mbstate_t = __mbstate_t;
}
else version (Solaris)
{
    ///
    struct __mbstate_t
    {
        version (D_LP64)
        {
            long[4] __filler;
        }
        else
        {
            int[6] __filler;
        }
    }

    ///
    alias mbstate_t = __mbstate_t;
}
else version (CRuntime_UClibc)
{
    ///
    struct mbstate_t
    {
        wchar_t __mask = 0;
        wchar_t __wc = 0;
    }
}
else
{
    ///
    alias int mbstate_t;
}

///
alias wchar_t wint_t;

///
enum wchar_t WEOF = 0xFFFF;

///
int fwprintf(FILE* stream, const scope wchar_t* format, scope const ...);
///
int fwscanf(FILE* stream, const scope wchar_t* format, scope ...);
///
int swprintf(wchar_t* s, size_t n, const scope wchar_t* format, scope const ...);
///
int swscanf(const scope wchar_t* s, const scope wchar_t* format, scope ...);
///
int vfwprintf(FILE* stream, const scope wchar_t* format, va_list arg);
///
int vfwscanf(FILE* stream, const scope wchar_t* format, va_list arg);
///
int vswprintf(wchar_t* s, size_t n, const scope wchar_t* format, va_list arg);
///
int vswscanf(const scope wchar_t* s, const scope wchar_t* format, va_list arg);
///
int vwprintf(const scope wchar_t* format, va_list arg);
///
int vwscanf(const scope wchar_t* format, va_list arg);
///
int wprintf(const scope wchar_t* format, scope const ...);
///
int wscanf(const scope wchar_t* format, scope ...);

// No unsafe pointer manipulation.
@trusted
{
    ///
    wint_t fgetwc(FILE* stream);
    ///
    wint_t fputwc(wchar_t c, FILE* stream);
}

///
wchar_t* fgetws(wchar_t* s, int n, FILE* stream);
///
int      fputws(const scope wchar_t* s, FILE* stream);

// No unsafe pointer manipulation.
extern (D) @trusted
{
    ///
    wint_t getwchar()                     { return fgetwc(stdin);     }
    ///
    wint_t putwchar(wchar_t c)            { return fputwc(c,stdout);  }
}

///
alias getwc = fgetwc;
///
alias putwc = fputwc;

// No unsafe pointer manipulation.
@trusted
{
    ///
    wint_t ungetwc(wint_t c, FILE* stream);
    ///
    version (CRuntime_Microsoft)
    {
        // MSVC defines this as an inline function.
        int fwide(FILE* stream, int mode) { return mode; }
    }
    else
    {
        int    fwide(FILE* stream, int mode);
    }
}

///
double  wcstod(const scope wchar_t* nptr, wchar_t** endptr);
///
float   wcstof(const scope wchar_t* nptr, wchar_t** endptr);
///
real    wcstold(const scope wchar_t* nptr, wchar_t** endptr);
///
c_long  wcstol(const scope wchar_t* nptr, wchar_t** endptr, int base);
///
long    wcstoll(const scope wchar_t* nptr, wchar_t** endptr, int base);
///
c_ulong wcstoul(const scope wchar_t* nptr, wchar_t** endptr, int base);
///
ulong   wcstoull(const scope wchar_t* nptr, wchar_t** endptr, int base);

///
pure wchar_t* wcscpy(return wchar_t* s1, scope const wchar_t* s2);
///
pure wchar_t* wcsncpy(return wchar_t* s1, scope const wchar_t* s2, size_t n);
///
pure wchar_t* wcscat(return wchar_t* s1, scope const wchar_t* s2);
///
pure wchar_t* wcsncat(return wchar_t* s1, scope const wchar_t* s2, size_t n);
///
pure int wcscmp(scope const wchar_t* s1, scope const wchar_t* s2);
///
int      wcscoll(scope const wchar_t* s1, scope const wchar_t* s2);
///
pure int wcsncmp(scope const wchar_t* s1, scope const wchar_t* s2, size_t n);
///
size_t   wcsxfrm(scope wchar_t* s1, scope const wchar_t* s2, size_t n);
///
pure inout(wchar_t)* wcschr(return inout(wchar_t)* s, wchar_t c);
///
pure size_t wcscspn(scope const wchar_t* s1, scope const wchar_t* s2);
///
pure inout(wchar_t)* wcspbrk(return inout(wchar_t)* s1, scope const wchar_t* s2);
///
pure inout(wchar_t)* wcsrchr(return inout(wchar_t)* s, wchar_t c);
///
pure size_t wcsspn(scope const wchar_t* s1, scope const wchar_t* s2);
///
pure inout(wchar_t)* wcsstr(return inout(wchar_t)* s1, scope const wchar_t* s2);
///
wchar_t* wcstok(return wchar_t* s1, scope const wchar_t* s2, wchar_t** ptr);
///
pure size_t wcslen(scope const wchar_t* s);

///
pure inout(wchar_t)* wmemchr(return inout wchar_t* s, wchar_t c, size_t n);
///
pure int      wmemcmp(scope const wchar_t* s1, scope const wchar_t* s2, size_t n);
///
pure wchar_t* wmemcpy(return wchar_t* s1, scope const wchar_t* s2, size_t n);
///
pure wchar_t* wmemmove(return wchar_t* s1, scope const wchar_t* s2, size_t n);
///
pure wchar_t* wmemset(return wchar_t* s, wchar_t c, size_t n);

///
size_t wcsftime(wchar_t* s, size_t maxsize, const scope wchar_t* format, const scope tm* timeptr);

version (Windows)
{
    ///
    wchar_t* _wasctime(tm*);      // non-standard
    ///
    wchar_t* _wctime(time_t*);    // non-standard
    ///
    wchar_t* _wstrdate(wchar_t*); // non-standard
    ///
    wchar_t* _wstrtime(wchar_t*); // non-standard
}

// No unsafe pointer manipulation.
@trusted
{
    ///
    wint_t btowc(int c);
    ///
    int    wctob(wint_t c);
}

///
int    mbsinit(const scope mbstate_t* ps);
///
size_t mbrlen(const scope char* s, size_t n, mbstate_t* ps);
///
size_t mbrtowc(wchar_t* pwc, const scope char* s, size_t n, mbstate_t* ps);
///
size_t wcrtomb(char* s, wchar_t wc, mbstate_t* ps);
///
size_t mbsrtowcs(wchar_t* dst, const scope char** src, size_t len, mbstate_t* ps);
///
size_t wcsrtombs(char* dst, const scope wchar_t** src, size_t len, mbstate_t* ps);

static if (__traits(getTargetInfo, "cppStd") >= 201103)
{
    /* Add backwards compatibility overloads to the same functions for wchar* and dchar* for C++11 or newer.
     * Being C with no name mangling, they'll resolve to the same functions.
     */
    version (Windows)
    private alias _old_wchar_t = wchar;
    else version (Posix)
    private alias _old_wchar_t = dchar;

    int fwprintf(FILE* stream, in _old_wchar_t* format, ...);
    int fwscanf(FILE* stream, in _old_wchar_t* format, ...);
    int swprintf(_old_wchar_t* s, size_t n, in _old_wchar_t* format, ...);
    int swscanf(in _old_wchar_t* s, in _old_wchar_t* format, ...);
    int vfwprintf(FILE* stream, in _old_wchar_t* format, va_list arg);
    int vfwscanf(FILE* stream, in _old_wchar_t* format, va_list arg);
    int vswprintf(_old_wchar_t* s, size_t n, in _old_wchar_t* format, va_list arg);
    int vswscanf(in _old_wchar_t* s, in _old_wchar_t* format, va_list arg);
    int vwprintf(in _old_wchar_t* format, va_list arg);
    int vwscanf(in _old_wchar_t* format, va_list arg);
    int wprintf(in _old_wchar_t* format, ...);
    int wscanf(in _old_wchar_t* format, ...);
    _old_wchar_t* fgetws(_old_wchar_t* s, int n, FILE* stream);
    int      fputws(in _old_wchar_t* s, FILE* stream);
    double  wcstod(in _old_wchar_t* nptr, _old_wchar_t** endptr);
    float   wcstof(in _old_wchar_t* nptr, _old_wchar_t** endptr);
    real    wcstold(in _old_wchar_t* nptr, _old_wchar_t** endptr);
    c_long  wcstol(in _old_wchar_t* nptr, _old_wchar_t** endptr, int base);
    long    wcstoll(in _old_wchar_t* nptr, _old_wchar_t** endptr, int base);
    c_ulong wcstoul(in _old_wchar_t* nptr, _old_wchar_t** endptr, int base);
    ulong   wcstoull(in _old_wchar_t* nptr, _old_wchar_t** endptr, int base);
    pure _old_wchar_t* wcscpy(return _old_wchar_t* s1, scope const _old_wchar_t* s2);
    pure _old_wchar_t* wcsncpy(return _old_wchar_t* s1, scope const _old_wchar_t* s2, size_t n);
    pure _old_wchar_t* wcscat(return _old_wchar_t* s1, scope const _old_wchar_t* s2);
    pure _old_wchar_t* wcsncat(return _old_wchar_t* s1, scope const _old_wchar_t* s2, size_t n);
    pure int wcscmp(scope const _old_wchar_t* s1, scope const _old_wchar_t* s2);
    int      wcscoll(scope const _old_wchar_t* s1, scope const _old_wchar_t* s2);
    pure int wcsncmp(scope const _old_wchar_t* s1, scope const _old_wchar_t* s2, size_t n);
    size_t   wcsxfrm(scope _old_wchar_t* s1, scope const _old_wchar_t* s2, size_t n);
    pure inout(_old_wchar_t)* wcschr(return inout(_old_wchar_t)* s, wchar_t c);
    pure size_t wcscspn(scope const _old_wchar_t* s1, scope const _old_wchar_t* s2);
    pure inout(_old_wchar_t)* wcspbrk(return inout(_old_wchar_t)* s1, scope const _old_wchar_t* s2);
    pure inout(_old_wchar_t)* wcsrchr(return inout(_old_wchar_t)* s, wchar_t c);
    pure size_t wcsspn(scope const _old_wchar_t* s1, scope const _old_wchar_t* s2);
    pure inout(_old_wchar_t)* wcsstr(return inout(_old_wchar_t)* s1, scope const _old_wchar_t* s2);
    _old_wchar_t* wcstok(return _old_wchar_t* s1, scope const _old_wchar_t* s2, _old_wchar_t** ptr);
    pure size_t wcslen(scope const _old_wchar_t* s);
    pure _old_wchar_t* wmemchr(return const _old_wchar_t* s, wchar_t c, size_t n);
    pure int      wmemcmp(scope const _old_wchar_t* s1, scope const _old_wchar_t* s2, size_t n);
    pure _old_wchar_t* wmemcpy(return _old_wchar_t* s1, scope const _old_wchar_t* s2, size_t n);
    pure _old_wchar_t* wmemmove(return _old_wchar_t* s1, scope const _old_wchar_t* s2, size_t n);
    pure _old_wchar_t* wmemset(return _old_wchar_t* s, wchar_t c, size_t n);
    size_t wcsftime(_old_wchar_t* s, size_t maxsize, in _old_wchar_t* format, in tm* timeptr);

    version (Windows)
    {
        // Can't overload based on return type
        //_old_wchar_t* _wasctime(tm*);      // non-standard
        //_old_wchar_t* _wctime(time_t*);    // non-standard

        _old_wchar_t* _wstrdate(_old_wchar_t*); // non-standard
        _old_wchar_t* _wstrtime(_old_wchar_t*); // non-standard
    }
    size_t mbrtowc(_old_wchar_t* pwc, in char* s, size_t n, mbstate_t* ps);
    size_t mbsrtowcs(_old_wchar_t* dst, in char** src, size_t len, mbstate_t* ps);
}
