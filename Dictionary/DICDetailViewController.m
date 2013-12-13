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
        self.indicatorView.alpha = 0.0f;
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
    barButtonItem.title = NSLocalizedString(@"Dictionary", @"Dictionary");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

#pragma mark - weird iPad method
- (void)iPadSelectedWord
{
    if (self.selectedWord) {
        [[self definitionTextView]setContentInset:UIEdgeInsetsMake(-5, 0, 5,0)];
        [self requestDataForWord:self.selectedWord];
        self.indicatorView.alpha = 1.0f;
        self.title = self.selectedWord;
        self.definitionTextView.text = @"";
    }
}

#pragma mark - Request data

- (void)requestDataForWord:(NSString *)word
{
    // Set up and start rotating spinner
    [self.indicatorView startAnimating];
    self.indicatorView.opaque = YES;
    self.indicatorView.hidesWhenStopped = YES;
    
    //Request data from dictionary API and then parse it to a dict
    DICRequestData *req = [[DICRequestData alloc]init];
    [req requestDictionaryDataForWord:word completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
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
            // UI work must be done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.indicatorView stopAnimating];
                [self displayDefinitions:definitionsList];
            });
        }
        
    }];
    
    // Request thesaurus data
    DICRequestData *thes = [[DICRequestData alloc]init];
    [thes requestThesaurusDataForWord:word completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
        if (error || !data) {
            NSLog(@"there was an error %@", error);
            
            // UI work must be done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.indicatorView stopAnimating];
            });
        } else {
            DICParseResponse *parseThes = [[DICParseResponse alloc]init];
            NSDictionary *thesDic = [parseThes parseResponseData:data];

            NSMutableArray *thesArray = [parseThes formatDataToThesaurus:thesDic];
            // UI work must be done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
             //[self.indicatorView stopAnimating];
                [self displayThesaurus:thesArray[0]];

             });
        }
        
    }];

    
}

- (void)displayDefinitions:(NSMutableArray *)array
{
    self.definitionTextView.text = @"";
    for (int i = 0; i < array.count; i++) {
        // NOTE: We increase the counter by one within the string
        array[i] = [[NSString stringWithFormat:@"%d. ", i+1] stringByAppendingString:array[i]];
        array[i] = [array[i] stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
        self.definitionTextView.text = [[self.definitionTextView.text stringByAppendingString:@"\n" ] stringByAppendingString:  array[i]];
    }
    
}

- (void)displayThesaurus:(NSMutableArray *)array
{
    NSString *midString = @"";
    // Merge with displayDefinitions
    self.thesaurusTextView.text = @"";
    for (int i = 0; i < array.count; i++) {
        midString = [midString stringByAppendingString:[NSString stringWithFormat:@"%@, ", array[i]]];
        
         
    }
    self.thesaurusTextView.frame = CGRectMake(0.0, self.definitionTextView.frame.size.height, self.view.frame.size.width, 150.0);
    self.thesaurusTextView.text = midString;
}


@end
