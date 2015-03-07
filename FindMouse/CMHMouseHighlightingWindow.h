//
//  CMHMouseHighlightingWindow.h
//  FindMouse
//
//  Created by Conor Hughes on 3/6/15.
//  Copyright © 2015 Conor Hughes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CMHMouseHighlightingWindow : NSWindow

- (void)displayOnMouse;
- (void)hide;
- (void)mouseDidMove;

@end
