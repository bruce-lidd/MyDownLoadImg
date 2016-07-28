//
//  UIImage+GIF.h
//  MyDownImage
//
//  Created by ldd on 16/7/27.
//  Copyright © 2016年 ldd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GIF)
+ (UIImage *)animatedGIFNamed:(NSString *)name;
+ (UIImage *)animatedGIFWithData:(NSData *)data ;
+ (UIImage* )getPartImage:(NSData *)imageData isLoadFinished:(BOOL)isLoadFinished;
@end
