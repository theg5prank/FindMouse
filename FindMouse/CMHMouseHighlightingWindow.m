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

@implementation CMHMouseHighlightingWindow
- (instancetype)init
{
    return [self initWithContentRect:NSMakeRect(100, 100, 400, 400) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:YES screen:nil];
}

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen
{
    if ( (self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag screen:screen]) )
    {
        [self setCollectionBehavior: NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorFullScreenAuxiliary];
        [self setLevel:kCGMaximumWindowLevel];
        [self setIsVisible:NO];
        [self setOpaque:NO];
        [self setIgnoresMouseEvents:YES];
        [self setContentView:[[CMHDiscoDiskView alloc] init]];
    }
    return self;
}

- (void)_enableColorRotation
{
    [(CMHDiscoDiskView*)[self contentView] resumeDisco];
}

- (void)_disableColorRotation
{
    [(CMHDiscoDiskView*)[self contentView] suspendDisco];
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
