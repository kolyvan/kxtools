//
//  main.m
//  specs
//
//  Created by Kolyvan on 08.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cedar/Cedar.h>
#import "KxArc.h"

int main(int argc, const char * argv[])
{
    int result = 0;
    
    KX_AUTORELEASE_POOL_BEGIN()

    result = runSpecs();
        
    KX_AUTORELEASE_POOL_END()
    
    return result;
}

