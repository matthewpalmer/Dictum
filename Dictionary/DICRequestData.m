//
//  DICRequestData.m
//  Dictionary
//
//  Created by Matthew Palmer on 20/11/2013.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import "DICRequestData.h"

@implementation DICRequestData
- (NSURL *)convertPhraseToURL:(NSString *)phrase
{
    NSString *baseString = @"http://glosbe.com/gapi/translate?from=eng&dest=eng&format=json&phrase=";
    NSString *finalString = [baseString stringByAppendingString:phrase];
    NSURL *url = [[NSURL alloc]initWithString:finalString];
    return url;
}

- (void)requestDataForURL:(NSURL *)url completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))block
{
    NSURLRequest *req = [[NSURLRequest alloc]initWithURL:url];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:queue
                           completionHandler:block];
}
@end
