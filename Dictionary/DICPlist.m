//
//  DICPlist.m
//  Dictionary
//
//  Created by Matthew Palmer on 22/11/2013.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import "DICPlist.h"

@implementation DICPlist
- (NSArray *)loadSystemPlistAtFilename:(NSString *)filename
{
/*    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *plistfile = [[paths objectAtIndex:0]stringByAppendingPathComponent:string];
    NSLog(@"plistfile %@", paths);
    NSDictionary *plist = [[NSMutableDictionary alloc]initWithContentsOfFile:plistfile];
    return plist;
 */
    NSString *path = [[NSBundle mainBundle]bundlePath];
    NSString *middlePath = [path stringByAppendingString:@"/"];
    NSString *finalPath = [middlePath stringByAppendingString:filename];
    NSArray *ar = [NSArray arrayWithContentsOfFile:finalPath];
    return ar;
}

- (NSArray *)loadUserPlistAtFilename:(NSString *)filename {
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:filename];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:destPath]) {
        // The file doesn't exist.
        NSLog(@"The file did not exist.");
    }
    
    NSArray *plistContents = [[NSArray alloc]initWithContentsOfFile:destPath];
    return plistContents;
}

- (void)saveUserPlistAtFilename:(NSString *)filename withArray:(NSArray *)array {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:filename];
    [array writeToFile:path atomically:YES];
}

- (void)appendStringToUserPlistAtFilename:(NSString *)filename withString:(NSString *)string {
    NSArray *oldContents = [self loadUserPlistAtFilename:filename];
    NSMutableArray *newContents = [[NSMutableArray alloc]initWithArray:oldContents];
    [newContents addObject:string];
    [self saveUserPlistAtFilename:filename withArray:newContents];
}

- (void)prependStringToUserPlistAtFilename:(NSString *)filename withString:(NSString *)string {
    NSArray *oldContents = [self loadUserPlistAtFilename:filename];
    NSMutableArray *newContents = [[NSMutableArray alloc]initWithObjects:string, nil];
    [newContents addObjectsFromArray:oldContents];
    NSLog(@"newContents %@ ", newContents);
    [self saveUserPlistAtFilename:filename withArray:newContents];
    
}
@end
