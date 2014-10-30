/**
 * D header file for POSIX.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License:   $(WEB www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   Sean Kelly
 * Standards: The Open Group Base Specifications Issue 6, IEEE Std 1003.1, 2004 Edition
 */

/*          Copyright Sean Kelly 2005 - 2009.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module core.sys.posix.setjmp;

private import core.sys.posix.config;
private import core.sys.posix.signal; // for sigset_t

version (Posix):
extern (C) nothrow @nogc:

//
// Required
//
/*
jmp_buf

int  setjmp(ref jmp_buf);
void longjmp(ref jmp_buf, int);
*/

version( linux )
{
    version( X86_64 )
    {
        //enum JB_BX      = 0;
        //enum JB_BP      = 1;
        //enum JB_12      = 2;
        //enum JB_13      = 3;
        //enum JB_14      = 4;
        //enum JB_15      = 5;
        //enum JB_SP      = 6;
        //enum JB_PC      = 7;
        //enum JB_SIZE    = 64;

        alias __jmp_buf = long[8];
    }
    else version( X86 )
    {
        //enum JB_BX      = 0;
        //enum JB_SI      = 1;
        //enum JB_DI      = 2;
        //enum JB_BP      = 3;
        //enum JB_SP      = 4;
        //enum JB_PC      = 5;
        //enum JB_SIZE    = 24;

        alias __jmp_buf = int[6];
    }
    else version ( SPARC )
    {
        alias __jmp_buf = int[3];
    }
    else version (ARM)
    {
        alias __jmp_buf = int[64];
    }
    else version (PPC)
    {
        alias __jmp_buf = int[64 + (12*4)];
    }
    else version (PPC64)
    {
        alias __jmp_buf = long[64];
    }
    else version (MIPS)
    {
        struct __jmp_buf
        {
            version (MIPS_O32)
            {
                void * __pc;
                void * __sp;
                int[8] __regs;
                void * __fp;
                void * __gp;
            }
            else
            {
                long __pc;
                long __sp;
                long[8] __regs;
                long __fp;
                long __gp;
            }
            int __fpc_csr;
            version (MIPS_N64)
                double[8] __fpregs;
            else
                double[6] __fpregs;
        }
    }
    else version (MIPS64)
    {
        struct __jmp_buf
        {
            long __pc;
            long __sp;
            long[8] __regs;
            long __fp;
            long __gp;
            int __fpc_csr;
            version (MIPS_N64)
                double[8] __fpregs;
            else
                double[6] __fpregs;
        }
    }
    else
        static assert(0, "unimplemented");

    struct __jmp_buf_tag
    {
        __jmp_buf   __jmpbuf;
        int         __mask_was_saved;
        sigset_t    __saved_mask;
    }

    alias jmp_buf = __jmp_buf_tag[1];

    alias setjmp = _setjmp; // see XOpen block
    void longjmp(ref jmp_buf, int);
}
else version( FreeBSD )
{
    // <machine/setjmp.h>
    version( X86 )
    {
        enum _JBLEN = 11;
        struct _jmp_buf { int[_JBLEN + 1] _jb; }
    }
    else version( X86_64)
    {
        enum _JBLEN = 12;
        struct _jmp_buf { c_long[_JBLEN] _jb; }
    }
    else version( SPARC )
    {
        enum _JBLEN = 5;
        struct _jmp_buf { c_long[_JBLEN + 1] _jb; }
    }
    else
        static assert(0);
    alias jmp_buf = _jmp_buf[1];

    int  setjmp(ref jmp_buf);
    void longjmp(ref jmp_buf, int);
}
else version( Android )
{
    // <machine/setjmp.h>
    version( X86 )
    {
        enum _JBLEN = 10;
    }
    else
    {
        static assert(false, "Architecture not supported.");
    }

    alias jmp_buf = c_long[_JBLEN];

    int  setjmp(ref jmp_buf);
    void longjmp(ref jmp_buf, int);
}

//
// C Extension (CX)
//
/*
sigjmp_buf

int  sigsetjmp(sigjmp_buf, int);
void siglongjmp(sigjmp_buf, int);
*/

version( linux )
{
    alias sigjmp_buf = jmp_buf;

    int __sigsetjmp(sigjmp_buf, int);
    alias sigsetjmp = __sigsetjmp;
    void siglongjmp(sigjmp_buf, int);
}
else version( FreeBSD )
{
    // <machine/setjmp.h>
    version( X86 )
    {
        struct _sigjmp_buf { int[_JBLEN + 1] _ssjb; }
    }
    else version( X86_64)
    {
        struct _sigjmp_buf { c_long[_JBLEN] _sjb; }
    }
    else version( SPARC )
    {
        enum _JBLEN         = 5;
        enum _JB_FP         = 0;
        enum _JB_PC         = 1;
        enum _JB_SP         = 2;
        enum _JB_SIGMASK    = 3;
        enum _JB_SIGFLAG    = 5;
        struct _sigjmp_buf { c_long[_JBLEN + 1] _sjb; }
    }
    else
        static assert(0);
    alias sigjmp_buf = _sigjmp_buf[1];

    int  sigsetjmp(ref sigjmp_buf);
    void siglongjmp(ref sigjmp_buf, int);
}
else version( Android )
{
    alias sigjmp_buf = c_long[_JBLEN + 1];

    int  sigsetjmp(ref sigjmp_buf, int);
    void siglongjmp(ref sigjmp_buf, int);
}

//
// XOpen (XSI)
//
/*
int  _setjmp(jmp_buf);
void _longjmp(jmp_buf, int);
*/

version( linux )
{
    int  _setjmp(ref jmp_buf);
    void _longjmp(ref jmp_buf, int);
}
else version( FreeBSD )
{
    int  _setjmp(ref jmp_buf);
    void _longjmp(ref jmp_buf, int);
}
else version( Android )
{
    int  _setjmp(ref jmp_buf);
    void _longjmp(ref jmp_buf, int);
}
