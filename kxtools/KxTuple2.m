//
//  ru.kolyvan.repo
//  https://github.com/kolyvan
//  

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "KxTuple2.h"
#import "KxUtils.h"
#define NSNUMBER_SHORTHAND 
#import "KxMacros.h"

@implementation KxTuple2

@synthesize first = _first;
@synthesize second = _second;

+ (KxTuple2 *) first:(id) first second:(id) second
{
    KxTuple2 *r = [[KxTuple2 alloc] initWithFirst:first andSecond:second];
    return KX_AUTORELEASE(r);
}

- (id) initWithFirst: (id) first andSecond: (id) second
{
    self = [super init];
    if (self) {
        _first = KX_RETAIN(first);
        _second = KX_RETAIN(second);        
    }    
    return self;
}

- (void) dealloc
{
    KX_RELEASE(_first);
    KX_RELEASE(_second);
    KX_SUPER_DEALLOC();
}

- (KxTuple2 *) swap
{
    KxTuple2 *r = [[KxTuple2 alloc] initWithFirst:_second andSecond:_first];
    return KX_AUTORELEASE(r);
}

- (NSString *) description
{
    return KxUtils.format(@"(%@,%@)", _first, _second);
}

- (id) copyWithZone:(NSZone *) zone 
{
	return [[KxTuple2 allocWithZone:zone] initWithFirst:_first andSecond:_second];    
}

- (BOOL) isEqual:(id) other 
{
	if (self == other)
		return YES;
    
	if (![other isKindOfClass:[KxTuple2 class]])
		return NO;
    
    KxTuple2 * p = (KxTuple2 *)other;
    
	return [_first isEqual:p->_first] && [_second isEqual:p->_second];
}

- (NSUInteger) hash 
{
	return [_first hash] * 31 + [_second hash];
}




#pragma mark - NSCoding

- (id) initWithCoder: (NSCoder*)coder
{    
   	if ([coder versionForClassName: NSStringFromClass([self class])] != 0) 
	{ 
		KX_RELEASE(self);
		return nil;
	}
	if ([coder allowsKeyedCoding])
	{
		_first   = KX_RETAIN([coder decodeObjectForKey: @"first"]);
		_second  = KX_RETAIN([coder decodeObjectForKey: @"second"]);        
	}
	else
	{
		_first   = KX_RETAIN([coder decodeObject]);
		_second  = KX_RETAIN([coder decodeObject]);        
	}
    
	return self;
}
- (void) encodeWithCoder: (NSCoder*)coder
{
	if ([coder allowsKeyedCoding])
	{
        [coder encodeObject:_first  forKey:@"first"];
        [coder encodeObject:_second forKey:@"second"];
	}
	else
	{
        [coder encodeObject:_first];
        [coder encodeObject:_second];
    }    
}



@end
