//
//  EBBannerView.m
//  iOS-Foreground-Push-Notification
//
//  Created by wuxingchen on 0/7/21.
//  Copyright © 200年 57300022@qq.com. All rights reserved.
//

#import "EBBannerView.h"
#import "EBForeNotification.h"
#import "UIImage+ColorAtPoint.h"
#import "UILabel+ContentSize.h"
#import "UIImageView+Download.h"
//#import "TSConstants.h"
#import "AppDelegate.h"
#import "VAConstant.h"

@interface EBBannerView()
@property (weak, nonatomic) IBOutlet UIImageView *icon_image;
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UILabel *content_label;
@property (weak, nonatomic) IBOutlet UILabel *time_label;
@property (weak, nonatomic) IBOutlet UIView *line_view;
@property (weak, nonatomic) IBOutlet UIView *mask_view;
@property (nonatomic, assign)BOOL isDownSwiped;
@property (strong, nonatomic) IBOutlet UIImageView *imgItem;
@end

@implementation EBBannerView

#define BannerHeight 88
#define BannerHeightiOS10 88
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define WEAK_SELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

UIWindow *originWindow;

-(void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [self addGestureRecognizer];
    self.windowLevel = UIWindowLevelAlert;
    originWindow = [UIApplication sharedApplication].keyWindow;
    if (self.tag == 2) {
        //corner
        self.mask_view.layer.masksToBounds = YES;
        self.mask_view.layer.cornerRadius  = 10;
        self.mask_view.clipsToBounds       = YES;
        //shadow
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;

        self.mask_view.layer.shadowColor = [UIColor blackColor].CGColor;
        self.mask_view.layer.shadowOffset = CGSizeMake(0,0);
        self.mask_view.layer.shadowOpacity = 1;
        self.mask_view.layer.shadowRadius = 5;
        self.mask_view.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.mask_view.bounds cornerRadius:10].CGPath;
    }
}

-(void)setUserInfo:(NSDictionary *)userInfo
{
    _userInfo = userInfo;
  
    
    UIImage *appIcon;
    appIcon = [UIImage imageNamed:@"AppIcon60x60"];
    if (!appIcon) {
        appIcon = [UIImage imageNamed:@"AppIcon80x80"];
    }
    [self.icon_image setImage:appIcon];
    NSDictionary *infoDictionary = [[NSBundle bundleForClass:[self class]] infoDictionary];
    // app名称
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    if (!appName) {
        appName = [infoDictionary objectForKey:@"CFBundleName"];
    }
    //appName = @"input a app name here"; //if appName = nil, unsign this line and change it to you'r own app name.
    if (!appName) {
        assert(0);
    }
    
    
    // user info :
    
    if([userInfo objectForKey:@"aps"])
    {
        NSDictionary *alert=[[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        self.title_label.text=[NSString stringWithFormat:@"%@",[alert valueForKey:@"title"]];
        self.content_label.text=[NSString stringWithFormat:@"%@",[alert valueForKey:@"body"]];
    }
    
//    if([userInfo objectForKey:@"title"])
//    {
//        if([[userInfo valueForKey:@"type"] isEqualToString:@"sale"])
//        {
//            NSString *sttd=[[AppDelegate sharedAppDelegate] decodeStringTo64:[userInfo valueForKey:@"title"]];
//            NSString *newString=@"%";
//            
//            if([sttd containsString:@"Up"])
//            {
//                //NSString *strper=@"%";
//                 self.title_label.text=[NSString stringWithFormat:@"%@",sttd];
//                
//            }else if([sttd containsString:newString])
//            {
//                // NSString *newString=@"%";
//                 self.title_label.text=[NSString stringWithFormat:@"Up to %@ off",sttd];
//                
//            }else
//            {
//                NSString *newString=@"%";
//                 self.title_label.text=[NSString stringWithFormat:@"Up to %@ %@ off",sttd,newString];
//            }
//            
//            
//            //  NSString *newString = [[dict valueForKey:@"title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            //NSString *strper=@"%";
//            //cell.lblName.text=[NSString stringWithFormat:@"Up to %@ %@ off",newString,[dict valueForKey:@"title"]];
//            
//        }
//        else
//        {
//            NSString *sttd=[userInfo valueForKey:@"title"];
//            if([sttd containsString:@"+"])
//            {
//                 NSString *snamedtm=[[AppDelegate sharedAppDelegate] decodeStringTo64:[userInfo valueForKey:@"title"]];
//                //NSString *newString = [[userInfo valueForKey:@"title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//              //  NSString *strdm=[newString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
//                // NSString *utf8String = [[NSString alloc]initWithCString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"title"]] encoding:NSUTF8StringEncoding];
//                self.title_label.text=snamedtm;
//                
//            }else
//            {
//                //NSString *newString = [[userInfo valueForKey:@"title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                NSString *snamedtm=[[AppDelegate sharedAppDelegate] decodeStringTo64:[userInfo valueForKey:@"title"]];
//                self.title_label.text=snamedtm;
//                
//            }
//        }
//        //self.title_label.text   = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"title"]];
//    }
//    else
//    {
//        self.title_label.text   = @"Ghoast";
//    }

//    //self.content_label.text = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"shop_name"]];
//    
//    NSString *strd=[userInfo valueForKey:@"start"];
//    NSArray *arstart=[strd componentsSeparatedByString:@"-"];
//    
//    NSString *strend=[userInfo valueForKey:@"end"];
//    NSArray *arend=[strend componentsSeparatedByString:@"-"];
//    
//    if([userInfo objectForKey:@"start"] && [userInfo objectForKey:@"end"])
//    {
//       // self.time_label.text=[NSString stringWithFormat:@"%@/%@/%@ - %@/%@/%@",[arstart objectAtIndex:2],[arstart objectAtIndex:1],[arstart objectAtIndex:0],[arend objectAtIndex:2],[arend objectAtIndex:1],[arend objectAtIndex:0]];
//         NSString *snamedtm=[[AppDelegate sharedAppDelegate] decodeStringTo64:[userInfo valueForKey:@"shop_name"]];
//         self.content_label.text = [NSString stringWithFormat:@"%@ %@/%@/%@ to %@/%@/%@",snamedtm,[arstart objectAtIndex:2],[arstart objectAtIndex:1],[arstart objectAtIndex:0],[arend objectAtIndex:2],[arend objectAtIndex:1],[arend objectAtIndex:0]];
//        
//       // self.time_label.text = [NSString stringWithFormat:@"%@ - %@",[userInfo valueForKey:@"start"],[userInfo valueForKey:@"end"]];
//    }else
//    {
//        self.time_label.text=@"";
//    }
//    
//    // self.time_label.text=@"date : 05/06/1992";
//    
//    NSString *str=[userInfo valueForKey:@"image"];
//    if([str containsString:@","])
//    {
//        NSArray *ard=[str componentsSeparatedByString:@","];
//        NSLog(@"ard :%@",ard);
//        [self.imgItem  downloadFromURL:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[ard objectAtIndex:0]]  withPlaceholder:[UIImage imageNamed:@"Ghoast"]];
//        
//    }else
//    {
//        [self.imgItem downloadFromURL:[NSString stringWithFormat:@"%@%@",IMAGE_URL,str]  withPlaceholder:[UIImage imageNamed:@"Ghoast"]];
//    }
    // [self.imgItem downloadFromURL:[NSString stringWithFormat:@"%@",[userInfo valueForKey:@"image"]] withPlaceholder:[UIImage imageNamed:@"snap_img_icon"]];
    
    [originWindow makeKeyAndVisible];
//    if (!self.isIos10)
//    {
//        self.time_label.textColor      = [UIImage colorAtPoint:self.time_label.center];
//        self.time_label.alpha = 1;
//        CGPoint lineCenter = self.line_view.center;
//        self.line_view.backgroundColor = [UIImage colorAtPoint:CGPointMake(lineCenter.x, lineCenter.y - 7)];
//        self.line_view.alpha = 0.5;
//    }
    
    [self apperWithAnimation];
}

-(void)statusBarOrientationChange:(NSNotification *)notification
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 77);
}

-(void)addGestureRecognizer{
    UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpGesture:)];
    swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeUpGesture];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tapGesture];

    UISwipeGestureRecognizer *swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownGesture:)];
    swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeDownGesture];
}

-(void)tapGesture:(UITapGestureRecognizer*)tapGesture{
    [[NSNotificationCenter defaultCenter] postNotificationName:EBBannerViewDidClick object:self.userInfo];
    [self removeWithAnimation];
}

-(void)swipeUpGesture:(UISwipeGestureRecognizer*)gesture{
    if (gesture.direction == UISwipeGestureRecognizerDirectionUp) {
        [self removeWithAnimation];
    }
}

-(void)swipeDownGesture:(UISwipeGestureRecognizer*)gesture{
    if (!self.isIos10) {
        if (gesture.direction == UISwipeGestureRecognizerDirectionDown) {
            CGFloat originHeight = 0;
            self.isDownSwiped = YES;
            if (originHeight == 0) {
                originHeight = self.content_label.frame.size.height;
            }
            CGFloat caculatedHeight = [self.content_label caculatedSize].height;
            WEAK_SELF(weakSelf);
            [UIView animateWithDuration:BannerSwipeDownTime animations:^{
                weakSelf.frame = CGRectMake(0, 0, ScreenWidth, BannerHeight + caculatedHeight - originHeight);
            } completion:^(BOOL finished) {
                weakSelf.frame = CGRectMake(0, 0, ScreenWidth, BannerHeight + caculatedHeight - originHeight);
            }];
        }
    }
}

-(void)apperWithAnimation{
    CGFloat bannerHeight = self.isIos10 ? BannerHeightiOS10 : BannerHeight;
    self.frame = CGRectMake(0, 0, ScreenWidth, 0);
    WEAK_SELF(weakSelf);
    [UIView animateWithDuration:BannerSwipeUpTime animations:^{
        weakSelf.frame = CGRectMake(0, 0, ScreenWidth, bannerHeight);
    } completion:^(BOOL finished) {
        weakSelf.frame = CGRectMake(0, 0, ScreenWidth, bannerHeight);
    }];
    [NSTimer scheduledTimerWithTimeInterval:BannerStayTime target:self selector:@selector(removeWithAnimation) userInfo:nil repeats:NO];
}

-(void)removeWithAnimation{
    WEAK_SELF(weakSelf);
    [UIView animateWithDuration:BannerSwipeUpTime animations:^{
        for (UIView *view in weakSelf.subviews) {
            CGRect frame = view.frame;
            [view removeConstraints:view.constraints];
            view.frame = frame;
        }
        [weakSelf removeConstraints:self.constraints];
        weakSelf.frame = CGRectMake(0, 0, ScreenWidth, 0);
    } completion:^(BOOL finished) {
        weakSelf.frame = CGRectMake(0, 0, ScreenWidth, 0);
        [weakSelf removeFromSuperview];
        for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
            if ([window isKindOfClass:[EBBannerView class]]) {
                window.hidden = YES;
                [window resignKeyWindow];
                [window removeFromSuperview];
            }
        }
        SharedBannerView = nil;
    }];
}

+(UIViewController *)appRootViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

#pragma mark-
#pragma mark - get_string_to_date

-(NSString *)getStringtoDate :(NSString *)str
{
    NSDateFormatter * d1 = [[NSDateFormatter alloc] init];
    d1.dateFormat = @"yyyyMMddHHmmss";
    NSDate * date = [d1 dateFromString: str];
    d1.dateFormat = @"dd/MM/yyyy HH:mm";
    str = [d1 stringFromDate: date];
    return str;
    
}

@end
