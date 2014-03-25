//
//  DICRecentWords.m
//  Dictum
//
//  Created by Matthew Palmer on 25/03/2014.
//  Copyright (c) 2014 Matthew Palmer. All rights reserved.
//

#import "DICRecentWords.h"

@implementation DICRecentWords


- (NSArray *) loadRecentWords {
    DICPlist *loader = [[DICPlist alloc]init];
    return [loader loadUserPlistAtFilename:@"recentWords.plist"];
}

- (void) addWord:(NSString *)word {
    DICPlist *plister = [[DICPlist alloc]init];
//    NSArray *currentList = [plister loadUserPlistAtFilename:@"recentWords.plist"];
    // Todo: Check that the new word is not already in the recent words list.
    //       If it is, move the word to the top of the list.
//    NSMutableArray *newList = [[NSMutableArray alloc]initWithArray:currentList];
//    [newList addObject:word];
    [plister prependStringToUserPlistAtFilename:@"recentWords.plist" withString:word];
}
@end
