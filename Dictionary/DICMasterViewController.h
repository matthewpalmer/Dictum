//
//  DICMasterViewController.h
//  Dictionary
//
//  Created by Matthew Palmer on 20/11/2013.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DICRequestData.h"
#import "DICLoadPlist.h"
#import "DICDictionaryToArray.h"

@class DICDetailViewController;

@interface DICMasterViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) DICDetailViewController *detailViewController;
// Default 'master list' of content
@property (strong, nonatomic) NSArray *masterContent;
// Array containing filtered results of search
@property (strong, nonatomic) NSMutableArray *searchResults;

@end
