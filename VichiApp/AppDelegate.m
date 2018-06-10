//
//  AppDelegate.m
//  VichiApp
//
//  Created by Hiren Dhamecha on 2/5/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "AppDelegate.h"
#import "VAConstant.h"
#import "EBBannerView.h"
#import "EBForeNotification.h"
#import <AVFoundation/AVFoundation.h>

@import Firebase;

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    [FIRApp configure];
    //[Fabric with:@[[Crashlytics class]]];

    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max)
    {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
#endif
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        //register to receive notifications
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSString *fcmToken = [[FIRInstanceID instanceID] token];
    NSLog(@"My Token :%@",fcmToken);
    
    [[NSUserDefaults standardUserDefaults] setValue:fcmToken forKey:PREF_DEVICE_TOKEN];
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
    NSString *userAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 10_3 like Mac OS X) AppleWebKit/603.1.23 (KHTML, like Gecko) Version/10.0 Mobile/14E5239e Safari/602";
    
    // set default user agent
    
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:userAgent,@"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:(dictionary)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dddd:) name:EBBannerViewDidClick object:nil];
    
    return YES;
}


-(NSString*)remaningTime:(NSDate*)startDate endDate:(NSDate*)endDate
{
    NSDateComponents *components;
    NSInteger days;
    NSInteger hour;
    NSInteger minutes;
    NSString *durationString;
    
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate: startDate toDate: endDate options: 0];
    
    days = [components day];
    hour = [components hour];
    minutes = [components minute];
    
//    if(days>0)
//    {
//        if(days>1)
//            durationString=[NSString stringWithFormat:@"%d days",days];
//        else
//            durationString=[NSString stringWithFormat:@"%d day",days];
//        //return durationString;
//    }
//    if(hour>0)
//    {
//        if(hour>1)
//            durationString=[NSString stringWithFormat:@"%d hours",hour];
//        else
//            durationString=[NSString stringWithFormat:@"%d hour",hour];
//        //return durationString;
//    }
//    if(minutes>0)
//    {
//        if(minutes>1)
//            durationString = [NSString stringWithFormat:@"%d minutes",minutes];
//        else
//            durationString = [NSString stringWithFormat:@"%d minute",minutes];
//        
//        //return durationString;
//    }
    
    NSString *strfinal=[NSString stringWithFormat:@"%ld D,%ld H,%ld M",(long)days,(long)hour,(long)minutes];
    
    return strfinal;
}
+ (AppDelegate*) getAppDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (BOOL) checkInternateConnection
{
    Reachability *reg = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [reg currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
        return NO;
    else
        return YES;
}

- (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    //@"[wW]{3}+.[a-zA-Z]{3,}+.[a-z]{2,}";
    @"((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}


#pragma mark - dddd :

-(void)dddd:(NSNotification*)noti
{
    NSLog(@"ddd,%@",noti);
}

//- (BOOL)application:(nonnull UIApplication *)application
//            openURL:(nonnull NSURL *)url
//            options:(nonnull NSDictionary<NSString *, id> *)options
//{
//    NSLog(@"code :%@",url);
//    NSString *strd=[NSString stringWithFormat:@"%@",url];
//    if([strd containsString:@"googleuser"])
//    {
//        return [[GIDSignIn sharedInstance] handleURL:url
//                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
//
//    }
//    else if([strd containsString:@"facebook"])
//    {
//         //return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
//        return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:options];
//
//    }else
//    {
//          return [[Twitter sharedInstance] application:application openURL:url options:options];
//    }
//
//
//}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"URL M :%@",url);
    NSString *strd=[NSString stringWithFormat:@"%@",url];
    
    return YES;
    
    
}


#pragma mark - Callback methods


#pragma mark -
#pragma mark - Push Notification Methods

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

//For interactive notification only
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

//-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
//{
//    NSString* strdeviceToken = [[NSString alloc]init];
//    strdeviceToken=[self stringWithDeviceToken:deviceToken];
//
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    [prefs setObject:strdeviceToken forKey:PREF_DEVICE_TOKEN];
//    [prefs synchronize];
//    //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Token " message:strdeviceToken delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//    //[alert show];
//    NSLog(@"My token is: %@",strdeviceToken);
//
//}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"121212121212121212" forKey:PREF_DEVICE_TOKEN];
    [prefs synchronize];
    NSLog(@"My token is: %@",[[NSUserDefaults standardUserDefaults] objectForKey:PREF_DEVICE_TOKEN]);
    
}

#pragma mark - local notification

- (void)application:(UIApplication *)application didReceiveLocalNotification:    (UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    
    application.applicationIconBadgeNumber = 0;
    //call your method that you want to do something in your app
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Push data :%@",userInfo);
    if(userInfo != nil)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:PREF_NOTIFY];
        [[NSUserDefaults standardUserDefaults] setValue:userInfo forKey:PREF_NOTIFICATION];
    }
    
    
//    NSMutableDictionary *aps=[userInfo valueForKey:@"aps"];
//    NSArray *ar=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_NOTIFICATION];
//    if(ar==nil)
//    {
//        NSMutableArray *ard=[[NSMutableArray alloc] init];
//        NSMutableDictionary *dictM=[[NSMutableDictionary alloc] init];
//        dictM=[aps valueForKey:@"alert"];
//        [ard addObject:dictM];
//        [[NSUserDefaults standardUserDefaults] setValue:ard forKey:PREF_NOTIFICATION];
//    }
//    else
//    {
//        NSMutableArray *ard=[[NSMutableArray alloc] initWithArray:ar];
//        NSMutableDictionary *dictM=[[NSMutableDictionary alloc] init];
//        dictM=[aps valueForKey:@"alert"];
//        [ard addObject:dictM];
//        [[NSUserDefaults standardUserDefaults] setValue:ard forKey:PREF_NOTIFICATION];
//    }
    
    //    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:[NSString stringWithFormat:@"%@",aps] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    //    [alert show];
    
    
    /*  NSMutableDictionary *aps=[userInfo valueForKey:@"aps"];
     NSMutableDictionary *msg=[aps valueForKey:@"message"];
     dictBillInfo=[msg valueForKey:@"bill"];
     is_walker_started=[[msg valueForKey:@"is_walker_started"] intValue];
     is_walker_arrived=[[msg valueForKey:@"is_walker_arrived"] intValue];
     is_started=[[msg valueForKey:@"is_walk_started"] intValue];
     is_completed=[[msg valueForKey:@"is_completed"] intValue];
     is_dog_rated=[[msg valueForKey:@"is_walker_rated"] intValue];
     if (dictBillInfo!=nil)
     {
     if (vcProvider)
     {
     [vcProvider.timerForCheckReqStatuss invalidate];
     [vcProvider.timerForTimeAndDistance invalidate];
     vcProvider.timerForTimeAndDistance=nil;
     vcProvider.timerForCheckReqStatuss=nil;
     }
     else
     {
     
     }
     
     }
     */
    
    
    //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",msg] message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:@"cancel", nil];
    //[alert show];
    
}
-(void)handleRemoteNitification:(UIApplication *)application userInfo:(NSDictionary *)userInfo
{
    // NSMutableDictionary *aps=[userInfo valueForKey:@"aps"];
    
    //   NSMutableDictionary *msg=[aps valueForKey:@"message"];
    // dictBillInfo=[msg valueForKey:@"bill"];
    //  is_walker_started=[[msg valueForKey:@"is_walker_started"] intValue];
    //  is_walker_arrived=[[msg valueForKey:@"is_walker_arrived"] intValue];
    //  is_started=[[msg valueForKey:@"is_walk_started"] intValue];
    //  is_completed=[[msg valueForKey:@"is_completed"] intValue];
    // is_dog_rated=[[msg valueForKey:@"is_walker_rated"] intValue];
    //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",msg] message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:@"cancel", nil];
    //[alert show];
    // if (vcProvider)
    // {
    //     [vcProvider checkDriverStatus];
    // }
    
}
- (NSString*)stringWithDeviceToken:(NSData*)deviceToken
{
    const char* data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    
    for (int i = 0; i < [deviceToken length]; i++)
    {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    return [token copy] ;
}

#pragma mark -
#pragma mark - sharedAppDelegate

+(AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark -
#pragma mark - Loading View

-(void)showLoadingWithTitle:(NSString *)title
{
    if (viewLoading==nil) {
        viewLoading=[[UIView alloc]initWithFrame:self.window.bounds];
        viewLoading.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7]; //[UIColor blackColor];
        //viewLoading.alpha=0.6f;
        
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((viewLoading.frame.size.width-50)/2, ((viewLoading.frame.size.height)/2)-30, 50, 20)];
        img.backgroundColor=[UIColor clearColor];
        [img setContentMode:UIViewContentModeScaleAspectFit];
        
        img.animationImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"loading_1.png"],[UIImage imageNamed:@"loading_2.png"],[UIImage imageNamed:@"loading_3.png"], nil];
        img.animationDuration = 1.0f;
        img.animationRepeatCount = 0;
        [img startAnimating];
        [viewLoading addSubview:img];
        
        UITextView *txt=[[UITextView alloc]initWithFrame:CGRectMake((viewLoading.frame.size.width-250)/2, ((viewLoading.frame.size.height-165)/2)+20, 255, 60)];
        txt.textAlignment=NSTextAlignmentCenter;
        txt.backgroundColor=[UIColor clearColor];
        txt.text=[title capitalizedString];
        txt.font=[UIFont systemFontOfSize:16];
        txt.userInteractionEnabled=FALSE;
        txt.scrollEnabled=FALSE;
        txt.textColor=[UIColor colorWithRed:239/255.0f green:71/255.0f blue:95/255.0f alpha:1];
        [viewLoading addSubview:txt];
    }
    
    [self.window addSubview:viewLoading];
    [self.window bringSubviewToFront:viewLoading];
    
    
}

-(void)hideLoadingView
{
    if (viewLoading) {
        [viewLoading removeFromSuperview];
        viewLoading=nil;
    }
}

-(void) showHUDLoadingView:(NSString *)strTitle
{
    if (HUD==nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.window];
        [self.window addSubview:HUD];
    }
    //HUD.delegate = self;
    //HUD.labelText = [strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    HUD.detailsLabelText=[strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    [HUD show:YES];
    
    
}

-(void) hideHUDLoadingView
{
    //[HUD removeFromSuperview];
    [HUD hide:YES];
}

-(void)showToastMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window
                                              animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}
#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */

#pragma mark -
#pragma mark - Directory Path Methods

- (NSString *)applicationCacheDirectoryString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return cacheDirectory;
}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


// [START ios_10_data_message_handling]
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Receive data message on iOS 10 devices while app is in the foreground.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage
{
    // Print full message
    NSLog(@"FIREBASE RECV MSG : %@", [remoteMessage appData]);
    //[audioPlayer stop];
    
    
}
#endif
// [END ios_10_data_message_handling]

// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification
{
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:refreshedToken forKey:PREF_DEVICE_TOKEN];
    [prefs synchronize];
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
}
// [END refresh_token]

// [START connect_to_fcm]
- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error)
     {
         if (error != nil) {
             NSLog(@"Unable to connect to FCM. %@", error);
         } else {
             NSLog(@"Connected to FCM.");
         }
     }];
    
}
// [END connect_to_fcm]

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    // Print message ID.
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    // Print full message.
    NSLog(@"%@", userInfo);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSLog(@"%@", userInfo);
    
    
}
#endif
// [END ios_10_message_handling]

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    // If you are receiving a notification message while your app is in the background,
//    // this callback will not be fired till the user taps on the notification launching the application.
//    // TODO: Handle data of notification
//
//    // With swizzling disabled you must let Messaging know about the message, for Analytics
//    // [[Messaging messaging] appDidReceiveMessage:userInfo];
//
//    // Print message ID.
////    if (userInfo[kGCMMessageIDKey]) {
////        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
////    }
//
//    // Print full message.
//    NSLog(@"%@", userInfo);
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    // If you are receiving a notification message while your app is in the background,
//    // this callback will not be fired till the user taps on the notification launching the application.
//    // TODO: Handle data of notification
//
//    // With swizzling disabled you must let Messaging know about the message, for Analytics
//    // [[Messaging messaging] appDidReceiveMessage:userInfo];
//
////    // Print message ID.
////    if (userInfo[kGCMMessageIDKey]) {
////        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
////    }
//
//    // Print full message.
//    NSLog(@"%@", userInfo);
//
//    completionHandler(UIBackgroundFetchResultNewData);
//}

// With "FirebaseAppDelegateProxyEnabled": NO
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler: (void (^)(UIBackgroundFetchResult))completionHandler
{
    
    NSLog(@"Push data :%@",userInfo);
    if(userInfo != nil)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:PREF_NOTIFY];
        [[NSUserDefaults standardUserDefaults] setValue:userInfo forKey:PREF_NOTIFICATION];
    }

  //  NSLog(@"userInfo %@",userInfo);
//    [[NSUserDefaults standardUserDefaults] setValue:userInfo forKey:PREF_NOTIFY];
    
    
    //    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"msg" message:[NSString stringWithFormat:@"%@",userInfo] delegate:nil
    //                                        cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    //
    //    [alert show];
    
    // Let FCM know about the message for analytics etc.
    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    // handle your message.
    
}

- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSLog(@"FCM registration token: %@", fcmToken);
    
    // TODO: If necessary send token to application server.
}


-(void)timerCalled
{
    NSLog(@"Timer Called");
    // Your Code
}


// With "FirebaseAppDelegateProxyEnabled": NO
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* strdeviceToken = [[NSString alloc]init];
    
    strdeviceToken=[self stringWithDeviceToken:deviceToken];
    NSLog(@"token:%@",strdeviceToken);
    [FIRMessaging messaging].APNSToken = deviceToken;
    
}

#pragma mark -
#pragma mark - encoded _ string by base64

- (NSString*)encodeStringTo64:(NSString*)fromString
{
    
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    NSLog(@"%@", base64String); // Zm9v
    return base64String;
}


#pragma mark -
#pragma mark - decode _ string by base64

- (NSString*)decodeStringTo64:(NSString*)fromString
{
    if(fromString !=nil)
    {
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:fromString options:1];
        NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", decodedString); // foo
        return decodedString;
    }
    else
    {
        return @"";
    }
    
}



#pragma mark-
#pragma mark- Font Descriptor

-(id)setBoldFontDiscriptor:(id)objc
{
    if([objc isKindOfClass:[UIButton class]])
    {
        UIButton *button=objc;
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0f];
        return button;
    }
    else if([objc isKindOfClass:[UITextField class]])
    {
        UITextField *textField=objc;
        textField.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0f];
        return textField;
        
    }
    else if([objc isKindOfClass:[UILabel class]])
    {
        UILabel *lable=objc;
        lable.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0f];
        return lable;
    }
    return objc;
}

- (void)userLoggedIn
{
    // Set the button title as "Log out"
    /*
     SignInVC *obj=[[SignInVC alloc]init];
     UIButton *loginButton = obj.btnFacebook;
     [loginButton setTitle:@"Log out" forState:UIControlStateNormal];
     */
    // Welcome message
    // [self showMessage:@"You're now logged in" withTitle:@"Welcome!"];
    
}


-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}





/**
 Returns the URL to the application's Documents directory.
 */


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.dronalaya.developer.VichiApp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"VichiApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"VichiApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
