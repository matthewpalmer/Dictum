//
//  DICParseResponse.m
//  Dictionary
//
//  Created by Matthew Palmer on 20/11/2013.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import "DICParseResponse.h"

@implementation DICParseResponse
- (NSDictionary *)parseResponseData:(NSData *)data
{
//    NSString *stringFromData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    NSLog(@"dict is %@", dict);
    return dict;
}
@end
