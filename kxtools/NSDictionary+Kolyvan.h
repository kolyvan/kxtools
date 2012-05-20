//
//  ru.kolyvan.repo
//  https://github.com/kolyvan
//  

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import <Foundation/Foundation.h>


@interface NSDictionary (Kolyvan)

@property(nonatomic,readonly,getter=isEmpty) BOOL isEmpty;
@property(nonatomic,readonly,getter=nonEmpty) BOOL nonEmpty;

- (BOOL) isEmpty; 
- (BOOL) nonEmpty;

- (BOOL) contains:(id)key; 

- (id) get:(id)key; 
- (id) get:(id)key orElse:(id) defaultObject; 

- (void) each: (void (^)(id key, id obj)) block;
- (NSDictionary *) map: (id (^)(id key, id elem)) block;

//- (NSDictionary *) flatMap: (id (^)(id key, id elem)) block;
//- (NSDictionary *) filter: (BOOL(^)(id key, id elem)) block;
//- (NSDictionary *) filterNot: (BOOL(^)(id key, id elem)) block;
//- (id) fold:(id) start with:(id (^)(id acc, id key, id elem)) block;

- (NSArray *) toArray;


@end


@interface NSMutableDictionary (Kolyvan)

- (void) toggle:(id) key value: (id) value;
- (void) update:(id) key value: (id) value;
- (void) updateSafe:(id) key value: (id) value;
- (void) updateOnly:(id) key valueNotNil: (id) value;
- (void) updateOnce:(id) key with: (id (^)()) block;

- (id) get:(id)key orSet:(id (^)()) block; 

@end


