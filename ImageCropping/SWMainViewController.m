//
//  SWMainViewController.m
//  ImageCropping
//
//  Created by Steve Walsh on 17/05/2015.
//  Copyright (c) 2015 Steve Walsh. All rights reserved.
//

#import "SWMainViewController.h"

@interface SWMainViewController ()

@property (strong) IBOutlet NSImageView *imageView;
@property NSImage *image;
@property NSURL *imageURL;
@property NSURL *outputURL;
@property (strong) IBOutlet NSTextField *imageDetailLabel;
@property (strong) IBOutlet NSTextField *aspectRatioLabel;
@property (strong) IBOutlet NSImageView *outputImageView;
@property (strong) IBOutlet NSTextField *widthRatioTextField;
@property (strong) IBOutlet NSTextField *heightRatioTextField;
@property NSView *expandableView;
@property (strong) IBOutlet NSTextField *overlayDetailLabel;
@property (strong) IBOutlet NSTextField *overlayRatioLabel;
@property CGFloat aspectRatio;

@property (strong) IBOutlet NSButton *upArrowBtn;
@property (strong) IBOutlet NSButton *downArrowBtn;
@property (strong) IBOutlet NSButton *rightArrowBtn;
@property (strong) IBOutlet NSButton *leftArrowBtn;
@property (strong) IBOutlet NSButton *centerBtn;

@property CGFloat xOffset;
@property CGFloat yOffset;

@end

@implementation SWMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.widthRatio = 16.0f;
      self.heightRatio = 9.0f;
      self.aspectRatio = self.widthRatio / self.heightRatio;
      self.xOffset = 0;
      self.yOffset = 0;
    }
    return self;
}

- (void)viewDidLoad {
  [self getImage];
  [self drawOverlay];
  [self cropImage];
}

#pragma mark - Handle button presses

- (IBAction)getImagePressed:(id)sender {
  [self getImage];
  [self drawOverlay];
  [self cropImage];
}

- (IBAction)drawOverlay:(id)sender {
  [self drawOverlay];
}

- (IBAction)resetOverlay:(id)sender {
  [self.expandableView removeFromSuperview];
}
- (IBAction)cropButtonPressed:(id)sender {
  [self cropImage];
}

- (IBAction)upArrowPressed:(id)sender {
  self.yOffset += 10;
  [self drawOverlay];
  [self cropImage];
}
- (IBAction)rightArrowPressed:(id)sender {
  self.xOffset += 10;
  [self drawOverlay];
  [self cropImage];
}
- (IBAction)downArrowPressed:(id)sender {
  self.yOffset -= 10;
  [self drawOverlay];
  [self cropImage];
}
- (IBAction)leftArrowPressed:(id)sender {
  self.xOffset -= 10;
  [self drawOverlay];
  [self cropImage];
}
- (IBAction)centerButtonPressed:(id)sender {
  self.xOffset = 0;
  self.yOffset = 0;
  [self drawOverlay];
   [self cropImage];
}

#pragma mark - Image editing methods

- (void)getImage {
  
  NSOpenPanel *openPanel = [NSOpenPanel openPanel];
  openPanel.allowedFileTypes = @[@"png", @"jpg"];
  openPanel.title = @"Select Thumbnail Image";
  
  NSInteger modalResult = [openPanel runModal];
  
  if (modalResult == NSFileHandlingPanelCancelButton) {
    NSLog(@"You didn't select a file");
    return;
  }
  self.imageURL = [openPanel URL];
  self.image = [[NSImage alloc] initWithContentsOfURL:[openPanel URL]];
  [self.imageView setImage:self.image];
  
  CGFloat width = self.image.size.width;
  CGFloat height = self.image.size.height;
  [self.imageDetailLabel setStringValue:[NSString stringWithFormat:@"Dimensions: %d x% d", (int)width, (int)height]];
  
  int width_reduced = (int)width / gcd((int)width, (int)height);
  int height_reduced = (int)height / gcd((int)width, (int)height);
  
  [self.aspectRatioLabel setStringValue:[NSString stringWithFormat:@"Aspect Ratio: %d:%d", width_reduced, height_reduced]];
}




- (void)drawOverlay {
  [self resetOverlay:nil];
  
  CGFloat originalImageWidth = self.image.size.width;
  CGFloat originalImageHeight = self.image.size.height;
  CGFloat imageViewWidth = self.imageView.frame.size.width;
  CGFloat imageViewHeight = self.imageView.frame.size.height;
  
  CGFloat overlay_width;
  CGFloat overlay_height;
  
  if (originalImageWidth > originalImageHeight) {
    
    CGFloat scalingFactor = imageViewWidth / originalImageWidth;
    
    if ((originalImageWidth / originalImageHeight ) >= self.aspectRatio ) {
      
      overlay_height = originalImageHeight * scalingFactor;
      overlay_width = overlay_height * self.aspectRatio;
      
    } else {
      
      overlay_width = originalImageWidth * scalingFactor;
      overlay_height = overlay_width / self.aspectRatio;
      
    }
    
  } else {
    
    CGFloat scalingFactor = imageViewHeight / originalImageHeight;
    
    overlay_width = originalImageWidth * scalingFactor;
    overlay_height = overlay_width / self.aspectRatio;
    
  }
  CGFloat overlay_x = ((imageViewWidth - overlay_width) / 2) + self.xOffset;
  CGFloat overlay_y = ((imageViewHeight - overlay_height) / 2) + self.yOffset;
  
  
  NSRect frame = NSMakeRect(overlay_x, overlay_y, overlay_width, overlay_height);
  self.expandableView = [[NSView alloc] initWithFrame:frame];
  [self.overlayDetailLabel setStringValue:[NSString stringWithFormat:@"Dimensions: %d x% d", (int)overlay_width, (int)overlay_height]];
  [self colorTheFrame];
  int width_reduced = (int)overlay_width / gcd((int)overlay_width, (int)overlay_height);
  int height_reduced = (int)overlay_height / gcd((int)overlay_width, (int)overlay_height);
  
  [self.overlayRatioLabel setStringValue:[NSString stringWithFormat:@"Aspect Ratio: %d:%d", width_reduced, height_reduced]];
  [self.imageView addSubview:self.expandableView];
}



- (void)colorTheFrame {
  [self.expandableView setWantsLayer:YES];
  CGColorRef backgroundColor = CGColorCreateGenericRGB(1, 1, 1, 0);
  CGColorRef borderColor = CGColorCreateGenericRGB(1, 0.3, 0.3, 1);
  self.expandableView.layer.backgroundColor = backgroundColor;
  self.expandableView.layer.borderColor = borderColor;
  self.expandableView.layer.borderWidth = 5.0;
  CGColorRelease(backgroundColor);
  CGColorRelease(borderColor);
}


- (void)cropImage {
  // this chunk of code loads a jpeg image into a cgimage
  // creates a second crop of the original image with CGImageCreateWithImageInRect
  // writes the new cropped image to the desktop
  // ensure that the xy origin of the CGRectMake call is smaller than the width or height of the original image
  
  NSURL *originalImage = self.imageURL;
  
  CGImageRef imageRef = NULL;
  CGImageSourceRef loadRef = CGImageSourceCreateWithURL((CFURLRef)originalImage, NULL);
  if (loadRef != NULL)
  {
    imageRef = CGImageSourceCreateImageAtIndex(loadRef, 0, NULL);
    CFRelease(loadRef); // Release CGImageSource reference
  }
  
  CGFloat width = CGImageGetWidth(imageRef);
  CGFloat height = CGImageGetHeight(imageRef);
  CGFloat outputWidth;
  CGFloat outputHeight;

  if (width >= height) {
    if ((width / height) >= self.aspectRatio) {
      outputWidth = height * self.aspectRatio;
      outputHeight = height;
    } else {
      outputWidth = width;
      outputHeight = width / self.aspectRatio;
    }
  } else {
      outputWidth = width;
      outputHeight = width / self.aspectRatio;
  }
  
  CGFloat origin_x = self.expandableView.frame.origin.x;
  CGFloat origin_y = self.expandableView.frame.origin.y - (2 * self.yOffset);
  CGFloat output_x;
  CGFloat output_y;
  if (width >= height) {
    if (width / height >= self.aspectRatio ) {
      output_x = (origin_x / (self.imageView.frame.size.width)) * width;
      output_y = 0;
    } else {
      output_x = 0;
      output_y = (origin_y / (self.imageView.frame.size.height)) * height;
    }
  } else {
    output_x = 0;
    output_y = (origin_y / self.imageView.frame.size.height) * height;
  }

  CGRect outputFrame = CGRectMake(output_x, output_y, outputWidth, outputHeight);
  
  
  CGImageRef croppedImage = CGImageCreateWithImageInRect(imageRef, outputFrame);
  self.outputURL = [NSURL fileURLWithPath:@"/Users/stevewalsh/Desktop/steve-crop.jpg"];
  CFURLRef saveUrl = (__bridge CFURLRef) self.outputURL;
  CGImageDestinationRef destination = CGImageDestinationCreateWithURL(saveUrl, kUTTypeJPEG, 1, NULL);
  CGImageDestinationAddImage(destination, croppedImage, nil);
  
  if (!CGImageDestinationFinalize(destination)) {
    NSLog(@"Failed to write image to %@", saveUrl);
  }
  
  CFRelease(destination);
  CFRelease(imageRef);
  CFRelease(croppedImage);
  
  [self.outputImageView setImage:[[NSImage alloc] initWithContentsOfURL:self.outputURL]];
}



#pragma mark - Helper functions

int gcd(int n, int m) {
  int gcd, remainder;
  while (n != 0)
  {
    remainder = m % n;
    m = n;
    n = remainder;
  }
  gcd = m;
  return gcd;
}

- (void)dashTheFrame {
  // get the current CGContextRef for the view
  CGContextRef currentContext = (CGContextRef)[[NSGraphicsContext currentContext]
                                               graphicsPort];
  
  // grab some useful view size numbers
  NSRect bounds = [self.expandableView bounds];
  //float width = NSWidth( bounds );
  //float height = NSHeight( bounds );
  float originX = NSMinX( bounds );
  //float originY = NSMinY( bounds );
  float maxX = NSMaxX( bounds );
  //float maxY = NSMaxY( bounds );
  //float middleX = NSMidX( bounds );
  float middleY = NSMidY( bounds );
  
  CGContextSetLineWidth( currentContext, 10.0 );
  float dashPhase = 0.0;
  CGFloat dashLengths[] = { 20, 30, 40, 30, 20, 10 };
  CGContextSetLineDash( currentContext, dashPhase, dashLengths, sizeof( dashLengths ) / sizeof( float ) );
  
  CGContextMoveToPoint( currentContext, originX + 10, middleY );
  CGContextAddLineToPoint( currentContext, maxX - 10, middleY );
  CGContextStrokePath( currentContext );
}


@end
