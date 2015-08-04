//
//  SWMainWindowController.m
//  ImageCropping
//
//  Created by Steve Walsh on 04/08/2015.
//  Copyright (c) 2015 Steve Walsh. All rights reserved.
//

#import "SWMainWindowController.h"
#import "SWImageCrop.h"

@interface SWMainWindowController ()

@property (strong) IBOutlet NSImageView *originalImageView;
@property (strong) IBOutlet NSImageView *croppedImageView;
@property NSURL *originalImageURL;

@end

@implementation SWMainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)getImagePressed:(id)sender {
  
  NSOpenPanel *openPanel = [NSOpenPanel openPanel];
  openPanel.allowedFileTypes = @[@"png", @"jpg"];
  openPanel.title = @"Get image";
  
  NSInteger modalResult = [openPanel runModal];
  if (modalResult == NSFileHandlingPanelCancelButton) {
    NSLog(@"You didn't select a file");
    return;
  }
  
  self.originalImageURL = openPanel.URL;
  [self.originalImageView setImage:[[NSImage alloc] initWithContentsOfURL:self.originalImageURL]];
  
}

- (IBAction)cropImagePressed:(id)sender {
  
  NSImage *croppedImage = [SWImageCrop getSquareCroppedImageFromImageURL:self.originalImageURL];

  self.croppedImageView.image = croppedImage;
}

@end
