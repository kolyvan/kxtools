//
//  ru.kolyvan.kxtools
//  https://github.com/kolyvan/kxtools
//

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "KxTuple2.h"

@implementation KxTuple2  {
    id _first;
    id _second;
}

@synthesize first = _first;
@synthesize second = _second;

+ (KxTuple2 *) first:(id) first second:(id) second
{
    return [[KxTuple2 alloc] initWithFirst:first andSecond:second];
}

- (id) initWithFirst: (id) first andSecond: (id) second
{
    self = [super init];
    if (self) {
        _first = first;
        _second = second;
    }    
    return self;
}

- (KxTuple2 *) swap
{
    return [[KxTuple2 alloc] initWithFirst:_second andSecond:_first];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"(%@,%@)", _first, _second];
}

- (id) copyWithZone:(NSZone *) zone 
{
	return [[KxTuple2 allocWithZone:zone] initWithFirst:_first andSecond:_second];    
}

- (BOOL) isEqualToTuple:(KxTuple2 *) other
{
    return [_first isEqual:other.first] && [_second isEqual:other.second];
}

- (BOOL) isEqual:(id) other 
{
	if (self == other)
		return YES;
	if (![other isKindOfClass:[KxTuple2 class]])
		return NO;
    return [self isEqualToTuple:other];
}

- (NSUInteger) hash 
{
	return [_first hash] * 31 + [_second hash];
}

- (NSArray *) toArray
{
    return @[_first, _second];
}

- (NSDictionary *) toDictionary
{
    return @{_first : _second};
}

#pragma mark - NSCoding

- (id) initWithCoder: (NSCoder*)coder
{    
   	if ([coder versionForClassName: NSStringFromClass([self class])] != 0)
		return nil;
	
    self = [super init];
    if (self) {
        
        if ([coder allowsKeyedCoding]) {
            
            _first   = [coder decodeObjectForKey: @"first"];
            _second  = [coder decodeObjectForKey: @"second"];
            
        } else {
            
            _first   = [coder decodeObject];
            _second  = [coder decodeObject];
        }
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

/////

@implementation NSArray (KxTuple2)

- (KxTuple2 *) partition: (BOOL(^)(id elem)) block
{
    NSMutableArray *acc = [NSMutableArray arrayWithCapacity:self.count];
    NSMutableArray *accNot = [NSMutableArray arrayWithCapacity:self.count];
    
    for (id elem in self)
        if (block(elem))
            [acc addObject:elem];
        else
            [accNot addObject:elem];
    
    return [KxTuple2 first:[acc copy] second:[accNot copy]];
}

- (NSArray *) zip: (NSArray *) other
{
    NSInteger len = MIN(self.count, other.count);
    
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:len];
    
    for (NSInteger i = 0; i < len; ++i) {
        KxTuple2 *tuple = [KxTuple2 first: [self objectAtIndex:i] second: [other objectAtIndex:i]];
        [result addObject: tuple];
    }
    
    return [result copy];
}

- (NSArray *) zipWithIndex
{
    NSInteger len = self.count;
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:len];
    for (NSInteger i = 0; i < len; ++i) {
        KxTuple2 *tuple = [KxTuple2 first: [self objectAtIndex:i] second: @(i)];
        [result addObject: tuple];
    }
    return [result copy];
}

- (KxTuple2 *) unzip
{
    NSMutableArray * l = [NSMutableArray arrayWithCapacity:[self count]];
    NSMutableArray * r = [NSMutableArray arrayWithCapacity:[self count]];
    
    for (KxTuple2 *p in self) {
        [l addObject:p.first];
        [r addObject:p.second];
    }
    
    return [KxTuple2 first:l second: r];
}

@end

/////

@implementation NSDictionary (KxTuple2)

- (NSArray *) toArray
{
    NSMutableArray * acc = [NSMutableArray arrayWithCapacity:self.count];    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [acc addObject: [KxTuple2 first:key second:obj]];
    }];
    return acc;
}

@end

/////

@implementation NSString (KxTuple2)

- (KxTuple2 *) splitAt:(NSInteger)position
{
    return [KxTuple2 first: [self substringToIndex:position] second: [self substringFromIndex:position]];
}

@end