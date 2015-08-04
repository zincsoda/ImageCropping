//
//  SWAppDelegate.m
//  ImageCropping
//
//  Created by Steve Walsh on 17/05/2015.
//  Copyright (c) 2015 Steve Walsh. All rights reserved.
//

#import "SWAppDelegate.h"
#import "SWMainWindowController.h"

@interface SWAppDelegate()

@property SWMainWindowController *mainWindowController;

@end

@implementation SWAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  self.mainWindowController = [[SWMainWindowController alloc] initWithWindowNibName:@"SWMainWindowController"];
  [self.mainWindowController showWindow:self];
}

@end
