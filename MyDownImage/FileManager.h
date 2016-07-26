//
//  FileManager.h
//  MyDownImage
//
//  Created by ldd on 16/7/26.
//  Copyright © 2016年 ldd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FileManager : NSObject
//获取本地图片
-(UIImage *)getImageFromLocal:(NSString*)relativePath imageID:(NSString*)imageID imgType:(NSString*)imgType;
//创建文件
- (NSString *)createFile:(NSString*)urlStr;
//把网络上请求的图片保存在本地
- (void)saveDownloadImage:(NSString*)imageId withImage:(UIImage*)image localDir:(NSString*)resURL ofType:(NSString *)extension;
@end
