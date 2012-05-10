//
//  TLDViewController.m
//  TLDSlowCoreImage
//
//  Created by Patrick Gibson on 5/10/12.
//  Copyright (c) 2012 Tilde Inc. All rights reserved.
//

#import "TLDViewController.h"

@interface TLDViewController ()

@property (nonatomic, retain) CIImage *testImage;
- (void)redrawImage;

@end

@implementation TLDViewController

// Public
@synthesize slowCoreImageView;
@synthesize fastCoreImageView;
@synthesize contrastSlider;
@synthesize useFast;

// Private
@synthesize testImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.testImage = [CIImage imageWithCGImage:[[UIImage imageNamed:@"Sutro.png"] CGImage]];
    
    // Start out showing the slow image view.
    [self.useFast setOn:NO animated:NO];
    slowCoreImageView.coreImage = testImage;
    [slowCoreImageView setNeedsDisplay];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.testImage = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark IBActions

- (IBAction)contrastSliderValueChanged:(id)sender;
{
    [self redrawImage];
}

- (IBAction)useFastSwitchToggled:(id)sender
{
    if ([useFast isOn]) {
        [self.view bringSubviewToFront:fastCoreImageView];
    } else {
        [self.view bringSubviewToFront:slowCoreImageView];
    }
    
    [self redrawImage];
}

#pragma mark Private Methods

- (void)redrawImage;
{
    // Set the new filter value
    CIFilter *contrastFilter = [CIFilter filterWithName:@"CIColorControls"];
    [contrastFilter setDefaults];
    [contrastFilter setValue:[NSNumber numberWithDouble:contrastSlider.value] forKey:@"inputContrast"];
    
    // Apply the filter
    [contrastFilter setValue:testImage forKey:@"inputImage"];
    
    if ([useFast isOn]) {
        fastCoreImageView.coreImage = [contrastFilter outputImage];
        [fastCoreImageView drawView];
    } else {
        slowCoreImageView.coreImage = [contrastFilter outputImage];
        [slowCoreImageView setNeedsDisplay];
    }
}

@end
