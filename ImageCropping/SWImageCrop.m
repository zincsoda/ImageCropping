//
//  SWImageCrop.m
//  ImageCropping
//
//  Created by Steve Walsh on 03/08/2015.
//  Copyright (c) 2015 Steve Walsh. All rights reserved.
//

#import "SWImageCrop.h"

@implementation SWImageCrop

+ (NSImage *)getSquareCroppedImageFromImageURL:(NSURL *)imageURL {
 

  // Get square size width
  NSImage *originalImage = [[NSImage alloc] initWithContentsOfURL:imageURL];

  CGFloat originalImageWidth = originalImage.size.width;
  CGFloat originalImageHeight = originalImage.size.height;

  CGFloat cropWidth;
  CGFloat cropped_x;
  CGFloat cropped_y;
  
  if (originalImageWidth >= originalImageHeight) {
    cropWidth = originalImageHeight;
    cropped_x = (originalImageWidth - cropWidth) / 2.0;
    cropped_y = 0;
  } else {
    cropWidth = originalImageWidth;
    cropped_x = 0;
    cropped_y = (originalImageHeight - cropWidth) / 2.0;
  }

  CGImageRef originalImageRef = NULL;
  CGImageSourceRef loadRef = CGImageSourceCreateWithURL((CFURLRef)imageURL, NULL);
  if (loadRef != NULL)
  {
    originalImageRef = CGImageSourceCreateImageAtIndex(loadRef, 0, NULL);
  }
  CGRect outputFrame = CGRectMake(cropped_x, cropped_y, cropWidth, cropWidth);
  CGImageRef imageRef = CGImageCreateWithImageInRect(originalImageRef, outputFrame);
  NSImage *croppedImage = [[NSImage alloc] initWithCGImage:imageRef size:(NSSize){cropWidth, cropWidth}];
  CGImageRelease(imageRef);

  return croppedImage;
}

@end
