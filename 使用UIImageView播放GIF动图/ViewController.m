//
//  ViewController.m
//  使用UIImageView播放GIF动图
//
//  Created by 123 on 16/9/22.
//  Copyright © 2016年 彭洪. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createGIF];
    
}

- (void)createGIF {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 280, 200)];
    [self.view addSubview:imageView];
    
    //1.找到gif文件路径
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"11" ofType:@"gif"];
    //2.获取gif文件数据
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:dataPath], NULL);
    //3.获取gif文件中图片的个数
    size_t count = CGImageSourceGetCount(source);
    //4.定义一个变量记录gif播放一轮的时间
    float allTime = 0;
    //5.定义一个可变数组存放所有图片
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    //6.定义一个可变数组存放每一帧播放的时间
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    //7.每张图片的宽度
    NSMutableArray *widthArray = [[NSMutableArray alloc] init];
    //8.每张图片的高度
    NSMutableArray *heightArray = [[NSMutableArray alloc] init];
    
    //遍历gif
    for (size_t i=0; i<count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        [imageArray addObject:(__bridge UIImage *)(image)];
        CGImageRelease(image);
        
        //获取图片信息
        NSDictionary *info = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        NSLog(@"info---%@",info);
        //获取宽度
        CGFloat width = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth] floatValue];
        //获取高度
        CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight] floatValue];
        
        //
        [widthArray addObject:[NSNumber numberWithFloat:width]];
        [heightArray addObject:[NSNumber numberWithFloat:height]];
        
        //统计时间
        NSDictionary *timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime] floatValue];
        [timeArray addObject:[NSNumber numberWithFloat:time]];
    }
    //添加帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    NSMutableArray *times = [[NSMutableArray alloc] init];
    float currentTime = 0;
    //设置每一帧的时间占比
    for (int i=0; i<imageArray.count; i++) {
        [times addObject:[NSNumber numberWithFloat:currentTime/allTime]];
        currentTime +=[timeArray[i] floatValue];
    }
    [animation setKeyTimes:times];
    [animation setValues:imageArray];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    //设置循环
    animation.repeatCount = MAXFLOAT;
    //设置播放总时长
    animation.duration = allTime*MAXFLOAT;
    //Layer层添加
    [[imageView layer]addAnimation:animation forKey:@"gifAnimation"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}

@end
