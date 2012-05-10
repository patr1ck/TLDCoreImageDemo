//
//  TLDFastCoreImageView.m
//  TLDCoreImageDemo
//
//  Created by Patrick Gibson on 5/10/12.
//  Copyright (c) 2012 Tilde Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

#import "TLDFastCoreImageView.h"

@interface TLDFastCoreImageView () {
    GLint               backingWidth; 
    GLint               backingHeight;
    GLuint              frameBuffer; 
    GLuint              renderBuffer;
    GLuint              depthBuffer;
}

@property (nonatomic, strong) EAGLContext *_eaglContext;
@property (nonatomic, strong) CIContext *_coreImageContext;

@end

@implementation TLDFastCoreImageView

// Public
@synthesize coreImage;

// Private
@synthesize _eaglContext;
@synthesize _coreImageContext;

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (void)awakeFromNib
{
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    eaglLayer.opaque = YES;
    //self.contentScaleFactor = [[UIScreen mainScreen] scale];
    
    self._eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self._coreImageContext = [CIContext contextWithEAGLContext:_eaglContext];
    
    if (!_eaglContext || ![EAGLContext setCurrentContext:_eaglContext]) {
        NSLog(@"ERROR: Couldn't create or set the EAGLContext during setup.");
        return;
    }
    
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    
    glGenRenderbuffers(1, &renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
    [_eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBuffer); 
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
    glGenRenderbuffers(1, &depthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthBuffer);
    
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, backingWidth, backingHeight);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthBuffer);
    
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER) ;
    if(status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"ERROR: Failed to make complete framebuffer object %x", status);
    } else {
        glViewport(0, 0, backingWidth, backingHeight);
        [self drawView];
    }
}

- (void)dealloc
{
    [self destroyBuffers];
    self._eaglContext = nil;
    self._coreImageContext = nil;
    self.coreImage = nil;
}

- (void)destroyBuffers
{
    glDeleteFramebuffers(1, &frameBuffer);
    frameBuffer = 0;
    glDeleteRenderbuffers(1, &renderBuffer);
    renderBuffer = 0;
    
    if(depthBuffer) 
    {
        glDeleteRenderbuffers(1, &depthBuffer);
        depthBuffer = 0;
    }
    
}

- (void)drawView
{    
    if (!coreImage) {
        NSLog(@"Can't draw, no image.");
        return;
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    [_coreImageContext drawImage:coreImage 
                          inRect:self.bounds
                        fromRect:coreImage.extent];
    
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
    [_eaglContext presentRenderbuffer:GL_RENDERBUFFER];

}

@end
