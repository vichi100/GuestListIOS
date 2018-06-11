//
//  ViewController.m
//  VichiApp
//
//  Created by Hiren Dhamecha on 2/5/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "ViewController.h"
#import "VAConstant.h"
#import "SocketIO.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<UITextFieldDelegate,SocketIODelegate,CLLocationManagerDelegate>
{
     SocketIO *socketIO;
    int flagage;
    CLLocationManager *locationManager;
    
}
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCalled) userInfo:nil repeats:NO];
    
    flagage=0;
    self.navigationController.navigationBarHidden=YES;

    self.txtconfmob.inputAccessoryView=self.toolbar;
    self.txtmob.inputAccessoryView=self.toolbar;
    
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:IP_URL onPort:3080];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
 
}

-(void)timerCalled
{
    NSLog(@"Timer Called");
      [self performSegueWithIdentifier:SEGUE_TO_DIRECT_TO_HOME sender:nil];
    // Your Code
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    [self.btnage setImage:[UIImage imageNamed:@"ic_uchk"] forState:UIControlStateNormal];
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_ID];
    
    if(str !=nil)
    {
        [self performSegueWithIdentifier:SEGUE_TO_DIRECT_TO_HOME sender:nil];
    }
}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
  //  NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
    [NSUserDefaults.standardUserDefaults setValue:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:PREF_LAT];
    [NSUserDefaults.standardUserDefaults setValue:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:PREF_LONG];
    
}

#pragma mark - textfield :

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [UIView animateWithDuration:0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:nil];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(self.txtname==textField)
    {
        
        [UIView animateWithDuration:0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.view.frame = CGRectMake(0,-20, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:nil];
        
    }else if (self.txtconfmob==textField)
    {
        [UIView animateWithDuration:0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.view.frame = CGRectMake(0,-100, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:nil];
        
    }else
    {
        [UIView animateWithDuration:0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.view.frame = CGRectMake(0,-170, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:nil];
    }
    
}

#pragma mark - done btn :

- (IBAction)onClickforDone:(id)sender
{
    [self.txtmob resignFirstResponder];
    [self.txtconfmob resignFirstResponder];
    [UIView animateWithDuration:0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:nil];
    
}

#pragma mark -
#pragma mark - start activity :

- (IBAction)onClickforStartActivity:(id)sender
{
   if([self.txtmob.text isEqualToString:@""] || [self.txtname.text isEqualToString:@""])
   {
        [[AppDelegate sharedAppDelegate] showToastMessage:@"Please Enter All Fields !"];
   }
   else
   {
       
       if(![self.txtmob.text isEqualToString:self.txtconfmob.text])
       {
           [[AppDelegate sharedAppDelegate] showToastMessage:@"Mobile and Confirm Mobile Doesn't Match !"];
       }
       else
       {
           if(flagage==0)
           {
               [[AppDelegate sharedAppDelegate] showToastMessage:@"Please Confirm Your Age is 21 !"];
             
           }
           else
           {
               if([socketIO isConnected])
               {
                   NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                   [dict setObject:@"createNewCustomer" forKey:@"action"];
                   [dict setObject:self.txtname.text forKey:@"cutomername"];
                   [dict setObject:self.txtmob.text forKey:@"mobile"];

                   NSError * err;
                   NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
                   NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
                   NSLog(@" my json string : %@",myString);
                   [socketIO sendMessage:myString];
                   [[AppDelegate sharedAppDelegate] showLoadingWithTitle:@"please wait"];
               }
               else
               {
                   socketIO = [[SocketIO alloc] initWithDelegate:self];
                   [socketIO connectToHost:IP_URL onPort:3080];
                   NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                   [dict setObject:@"createNewCustomer" forKey:@"action"];
                   [dict setObject:self.txtname.text forKey:@"cutomername"];
                   [dict setObject:self.txtmob.text forKey:@"mobile"];
                   
                   NSError * err;
                   NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
                   NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
                   NSLog(@" my json string : %@",myString);
                   [socketIO sendMessage:myString];
                   [[AppDelegate sharedAppDelegate] showLoadingWithTitle:@"please wait"];
               }
           }
       }
   }
    
}

#pragma mark -
#pragma mark - socket delegate :

// message delegate
- (void) socketIO:(SocketIO *)socket didReceiveMessage:(NSString *)packet
{
    [[AppDelegate sharedAppDelegate] hideLoadingView];
    NSError *jsonError;
    NSData *objectData = [packet dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                          
                                                           error:&jsonError];
    
    [[AppDelegate sharedAppDelegate] hideLoadingView];
    NSLog(@"response Login  %@",json);
    
    if(json !=nil)
    {
        NSMutableDictionary *dictr=[[NSMutableDictionary alloc] init];
        [dictr setValue:self.txtname.text forKey:@"email"];
        [dictr setValue:self.txtmob.text forKey:@"mob"];
        [[NSUserDefaults standardUserDefaults] setValue:dictr forKey:PREF_USER_DATA];
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",[json valueForKey:@"customerId"]] forKey:PREF_USER_ID];
        [self performSegueWithIdentifier:SEGUE_REVEAL sender:nil];
    }
}


-(void)socketIODidConnect:(SocketIO *)socket
{
    //NSLog(@"connected !");
}

// event delegate
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    //NSLog(@"didReceiveEvent  >>> data: %@",packet);
    [[AppDelegate sharedAppDelegate] hideLoadingView];
    
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error
{
    // NSLog(@"didReceiveEvent >>> error : ");
    [[AppDelegate sharedAppDelegate] hideLoadingView];
}

- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    //NSLog(@"socket.io disconnected. did error occur? %@", error);
    [[AppDelegate sharedAppDelegate] hideLoadingView];
}

- (IBAction)onClickforAge:(id)sender
{
    if(flagage==0)
    {
        flagage=1;
        [self.btnage setImage:[UIImage imageNamed:@"ic_chk"] forState:UIControlStateNormal];
        
    }else
    {
        flagage=0;
        [self.btnage setImage:[UIImage imageNamed:@"ic_uchk"] forState:UIControlStateNormal];
    }
}

#pragma mark - memroy mgnt :

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
