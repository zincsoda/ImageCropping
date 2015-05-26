//
//  SWAppDelegate.m
//  ImageCropping
//
//  Created by Steve Walsh on 17/05/2015.
//  Copyright (c) 2015 Steve Walsh. All rights reserved.
//

#import "SWAppDelegate.h"
#import "SWMainViewController.h"

@interface SWAppDelegate()

@property (nonatomic, strong) IBOutlet SWMainViewController *mainViewController;

@end

@implementation SWAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  self.mainViewController = [[SWMainViewController alloc] initWithNibName:@"SWMainViewController" bundle:nil];
  [self.window.contentView addSubview:self.mainViewController.view];
}

@end
