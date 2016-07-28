//
//  DownLoadImage.m
//  MyDownImage
//
//  Created by ldd on 16/7/26.
//  Copyright © 2016年 ldd. All rights reserved.
//

#import "DownLoadImage.h"
#import "UIImage+GIF.h"
@implementation DownLoadImage
{
    NSURLSessionTask *_task;
    NSMutableString* _urlStr;
    NSString * _defaultUrlStr;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame]) {
        self.imgView = [[UIImageView alloc]initWithFrame:frame];
        //图片居中显示
        [self.imgView setContentMode:UIViewContentModeScaleAspectFit];
        UIImage *img = [UIImage imageNamed:@"default"];
        [self.imgView setImage:img];
        [self addSubview:self.imgView];
        
        return self;
    }
    return nil;
}
- (void)loadImageFromUrl:(NSString *)urlStr
{
    _defaultUrlStr = urlStr;
    _urlStr = [NSMutableString stringWithFormat:@"%@",urlStr];
    [_urlStr deleteCharactersInRange:NSMakeRange(_urlStr.length-4, 4)];

    //首先从本地读取图片
    UIImage *img = [self getImageFromLocal:_urlStr];
    if (img) {
        [self resetImg:img];
    }else{
        [self getImgFromNetWork:urlStr];
    }

}
//从网络上获取图片
- (void)getImgFromNetWork:(NSString *)urlStr
{
    //组装url
    NSURL* url = [NSURL URLWithString:urlStr];
    // 快捷方式获得session对象
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:[[NSOperationQueue alloc] init]];
    _task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url]];
    //请求开始
    [_task resume];
}
- (UIImage *)getImageFromLocal:(NSString *)urlStr
{
   return [self.fileManager getImageFromLocal:urlStr imageID:urlStr imgType:[self getImgType:_defaultUrlStr]];
}
//初始化图片管理类
- (FileManager *)fileManager
{
    if (!_fileManager) {
        _fileManager = [[FileManager alloc]init];
    }
    return _fileManager;
}
//初始化图片接收数据源
- (NSMutableData *)imgData
{
    if (!_imgData) {
        _imgData = [[NSMutableData alloc]init];
    }
    return _imgData;
}
#pragma mark++++++++++++++++++sessionDelegate+++++++++++++++++++++++++
// 1.接收到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}

// 2.接收到服务器的数据（可能调用多次）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 处理每次接收的数据
    [self.imgData appendData:data];
}

// 3.请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 请求完成,成功或者失败的处理
    [_task resume];
    if (!error) {
        NSLog(@"下载成功");
        NSString* imgType = [self getImgType:_defaultUrlStr];
       __block UIImage* img = nil;
        if (![[imgType lowercaseString] isEqualToString:@"gif"]) {
           img = [UIImage imageWithData:self.imgData];
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                img = [UIImage animatedGIFWithData:self.imgData];
            });
            
        }
        
        [self resetImg:img];
        //重置图片之后，保存到本地
        NSString* localDir = [self.fileManager createFile:_urlStr];
        
        [self.fileManager saveDownloadImage:_urlStr withImage:self.imgData localDir:localDir ofType:imgType];
    }else{
        NSLog(@"下载失败");
    }
}
//获取图片类型
- (NSString *)getImgType:(NSString*)urlStr
{
    NSString* extention = nil;
    if ([urlStr containsString:@"jpg"]) {
        extention = @"jpg";
    }else if ([urlStr containsString:@"png"]){
        extention = @"png";
    }else if ([urlStr containsString:@"gif"]){
        extention = @"gif";
    }
    return extention;
}
//更新图片
- (void)resetImg:(UIImage *)img
{
    [self.imgView setImage:img];
    [self.imgView setNeedsDisplay];
}
- (void)dealloc
{
    self.imgView = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
