//
//  DICRecentWordsTableViewController.h
//  Dictum
//
//  Created by Matthew Palmer on 25/03/2014.
//  Copyright (c) 2014 Matthew Palmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DICPlist.h"

@interface DICRecentWordsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) NSArray *recentWords;

@end
