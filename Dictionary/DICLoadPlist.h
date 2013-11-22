//
//  DICLoadPlist.h
//  Dictionary
//
//  Created by Matthew Palmer on 22/11/2013.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DICLoadPlist : NSObject
- (NSArray *)loadPlistAtFilename:(NSString *)string;
@end
