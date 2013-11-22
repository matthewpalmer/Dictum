//
//  DICMasterViewController.m
//  Dictionary
//
//  Created by Matthew Palmer on 20/11/2013.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import "DICMasterViewController.h"

#import "DICDetailViewController.h"

@interface DICMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation DICMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DICDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // $Search
    // Set up some sample data
    NSArray *ar = [[NSArray alloc]initWithObjects: @{@"name": @"matt"}, @{@"name": @"max"}, @{@"name": @"meg"} , nil];
    
    [self setMasterContent:[NSArray arrayWithArray:ar]];
    
    self.searchResults = [NSMutableArray arrayWithCapacity:self.masterContent.count];
    
    
    
    
//    DICRequestData *rd = [[DICRequestData alloc]init];
//    // - (void)requestDataForURL:(NSURL *)url completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))block
//    [rd requestDataForURL:[NSURL URLWithString:@"http://glosbe.com/gapi/translate?from=eng&dest=eng&format=json&phrase=car"]
//        completionHandler:^void (NSURLResponse *res, NSData *data, NSError *err) {
//            NSLog(@"WITHIN %@", data);
//            NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", str);
//        }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // If requested table view is for search, return the count of the filtered search list
    // Else return the master list count
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResults.count;
        
    } else {
        return self.masterContent.count;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSObject *item;
    
    // If requested table view is for search, return the item from filtered search list
    // Else return the master list item
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        item = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        item = [self.masterContent objectAtIndex:indexPath.row];
    }

    cell.detailTextLabel.text = @"this is a detail label";
    cell.textLabel.text = [item valueForKey:@"name"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

/*
// Hide the search bar until the user swipes up
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
}
*/

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
        
    } else if ([segue.identifier isEqualToString:@"pushDetailView"]) {
        NSLog(@"Push detail view segue");
        // Sender is the table view
        NSArray *sourceArray;
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:(UITableViewCell *)sender];
        
        if (indexPath != nil) {
            sourceArray = self.searchResults;
            
        } else {
            indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
            sourceArray = self.masterContent;
        }
        
        UIViewController *destinationController = segue.destinationViewController;
        NSObject *obj = sourceArray[indexPath.row];
        destinationController.title = [obj valueForKey:@"name"];
        
    }
}

#pragma mark - Content Filtering

- (void)updateFilteredContentForProductName:(NSString *)productName type:(NSString *)typeName
{
    // Update the search results array based on the search input
    
    // If there is no search input, recreate the master array
    if ((productName == nil) || productName.length == 0) {
        // Possible error in the dot notation on mutableCopy
        self.searchResults = self.masterContent.mutableCopy;
        return;
        
    }
    
    // There is search input
    // Clear the search array
    [self.searchResults removeAllObjects];
    
    // Search the master list for matching items
    // When they match, add them to the search results array
    for (NSObject *item in self.masterContent) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange nameRange = NSMakeRange(0, [[item valueForKey:@"name"]length]);
        NSRange foundRange = [[item valueForKey:@"name"]rangeOfString:productName options:searchOptions range:nameRange];
        
        //Add item to the search results
        if (foundRange.length > 0) {
            [self.searchResults addObject:item];
        }
    }
    
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Probably shouldn't be nil
    [self updateFilteredContentForProductName:searchString type:nil];
    
    // Return yes to cause table view to reload
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSString *searchString = self.searchDisplayController.searchBar.text;
    [self updateFilteredContentForProductName:searchString type:nil];
    return YES;
}

@end
