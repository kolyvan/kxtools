//
//  ru.kolyvan.repo
//  https://github.com/kolyvan
//  

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



#import "KxConsole.h"
#import "KxArc.h"
#import <sys/uio.h>

#if ! __has_feature(objc_arc)

static NSString * ansiCode_right(int n)      { return [NSString stringWithFormat: @"\e[%dC", n, nil]; }
static NSString * ansiCode_left(int n)       { return [NSString stringWithFormat: @"\e[%dD", n, nil]; }       
static NSString * ansiCode_up(int n)         { return [NSString stringWithFormat: @"\e[%dA", n, nil]; }                                
static NSString * ansiCode_down(int n)       { return [NSString stringWithFormat: @"\e[%dB", n, nil]; }                                    
static NSString * ansiCode_move(int x, int y){ return [NSString stringWithFormat: @"\e[%d;%dH", x, y, nil]; } 
 

KxAnsiCodes_t KxAnsiCodes = {
    @"\e[0m",   //reset
    @"\e[1m",   //bold
    @"\e[2m",   //dark
    @"\e[3m",   //italic
    @"\e[4m",   //underline
    @"\e[5m",   //blink
    @"\e[7m",   //negative
    @"\e[8m",   //concealed
    @"\e[9m",   //strikethrough 
    
    @"\e[22m",  //boldOff       
    @"\e[23m",  //italicOff       
    @"\e[24m",  //underlineOff      
    @"\e[27m",  //negativeOff      
    @"\e[29m",  //strikethroughOff          
    
    @"\e[30m",
    @"\e[31m",    
    @"\e[32m",
    @"\e[33m",
    @"\e[34m",
    @"\e[35m",
    @"\e[36m",
    @"\e[37m",
    @"\e[39m",    
    
    @"\e[40m",    
    @"\e[41m",
    @"\e[42m",
    @"\e[43m",
    @"\e[44m",
    @"\e[45m",
    @"\e[46m",
    @"\e[47m",    
    @"\e[49m",    
    
    @"\e[s",    
    @"\e[u",        
    @"\e[K",        
    @"\e[2J",        
    
    ansiCode_right,
    ansiCode_left,
    ansiCode_up,
    ansiCode_down,
    ansiCode_move,    
    
};

#endif

//////

static void c_print (const char * msg) {
    
    size_t len = strlen(msg);
    
    struct iovec v[1];
    
    v[0].iov_base = (char *)msg;
    v[0].iov_len = len;
    
    writev(STDOUT_FILENO, v, 1);    
}

static void c_println (const char * msg) {

    size_t len = strlen(msg);
    
    struct iovec v[2];
    
    v[0].iov_base = (char *)msg;
    v[0].iov_len = len;
    
    v[1].iov_base = "\n";
    v[1].iov_len = 1;
    
    writev(STDOUT_FILENO, v, 2);    
}

static void ns_print (NSString * s) {    
    c_print([s UTF8String]);
}

static void ns_printf (NSString * fmt, ...) {
    
    va_list args;    
    va_start(args, fmt);
    NSString * s =[[NSString alloc] initWithFormat:fmt arguments:args];
    c_print([s UTF8String]);
    va_end(args);
    KX_RELEASE(s);    
}


static void ns_println (NSString * s) {    
    c_println([s UTF8String]);
}

static void ns_printlnf (NSString * fmt, ...) {
    
    va_list args;    
    va_start(args, fmt);
    NSString * s =[[NSString alloc] initWithFormat:fmt arguments:args];
    c_println([s UTF8String]);
    va_end(args);
    KX_RELEASE(s);    
}


KxConsole_t KxConsole = {
    ns_print,
    ns_printf,    
    ns_println,
    ns_printlnf
};