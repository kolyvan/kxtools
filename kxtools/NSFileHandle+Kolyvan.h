//
//  NSFileHandle+Kolyvan.h
//  kxtools
//
//  Created by Kolyvan on 05.06.13.
//
//

#import <Foundation/Foundation.h>

@interface NSFileHandle (Kolyvan)

+ (NSFileHandle *) createFileAtPath:(NSString *)path
                          overwrite:(BOOL) overwrite
                              error:(NSError **)outError;

- (void) writeString:(NSString *)s;
- (void) writeFormat:(NSString *)fmt, ... NS_FORMAT_FUNCTION(1,2);

@end
