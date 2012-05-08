//
//  ru.kolyvan.repo
//  https://github.com/kolyvan
//  

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import <Foundation/Foundation.h>

@class KxTuple2;

@interface NSArray (Kolyvan)

@property(nonatomic,readonly,getter=isEmpty) BOOL isEmpty;
@property(nonatomic,readonly,getter=nonEmpty) BOOL nonEmpty;
@property(nonatomic,readonly) id first;
@property(nonatomic,readonly) id second;
@property(nonatomic,readonly) id last;
@property(nonatomic,readonly) NSUInteger count;

- (BOOL) isEmpty; 
- (BOOL) nonEmpty;

- (id) first;
- (id) second; 
- (id) last;

- (NSArray *) tail;
- (NSArray *) take: (NSInteger) n;
- (NSArray *) drop: (NSInteger) n;

- (NSArray*) sorted;
- (NSArray*) sortWith: (NSComparator) block;

- (NSArray *) reverse;

- (NSArray *) map: (id (^)(id elem)) block;
- (NSArray *) flatMap: (id (^)(id elem)) block;
- (void) each: (void (^)(id elem)) block;
- (id) reduce: (id (^)(id acc, id elem)) block; // reduceLeft
- (id) fold: (id) start with: (id (^)(id acc, id elem)) block; // foldLeft
- (id) reduceRight: (id (^)(id acc, id elem)) block;
- (id) foldRight: (id) start with: (id (^)(id elem, id acc)) block;
- (NSArray *) filter: (BOOL(^)(id elem)) block;
- (NSArray *) filterNot: (BOOL(^)(id elem)) block;
- (id) find: (BOOL(^)(id elem)) block;
- (BOOL) exists: (BOOL(^)(id elem)) block;

- (NSString *) mkString;
- (NSString *) mkString:(NSString *)separator; 

- (NSArray *) zip: (NSArray *) other; 
- (NSArray *) zipWithIndex;
- (KxTuple2 *) unzip;

+ (NSArray *) rangeFrom: (NSInteger)start until: (NSInteger)end step: (NSInteger)step;
+ (NSArray *) fill: (NSInteger)n block: (id(^)()) block;

- (NSArray *) toArray;

@end



@interface NSMutableArray (Kolyvan)

- (void) append:(id)first, ... NS_REQUIRES_NIL_TERMINATION;
- (void) appendAll:(NSArray *)xs;
- (void) appendFlat: (id) obj;

- (void) push:(id) object;
- (id) pop;

@end