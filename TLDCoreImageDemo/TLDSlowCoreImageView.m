//
//  TLDSlowCoreImageView.m
//  TLDCoreImageDemo
//
//  Created by Patrick Gibson on 5/10/12.
//  Copyright (c) 2012 Tilde Inc. All rights reserved.
//

#import <CoreImage/CoreImage.h>

#import "TLDSlowCoreImageView.h"

@interface TLDSlowCoreImageView ()
@property (nonatomic, strong) CIContext *_coreImageContext;
@end

@implementation TLDSlowCoreImageView

// Public
@synthesize coreImage;

// Private
@synthesize _coreImageContext;

- (void)awakeFromNib
{
    NSDictionary *optionsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kCIContextUseSoftwareRenderer, nil];
    self._coreImageContext = [CIContext contextWithOptions:optionsDict];
}

- (void)dealloc
{
    self._coreImageContext = nil;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef imageRef = [_coreImageContext createCGImage:coreImage fromRect:coreImage.extent];
    
    CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0.0f, coreImage.extent.size.height);
        CGContextScaleCTM(context, 1.0f, -1.0f);
        CGContextDrawImage(context, rect, imageRef);        
    CGContextRestoreGState(context);
    CGImageRelease(imageRef);
}


@end
