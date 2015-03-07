//
//  CMHQuitMenu.m
//  FindMouse
//
//  Created by Conor Hughes on 3/7/15.
//  Copyright © 2015 Conor Hughes. All rights reserved.
//

#import "CMHQuitMenu.h"

@interface CMHQuitMenu ()
@property (weak) id<CMHQuitMenuDelegate> quitMenuDelegate;
@end

@implementation CMHQuitMenu

- (instancetype)initWithQuitMenuDelegate:(id<CMHQuitMenuDelegate>)delegate
{
    if ( (self = [super init]) )
    {
        [self setQuitMenuDelegate:delegate];
        [self setTitle:@"FM"];
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quitMenuItemSelected) keyEquivalent:@""];
        [item setTarget:self];
        [self addItem:item];
    }
    return self;
}

- (void)quitMenuItemSelected
{
    [[self quitMenuDelegate] quitSelected];
}

@end
