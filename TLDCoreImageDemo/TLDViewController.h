//
//  TLDViewController.h
//  TLDCoreImageDemo
//
//  Created by Patrick Gibson on 5/10/12.
//  Copyright (c) 2012 Tilde Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLDSlowCoreImageView.h"
#import "TLDFastCoreImageView.h"

@interface TLDViewController : UIViewController

@property (nonatomic, strong) IBOutlet TLDSlowCoreImageView *slowCoreImageView;
@property (nonatomic, strong) IBOutlet TLDFastCoreImageView *fastCoreImageView;
@property (nonatomic, strong) IBOutlet UISlider *contrastSlider;
@property (nonatomic, strong) IBOutlet UISwitch *useFast;

- (IBAction)contrastSliderValueChanged:(id)sender;
- (IBAction)useFastSwitchToggled:(id)sender;

@end
