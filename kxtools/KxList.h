//
//  ru.kolyvan.repo
//  https://github.com/kolyvan
//  

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import <Foundation/Foundation.h>
#import "KxArc.h"

@interface KxList : NSObject<NSCopying, NSCoding, NSFastEnumeration> {
    id _head;
    KxList * _tail;    
@private
}

@property (readonly, nonatomic, KX_PROP_STRONG) id head;
@property (readonly, nonatomic, KX_PROP_STRONG) KxList * tail;

- (NSInteger) count;
- (id) last; 
- (KxList *) butlast;

+ (KxList *) head: (id)x tail: (KxList *) xs;
+ (KxList *) list: (id) head, ... NS_REQUIRES_NIL_TERMINATION;
+ (KxList *) fromArray: (NSArray *) array;
+ (KxList *) rangeFrom: (NSInteger) start until: (NSInteger) end step: (NSInteger) step;
+ (KxList *) fill: (NSInteger) n block: (id(^)()) block;

- (id) initWithHead: (id)x andTail: (KxList *) xs;

- (NSEnumerator *) objectEnumerator;
- (NSEnumerator *) reverseObjectEnumerator;

- (BOOL) isEqualToList: (KxList *) other;
- (BOOL) contains: (id) elem;

- (KxList *) cons: (id)x;
- (KxList *) concat: (KxList *)xs;

- (KxList *) reverse;

- (KxList *) take: (NSInteger) n;
- (KxList *) drop: (NSInteger) n;

- (KxList *) sorted;
- (KxList*) sortWith: (NSComparator) block;

- (void) each: (void(^)(id elem)) block;
- (KxList *) map: (id (^)(id elem)) block;
- (KxList *) flatMap: (id (^)(id elem)) block;
- (id) reduce: (id (^)(id acc, id elem)) block;
- (id) fold: (id) start with: (id (^)(id acc, id elem)) block;
- (id) reduceRight: (id (^)(id acc, id elem)) block;
- (id) foldRight: (id) start with: (id (^)(id elem, id acc)) block;
- (KxList *) filter: (BOOL(^)(id elem)) block;
- (KxList *) filterNot: (BOOL(^)(id elem)) block;
- (id) find: (BOOL(^)(id elem)) block;
- (BOOL) exists: (BOOL(^)(id elem)) block;

- (KxList *) zip: (KxList *) other; 
- (KxList *) unzip;

- (NSString *) mkString;
- (NSString *) mkString:(NSString *)separator; 

- (NSArray *) toArray;

@end


