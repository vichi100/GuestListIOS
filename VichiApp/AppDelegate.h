//
//  AppDelegate.h
//  VichiApp
//
//  Created by Hiren Dhamecha on 2/5/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MBProgressHUD.h"
#import "Reachability.h"

@import Firebase;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MBProgressHUD *HUD;
    UIView *viewLoading;
    UINavigationController *navigation;
}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (BOOL) checkInternateConnection;
+ (AppDelegate*) getAppDelegate;
+(AppDelegate *)sharedAppDelegate;

-(void) showHUDLoadingView:(NSString *)strTitle;
-(void) hideHUDLoadingView;
-(void)showToastMessage:(NSString *)message;

-(void)showLoadingWithTitle:(NSString *)title;
-(void)hideLoadingView;
-(id)setBoldFontDiscriptor:(id)objc;

- (void)userLoggedIn;
- (NSString *)applicationCacheDirectoryString;
- (BOOL)connected;

-(BOOL) NSStringIsValidEmail:(NSString *)checkString;
- (BOOL) validateUrl: (NSString *) candidate;
- (NSString*)encodeStringTo64:(NSString*)fromString;
- (NSString*)decodeStringTo64:(NSString*)fromString;
-(NSString*)remaningTime:(NSDate*)startDate endDate:(NSDate*)endDate;


@end

