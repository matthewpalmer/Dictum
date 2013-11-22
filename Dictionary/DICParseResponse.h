//
//  DICParseResponse.h
//  Dictionary
//
//  Created by Matthew Palmer on 20/11/2013.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DICParseResponse : NSObject
- (NSDictionary *)parseResponseData:(NSData *)data;
@end
