//
//  TLDFastCoreImageView.h
//  TLDCoreImageDemo
//
//  Created by Patrick Gibson on 5/10/12.
//  Copyright (c) 2012 Tilde Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLDFastCoreImageView : UIView

@property (nonatomic, strong) CIImage *coreImage;

- (void)drawView;

@end
