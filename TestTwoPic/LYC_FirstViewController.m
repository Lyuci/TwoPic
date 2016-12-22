//
//  LYC_FirstViewController.m
//  TestTwoPic
//
//  Created by Lyuci on 2016/10/9.
//  Copyright © 2016年 Lyuci. All rights reserved.
//

// 

#import "LYC_FirstViewController.h"
#import <CoreImage/CoreImage.h>

@interface LYC_FirstViewController ()
@property (nonatomic, strong) UIImageView *ciImageView;
@end

@implementation LYC_FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ciImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    
//  1. 创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//  2. 恢复默认
    [filter setDefaults];
//  3. 给过滤器添加数据
    NSString *dataString = @"https://github.com/Lyuci";
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
//  4. 获取输出的二维码
    CIImage *outputImg = [filter outputImage];
//    因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
//   5.显示二维码
    self.ciImageView.image = [self lyc_createNonInterpolatedUIImageForCIImage:outputImg withSize:200] ;
    [self.view addSubview:self.ciImageView];
}
#pragma mark 生成二维码的方法
/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)lyc_createNonInterpolatedUIImageForCIImage:(CIImage *)ciImage withSize:(CGFloat)size
{
    CGRect exent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(exent), size/CGRectGetHeight(exent));
//    1. 创建bitmap
    size_t width = CGRectGetWidth(exent) *scale;
    size_t height = CGRectGetHeight(exent) * scale;
    CGColorSpaceRef cSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:exent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, exent, bitmapImage);
//    2. 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);;
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
    
}

#pragma mark 二维码的扫描

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
