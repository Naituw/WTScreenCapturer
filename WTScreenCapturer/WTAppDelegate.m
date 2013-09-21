//
//  WTAppDelegate.m
//  WTScreenCapturer
//
//  Created by Wutian on 13-9-21.
//  Copyright (c) 2013年 wutian. All rights reserved.
//

#import "WTAppDelegate.h"
#import "WTScreenCapturer.h"

@interface WTAppDelegate () <WTScreenCapturerDelegate>

@property (nonatomic, retain) WTScreenCapturer * screenCapturer;

@end

@implementation WTAppDelegate

- (void)dealloc
{
    [_screenCapturer release], _screenCapturer = nil;
    [super dealloc];
}

- (WTScreenCapturer *)screenCapturer
{
    if (!_screenCapturer)
    {
        _screenCapturer = [[WTScreenCapturer alloc] init];
        _screenCapturer.delegate = self;
    }
    
    return _screenCapturer;
}

- (void)capture:(id)sender
{
    [self.screenCapturer startCapture];
}

#pragma mark - ScreenCapturer Delegate

- (void)screenCapturer:(WTScreenCapturer *)capturer didFinishWithImageData:(NSData *)data
{
    NSImage * image = [[[NSImage alloc] initWithData:data] autorelease];
    
    self.imageView.image = image;
}

@end
