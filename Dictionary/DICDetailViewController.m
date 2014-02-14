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
    // Set the scrollview's frame to be beneath the nav bar and occupying the rest of the view
    self.scrollView.frame = CGRectMake(0.0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);
    
    // Super annoying bug where dictionary header
    // doesn't appear on device but does on IB
    // and vice versa
    // Manually set the frame for the definitions header
//    self.definitionsHeaderLabel.frame = CGRectMake(15.0, self.navigationController.navigationBar.frame.size.height + 45.0, 100.0f, 30.0f);
    
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
        [self requestDataForWord:self.selectedWord];
        self.indicatorView.alpha = 1.0f;
        self.title = self.selectedWord;
        self.definitionsContent.text = @"";
    }
}

#pragma mark - Request data

- (void)requestDataForWord:(NSString *)word
{
    // Set up and start rotating spinner
    [self.indicatorView startAnimating];
    self.indicatorView.opaque = YES;
    self.indicatorView.hidesWhenStopped = YES;
    
    self.isDictionaryLoaded = [NSNumber numberWithBool:NO];
    
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
                            NSLog(@"thesarray %@", thesArray);
                            [self.indicatorView stopAnimating];
                            
                            [self displayThesaurus:thesArray];
                            [self displayDefinitions:definitionsList];

                            
                        });
                    }
                    
                }];
            });
        }
        
    }];


    
}

- (void)displayDefinitions:(NSMutableArray *)array
{
    if ([self.definitionsContent.text isEqualToString:@""]) {
        // The dictionary has loaded first
        NSLog(@"the dict loaded first");
        self.definitionsContent.text = @"";
        for (int i = 0; i < array.count; i++) {
            // NOTE: We increase the counter by one within the string
            array[i] = [[NSString stringWithFormat:@"%d. ", i+1] stringByAppendingString:array[i]];
            array[i] = [array[i] stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
            self.definitionsContent.text = [[self.definitionsContent.text stringByAppendingString:@"\n" ] stringByAppendingString:  array[i]];
        }
//        [self textViewDidChange:self.definitionsContent];
        
    } else {
        // There is already thesaurus data
        NSLog(@"thes first");
        NSString *currentContents = self.definitionsContent.text;
        NSString *dictContents = [[NSString alloc]init];
        for (int i = 0; i < array.count; i++) {
            // NOTE: We increase the counter by one within the string
            array[i] = [[NSString stringWithFormat:@"%d. ", i+1] stringByAppendingString:array[i]];
            array[i] = [array[i] stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
            dictContents = [dictContents stringByAppendingString:[NSString stringWithFormat:@"%@\n", array[i]]];
        }
        self.definitionsContent.text = dictContents;
//        [self textViewDidChange:self.definitionsContent];
        
    }
    
    /*
     Relocate labels, views, etc
     */
    [self.definitionsContent sizeToFit];
    [self.synonymsContent sizeToFit];
    
    // Move the definition content up
    CGRect tC = self.definitionsContent.frame;
    tC.origin.y = self.definitionsHeaderLabel.frame.origin.y + self.definitionsHeaderLabel.frame.size.height;
    self.definitionsContent.frame = tC;
    
    // Move the synonyms header label down
    CGRect tH = self.synonymsHeaderLabel.frame;
    tH.origin.y = self.definitionsContent.frame.size.height + self.definitionsContent.frame.origin.y + 30.0f;
    self.synonymsHeaderLabel.frame = tH;
    
    // Move the synonyms content label down
    CGRect temp = self.synonymsContent.frame;
    temp.origin.y = self.synonymsHeaderLabel.frame.origin.y + self.synonymsHeaderLabel.frame.size.height;
    self.synonymsContent.frame = temp;
    
    // Set content size
    NSLog(@"VARLUELUE %f", self.definitionsContent.frame.size.height + self.synonymsContent.frame.origin.y + self.synonymsContent.frame.size.height + 30.0f);
    CGSize scrollableSize = CGSizeMake(self.view.frame.size.width, 1200.0f);
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 2200.0f)];
    
    NSLog(@"contents are %@", self.definitionsContent.text);
//    [self textViewDidChange:self.definitionsContent];


}

- (void)relocateTextViews
{
//    //    CGFloat fixedWidth = textView.frame.size.width;
//    //    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT+500.0)];
//    //    CGRect newFrame = textView.frame;
//    //    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
//    //    textView.frame = newFrame;
//    //CGSize size = [textView sizeToFit];
    
   
    
}

- (void)displayThesaurus:(NSMutableArray *)array
{
    NSLog(@"array %@ %@", array, array[0]);
    if ([array[0] isKindOfClass:[NSString class]]) {
        NSLog(@"No synonyms found");
        self.synonymsContent.text = [self.definitionsContent.text stringByAppendingString:@"No synonyms found."];
    } else {
        // The dictionary data has not yet loaded,
        // i.e. the thesaurus loaded first
        NSString *midString = @"";
        // Merge with displayDefinitions
        
        // The first element of the correct array is another array
        
        // TODO: WHAT HAPPENS IF IT'S GOT MULTIPLE SYNONYM VERSIONS
        // EG: noun, verb, adjective ???
        
        NSArray *arrayOfSynonyms = [NSArray arrayWithArray:array[0]];
        

        for (int i = 0; i < arrayOfSynonyms.count; i++) {
            midString = [midString stringByAppendingString:[NSString stringWithFormat:@"%@, ", arrayOfSynonyms[i]]];
            
            
        }
        self.synonymsContent.text = midString;
//        [self textViewDidChange:self.synonymsContent];
    }

}

- (void)textViewDidChange:(UITextView *)textView
{
    // As of 14/12/13 1:35pm, not having this code makes the
    // text view work properly i.e. it doesn't cut off any
    // of the text and it scrolls fine
    
    // -------
//    NSLog(@"tvch");
//    CGFloat fixedWidth = textView.frame.size.width;
//    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT+500.0)];
//    CGRect newFrame = textView.frame;
//    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
//    textView.frame = newFrame;
    //CGSize size = [textView sizeToFit];
    
}


@end
