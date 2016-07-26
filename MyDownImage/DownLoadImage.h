//
//  DownLoadImage.h
//  MyDownImage
//
//  Created by ldd on 16/7/26.
//  Copyright © 2016年 ldd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileManager.h"
@interface DownLoadImage : UIView <NSURLSessionDelegate>
@property (nonatomic,retain)NSMutableData *imgData;
@property (nonatomic,retain)UIImageView *imgView;
@property (nonatomic,retain)FileManager* fileManager;
//加载网络图片
- (void)loadImageFromUrl:(NSString *)urlStr;
@end
