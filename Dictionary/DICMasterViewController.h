//
//  DICMasterViewController.h
//  Dictionary
//
//  Created by Matthew Palmer on 20/11/2013.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DICDetailViewController;

@interface DICMasterViewController : UITableViewController

@property (strong, nonatomic) DICDetailViewController *detailViewController;

@end
