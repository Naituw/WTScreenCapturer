//
//  WTAppDelegate.h
//  WTScreenCapturer
//
//  Created by Wutian on 13-9-21.
//  Copyright (c) 2013年 wutian. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WTAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSImageView *imageView;

- (IBAction)capture:(id)sender;

@end
