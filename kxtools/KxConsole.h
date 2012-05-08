//
//  ru.kolyvan.repo
//  https://github.com/kolyvan
//  

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
//#warning This file must be compiled without ARC. Use -fno-objc-arc flag.

typedef struct {
   
    NSString * reset;      
    NSString * bold;
    NSString * dark;    
    NSString * italic;
    NSString * underline;
    NSString * blink;    
    NSString * negative;
    NSString * concealed;   
    NSString * strikethrough;
    
    NSString * boldOff;
    NSString * italicOff;
    NSString * underlineOff;
    NSString * negativeOff;
    NSString * strikethroughOff;
        
    NSString * black;       
    NSString * red;    
    NSString * green;           
    NSString * yellow;               
    NSString * blue;                   
    NSString * magenta;                       
    NSString * cyan;                           
    NSString * white;
    NSString * fgDefault;
    
    NSString * bgBlack;       
    NSString * bgRed;    
    NSString * bgGreen;           
    NSString * bgYellow;               
    NSString * bgBlue;                   
    NSString * bgMagenta;                       
    NSString * bgCyan;                           
    NSString * bgWhite;    
    NSString * bgDefault;    
    
    NSString * save;        
    NSString * restore;            
    NSString * clearLine;                
    NSString * clearScreen;                    
    
    NSString * (*right)(int n);                        
    NSString * (*left)(int n);                            
    NSString * (*up)(int n);                                
    NSString * (*down)(int n);                                    
    NSString * (*move)(int x, int y); 
    
} KxAnsiCodes_t;

extern KxAnsiCodes_t KxAnsiCodes;

#endif

typedef struct {
    
    void (*print)(NSString * s);
    void (*printf)(NSString * fmt, ...);    
    
    void (*println)(NSString * s);
    void (*printlnf)(NSString * fmt, ...);    
    
} KxConsole_t;

extern KxConsole_t KxConsole;