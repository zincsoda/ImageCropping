//
//  SWImageCrop.h
//  ImageCropping
//
//  Created by Steve Walsh on 03/08/2015.
//  Copyright (c) 2015 Steve Walsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWImageCrop : NSObject

@property CGFloat widthRatio;
@property CGFloat heightRatio;

+ (NSImage *)getSquareCroppedImageFromImageURL:(NSURL *)imageURL;

@end
