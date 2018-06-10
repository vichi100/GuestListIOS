//
//  ClubPassVC.m
//  VichiApp
//
//  Created by Angel on 06/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "ClubPassVC.h"
#import "VAConstant.h"
#import "AppDelegate.h"
#import "PaymentsSDK.h"
#import "AFNetworking.h"
#import "SocketIO.h"
#import "BookingConfirmClubVC.h"
#import "UIImageView+Download.h"
#import "LoginVC.h"

@interface ClubPassVC ()<SocketIODelegate,PGTransactionDelegate>
{
    int one,two,three;
    NSString *strChecksum,*strOrderId;
    SocketIO *socketIO;
    NSString *strTotal;
    NSString *strAmount;
    NSString *strCost;
}
@end

@implementation ClubPassVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    one=0;
    two=0;
    three=0;
    NSLog(@"Pass :%@",self.dictstore);
    strChecksum=@"";
    self.imgItem.clipsToBounds=YES;

}


#pragma mark - viewWillAppear

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
        self.tabBarController.tabBar.hidden = true;
     self.navigationItem.hidesBackButton=YES;
    
    if([self.dictMain objectForKey:@"offerForPass"])
    {
        [self.imgItem downloadFromURL:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[self.dictMain valueForKey:@"imageURL"]] withPlaceholder:[UIImage imageNamed:@"place"]];
      
    }else
    {
          [self.imgItem downloadFromURL:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[self.dictstore valueForKey:@"imageURL"]] withPlaceholder:[UIImage imageNamed:@"place"]];
   
    }
    self.imgItem.clipsToBounds=YES;
    self.lblDate.text=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"date"]];
   
    NSString *dateStr = [NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"date"]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MMM/yyyy"];
    
    NSDate *date = [dateFormat dateFromString:dateStr];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dayName = [dateFormatter stringFromDate:date];
    self.lblDay.text=dayName;
    NSString *strp =@"%";
    
    if([self.dictMain objectForKey:@"offerForPass"])
    {
        self.lbdiscount.text =[NSString stringWithFormat:@"%@%@ Discount will apply on passes",[self.dictMain valueForKey:@"offerForPass"],strp];
    }
    
}

- (IBAction)onClcikforBack:(id)sender
{
     [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickforMinusone:(id)sender
{
    if(one>0)
    {
        one--;
        self.lblone.text=[NSString stringWithFormat:@"%d",one];
    }else
    {
        one=0;
        self.lblone.text=[NSString stringWithFormat:@"%d",one];
    }
    
    NSString *strpr=@"%";
    if([self.dictMain objectForKey:@"offerForPass"])
    {
        int str15 = 1500 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int coupleone = 1500 - str15;
        
        int str10 = 1000 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int stage = 1000 - str10;
        
        int str50 = 500 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int girl = 500 - str50;
        
        int total=[self.lblone.text intValue]*coupleone+[self.lbltwo.text intValue]*stage+[self.lblthree.text intValue]*girl;
        
        strTotal=[NSString stringWithFormat:@"%d",total];
        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER AFTER %@%@ DISCOUNT",total,[self.dictMain valueForKey:@"offerForPass"],strpr];
        
        int totalFinal=[self.lblone.text intValue]*1500+[self.lbltwo.text intValue]*1000+[self.lblthree.text intValue]*500;
        strCost=[NSString stringWithFormat:@"%d",totalFinal];
    }else
    {
        int total=[self.lblone.text intValue]*1500+[self.lbltwo.text intValue]*1000+[self.lblthree.text intValue]*500;
        strTotal=[NSString stringWithFormat:@"%d",total];
        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER",total];
    }
    
//     int total=[self.lblone.text intValue]*1500+[self.lbltwo.text intValue]*1000+[self.lblthree.text intValue]*500;
//     strTotal=[NSString stringWithFormat:@"%d",total];
// //   self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER",total];
//    NSString *strpr=@"%";
//    if([self.dictMain objectForKey:@"offerForPass"])
//    {
//        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER AFTER %@%@ DISCOUNT",total,[self.dictMain valueForKey:@"offerForPass"],strpr];
//    }else
//    {
//        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER",total];
//    }
    
}

- (IBAction)onClickforPlusOne:(id)sender
{
    if(one>=0)
    {
        one++;
        if(one >= 4){
            one=3;
            return;
            
        }
        self.lblone.text=[NSString stringWithFormat:@"%d",one];
    }else
    {
        one=0;
        self.lblone.text=[NSString stringWithFormat:@"%d",one];
    }
   
    NSString *strpr=@"%";
    if([self.dictMain objectForKey:@"offerForPass"])
    {
        int str15 = 1500 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int coupleone = 1500 - str15;
        
        int str10 = 1000 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int stage = 1000 - str10;
        
        int str50 = 500 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int girl = 500 - str50;
        
        int total=[self.lblone.text intValue]*coupleone+[self.lbltwo.text intValue]*stage+[self.lblthree.text intValue]*girl;
        
        strTotal=[NSString stringWithFormat:@"%d",total];
        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER AFTER %@%@ DISCOUNT",total,[self.dictMain valueForKey:@"offerForPass"],strpr];
        
          int totalFinal=[self.lblone.text intValue]*1500+[self.lbltwo.text intValue]*1000+[self.lblthree.text intValue]*500;
            strCost=[NSString stringWithFormat:@"%d",totalFinal];
        
    }else
    {
        int total=[self.lblone.text intValue]*1500+[self.lbltwo.text intValue]*1000+[self.lblthree.text intValue]*500;
        strTotal=[NSString stringWithFormat:@"%d",total];
        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER",total];
    }
}

- (IBAction)onClickforMinusTwo:(id)sender
{
    if(two>0)
    {
        two--;
        self.lbltwo.text=[NSString stringWithFormat:@"%d",two];
    }else
    {
        two=0;
        self.lbltwo.text=[NSString stringWithFormat:@"%d",two];
    }
    
    NSString *strpr=@"%";
    if([self.dictMain objectForKey:@"offerForPass"])
    {
        int str15 = 1500 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int coupleone = 1500 - str15;
        
        int str10 = 1000 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int stage = 1000 - str10;
        
        int str50 = 500 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int girl = 500 - str50;
        
        int total=[self.lblone.text intValue]*coupleone+[self.lbltwo.text intValue]*stage+[self.lblthree.text intValue]*girl;
        
        strTotal=[NSString stringWithFormat:@"%d",total];
        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER AFTER %@%@ DISCOUNT",total,[self.dictMain valueForKey:@"offerForPass"],strpr];
        int totalFinal=[self.lblone.text intValue]*1500+[self.lbltwo.text intValue]*1000+[self.lblthree.text intValue]*500;
        strCost=[NSString stringWithFormat:@"%d",totalFinal];
        
    }else
    {
        int total=[self.lblone.text intValue]*1500+[self.lbltwo.text intValue]*1000+[self.lblthree.text intValue]*500;
        strTotal=[NSString stringWithFormat:@"%d",total];
        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER",total];
    }
    
//    int total=[self.lblone.text intValue]*1500+[self.lbltwo.text intValue]*1000+[self.lblthree.text intValue]*500;
//     strTotal=[NSString stringWithFormat:@"%d",total];
//
//    NSString *strpr=@"%";
//    if([self.dictMain objectForKey:@"offerForPass"])
//    {
//        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER AFTER %@%@ DISCOUNT",total,[self.dictMain valueForKey:@"offerForPass"],strpr];
//    }else
//    {
//        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER",total];
//    }
    //self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER",total];
}

- (IBAction)onClickforPlusTwo:(id)sender
{
    if(two>=0)
    {
        two++;
        if(two >= 3){
            two=2;
            return;
        }
        self.lbltwo.text=[NSString stringWithFormat:@"%d",two];
    }else
    {
        two=0;
        self.lbltwo.text=[NSString stringWithFormat:@"%d",two];
    }
    
    NSString *strpr=@"%";
    if([self.dictMain objectForKey:@"offerForPass"])
    {
        int str15 = 1500 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int coupleone = 1500 - str15;
        
        int str10 = 1000 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int stage = 1000 - str10;
        
        int str50 = 500 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int girl = 500 - str50;
        
        int total=[self.lblone.text intValue]*coupleone+[self.lbltwo.text intValue]*stage+[self.lblthree.text intValue]*girl;
        
        strTotal=[NSString stringWithFormat:@"%d",total];
        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER AFTER %@%@ DISCOUNT",total,[self.dictMain valueForKey:@"offerForPass"],strpr];
        int totalFinal=[self.lblone.text intValue]*1500+[self.lbltwo.text intValue]*1000+[self.lblthree.text intValue]*500;
        strCost=[NSString stringWithFormat:@"%d",totalFinal];
    }else
    {
        int total=[self.lblone.text intValue]*1500+[self.lbltwo.text intValue]*1000+[self.lblthree.text intValue]*500;
        strTotal=[NSString stringWithFormat:@"%d",total];
        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER",total];
    }
    
//    int total=[self.lblone.text intValue]*1500+[self.lbltwo.text intValue]*1000+[self.lblthree.text intValue]*500;
//     strTotal=[NSString stringWithFormat:@"%d",total];
//    //self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER",total];
//
//    NSString *strpr=@"%";
//    if([self.dictMain objectForKey:@"offerForPass"])
//    {
//        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER AFTER %@%@ DISCOUNT",total,[self.dictMain valueForKey:@"offerForPass"],strpr];
//    }else
//    {
//        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER",total];
//    }
}

- (IBAction)onClickforPlusThree:(id)sender
{
    if(three>=0)
    {
        three++;
        if(three >= 4){
            three=3;
            return;
        }
        self.lblthree.text=[NSString stringWithFormat:@"%d",three];
    }else
    {
        three=0;
        self.lblthree.text=[NSString stringWithFormat:@"%d",three];
    }
    
    NSString *strpr=@"%";
    if([self.dictMain objectForKey:@"offerForPass"])
    {
        int str15 = 1500 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int coupleone = 1500 - str15;
        
        int str10 = 1000 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int stage = 1000 - str10;
        
        int str50 = 500 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int girl = 500 - str50;
        
        int total=[self.lblone.text intValue]*coupleone+[self.lbltwo.text intValue]*stage+[self.lblthree.text intValue]*girl;
        
        strTotal=[NSString stringWithFormat:@"%d",total];
        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER AFTER %@%@ DISCOUNT",total,[self.dictMain valueForKey:@"offerForPass"],strpr];
        int totalFinal=[self.lblone.text intValue]*1500+[self.lbltwo.text intValue]*1000+[self.lblthree.text intValue]*500;
        strCost=[NSString stringWithFormat:@"%d",totalFinal];
    }else
    {
        int total=[self.lblone.text intValue]*1500+[self.lbltwo.text intValue]*1000+[self.lblthree.text intValue]*500;
        strTotal=[NSString stringWithFormat:@"%d",total];
        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER",total];
    }
//   int total=[self.lblone.text intValue]*1500+[self.lbltwo.text intValue]*1000+[self.lblthree.text intValue]*500;
//     strTotal=[NSString stringWithFormat:@"%d",total];
//   // self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER",total];
//
//    NSString *strpr=@"%";
//    if([self.dictMain objectForKey:@"offerForPass"])
//    {
//        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER AFTER %@%@ DISCOUNT",total,[self.dictMain valueForKey:@"offerForPass"],strpr];
//    }else
//    {
//        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER",total];
//    }
    
}

- (IBAction)onClickofrMinusThree:(id)sender
{
    if(three>0)
    {
        three--;
        self.lblthree.text=[NSString stringWithFormat:@"%d",three];
    }else
    {
        three=0;
        self.lblthree.text=[NSString stringWithFormat:@"%d",three];
    }
    
    NSString *strpr=@"%";
    if([self.dictMain objectForKey:@"offerForPass"])
    {
        int str15 = 1500 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int coupleone = 1500 - str15;
        
        int str10 = 1000 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int stage = 1000 - str10;
        
        int str50 = 500 * [[self.dictMain valueForKey:@"offerForPass"] floatValue]/100;
        int girl = 500 - str50;
        
        int total=[self.lblone.text intValue]*coupleone+[self.lbltwo.text intValue]*stage+[self.lblthree.text intValue]*girl;
        
        strTotal=[NSString stringWithFormat:@"%d",total];
        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER AFTER %@%@ DISCOUNT",total,[self.dictMain valueForKey:@"offerForPass"],strpr];
        int totalFinal=[self.lblone.text intValue]*1500+[self.lbltwo.text intValue]*1000+[self.lblthree.text intValue]*500;
        strCost=[NSString stringWithFormat:@"%d",totalFinal];
    }else
    {
        int total=[self.lblone.text intValue]*1500+[self.lbltwo.text intValue]*1000+[self.lblthree.text intValue]*500;
        strTotal=[NSString stringWithFormat:@"%d",total];
        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER",total];
    }
    
//    int total=[self.lblone.text intValue]*1500+[self.lbltwo.text intValue]*1000+[self.lblthree.text intValue]*500;
//     strTotal=[NSString stringWithFormat:@"%d",total];
//
//    NSString *strpr=@"%";
//    if([self.dictMain objectForKey:@"offerForPass"])
//    {
//        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER AFTER %@%@ DISCOUNT",total,[self.dictMain valueForKey:@"offerForPass"],strpr];
//    }else
//    {
//        self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER",total];
//    }
    
   // self.lblTotal.text=[NSString stringWithFormat:@"%d Rs FULL COVER",total];
    
}

#pragma mark - book :

- (IBAction)onClickforBook:(id)sender
{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_ID];
    if(str != nil)
    {
        
    if([strTotal isEqualToString:@""] || [strTotal intValue]==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Please book any pass !" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
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
        
        NSString *dateStr = [NSString stringWithFormat:@"%@",strdate];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MMM/yyyy"];
        
        NSDate *date = [dateFormat dateFromString:dateStr];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE"];
        NSString *dayName = [dateFormatter stringFromDate:date];
        
        if([socketIO isConnected])
        {
            
            NSString *strType;
            
            if([self.dictstore objectForKey:@"music"])
            {
                strType=[NSString stringWithFormat:@"%@",[self.dictstore objectForKey:@"music"]];
                
            }else
            {
                strType=[NSString stringWithFormat:@"%@",[self.dictstore objectForKey:@"offerfor"]];
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
            [dict setObject:@"pass" forKey:@"tickettype"];
            
            
            NSString *strFinal =@"";
            if(one != 0)
            {
                strFinal= [NSString stringWithFormat:@"%d couple ",one];
            }
            
            if(three != 0)
            {
                if([strFinal isEqualToString:@""])
                {
                    strFinal = [NSString stringWithFormat:@"%d girl",three];
                }
                else
                {
                    strFinal=[NSString stringWithFormat:@"%@ and %d girl",strFinal,three];
                }
            }
            if(two !=0)
            {
                if([strFinal isEqualToString:@""])
                {
                    strFinal = [NSString stringWithFormat:@"%@ %d stag",strFinal,two];
                }
                else
                {
                     strFinal = [NSString stringWithFormat:@"%@ and %d stag",strFinal,two];
                }
            }
            
            if(![strFinal isEqualToString:@""])
            {
                strFinal = [NSString stringWithFormat:@"%@ is allowed",strFinal];
            }
           
            NSLog(@"final :%@",strFinal);
            
            [dict setObject:strFinal forKey:@"ticketDetails"];
            [dict setObject:[NSString stringWithFormat:@"%@",strdate] forKey:@"date"];
            [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubid"]] forKey:@"clubid"];
            [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubname"]] forKey:@"clubname"];
            [dict setObject:[NSString stringWithFormat:@"%@",timestampString] forKey:@"QRnumber"];
            [dict setObject:[NSString stringWithFormat:@"%@",[dictro valueForKey:@"email"]] forKey:@"cutomername"];
            [dict setObject:[NSString stringWithFormat:@"%@",[dictro valueForKey:@"mob"]] forKey:@"mobile"];
            [dict setObject:strcid forKey:@"customerId"];
            
            
            //[dict setObject:@"0" forKey:@"paidamount"];
           // [dict setObject:@"0" forKey:@"remainingamount"];
             [dict setObject:[NSString stringWithFormat:@"%@",strTotal] forKey:@"costafterdiscount"];
           
            if([self.dictMain objectForKey:@"offerForPass"])
            {
                [dict setObject:[NSString stringWithFormat:@"%@",strCost] forKey:@"cost"];
                [dict setObject:[NSString stringWithFormat:@"%@",[self.dictMain valueForKey:@"offerForPass"]] forKey:@"discount"];
                [dict setObject:strTotal forKey:@"paidamount"];
                [dict setObject:@"0" forKey:@"remainingamount"];
                
            }else
            {
                [dict setObject:[NSString stringWithFormat:@"%@",strTotal] forKey:@"cost"];
                [dict setObject:@"0" forKey:@"discount"];
                [dict setObject:strTotal forKey:@"paidamount"];
                [dict setObject:@"0" forKey:@"remainingamount"];
            }
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
           
            
            NSString *strType;
            
//            if([self.dictstore objectForKey:@"music"])
//            {
//                strType=[NSString stringWithFormat:@"%@",[self.dictstore objectForKey:@"music"]];
//
//            }else
//            {
//                strType=[NSString stringWithFormat:@"%@",[self.dictstore objectForKey:@"offerfor"]];
//            }

            
            NSString *strFinal =@"";
            if(one != 0)
            {
                strFinal= [NSString stringWithFormat:@"%d couple ",one];
            }
            
            if(three != 0)
            {
                if([strFinal isEqualToString:@""])
                {
                    strFinal = [NSString stringWithFormat:@"%d girl",three];
                }
                else
                {
                    strFinal=[NSString stringWithFormat:@"%@ and %d girl",strFinal,three];
                }
            }
            
            if(two !=0)
            {
                if([strFinal isEqualToString:@""])
                {
                    strFinal = [NSString stringWithFormat:@"%@ %d stag",strFinal,two];
                }
                else
                {
                    strFinal = [NSString stringWithFormat:@"%@ and %d stag",strFinal,two];
                }
            }
            
            if(![strFinal isEqualToString:@""])
            {
                strFinal = [NSString stringWithFormat:@"%@ is allowed",strFinal];
            }
            
            NSLog(@"final :%@",strFinal);
            
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
            [dict setObject:@"pass" forKey:@"tickettype"];
            [dict setObject:strFinal forKey:@"ticketDetails"];
            
            [dict setObject:[NSString stringWithFormat:@"%@",strdate] forKey:@"date"];
            [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubid"]] forKey:@"clubid"];
            [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubname"]] forKey:@"clubname"];
            [dict setObject:[NSString stringWithFormat:@"%@",timestampString] forKey:@"QRnumber"];
            [dict setObject:[NSString stringWithFormat:@"%@",[dictro valueForKey:@"email"]] forKey:@"cutomername"];
            [dict setObject:[NSString stringWithFormat:@"%@",[dictro valueForKey:@"mob"]] forKey:@"mobile"];
            [dict setObject:strcid forKey:@"customerId"];
            [dict setObject:[NSString stringWithFormat:@"%@",strTotal] forKey:@"cost"];
          
            [dict setObject:[NSString stringWithFormat:@"%@",strTotal] forKey:@"costafterdiscount"];
            
            if([self.dictMain objectForKey:@"offerForPass"])
            {
                [dict setObject:[NSString stringWithFormat:@"%@",strCost] forKey:@"cost"];
                [dict setObject:[NSString stringWithFormat:@"%@",[self.dictMain valueForKey:@"offerForPass"]] forKey:@"discount"];
                [dict setObject:strTotal forKey:@"paidamount"];
                [dict setObject:@"0" forKey:@"remainingamount"];
                
            }else
            {
                [dict setObject:[NSString stringWithFormat:@"%@",strTotal] forKey:@"cost"];
                [dict setObject:@"0" forKey:@"discount"];
                [dict setObject:strTotal forKey:@"paidamount"];
                [dict setObject:@"0" forKey:@"remainingamount"];
            }
            
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
    
 ///   [self performSegueWithIdentifier:SEGUE_TO_CLUB_PASS_TO_CONF sender:nil];
}


- (void)didFinishCASTransaction: (PGTransactionViewController *)controller response: (NSDictionary *)response
{
    NSLog(@"transfer :%@",response);
    
}

-(void)showController:(PGTransactionViewController *)controller
{
    if (self.navigationController != nil)
        [self.navigationController pushViewController:controller animated:YES];
    else
        [self presentViewController:controller animated:YES
                         completion:^{
                             
                         }];
}

-(void)removeController:(PGTransactionViewController *)controller
{
    if (self.navigationController != nil)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [controller dismissViewControllerAnimated:YES
                                       completion:^{
                                           
                                       }];
    
}

#pragma mark PGTransactionViewController delegate

-(void)didFinishedResponse:(PGTransactionViewController *)controller response:(NSString *)responseString
{
    
    NSLog(@"ViewController::didFinishedResponse:response = %@", responseString);
    NSString *strMid=@"vichii09596855246224";
    NSString *strOrderIdMno=strOrderId;
    NSString *strchecksume=strChecksum;
    
    [self getTxnStatus:strchecksume :strMid :strOrderIdMno];
    // [self.navigationController popToRootViewControllerAnimated:YES];
    
    //  [[[UIAlertView alloc] initWithTitle:title message:[responseString description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [self removeController:controller];
    
    
}

- (void)didCancelTransaction:(PGTransactionViewController *)controller error:(NSError*)error response:(NSDictionary *)response
{
    NSLog(@"ViewController::didCancelTransaction error = %@ response= %@", error, response);
    NSString *msg = nil;
    if (!error) msg = [NSString stringWithFormat:@"Successful"];
    else msg = [NSString stringWithFormat:@"UnSuccessful"];
    
    [[[UIAlertView alloc] initWithTitle:@"Transaction Cancel" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [self removeController:controller];
}


-(NSString*)generateOrderIDWithPrefix:(NSString *)prefix
{
    srand ( (unsigned)time(NULL) );
    int randomNo = rand(); //just randomizing the number
    NSString *orderID = [NSString stringWithFormat:@"%@%d", prefix, randomNo];
    return orderID;
}

-(void)didCancelTrasaction:(PGTransactionViewController *)controller
{
    [controller dismissViewControllerAnimated:YES
                                   completion:^{
                                   }];
}

#pragma mark -vertify :
#pragma mark - memroy mgnt :

-(void)getTxnStatus :(NSString *)str :(NSString *)mid :(NSString *)orderID
{
    
    if(![[AppDelegate sharedAppDelegate] connected])
    {
        [[AppDelegate sharedAppDelegate] showToastMessage:@"Network Connection Lost !"];
        
    }else
    {
        
        NSString *strid=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_ID];
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc] init];
        //[dictParam setValue:str forKey:@"CHECKSUMHASH"];
        [dictParam setValue:mid forKey:@"MID"];
        [dictParam setValue:orderID forKey:@"ORDER_ID"];
        [dictParam setValue:strid forKey:@"user_id"];
        [dictParam setValue:orderID forKey:@"transaction_id"];
        [dictParam setValue:strTotal forKey:@"amount"];
        
        NSLog(@"Done transaction See this thing :\n %@",dictParam);
        
        
        
        //        NSString *url;
        //
        //        url =@"http://drvinodgautam.com/paytm_service/TxnStatus.php";
        //        NSLog(@"url is :%@",url);
        //
        //        [[AppDelegate sharedAppDelegate] showHUDLoadingView:@"please wait"];
        //        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //        manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        //
        //        [manager POST:url parameters:dictParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
        //         {
        //             [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
        //             if(responseObject)
        //             {
        //
        //                 NSLog(@"response :%@",responseObject);
        //                 [self.navigationController popToRootViewControllerAnimated:YES];
        //             }
        //             else
        //             {
        //
        //             }
        //
        //         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
        //         {
        //
        //         }];
    }
}

#pragma mark -
#pragma mark - back :


- (IBAction)onClickforBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
        [self performSegueWithIdentifier:SEGUE_TO_CLUB_PASS_TO_CONF sender:nil];
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


#pragma mark - memroy mgnt :

-(void)serviceForChecksum
{
    
    if(![[AppDelegate sharedAppDelegate] connected])
    {
        [[AppDelegate sharedAppDelegate] showToastMessage:@"Network Connection Lost !"];
        
    }else
    {
        
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc] init];
        
        /*
         sandbox
         
         [dictParam setValue:@"Spinea70597304551023" forKey:@"MID"];
         [dictParam setValue:[NSString stringWithFormat:@"%@",strOrderId] forKey:@"ORDER_ID"];
         [dictParam setValue:@"345234524523452346" forKey:@"CUST_ID"];
         [dictParam setValue:@"Retail" forKey:@"INDUSTRY_TYPE_ID"];
         [dictParam setValue:@"WAP" forKey:@"CHANNEL_ID"];
         [dictParam setValue:self.txtAmount.text forKey:@"TXN_AMOUNT"];
         [dictParam setValue:@"APP_STAGING" forKey:@"WEBSITE"];
         [dictParam setValue:@"http://drvinodgautam.com/paytm_service/verifyChecksum.php" forKey:@"CALLBACK_URL"];
         
         */
        
        //NSString *strCallbackurl=[NSString stringWithFormat:@"https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=%@",strOrderId];
        
        NSString *strCallbackurl=[NSString stringWithFormat:@"https://pguat.paytm.com/paytmchecksum/paytmCallback.jsp"];
        
        
        //        NSString *strCallbackurl=[NSString stringWithFormat:@"https://pguat.paytm.com/paytmchecksum/paytmCallback.jsp?ORDER_ID=%@",strOrderId];
        
        NSString *struid=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_ID];
        
        
        [dictParam setValue:@"vichii09596855246224" forKey:@"MID"];
        [dictParam setValue:[NSString stringWithFormat:@"%@",strOrderId] forKey:@"ORDER_ID"];
        [dictParam setValue:struid forKey:@"CUST_ID"];
        [dictParam setValue:@"Retail" forKey:@"INDUSTRY_TYPE_ID"];
        [dictParam setValue:@"WAP" forKey:@"CHANNEL_ID"];
        [dictParam setValue:[NSString stringWithFormat:@"%@",strTotal] forKey:@"TXN_AMOUNT"];
        [dictParam setValue:@"APP_STAGING" forKey:@"WEBSITE"];
        [dictParam setValue:strCallbackurl forKey:@"CALLBACK_URL"];
        
        NSString *url;
        
        url =@"http://198.167.140.169/paytm/generateChecksum.php";
        NSLog(@"url is :%@",url);
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        [manager POST:url parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSLog(@"JSON: POST %@", responseObject);
             if(responseObject)
             {
                 strChecksum=[responseObject valueForKey:@"CHECKSUMHASH"];
                 
                 PGMerchantConfiguration *mc = [PGMerchantConfiguration defaultConfiguration];
                 
                 NSMutableDictionary * orderDict = [NSMutableDictionary new];
                 
                 NSString *struid=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_ID];
                 
                 //Merchant configuration in the order object
                 //NSString *strCallbackurl=[NSString stringWithFormat:@"https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=%@",strOrderId];
                 NSString *strCallbackurl=[NSString stringWithFormat:@"https://pguat.paytm.com/paytmchecksum/paytmCallback.jsp"];
                 
                 // NSString *strCallbackurl=[NSString stringWithFormat:@"https://pguat.paytm.com/paytmchecksum/paytmCallback.jsp?ORDER_ID=%@",strOrderId];
                 
                 
                 orderDict[@"MID"] = @"vichii09596855246224";
                 orderDict[@"CHANNEL_ID"] = @"WAP";
                 orderDict[@"INDUSTRY_TYPE_ID"] = @"Retail";
                 orderDict[@"WEBSITE"] = @"APP_STAGING";
                 
                 //Order configuration in the order object
                 orderDict[@"TXN_AMOUNT"] = [NSString stringWithFormat:@"%@",strTotal];
                 orderDict[@"ORDER_ID"] = [NSString stringWithFormat:@"%@",strOrderId];
                 orderDict[@"CALLBACK_URL"] = strCallbackurl;
                 orderDict[@"CHECKSUMHASH"] = strChecksum;
                 orderDict[@"CUST_ID"] = [NSString stringWithFormat:@"%@",struid];
                 //orderDict[@"MOBILE_NO"] = @"8735034595";
                 
                 PGOrder *order = [PGOrder orderWithParams:orderDict];
                 
                 PGTransactionViewController *txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];
                 txnController.serverType=eServerTypeProduction;
                 txnController.merchant = mc;
                 txnController.delegate = self;
                 [self showController:txnController];
                 
                 //                [PGServerEnvironment selectServerDialog:self.view completionHandler:^(ServerType type)
                 //                 {
                 //                     PGTransactionViewController *txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];
                 //                     txnController.serverType=eServerTypeStaging;
                 //                     txnController.merchant = mc;
                 //                     txnController.delegate = self;
                 //                     [self showController:txnController];
                 //
                 //                     //        if (type != eServerTypeNone) {
                 //                     //            txnController.serverType = type;
                 //                     //            txnController.merchant = mc;
                 //                     //            txnController.delegate = self;
                 //                     //            [self showController:txnController];
                 //                     //        }
                 //
                 //                 }];
                 
                 //   [self verify:strChecksum];
             }
             
         } failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
             
         }];
    }
}


#pragma mark -vertify :
#pragma mark - memroy mgnt :

-(void)verify :(NSString *)str
{
    
    if(![[AppDelegate sharedAppDelegate] connected])
    {
        [[AppDelegate sharedAppDelegate] showToastMessage:@"Network Connection Lost !"];
        
    }else
    {
        
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc] init];
        [dictParam setValue:str forKey:@"CHECKSUMHASH"];
        
        NSString *url;
        
        url =@"http://198.167.140.169/paytm/verifyChecksum.php";
        NSLog(@"url is :%@",url);
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        [manager POST:url parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"JSON: VERIFY -> %@", responseObject);
            if(responseObject)
            {
                
            }
            
        } failure:^(NSURLSessionTask *operation, NSError *error)
         {
             
             NSLog(@"Error: %@", error);
             
         }];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SEGUE_TO_CLUB_PASS_TO_CONF])
    {
        BookingConfirmClubVC *bv=[segue destinationViewController];
        bv.dictClub=self.dictstore;
        bv.strCouple=[NSString stringWithFormat:@"%d",one];
        bv.strGirl=[NSString stringWithFormat:@"%d",three];
        bv.strStage=[NSString stringWithFormat:@"%d",two];
        bv.strAmount=strTotal;
        bv.sttype=@"0";
        bv.dictMain=self.dictMain;
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
@end
