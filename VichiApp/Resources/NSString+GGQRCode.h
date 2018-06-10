//
//  NSString+GGQRCode.h
//  VichiApp
//
//  Created by Angel on 06/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (GGQRCode)

-(UIImage *)qrCodeImage:(CGFloat)width height:(CGFloat)height;
-(UIImage *)qrCodeImage:(CGFloat)width height:(CGFloat)height scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;


@end
