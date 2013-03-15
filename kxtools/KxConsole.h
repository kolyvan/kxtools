//
//  ru.kolyvan.kxtools
//  https://github.com/kolyvan/kxtools
//

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



#import <Foundation/Foundation.h>

typedef struct {
   
    const char * reset;
    const char * bold;
    const char * dark;
    const char * italic;
    const char * underline;
    const char * blink;
    const char * negative;
    const char * concealed;
    const char * strikethrough;
    
    const char * boldOff;
    const char * italicOff;
    const char * underlineOff;
    const char * negativeOff;
    const char * strikethroughOff;
        
    const char * black;
    const char * red;
    const char * green;
    const char * yellow;
    const char * blue;                   
    const char * magenta;                       
    const char * cyan;                           
    const char * white;
    const char * fgDefault;
    
    const char * bgBlack;       
    const char * bgRed;    
    const char * bgGreen;           
    const char * bgYellow;               
    const char * bgBlue;                   
    const char * bgMagenta;                       
    const char * bgCyan;                           
    const char * bgWhite;    
    const char * bgDefault;    
    
    const char * save;        
    const char * restore;            
    const char * clearLine;                
    const char * clearScreen;                    
    
} KxAnsiCodes_t;

extern KxAnsiCodes_t KxAnsiCodes;

typedef struct {
    
    void (*print)(NSString * s);
    void (*printf)(NSString * fmt, ...);    
    
    void (*println)(NSString * s);
    void (*printlnf)(NSString * fmt, ...);    
    
} KxConsole_t;

extern KxConsole_t KxConsole;