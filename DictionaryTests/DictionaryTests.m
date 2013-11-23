//
//  DictionaryTests.m
//  DictionaryTests
//
//  Created by Matthew Palmer on 20/11/2013.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DICRequestData.h"
#import "DICLoadPlist.h"
#import "DICParseResponse.h"

@interface DictionaryTests : XCTestCase

@end

@implementation DictionaryTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// - (NSURL *)convertPhraseToURL:(NSString *)phrase
- (void)testConvertPhraseToURL
{
    DICRequestData *phraseToURLRD = [[DICRequestData alloc]init];
    NSURL *testedURL = [phraseToURLRD convertPhraseToURL:@"car"];
    NSURL *properURL = [NSURL URLWithString:@"http://glosbe.com/gapi/translate?from=eng&dest=eng&format=json&phrase=car"];
    XCTAssertEqualObjects(testedURL, properURL, @"%s: %@, %@", __PRETTY_FUNCTION__, testedURL, properURL);
}
- (void)testLoadPlist
{
    DICLoadPlist *loadPlist = [[DICLoadPlist alloc]init];
    NSDictionary *dict = [loadPlist loadPlistAtFilename:@"wordsList.plist"];
    NSLog(@"test dict %@", dict);
    XCTAssertTrue(dict, @"Dictionary from plist could not be found");
    
}

// - (void)requestDataForURL:(NSURL *)url completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))block
// Note: this test doesn't actually work.
- (void)testRequestData
{
    DICRequestData *rd = [[DICRequestData alloc]init];
    [rd requestDataForURL:[NSURL URLWithString:@"http://glosbe.com/gapi/translate?from=eng&dest=eng&format=json&phrase=car"]
        completionHandler:^void (NSURLResponse *res, NSData *data, NSError *err) {
            NSLog(@"in here %@ %@ %@", res, data, err);
            XCTAssertTrue(data, @"testrequestdata");
        }];
    

}

// Todo: find out how to test this
- (void)testFormatDictToArray
{
    DICParseResponse *parse = [[DICParseResponse alloc]init];
    

}

@end
