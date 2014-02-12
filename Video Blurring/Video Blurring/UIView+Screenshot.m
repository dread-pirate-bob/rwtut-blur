//
//  UIView+Screenshot.m
//  Video Blurring
//
//  Created by Lion Rawr on 2/11/14.
//  Copyright (c) 2014 Mike Jaoudi. All rights reserved.
//

#import "UIView+Screenshot.h"

@implementation UIView (Screenshot)

-(UIImage *)convertViewToImage {
    
    // Begin Graphics Context
    UIGraphicsBeginImageContext(self.bounds.size);
    // draw all the views from this rect, drop it into current image context
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    // capture image context as UIImage
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // End Graphics context
    UIGraphicsEndImageContext();
    
    return image;
}

@end
