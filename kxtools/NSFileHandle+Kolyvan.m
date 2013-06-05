//
//  NSFileHandle+Kolyvan.m
//  kxtools
//
//  Created by Kolyvan on 05.06.13.
//
//

#import "NSFileHandle+Kolyvan.h"

@implementation NSFileHandle (Kolyvan)

+ (NSFileHandle *) createFileAtPath:(NSString *)path
                          overwrite:(BOOL) overwrite
                              error:(NSError **)outError
{
    NSFileManager *fm = [[NSFileManager alloc] init];
    
    if ([fm fileExistsAtPath:path]) {
        
        if (overwrite) {
            
            if (![fm removeItemAtPath:path error:outError]) {
                return nil;
            }
            
        } else {            
            return nil;
        }
    }
    
    NSString *folder = path.stringByDeletingLastPathComponent;
    
    if (![fm fileExistsAtPath:folder] &&
        ![fm createDirectoryAtPath:folder
       withIntermediateDirectories:YES
                        attributes:nil
                             error:outError]) {
            return nil;
        }
    
    if (![fm createFileAtPath:path
                     contents:nil
                   attributes:nil]) {
        return nil;
    }
    
    return [NSFileHandle fileHandleForWritingToURL:[NSURL fileURLWithPath:path]
                                             error:outError];
}

- (void) writeString:(NSString *)s
{
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    [self writeData:data];
}

- (void) writeFormat:(NSString *)fmt, ... NS_FORMAT_FUNCTION(1,2)
{
    va_list args;
    va_start(args, fmt);
    NSString * s = [[NSString alloc] initWithFormat:fmt arguments:args];
    va_end(args);
    
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    [self writeData:data];
}

@end
