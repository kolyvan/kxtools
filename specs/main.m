//
//  main.m
//  specs
//
//  Created by Kolyvan on 08.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cedar/Cedar.h>
#import "KxConsole.h"

int main(int argc, const char * argv[])
{
    int result = 0;
    
    @autoreleasepool {
        
        KxConsole.printlnf(@"run %stest%s ...", KxAnsiCodes.red, KxAnsiCodes.reset);
        
        result = runSpecs();
    }
    
    return result;
}

