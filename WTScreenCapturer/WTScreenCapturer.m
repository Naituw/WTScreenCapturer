//
//  WTScreenCapturer.m
//  WTScreenCapture
//
//  Created by Wutian on 12-1-29.
//  Copyright (c) 2012年 Wutian. All rights reserved.
//

#import "WTScreenCapturer.h"

#define kScreenCapturePath @"/usr/sbin/screencapture"

@interface WTScreenCapturer()

@property (nonatomic, assign) NSUInteger initialPasteboardChangeCount;

@end

@implementation WTScreenCapturer

- (void)startCapture
{
    self.initialPasteboardChangeCount = [[NSPasteboard generalPasteboard] changeCount];
    
    NSTask * task = [[NSTask alloc] init];
    
    [task setLaunchPath:kScreenCapturePath];
    
    // argument -c: Force screen capture to go to the clipboard.
    // argument -i: Capture screen interactively, by selection or window.
    // for more arguments, see screencapture(1) OS X Man Page: https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/screencapture.1.html
    
    [task setArguments:@[@"-ci"]];
    [task launch];
    [task autorelease];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCaptureTaskStatus:) name:NSTaskDidTerminateNotification object:task];
}

- (void)captureFinished
{
    NSPasteboard * pasteboard = [NSPasteboard generalPasteboard];

    NSString * desiredType = [pasteboard availableTypeFromArray:@[NSPasteboardTypePNG]];
    
    if ([desiredType isEqualToString:NSPasteboardTypePNG])
    {
        NSData *imageData = [pasteboard dataForType:desiredType];
        
		if (!imageData)
        {
			NSLog(@"capture failed! data is nil.");
			return;
		}
        
        if ([_delegate respondsToSelector:@selector(screenCapturer:didFinishWithImageData:)])
        {
            [_delegate screenCapturer:self didFinishWithImageData:imageData];
        }
    }
}

- (void)checkCaptureTaskStatus:(NSNotification *)notification
{
    NSTask * task = [notification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSTaskDidTerminateNotification object:task];
    
    if (![task isRunning] && [[task launchPath] isEqualToString:kScreenCapturePath])
    {
        int status = [task terminationStatus];
        
        // 0 means task completed
        if (status == 0)
        {
            // check if pasteboard actually changed
            if (self.initialPasteboardChangeCount == [[NSPasteboard generalPasteboard] changeCount])
            {
                NSLog(@"capture task canceled.");
            }
            else
            {
                [self captureFinished];
            }
        }
        else
        {
            NSLog(@"capture task failed.");
        }
    }
}

@end
