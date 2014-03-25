//
//  DICPlist.h
//  Dictionary
//
//  Created by Matthew Palmer on 22/11/2013.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DICPlist : NSObject
- (NSArray *)loadSystemPlistAtFilename:(NSString *)filename;
- (void)saveUserPlistAtFilename:(NSString *)filename withArray:(NSArray *)array;
- (NSArray *)loadUserPlistAtFilename:(NSString *)filename;
- (void)appendStringToUserPlistAtFilename:(NSString *)filename withString:(NSString *)string;
- (void)prependStringToUserPlistAtFilename:(NSString *)filename withString:(NSString *)string;
@end
