//
//  DICDetailViewController.h
//  Dictionary
//
//  Created by Matthew Palmer on 20/11/2013.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "DICRequestData.h"
#import "DICParseResponse.h"

@interface DICDetailViewController : UIViewController <UISplitViewControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSString *selectedWord;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) IBOutlet UITextView *definitionTextView;
@property (strong, nonatomic) IBOutlet UITextView *thesaurusTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *definitionsHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *synonymsHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *definitionsContent;
@property (strong, nonatomic) IBOutlet UILabel *synonymsContent;
@property (strong, nonatomic) IBOutlet UIView *view;

@property (strong, nonatomic) NSNumber *isDictionaryLoaded;


- (void)iPadSelectedWord;
- (void)requestDataForWord:(NSString *)word completion:(void (^) (NSMutableArray *arrayOfDefinitions))block;
- (void)displayDefinitions:(NSMutableArray *)array;
- (void)displayThesaurus:(NSMutableArray *)array;
- (void)relocateTextViews;
@end
