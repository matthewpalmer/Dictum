//
//  DICLoadPlist.m
//  Dictionary
//
//  Created by Matthew Palmer on 22/11/2013.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import "DICLoadPlist.h"

@implementation DICLoadPlist
- (NSDictionary *)loadPlistAtFilename:(NSString *)string
{
/*    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *plistfile = [[paths objectAtIndex:0]stringByAppendingPathComponent:string];
    NSLog(@"plistfile %@", paths);
    NSDictionary *plist = [[NSMutableDictionary alloc]initWithContentsOfFile:plistfile];
    return plist;
 */
    NSString *path = [[NSBundle mainBundle]bundlePath];
    NSLog(@"path %@", path);
    NSString *middlePath = [path stringByAppendingString:@"/"];
    NSLog(@"middlePath %@", middlePath);
    NSString *finalPath = [middlePath stringByAppendingString:string];
    NSLog(@"finalPath %@", finalPath);
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    return plist;
}
@end
