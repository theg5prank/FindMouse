//
//  CMHQuitMenu.h
//  FindMouse
//
//  Created by Conor Hughes on 3/7/15.
//  Copyright © 2015 Conor Hughes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CMHQuitMenuDelegate <NSObject>

- (void)quitSelected;

@end

@interface CMHQuitMenu : NSMenu

- (instancetype)initWithQuitMenuDelegate:(id<CMHQuitMenuDelegate>)delegate;

@end
