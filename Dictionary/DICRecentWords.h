//
//  DICRecentWords.h
//  Dictum
//
//  Created by Matthew Palmer on 25/03/2014.
//  Copyright (c) 2014 Matthew Palmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DICPlist.h"
@interface DICRecentWords : NSObject

- (NSArray *) loadRecentWords;
- (void) addWord:(NSString *)word;

@end
