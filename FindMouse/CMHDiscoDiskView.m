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
@end

@implementation CMHDiscoDiskView

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

@end
