//
//  DICDetailViewController.h
//  Dictionary
//
//  Created by Matthew Palmer on 20/11/2013.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DICRequestData.h"
#import "DICParseResponse.h"

@interface DICDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSString *selectedWord;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) IBOutlet UITextView *definitionTextView;

- (void)iPadSelectedWord;
- (void)requestDataForWord:(NSString *)word completion:(void (^) (NSMutableArray *arrayOfDefinitions))block;
- (void)displayDefinitions:(NSMutableArray *)array;
@end
