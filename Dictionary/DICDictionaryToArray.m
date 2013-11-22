//
//  DICDictionaryToArray.m
//  Dictionary
//
//  Created by Matthew Palmer on 22/11/2013.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import "DICDictionaryToArray.h"

@implementation DICDictionaryToArray
- (NSMutableArray *)convertDictionaryToArray:(NSDictionary *)dict
{
    NSMutableArray *ar = [[NSMutableArray alloc]init];
    NSString *dummy = @"dum";
    for (id item in dict) {
//        NSLog(@"item is %@ %@", item, [dict valueForKey:item]);
        [ar addObject:item];
        
    }
    return ar;
}
@end
