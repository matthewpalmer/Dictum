//
//  DICDetailViewController.m
//  Dictionary
//
//  Created by Matthew Palmer on 20/11/2013.
//  Copyright (c) 2013 Matthew Palmer. All rights reserved.
//

#import "DICDetailViewController.h"

@interface DICDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DICDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSLog(@"iPad %@", self.selectedWord);
        return;
    } else {
        // iPhone
       [self requestDataForWord:self.selectedWord];
        self.navigationItem.title = self.selectedWord;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - weird iPad method
- (void)iPadSelectedWord
{
    NSLog(@"ipad selected word");
    if (self.selectedWord) {
        NSLog(@"selected word %@", self.selectedWord);
        [self requestDataForWord:self.selectedWord];
    }
}

#pragma mark - Request data

- (void)requestDataForWord:(NSString *)word
{
    // Set up and start rotating spinner
    [self.indicatorView startAnimating];
    self.indicatorView.hidesWhenStopped = YES;
    
    //Request data from dictionary API and then parse it to a dict
    DICRequestData *req = [[DICRequestData alloc]init];
    NSURL *urlToGet = [req convertPhraseToURL:word];
    [req requestDataForURL:urlToGet completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
        if (error || !data) {
            NSLog(@"there was an error %@", error);
            
            // UI work must be done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.indicatorView stopAnimating];
            });
        } else {
            DICParseResponse *parser = [[DICParseResponse alloc]init];
            NSDictionary *dict = [parser parseResponseData:data];
            NSMutableArray *definitionsList = [parser formatDataToDefinitions:dict];
            NSLog(@"array: %@", definitionsList);
            
            
            
            // UI work must be done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.indicatorView stopAnimating];
                [self displayDefinitions:definitionsList];
            });
        }
        
    }];
    
}

- (void)displayDefinitions:(NSMutableArray *)array
{
    for (int i = 0; i < array.count; i++) {
        NSLog(@"%d", i);
        // NOTE: We increase the counter by one within the string
        array[i] = [[NSString stringWithFormat:@"%d. ", i+1] stringByAppendingString:array[i]];
        array[i] = [array[i] stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
        NSLog(@"%@", array[i]);
        self.definitionTextView.text = [[self.definitionTextView.text stringByAppendingString:@"\n" ] stringByAppendingString:  array[i]];
    }
    
}
@end
