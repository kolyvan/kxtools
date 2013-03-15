//
//  ru.kolyvan.kxtools
//  https://github.com/kolyvan/kxtools
//

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import <Foundation/Foundation.h>

@interface KxTuple2 : NSObject<NSCopying, NSCoding>

@property (nonatomic, readonly, strong) id first;
@property (nonatomic, readonly, strong) id second;

+ (KxTuple2 *) first:(id) first second:(id) second;
- (id) initWithFirst:(id) first andSecond:(id) second;

- (KxTuple2 *) swap;
- (BOOL) isEqualToTuple:(KxTuple2 *) other;

- (NSArray *) toArray;
- (NSDictionary *) toDictionary;

@end


@interface NSArray (KxTuple2)
- (KxTuple2 *) partition: (BOOL(^)(id elem)) block;
- (NSArray *) zip: (NSArray *) other;
- (NSArray *) zipWithIndex;
- (KxTuple2 *) unzip;
@end

@interface NSDictionary (KxTuple2)
- (NSArray *) toArray;
@end

@interface NSString (KxTuple2)
- (KxTuple2 *) splitAt:(NSInteger)position;
@end