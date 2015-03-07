//
//  CMHMouseHighlightingWindow.m
//  FindMouse
//
//  Created by Conor Hughes on 3/6/15.
//  Copyright © 2015 Conor Hughes. All rights reserved.
//

#import "CMHMouseHighlightingWindow.h"
#import "CMHDiscoDiskView.h"

#define RADIUS 75

@interface CMHMouseHighlightingWindow ()
@property (retain) dispatch_source_t color_rotation_timer;
@end

@implementation CMHMouseHighlightingWindow
- (instancetype)init
{
    return [self initWithContentRect:NSMakeRect(100, 100, 400, 400) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:YES screen:nil];
}

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen
{
    if ( (self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag screen:screen]) )
    {
        [self setCollectionBehavior: NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorFullScreenAuxiliary];
        [self setLevel:kCGMaximumWindowLevel];
        [self setIsVisible:NO];
        [self setOpaque:NO];
        [self setIgnoresMouseEvents:YES];
        [self setContentView:[[CMHDiscoDiskView alloc] init]];

        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 50 * NSEC_PER_MSEC, 50 * NSEC_PER_MSEC);
        dispatch_source_set_event_handler(timer, ^{
            [(CMHDiscoDiskView*)[self contentView] rotateColor];
        });
        dispatch_source_set_cancel_handler(timer, ^{
            self.color_rotation_timer = nil;
        });
        self.color_rotation_timer = timer;
    }
    return self;
}

- (void)dealloc
{
    dispatch_source_cancel(self.color_rotation_timer);
}

- (void)_enableColorRotation
{
    dispatch_resume(self.color_rotation_timer);
}

- (void)_disableColorRotation
{
    dispatch_suspend(self.color_rotation_timer);
}

- (void)mouseDidMove
{
    [self displayOnMouse];
}

- (void)displayOnMouse
{
    NSPoint mousePoint = [NSEvent mouseLocation];
    NSPoint origin = NSMakePoint(mousePoint.x - (RADIUS), mousePoint.y - (RADIUS));
    NSRect rect = {
        origin, {RADIUS*2, RADIUS*2}
    };
    if (![self isVisible])
    {
        [self setFrame:rect display:YES animate:YES];
        [self setIsVisible:YES];
        [self orderFrontRegardless];
        [self _enableColorRotation];
    }
    else
    {
        [self setFrame:rect display:YES animate:NO];
        [self orderFrontRegardless];
    }
}

- (void)hide
{
    if ( [self isVisible] )
    {
        [self _disableColorRotation];
        [self setIsVisible:NO];
    }
}
@end
