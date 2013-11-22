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
    NSDictionary *dict = [loadPlist loadPlistAtFilename:@"test.plist"];
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

- (void)testParseResponse
{

    NSString *str =  @"\"result\":\"ok\",\"authors\":{\"1\":{\"U\":\"http://en.wiktionary.org\",\"id\":1,\"N\":\"en.wiktionary.org\"},\"2\":{\"U\":\"http://pl.wiktionary.org\",\"id\":2,\"N\":\"pl.wiktionary.org\"},\"5\":{\"U\":\"http://cs.wiktionary.org\",\"id\":5,\"N\":\"cs.wiktionary.org\"}},\"dest\":\"eng\",\"phrase\":\"car\",\"tuc\":[{\"authors\":[1],\"meaningId\":null,\"meanings\":[{\"text\":\"automobile, a vehicle steered by a driver\",\"language\":\"eng\"},{\"text\":\"railway carriage, a nonpowered unit in a railroad train\",\"language\":\"eng\"},{\"text\":\"passenger-carrying unit in a subway or elevated train, whether powered or not\",\"language\":\"eng\"},{\"text\":\"moving, load-carrying component of an elevator\",\"language\":\"eng\"},{\"text\":\"(uncountable, US) The aggregate of desirable characteristics of a car.\",\"language\":\"eng\"},{\"text\":\"(computing) The first part of a cons in LISP. The first element of a list.\",\"language\":\"eng\"},{\"text\":\"(dated) A wheeled vehicle, drawn by a horse or other animal\",\"language\":\"eng\"},{\"text\":\"A wheeled vehicle that moves independently, steered by a driver mostly for personal transportation; a motor car or automobile\",\"language\":\"eng\"},{\"text\":\"(rail transport, chiefly North America) An unpowered unit in a railroad train.\",\"language\":\"eng\"},{\"text\":\"(rail transport) an individual vehicle, powered or unpowered, in a multiple unit.\",\"language\":\"eng\"},{\"text\":\"(rail transport) A passenger-carrying unit in a subway or elevated train, whether powered or not.\",\"language\":\"eng\"},{\"text\":\"A rough unit of quantity approximating the amount which would fill a railroad car.\",\"language\":\"eng\"},{\"text\":\"The moving, load-carrying component of an elevator or other cable-drawn transport mechanism.\",\"language\":\"eng\"},{\"text\":\"The passenger-carrying portion of certain amusement park rides, such as Ferris wheels.\",\"language\":\"eng\"},{\"text\":\"The part of an airship, such as a balloon or dirigible, which houses the passengers and control apparatus.\",\"language\":\"eng\"},{\"text\":\"(sailing) A sliding fitting that runs along a track.\",\"language\":\"eng\"}]},{\"authors\":[2],\"meaningId\":null,\"meanings\":[{\"text\":\"A four-wheeled motor vehicle used for land transport, usually propelled by a gasoline or diesel internal combustion engine.\",\"language\":\"eng\"}],\"phrase\":{\"text\":\"automobile\",\"language\":\"eng\"}},{\"authors\":[2],\"meaningId\":null,\"phrase\":{\"text\":\"wagon\",\"language\":\"eng\"}},{\"authors\":[5],\"meaningId\":null,\"phrase\":{\"text\":\"cart\",\"language\":\"eng\"}}],\"from\":\"eng\"}";
    

    
    

}

@end
