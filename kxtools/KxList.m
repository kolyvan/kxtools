//
//  ru.kolyvan.repo
//  https://github.com/kolyvan
//  

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "KxList.h"
#import "KxTuple2.h"
#import "NSArray+Kolyvan.h"
#import "KxMacros.h"
#import "KxUtils.h"


/////

@implementation KxList

//@dynamic count;
@dynamic head;
@dynamic tail;

- (NSInteger) count 
{
    NSInteger n = 0;
    KxList * p = self;
    while (p) {     
        ++n;
        p = p->_tail;
    }    
    return n;
}

- (id) head 
{
    return KX_AUTORELEASE(KX_RETAIN(_head));
}

- (KxList *) tail
{
    return KX_AUTORELEASE(KX_RETAIN(_tail));
}

- (id) last 
{
    KxList * p = self;
    id r = nil;
    while (p) {
        r = p->_head;
        p = p->_tail;
    }    
    return KX_AUTORELEASE(KX_RETAIN(r));
}

- (KxList *) butlast
{      
    NSMutableArray * b = [NSMutableArray array];
    KxList * p = self;    
    id x = nil;
    
    while (p) {        
        if (x)
            [b addObject:x];
        x = p->_head;        
        p = p->_tail;        
    }    
    
    return [KxList fromArray:b];    
}

- (id) initWithHead: (id)x andTail: (KxList *) xs
{
    NSAssert(x, @"nil head");
    
    self = [super init];
    if (self) {
        _head = KX_RETAIN(x);
        _tail = KX_RETAIN(xs);
    }
    
    return self;    
}

- (void)dealloc
{
    KX_RELEASE(_head);
    KX_RELEASE(_tail);    
    KX_SUPER_DEALLOC();
}


+ (KxList *) head: (id)x tail: (KxList *) xs
{
    KxList *l = [[KxList alloc] initWithHead:x andTail:xs];
    return KX_AUTORELEASE(l);
}

+ (KxList *) fromArray: (NSArray *) array
{
    if (!array)
        return nil;
    
    KxList * result = nil;    
    NSEnumerator * e = [array reverseObjectEnumerator];
    id p;
    
    while ((p = [e nextObject])) {
        result = [KxList head: p tail: result];        
    }
    
    return result;
}

+ (KxList *) list: (id) head, ... 
{
    va_list args;    
    va_start(args, head);    

    NSMutableArray * b = [NSMutableArray array];
    for (id p = head; p != nil; p = va_arg(args, id)) {    
        [b addObject:p];
    }
    va_end(args);
    
    return [self fromArray:b];
}


+ (KxList *) rangeFrom: (NSInteger) start until: (NSInteger) end step: (NSInteger) step
{
    NSAssert(step, @"zero step");
    
    NSMutableArray *b = [NSMutableArray arrayWithCapacity:(end - start) / step];
    
    NSInteger i = start;
    
    while ((step < 0) ? end < i : i < end) {    
        [b addObject:[NSNumber numberWithInteger:i]];
        i += step;
    }
    
    return [KxList fromArray:b];    
}

+ (KxList *) fill: (NSInteger) n block: (id(^)()) block
{
    KxList * result = nil;    
    for (int i = 0; i < n; ++i)    
        result = [KxList head: block() tail:result];    
    return result;
}

- (id) init
{
    NSAssert(false, @"must call [KxList head:tail:]");
    
    self = [super init];
    if (self) {   
    }    
    return self;
}

- (id) copyWithZone:(NSZone *) zone 
{   
    KxList * newtail = [_tail map: ^(id elem) { return [elem copy]; }];
    id newhead = [_head copy];
    KxList* result =  [[KxList allocWithZone:zone] initWithHead: newhead 
                                                        andTail: newtail];    
    KX_RELEASE(newhead);
	return result;
}

- (NSEnumerator *) objectEnumerator
{
    return [[self toArray] objectEnumerator];
}

- (NSEnumerator *) reverseObjectEnumerator
{
    return [[self toArray] reverseObjectEnumerator];    
}

- (BOOL) isEqual:(id) other 
{   
	if (![other isKindOfClass:[KxList class]])
		return NO;
    
    return [self isEqualToList:(KxList *)other];
}

- (BOOL) isEqualToList: (KxList *) other
{
    if (self == other)
		return YES;
    
    KxList * l = self;
    KxList * r = other;
    
    while(l && r) {
        
        if (![l->_head isEqual:r->_head])
            return NO;
        
        l = l->_tail;
        r = r->_tail;        
    } 
    
    //    return (l == nil) && (r == nil); 
    return  l == r; // true only if l is nil and r is nil
}

- (NSUInteger) hash 
{   
    return [[self toArray] hash];
}

- (BOOL) contains: (id) elem
{
    KxList * p = self;    
    while (p) {
        if ([p->_head isEqualTo:elem])
            return YES;
        p = p->_tail;
    }
    return NO;
}

- (KxList *) cons: (id)x
{
    KxList *l = [[KxList alloc] initWithHead:x andTail:self];
    return KX_AUTORELEASE(l);
}

- (KxList *) concat: (KxList *)xs
{
    KxList * result = self;    
    KxList * p = [xs reverse];
    
    while (p) {
        result = [KxList head: p->_head tail: result];
        p = p->_tail;
    }
    
    return result;
}

- (KxList *) reverse 
{
    KxList * result = nil;    
    KxList * p = self;
    
    while (p) {    
        result = [KxList head: p->_head tail: result];
        p = p->_tail;
    }
    
    return result;
}

- (KxList *) take: (NSInteger) n
{
    NSMutableArray *b = [NSMutableArray array];
    
    KxList * p = self;
        
    while (p && n) {    
        [b addObject:p->_head];
        p = p->_tail;
        --n;
    }
    
    return [KxList fromArray:b];
}

- (KxList *) drop: (NSInteger) n
{    
    KxList * p = self;
    
    while (p && n) {
        p = p->_tail;
        --n;
    }
    
    return p;
}

- (KxList *) sorted 
{
	return [KxList fromArray: [[self toArray] sortedArrayUsingSelector:@selector(compare:)]];
}

- (KxList*) sortWith: (NSComparator) block
{
    return [KxList fromArray: [[self toArray] sortedArrayUsingComparator:block]];
}

- (void) each: (void(^)(id elem)) block
{
    KxList * p = self;
    while (p) {      
        block([p head]);
        p = p->_tail;
    }
}

- (KxList *) map: (id (^)(id elem)) block
{        
    NSMutableArray *b = [NSMutableArray array];
    KxList * p = self;
    
    while (p) {
        [b addObject: block(p->_head)];
        p = p->_tail;
    }

    return [KxList fromArray:b];
}


- (KxList *) flatMap: (id (^)(id elem)) block
{
    NSMutableArray *b = [NSMutableArray array];
    
    KxList * p = self;
    
    while (p) {
        
        id r = block(p->_head);
        
        if (r) {
            /*
            if ([r isKindOfClass:[NSArray class]]) {
                
                [b addObjectsFromArray:r];
            }
            else if ([r isKindOfClass:[KxList class]]) {
                
                [b addObjectsFromArray:[r toArray]];
            }
            else if ([r respondsToSelector:@selector(objectEnumerator:)]) {
                
                NSEnumerator *enumerator = [r objectEnumerator];
                id i;
                while ((i = [enumerator nextObject]))
                    [b addObject:i];
            }
            else {
                [b addObject:r];
            }
             */
            [b appendFlat:r];
        }
        
        p = p->_tail;
    }
    
    return [KxList fromArray:b];
}


- (id) reduce: (id (^)(id acc, id elem)) block
{  
    return [self.tail  fold: _head with: block];
}

- (id) reduceRight: (id (^)(id elem, id acc)) block
{
    return [[self reverse] reduce: (id)^(id acc, id elem) {
        block(elem, acc);
    }];
}

- (id) fold: (id) start with: (id (^)(id acc, id elem)) block
{
    KxList * p = self;    
    id acc = start;
    
    while (p) {
        acc = block(acc, p->_head);    
        p = p->_tail;
    }
    
    return acc;
}


- (id) foldRight: (id) start with: (id (^)(id elem, id acc)) block
{
    return [[self reverse] fold: start with: (id)^(id acc, id elem) {
        block(elem, acc);
    }];    
}


- (KxList *) filter: (BOOL(^)(id elem)) block 
{
    NSMutableArray *b = [NSMutableArray array];    
    KxList * p = self;
    
    while (p) {
        if (block(p->_head))
            [b addObject:p->_head];
        p = p->_tail;
    }
    
    return [KxList fromArray:b];
}

- (KxList *) filterNot: (BOOL(^)(id elem)) block
{
    return [self filter: ^(id elem){ return (BOOL)!block(elem); }];
}

- (id) find: (BOOL(^)(id elem)) block 
{
    KxList * p = self;
    
    while (p) {
        if (block(p->_head))
            return p->_head;
        p = p->_tail;
    }
    
    return nil;
}

- (BOOL) exists: (BOOL(^)(id elem)) block 
{
    return [self find: block] != nil;
}

- (KxList *) zip: (KxList *) other
{    
    NSMutableArray * b = [NSMutableArray array];        
    KxList *l = self;
    KxList *r = other;    
    
    while (l && r) {
        [b addObject: [KxTuple2 first: l->_head
                               second: r->_head]];
        l = l->_tail;
        r = r->_tail;        
    }
    
    return [KxList fromArray:b];
}

- (KxTuple2 *) unzip
{
    NSMutableArray * l = [NSMutableArray array];
    NSMutableArray * r = [NSMutableArray array];        
    KxList * p = self;
    
    while (p) {        
        KxTuple2 * t = p->_head;
        [l addObject:t.first];
        [r addObject:t.second];
        p = p->_tail;
    }   
    
    return KxUtils.tuple([KxList fromArray:l], [KxList fromArray:r]);
}

- (NSString *) mkString
{
    return [[self toArray] componentsJoinedByString:@""];
}

- (NSString *) mkString:(NSString *)separator
{
    return [[self toArray] componentsJoinedByString:separator];    
}

- (NSArray *) toArray
{
    NSMutableArray * b = [NSMutableArray array];    
    KxList * p = self;
    
    while (p) {      
        [b addObject:p->_head];        
        p = p->_tail;
    }
    
    return [NSArray arrayWithArray:b];
}


- (NSString *) description
{   
    return [[self toArray] description];
}

- (NSUInteger) countByEnumeratingWithState: (NSFastEnumerationState *)state 
                                   objects:(id KX_UNSAFE_UNRETAINED [])stackbuf 
                                     count:(NSUInteger)len
{
    NSUInteger count = 0;
    KX_UNSAFE_UNRETAINED KxList * p;
    
    if (!state->state)
    {
        state->mutationsPtr = &state->extra[0];
        state->state = 1;
        p = self;
    }
    else 
    {
    #if __has_feature(objc_arc)
        void * pp = (void *)state->extra[1];    
        p = (__bridge KxList *)pp;
    #else
        p = (KxList *)state->extra[1];    
    #endif
    }
     
    if (p)
    {        
        while (p && (count < len))
        {
            stackbuf[count] = p->_head;
            p = p ->_tail;
            count++;
        }
        
        state->itemsPtr = stackbuf;
        state->extra[1] = (unsigned long)p;        
    }
   
    return count;
}


#pragma mark - NSCoding

- (id) initWithCoder: (NSCoder*)coder
{
	if ([coder versionForClassName: [self className]] != 0)
	{ 
		KX_RELEASE(self);
		return nil;
	}

   // [self release];
   // self = [KxList fromArray: [[NSArray alloc] initWithCoder: coder]];    
    
    if ([coder allowsKeyedCoding])
	{
		_head  = KX_RETAIN([coder decodeObjectForKey: @"head"]);        
		_tail  = KX_RETAIN([KxList fromArray: [coder decodeObjectForKey: @"tail"]]);
	}
	else
	{
		_head  = KX_RETAIN([coder decodeObject]);        
		_tail  = KX_RETAIN([KxList fromArray: [coder decodeObject]]);
	}
    
    return self;

}

- (void) encodeWithCoder: (NSCoder*)coder
{

    if ([coder allowsKeyedCoding])
	{
        [coder encodeObject:_head  forKey:@"head"];
        [coder encodeObject:[_tail toArray] forKey:@"tail"];
	}
	else
	{
        [coder encodeObject:_head];
        [coder encodeObject:[_tail toArray]];
    }    
    
//    [[self toArray] encodeWithCoder: coder];
}



@end
