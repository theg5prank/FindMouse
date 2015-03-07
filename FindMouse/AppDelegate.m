//
//  AppDelegate.m
//  FindMouse
//
//  Created by Conor Hughes on 3/3/15.
//  Copyright © 2015 Conor Hughes. All rights reserved.
//

#import "AppDelegate.h"
#import "CMHMouseHighlightingWindow.h"
#import <Carbon/Carbon.h>

@interface AppDelegate ()

@property (retain) CMHMouseHighlightingWindow *window;
@property (assign) BOOL hotKeyActive;
@property (retain) id globalMouseMonitorToken;
@property (retain) id localMouseMonitorToken;
@property (retain) NSStatusItem *statusItem;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.window = [[CMHMouseHighlightingWindow alloc] init];

    CFMutableDictionaryRef opts = CFDictionaryCreateMutable(NULL, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(opts, kAXTrustedCheckOptionPrompt, kCFBooleanTrue);
    Boolean result = AXIsProcessTrustedWithOptions(opts);
    if (!result)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"No AX."];
        [alert runModal];
    }
    
    void (^eventHandler)(NSEvent *event) = ^(NSEvent *event) {
        if ( [event keyCode] == kVK_Tab )
        {
            NSInteger desiredMask = NSCommandKeyMask | NSControlKeyMask;
            if ( [event type] == NSKeyDown &&  !self.hotKeyActive &&
                ([event modifierFlags] & NSDeviceIndependentModifierFlagsMask) == desiredMask )
            {
                [self hotkeyPressed];
            }
            if ( [event type] == NSKeyUp && self.hotKeyActive )
            {
                [self hotkeyReleased];
            }
        }
    };
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:(NSKeyDownMask|NSKeyUpMask) handler:eventHandler];
    [NSEvent addLocalMonitorForEventsMatchingMask:(NSKeyDownMask|NSKeyUpMask) handler:^NSEvent *(NSEvent *event) {
        eventHandler(event);
        return event;
    }];
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    [[self.statusItem button] setTitle:@"FM"];
    [self.statusItem setMenu:[[CMHQuitMenu alloc] initWithQuitMenuDelegate:self]];
}

- (void)enableMouseMovedListener
{
    void (^eventHandler)(NSEvent *event) = ^(NSEvent *event) {
        [self.window mouseDidMove];
    };
    self.globalMouseMonitorToken = [NSEvent addGlobalMonitorForEventsMatchingMask:(NSMouseMovedMask) handler:eventHandler];
    self.localMouseMonitorToken = [NSEvent addLocalMonitorForEventsMatchingMask:(NSMouseMovedMask) handler:^NSEvent *(NSEvent *event) {
        eventHandler(event);
        return event;
    }];
}

- (void)disableMouseMovedListener
{
    [NSEvent removeMonitor:self.globalMouseMonitorToken];
    [NSEvent removeMonitor:self.localMouseMonitorToken];
    
    self.globalMouseMonitorToken = nil;
    self.localMouseMonitorToken = nil;
}

- (void)hotkeyPressed
{
    self.hotKeyActive = YES;
    [self.window displayOnMouse];
    [self enableMouseMovedListener];
}

- (void)hotkeyReleased
{
    self.hotKeyActive = NO;
    [self disableMouseMovedListener];
    [self.window hide];
}

- (void)quitSelected
{
    [[NSApplication sharedApplication] terminate:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
