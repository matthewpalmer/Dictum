//
//  DICRequestData.h
//  Dictionary
//
//  Created by Matthew Palmer on 20/11/2013.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DICRequestData : NSObject
- (void)requestDataForURL:(NSURL *)url completionHandler:(void (^)(NSURLResponse *res, NSData *data, NSError *error))block;
- (NSURL *)convertPhraseToURL:(NSString *)phrase;
@end
