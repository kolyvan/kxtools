//
//  ru.kolyvan.kxtools
//  https://github.com/kolyvan/kxtools
//

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "NSArray+Kolyvan.h"

@implementation NSArray (Kolyvan)

- (id) first
{   
    return [self objectAtIndex:0];
}

- (id) second 
{
    return [self objectAtIndex:1];
}

- (id) last
{
    return [self lastObject];
}

- (NSArray *) tail
{
    return [self subarrayWithRange:NSMakeRange(1, [self count] - 1)];
}

- (NSArray *) take: (NSInteger) n
{
    return [self subarrayWithRange:NSMakeRange(0, n)];    
}

- (NSArray *) drop: (NSInteger) n
{
    return [self subarrayWithRange:NSMakeRange(n, [self count] - n)];        
}

- (NSArray *) sorted 
{
	return [self sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray*)sortWith: (NSComparator) block
{
    return [self sortedArrayUsingComparator:block];
}

- (NSArray *) reverse 
{
    return [[self reverseObjectEnumerator] allObjects];
}

- (NSArray *) map: (id (^)(id elem)) block 
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    for (id elem in self)
        [result addObject:block(elem)];
    return [result copy];
}

- (NSArray *) flatMap: (id (^)(id elem)) block
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    for (id elem in self) {
        id r = block(elem);
        if (r)
            [result appendFlat:r];
    }
    return [result copy];
    
}

- (void) each: (void (^)(id elem)) block
{
    for (id elem in self) 
        block(elem);
}

- (id) reduce: (id (^)(id acc, id elem)) block // reduceLeft
{
    BOOL first = YES;
    id acc = nil;
    
    for (id elem in self) {
        if (first) {
            first = NO;
            acc = elem;
        } 
        else
            acc = block(acc, elem);
    }
    
    return acc;
}

- (id) reduceRight: (id (^)(id elem, id acc)) block
{
    return [[self reverse] reduce: (id)^(id acc, id elem) {
        block(elem, acc);
    }];
}

- (id) fold: (id) start with: (id (^)(id acc, id elem)) block // foldLeft
{
    id acc = start;    
    for (id elem in self)
        acc = block(acc, elem);
    return acc;
}

- (id) foldRight: (id) start with: (id (^)(id elem, id acc)) block
{
    return [[self reverse] fold: start with: (id)^(id acc, id elem) {
        block(elem, acc);
    }];    
}

- (NSArray *) filter: (BOOL(^)(id elem)) block 
{
    NSMutableArray *acc = [NSMutableArray arrayWithCapacity:[self count]];    
    for (id elem in self)
        if (block(elem))
            [acc addObject:elem];
    return [acc copy];
}

- (NSArray *) filterNot: (BOOL(^)(id elem)) block
{
    return [self filter: ^(id elem){ return (BOOL)!block(elem); }];
}

- (id) find: (BOOL(^)(id elem)) block 
{
    for (id elem in self)
        if (block(elem))
            return elem;

    return nil;
}

- (BOOL) exists: (BOOL(^)(id elem)) block 
{
    return [self find: block] != nil;
}

- (NSString *) toString
{
    return [self componentsJoinedByString:@""];
}

- (NSString *) toString:(NSString *)separator
{
    return [self componentsJoinedByString:separator];
}

+ (NSArray *) rangeFrom: (NSInteger) start until: (NSInteger) end step: (NSInteger) step
{
    NSAssert(step, @"zero step");

    NSMutableArray *b = [NSMutableArray arrayWithCapacity:(end - start) / step];
    
    NSInteger i = start;
    
    while ((step < 0) ? end < i : i < end) {    
        [b addObject:[NSNumber numberWithInteger:i]];
        i += step;
    }
    
    return [NSArray arrayWithArray:b];    
}

+ (NSArray *) fill: (NSInteger) n block: (id(^)()) block
{
    NSMutableArray *b = [NSMutableArray arrayWithCapacity:n];
    
    for (int i = 0; i < n; ++i)    
        [b addObject: block()];
    
    return [NSArray arrayWithArray:b];    
}

- (NSArray *) unique
{
    NSMutableArray *ma = [NSMutableArray array];
    
    for (id elem in self)
        if (![ma containsObject:elem])
            [ma addObject:elem];
    
    return ma.count ? [ma copy] : self;
}

- (NSArray *) shuffle
{
    NSMutableArray *ma = [self mutableCopy];
    [ma shuffle];
    return [ma copy];
}

@end


@implementation NSMutableArray (Kolyvan)

- (void) append:(id)first, ... 
{
    va_list args;    
    va_start(args, first);
    
    NSMutableArray* objects = [NSMutableArray array];  
    for (id p = first; p != nil; p = va_arg(args, id))
        [objects addObject:p];
    va_end(args);
    
    [self addObjectsFromArray:objects];
}

- (void) appendFlat:(id) obj
{   
    if ([obj isKindOfClass:[NSArray class]]) {
        
        [self addObjectsFromArray:obj];
    }
    else if ([obj conformsToProtocol:@protocol(NSFastEnumeration)]) {
    
        for (id p in obj)
            [self addObject:p];    
    }
    else if ([obj respondsToSelector:@selector(objectEnumerator)]) {
        
        NSEnumerator *enumerator = [obj objectEnumerator];
        id p;
        while ((p = [enumerator nextObject]))
            [self addObject:p];
    }
    else {
        [self addObject:obj];
    }
}

- (void) push:(id) object 
{
    if (object)        
        [self addObject:object]; 
}

- (id) pop
{    
    if (!self.count)
        return nil;
    
    id result = self.last;
    [self removeLastObject];
    return result;
}

- (void)shuffle
{
    const NSUInteger count = self.count;
    for (NSUInteger i = 0; i < count - 1; ++i) {
        const NSUInteger n = arc4random_uniform((UInt32)(count - i)) + i;
        if (i != n)
            [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end