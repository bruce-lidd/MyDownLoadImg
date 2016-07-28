//
//  FileManager.m
//  MyDownImage
//
//  Created by ldd on 16/7/26.
//  Copyright © 2016年 ldd. All rights reserved.
//

#import "FileManager.h"
#import "UIImage+GIF.h"
@implementation FileManager

/**
 *  获取本地图片
 *
 *  @param relativePath 图片相对路径
 *  @param imageName 图片名称
 *  @param imageID   图片的唯一ID
 *  @return
 */
-(UIImage*)getImageFromLocal:(NSString*)relativePath imageID:(NSString*)imageID imgType:(NSString*)imgType
{
    UIImage * localImage = nil;
    //调用创建文件夹的方法
    NSString* localDir = [self createFile:relativePath];
    //从本地读取图片
    localImage = [self loadImage:imageID ofType:imgType inDirectory:localDir];
    
    return localImage;
}

#pragma mark ---------读取本地保存的图片------------
//读取本地保存的图片
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    NSArray* urlStrArr = [fileName componentsSeparatedByString:@"/"];
    NSString *imgPath = [NSString stringWithFormat:@"%@/%@.%@", directoryPath,[urlStrArr lastObject], extension];
    __block UIImage* img = nil;
    if ([[extension lowercaseString] containsString:@"gif"]) {
        NSData* data = [NSData dataWithContentsOfFile:imgPath];
        img = [UIImage animatedGIFWithData:data];
        
    }else{
        img = [UIImage imageWithContentsOfFile:imgPath];
    }
    
    return img;
}

#pragma mark ------创建图片在本地保存的文件夹---------
//创建文件夹
- (NSString *)createFile:(NSString*)urlStr
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSString* imageDir = [NSString stringWithFormat:@"%@/%@", docDir,urlStr];//文件路径
    [self createFileInDocument:imageDir];
    return imageDir;
    
}
#pragma mark -------在本地创建图片文件-----------
//创建文件
- (void)createFileInDocument:(NSString*)imgDir
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imgDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        BOOL success = [fileManager createDirectoryAtPath:imgDir withIntermediateDirectories:YES attributes:nil error:nil];
        if (!success) {
            NSLog(@"创建文件失败");
        }
    }
    
}
/**
 *  保存下载的图片
 *
 *  @param imageID 图片ID
 *  @param image
 */
- (void)saveDownloadImage:(NSString*)imageId withImage:(NSData*)imageData localDir:(NSString*)resURL ofType:(NSString *)extension
{
    [self saveImage:imageData withFileName:imageId ofType:extension inDirectory:resURL];
    
}

//将所下载的图片保存到本地
-(void) saveImage:(NSData*)imageData withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    NSLog(@"url   。。。。。。  %@",directoryPath);
    NSArray* urlStrArr = [imageName componentsSeparatedByString:@"/"];
    NSString* path = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", [urlStrArr lastObject], extension]];
    BOOL success =   [imageData writeToFile:path atomically:YES];

    
    if (success) {
        NSLog(@"保存成功");
    }else{
        NSLog(@"保存失败");
    }
    
}

@end
