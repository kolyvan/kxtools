//
//  ru.kolyvan.repo
//  https://github.com/kolyvan
//  

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "NSDictionary+Kolyvan.h"
#import "NSArray+Kolyvan.h"
#import "KxTuple2.h"
#import "KxUtils.h"


@implementation NSDictionary (Kolyvan)

- (BOOL) isEmpty 
{
    return [self count] == 0;
}

- (BOOL) nonEmpty
{
    return [self count] > 0;
}

- (BOOL) contains:(id)key
{
    return [self objectForKey:key] != nil;
}

- (id) get:(id)key
{
    return [self objectForKey:key];
}

- (id) get:(id)key orElse:(id) defaultObject
{
    id result = [self objectForKey:key];
    if (!result)
        return defaultObject;
    return result;
}

- (void) each: (void (^)(id key, id obj)) block
{
    NSEnumerator *e = [self keyEnumerator];
    id key;
    while ((key = [e nextObject]))
        block(key, [self objectForKey:key]);    
}

- (NSDictionary *) map: (id (^)(id key, id elem)) block
{
    NSArray * keys = [self allKeys];
    NSMutableArray * objects = [NSMutableArray arrayWithCapacity:self.count];    
    for (id key in keys)
        [objects addObject: block(key, [self objectForKey:key])];    
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];    
}

/*
- (id) fold: (id) start with: (id (^)(id acc, id key, id elem)) block
{
    id acc = start;
    NSEnumerator *e = [self keyEnumerator];
    id key;
    while ((key = [e nextObject]))
        acc = block(acc, key, [self objectForKey:key]);    
    return acc;
}
*/

- (NSArray *) toArray
{
    NSMutableArray * acc = [NSMutableArray arrayWithCapacity:self.count];
    [self each: ^(id key, id elem) {
        [acc addObject: KxUtils.tuple(key, elem)];
    }];    
    return acc;
}


@end



@implementation NSMutableDictionary (Kolyvan)

- (void) toggle:(id) key value: (id) value
{
    if (value == nil)
        [self removeObjectForKey:key];
    else
        [self setObject:value forKey:key];    
}

- (void) update:(id) key value: (id) value
{
    [self setObject:value forKey:key];
}

- (void) updateSafe:(id) key value: (id) value
{
    if (value == nil)
        [self setObject:[NSNull null] forKey:key];
    else
        [self setObject:value forKey:key];
}

- (void) updateOnly:(id) key valueNotNil: (id) value
{
    if (value != nil)
        [self setObject:value forKey:key];    
}

- (void) updateOnce:(id) key with: (id (^)()) block
{
    if ([self objectForKey:key] == nil) {
        id value = block();
        if (value != nil)
            [self setObject:value forKey:key];
    }
}

- (id) get:(id)key orSet:(id (^)()) block
{
    id result = [self objectForKey:key];
    if (result == nil) {
        result = block();
        if (result != nil)
            [self setObject:result forKey:key];
    }    
    return result;
}

@end