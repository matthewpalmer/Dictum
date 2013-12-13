//
//  DICRequestData.m
//  Dictionary
//
//  Created by Matthew Palmer on 20/11/2013.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import "DICRequestData.h"

@implementation DICRequestData
- (NSURL *)convertPhraseToURLForDictionary:(NSString *)phrase
{
    NSString *baseString = @"http://glosbe.com/gapi/translate?from=eng&dest=eng&format=json&phrase=";
    NSString *finalString = [baseString stringByAppendingString:phrase];
    NSURL *url = [[NSURL alloc]initWithString:finalString];
    return url;
}

- (NSURL *)convertPhraseToURLForThesaurus:(NSString *)phrase
{
    // http://words.bighugelabs.com/api/2/ba66939ce88a48af935149cbda8936e0/word/json
    NSString *str = [NSString stringWithFormat:@"http://words.bighugelabs.com/api/2/ba66939ce88a48af935149cbda8936e0/%@/json", phrase];
    NSLog(@"%@", str);
    NSURL *url = [[NSURL alloc]initWithString:str];
    return url;
}

- (void)requestThesaurusDataForWord:(NSString *)word completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))block
{
    NSURL *url = [self convertPhraseToURLForThesaurus:word];
    NSURLRequest *req = [[NSURLRequest alloc]initWithURL:url];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:queue
                           completionHandler:block];
}

- (void)requestDictionaryDataForWord:(NSString *)word completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))block
{
    NSURL *url = [self convertPhraseToURLForDictionary:word];
    NSURLRequest *req = [[NSURLRequest alloc]initWithURL:url];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:queue
                           completionHandler:block];
}
@end
