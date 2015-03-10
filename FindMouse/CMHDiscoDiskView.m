//
//  CMHDiscoDiskView.m
//  FindMouse
//
//  Created by Conor Hughes on 3/7/15.
//  Copyright © 2015 Conor Hughes. All rights reserved.
//

#import "CMHDiscoDiskView.h"

@interface CMHDiscoDiskView ()
@property (retain) NSColor *currentFillColor;
@property (retain) dispatch_source_t color_rotation_timer;
@end

@implementation CMHDiscoDiskView
- (instancetype) init
{
    if ( (self = [super init]) )
    {
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 50 * NSEC_PER_MSEC, 50 * NSEC_PER_MSEC);
        dispatch_source_set_event_handler(timer, ^{
            [self rotateColor];
        });
        self.color_rotation_timer = timer;
    }
    
    return self;
}

- (void)dealloc
{
    self.currentFillColor = nil;
    dispatch_source_cancel(self.color_rotation_timer);
    self.color_rotation_timer = nil;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor clearColor] set];
    NSRectFill([self frame]);
    NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:[self frame]];
    [[self currentFillColor] set];
    [path fill];
}

- (void)rotateColor
{
    NSColor *newFillColor = [NSColor colorWithCalibratedRed:arc4random_uniform(100) / 100.0
                                                      green:arc4random_uniform(100) / 100.0
                                                       blue:arc4random_uniform(100) / 100.0
                                                      alpha:.7];
    self.currentFillColor = newFillColor;
    [self setNeedsDisplay:YES];
}

- (void)suspendDisco
{
    dispatch_suspend(self.color_rotation_timer);
}

- (void)resumeDisco
{
    dispatch_resume(self.color_rotation_timer);
}

@end
