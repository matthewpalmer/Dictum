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
    return dict;
}

// Highly specific method that works solely for this API:
// http://glosbe.com/a-api
- (NSMutableArray *)formatDataToDefinitions:(NSDictionary *)dict
{
    // Get the definitions from the response object from the API
    // Very dirty and specific parsing
    // Todo: write tests for this
    NSArray *v = [[[dict valueForKey:@"tuc"] valueForKey:@"meanings"]valueForKey:@"text"];
    NSMutableArray *defns = [NSMutableArray arrayWithArray:v[0]];
    return defns;
}
@end
