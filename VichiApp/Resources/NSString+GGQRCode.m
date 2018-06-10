//
//  NSString+GGQRCode.m
//  VichiApp
//
//  Created by Angel on 06/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "NSString+GGQRCode.h"

@implementation NSString (GGQRCode)


-(UIImage *)qrCodeImage:(CGFloat)width height:(CGFloat)height
{
    return [self qrCodeImage:width height:height scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}

-(UIImage *)qrCodeImage:(CGFloat)width height:(CGFloat)height scale:(CGFloat)scale orientation:(UIImageOrientation)orientation
{
    NSData *stringData = [self dataUsingEncoding: NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    float scaleX = width / qrImage.extent.size.width;
    float scaleY = height / qrImage.extent.size.height;
    
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:qrImage scale:scale orientation:orientation];
}

@end
