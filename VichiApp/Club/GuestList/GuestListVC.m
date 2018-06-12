//
//  GuestListVC.m
//  VichiApp
//
//  Created by Angel on 06/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "GuestListVC.h"
#import "VAConstant.h"
#import "UIImageView+Download.h"
#import "SocketIO.h"
#import "AppDelegate.h"
#import "PaymentsSDK.h"
#import "AFNetworking.h"
#import "BookingConfirmClubVC.h"
#import "LoginVC.h"


@interface GuestListVC ()<SocketIODelegate>
{
    SocketIO *socketIO;
    NSString *strOption;
    NSString *strone,*strTwo;
    
}
@end

@implementation GuestListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
 
}

-(void)viewWillAppear:(BOOL)animated
{
    strone=@"no";
    strTwo=@"no";
    strOption=@"";
    
    self.imgProduct.clipsToBounds=YES;
    
    self.navigationController.navigationBarHidden=YES;
        self.tabBarController.tabBar.hidden = true;
    NSLog(@"still :%@",self.dictstore);
    NSString *dateStr;
    if([self.dictstore objectForKey:@"date"])
    {
        self.lblDate.text=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"date"]];
         dateStr= [NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"date"]];
    }
    else
    {
        self.lblDate.text=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"eventDate"]];
         dateStr= [NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"eventDate"]];
        
    }

    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MMM/yyyy"];
    
    NSDate *date = [dateFormat dateFromString:dateStr];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dayName = [dateFormatter stringFromDate:date];
    
    self.lblDay.text=dayName;
    
    if([self.dictmain objectForKey:@"imageURL"])
    {
            [self.imgProduct downloadFromURL:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[self.dictmain valueForKey:@"imageURL"]] withPlaceholder:[UIImage imageNamed:@"place"]];
    }else
    {
            [self.imgProduct downloadFromURL:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[self.dictstore valueForKey:@"imageURL"]] withPlaceholder:[UIImage imageNamed:@"place"]];
        
    }
    
    if([self.dictstore objectForKey:@"music"])
    {
        
        NSString *strdm = [NSString stringWithFormat:@"Music : %@",[self.dictstore valueForKey:@"music"]];
        NSMutableString *resultd = [strdm mutableCopy];
        [resultd enumerateSubstringsInRange:NSMakeRange(0, [resultd length])
                                    options:NSStringEnumerationByWords
                                 usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                     [resultd replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                            withString:[[substring substringToIndex:1] uppercaseString]];
                                 }];
        
        self.lblmusic.text=resultd;
        
        
    }else
    {
        self.lblmusic.text=[NSString stringWithFormat:@"Music : English / Bollywood "];
    }
    
}


#pragma mark - couple :

- (IBAction)onClickforcouple:(id)sender
{
    strone=@"One";
    [self.btncouple setImage:[UIImage imageNamed:@"radio_ck"] forState:UIControlStateNormal];
    [self.btngirls setImage:[UIImage imageNamed:@"radio_uck"] forState:UIControlStateNormal];
    strOption=self.btncouple.titleLabel.text;
    
}

#pragma mark - giris :

- (IBAction)onClickforOnlyGrils:(id)sender
{
    strTwo=@"only";
    [self.btncouple setImage:[UIImage imageNamed:@"radio_uck"] forState:UIControlStateNormal];
    [self.btngirls setImage:[UIImage imageNamed:@"radio_ck"] forState:UIControlStateNormal];
     strOption=self.btngirls.titleLabel.text;
}

#pragma mark - back :

- (IBAction)onClickforBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickforBookingUpdate:(id)sender
{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_ID];
    if(str != nil)
    {
        
        
        if([strOption isEqualToString:@""])
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"please Select any Option !" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        else
        {
            if([socketIO isConnected])
            {
                
                NSString *strdate;
                if([self.dictstore objectForKey:@"date"])
                {
                    strdate=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"date"]];
                }
                else
                {
                    strdate=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"eventDate"]];
                }
                
                
                NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]); //double
                long digits = (long)time; //first 10 digits
                int decimalDigits = (int)(fmod(time, 1) * 1000); //3 missing digits
                /*** long ***/
                long timestamp = (digits * 1000) + decimalDigits;
                /*** string ***/
                NSString *timestampString = [NSString stringWithFormat:@"%ld%03d",digits ,decimalDigits];
                
                NSString *strcid=[[NSUserDefaults standardUserDefaults]objectForKey:PREF_USER_ID];
                NSDictionary *dictro=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_DATA];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@"inserOrderDetails" forKey:@"action"];
                [dict setObject:@"guest list" forKey:@"tickettype"];
                [dict setObject:[NSString stringWithFormat:@"%@",strOption] forKey:@"ticketDetails"];
                [dict setObject:[NSString stringWithFormat:@"%@",strdate] forKey:@"date"];
                [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubid"]] forKey:@"clubid"];
                [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubname"]] forKey:@"clubname"];
                [dict setObject:[NSString stringWithFormat:@"%@",timestampString] forKey:@"QRnumber"];
                [dict setObject:[NSString stringWithFormat:@"%@",[dictro valueForKey:@"email"]] forKey:@"cutomername"];
                [dict setObject:[NSString stringWithFormat:@"%@",[dictro valueForKey:@"mob"]] forKey:@"mobile"];
                [dict setObject:strcid forKey:@"customerId"];
                [dict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"cost"];
                
                [dict setObject:@"0" forKey:@"paidamount"];
                [dict setObject:@"0" forKey:@"remainingamount"];
                [dict setObject:@"0" forKey:@"discount"];
                [dict setObject:@"0" forKey:@"costafterdiscount"];
                
                NSError * err;
                NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
                NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
                NSLog(@" my json string : %@",myString);
                [socketIO sendMessage:myString];
                [[AppDelegate sharedAppDelegate] showLoadingWithTitle:@"please wait"];
                
            }
            else
            {
                NSString *strdate;
                if([self.dictstore objectForKey:@"date"])
                {
                    strdate=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"date"]];
                }
                else
                {
                    strdate=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"eventDate"]];
                }
                
                socketIO = [[SocketIO alloc] initWithDelegate:self];
                [socketIO connectToHost:IP_URL onPort:3080];
                
                NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]); //double
                long digits = (long)time; //first 10 digits
                int decimalDigits = (int)(fmod(time, 1) * 1000); //3 missing digits
                /*** long ***/
                long timestamp = (digits * 1000) + decimalDigits;
                /*** string ***/
                NSString *timestampString = [NSString stringWithFormat:@"%ld%03d",digits ,decimalDigits];
                
                NSString *strcid=[[NSUserDefaults standardUserDefaults]objectForKey:PREF_USER_ID];
                NSDictionary *dictro=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_DATA];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@"inserOrderDetails" forKey:@"action"];
                [dict setObject:@"guest list" forKey:@"tickettype"];
                [dict setObject:[NSString stringWithFormat:@"%@",strOption] forKey:@"ticketDetails"];
                [dict setObject:[NSString stringWithFormat:@"%@",strdate] forKey:@"date"];
                [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubid"]] forKey:@"clubid"];
                [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubname"]] forKey:@"clubname"];
                [dict setObject:[NSString stringWithFormat:@"%@",timestampString] forKey:@"QRnumber"];
                [dict setObject:[NSString stringWithFormat:@"%@",[dictro valueForKey:@"email"]] forKey:@"cutomername"];
                [dict setObject:[NSString stringWithFormat:@"%@",[dictro valueForKey:@"mob"]] forKey:@"mobile"];
                [dict setObject:strcid forKey:@"customerId"];
                [dict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"cost"];
                
                [dict setObject:@"0" forKey:@"paidamount"];
                [dict setObject:@"0" forKey:@"remainingamount"];
                [dict setObject:@"0" forKey:@"discount"];
                [dict setObject:@"0" forKey:@"costafterdiscount"];
                
                NSError * err;
                NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
                NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
                NSLog(@" my json string : %@",myString);
                [socketIO sendMessage:myString];
                [[AppDelegate sharedAppDelegate] showLoadingWithTitle:@"please wait"];
            }
            
        }
    }else
    {
        LoginVC *add = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:add animated:YES completion:nil];
        
    }
}
- (IBAction)dobooking:(id)sender
{
    NSLog(@"ram 2!");
}

- (IBAction)onClickforBooked:(id)sender
{
    NSLog(@"ram !");
}

- (IBAction)onClickforBooking:(id)sender
{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_ID];
    if(str != nil)
    {
        
    
    if([strOption isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"please Select any Option !" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else
    {
        if([socketIO isConnected])
        {
            
            NSString *strdate;
            if([self.dictstore objectForKey:@"date"])
            {
                strdate=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"date"]];
            }
            else
            {
                strdate=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"eventDate"]];
            }
            
            
            NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]); //double
            long digits = (long)time; //first 10 digits
            int decimalDigits = (int)(fmod(time, 1) * 1000); //3 missing digits
            /*** long ***/
            long timestamp = (digits * 1000) + decimalDigits;
            /*** string ***/
            NSString *timestampString = [NSString stringWithFormat:@"%ld%03d",digits ,decimalDigits];
            
            NSString *strcid=[[NSUserDefaults standardUserDefaults]objectForKey:PREF_USER_ID];
            NSDictionary *dictro=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_DATA];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"inserOrderDetails" forKey:@"action"];
            [dict setObject:@"guest list" forKey:@"tickettype"];
            [dict setObject:[NSString stringWithFormat:@"%@",strOption] forKey:@"ticketDetails"];
            [dict setObject:[NSString stringWithFormat:@"%@",strdate] forKey:@"date"];
            [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubid"]] forKey:@"clubid"];
            [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubname"]] forKey:@"clubname"];
            [dict setObject:[NSString stringWithFormat:@"%@",timestampString] forKey:@"QRnumber"];
            [dict setObject:[NSString stringWithFormat:@"%@",[dictro valueForKey:@"email"]] forKey:@"cutomername"];
            [dict setObject:[NSString stringWithFormat:@"%@",[dictro valueForKey:@"mob"]] forKey:@"mobile"];
            [dict setObject:strcid forKey:@"customerId"];
            [dict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"cost"];
            
            [dict setObject:@"0" forKey:@"paidamount"];
            [dict setObject:@"0" forKey:@"remainingamount"];
            [dict setObject:@"0" forKey:@"discount"];
            [dict setObject:@"0" forKey:@"costafterdiscount"];
            
            NSError * err;
            NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
            NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
            NSLog(@" my json string : %@",myString);
            [socketIO sendMessage:myString];
            [[AppDelegate sharedAppDelegate] showLoadingWithTitle:@"please wait"];
            
        }
        else
        {
            NSString *strdate;
            if([self.dictstore objectForKey:@"date"])
            {
                strdate=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"date"]];
            }
            else
            {
                strdate=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"eventDate"]];
            }
            
            socketIO = [[SocketIO alloc] initWithDelegate:self];
            [socketIO connectToHost:IP_URL onPort:3080];
            
            NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]); //double
            long digits = (long)time; //first 10 digits
            int decimalDigits = (int)(fmod(time, 1) * 1000); //3 missing digits
            /*** long ***/
            long timestamp = (digits * 1000) + decimalDigits;
            /*** string ***/
            NSString *timestampString = [NSString stringWithFormat:@"%ld%03d",digits ,decimalDigits];
            
            NSString *strcid=[[NSUserDefaults standardUserDefaults]objectForKey:PREF_USER_ID];
            NSDictionary *dictro=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_DATA];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"inserOrderDetails" forKey:@"action"];
            [dict setObject:@"guest list" forKey:@"tickettype"];
            [dict setObject:[NSString stringWithFormat:@"%@",strOption] forKey:@"ticketDetails"];
            [dict setObject:[NSString stringWithFormat:@"%@",strdate] forKey:@"date"];
            [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubid"]] forKey:@"clubid"];
            [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubname"]] forKey:@"clubname"];
            [dict setObject:[NSString stringWithFormat:@"%@",timestampString] forKey:@"QRnumber"];
            [dict setObject:[NSString stringWithFormat:@"%@",[dictro valueForKey:@"email"]] forKey:@"cutomername"];
            [dict setObject:[NSString stringWithFormat:@"%@",[dictro valueForKey:@"mob"]] forKey:@"mobile"];
            [dict setObject:strcid forKey:@"customerId"];
            [dict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"cost"];
            
            [dict setObject:@"0" forKey:@"paidamount"];
            [dict setObject:@"0" forKey:@"remainingamount"];
            [dict setObject:@"0" forKey:@"discount"];
            [dict setObject:@"0" forKey:@"costafterdiscount"];
            
            NSError * err;
            NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
            NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
            NSLog(@" my json string : %@",myString);
            [socketIO sendMessage:myString];
            [[AppDelegate sharedAppDelegate] showLoadingWithTitle:@"please wait"];
        }

    }
    }else
    {
        LoginVC *add = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:add animated:YES completion:nil];
        
    }
   // [self performSegueWithIdentifier:SEGUE_TO_BOOK_GUEST sender:nil];
    
}

#pragma mark -
#pragma mark - socket delegate :

// message delegate
- (void) socketIO:(SocketIO *)socket didReceiveMessage:(NSString *)packet
{
    [[AppDelegate sharedAppDelegate] hideLoadingView];
    NSError *jsonError;
    NSData *objectData = [packet dataUsingEncoding:NSUTF8StringEncoding];
    NSString* newStr = [[NSString alloc] initWithData:objectData encoding:NSUTF8StringEncoding];
    
    NSLog(@"newStr : >>  %@",newStr);
    if([newStr isEqualToString:@"success"])
    {
        [self performSegueWithIdentifier:SEGUE_TO_BOOK_GUEST sender:nil];
        
    }else if([newStr isEqualToString:@"fail"]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"You have already booked Guest list !!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }else if([newStr isEqualToString:@"sold out"]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Sold Out, Please Book Pass !!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                          
                                                           error:&jsonError];
    
    NSLog(@"response : >>  %@",json);
    if(json !=nil)
    {
        
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


#pragma mark -
#pragma mark - preppare :

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SEGUE_TO_BOOK_GUEST])
    {
        BookingConfirmClubVC *bv=[segue destinationViewController];
        bv.dictClub=self.dictstore;
        bv.strCouple=[NSString stringWithFormat:@"%@",strone];
        bv.strGirl=[NSString stringWithFormat:@"%@",strTwo];
        bv.strStage=@"no";
        bv.sttype=@"1";
        bv.dictMain=self.dictmain;
        
    }
    
    
}

#pragma mark - memroy mgnt :

- (void)didReceiveMemoryWarning
{
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

- (IBAction)onClickforCpl:(id)sender
{
    NSLog(@"cpl");
}

- (IBAction)onClickforGirlMax:(id)sender
{
    NSLog(@"cgirl");

}

- (IBAction)onClickforBackUpdated:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)mybooking:(id)sender
{
      NSLog(@"booking");
}

@end

