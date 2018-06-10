//
//  BookingConfirmClubVC.m
//  VichiApp
//
//  Created by Angel on 06/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "BookingConfirmClubVC.h"
#import "NSString+GGQRCode.h"

@interface BookingConfirmClubVC ()

@end

@implementation BookingConfirmClubVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     if([self.dictMain objectForKey:@"OfferForTable"])
     {
         NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]); //double
         long digits = (long)time; //first 10 digits
         int decimalDigits = (int)(fmod(time, 1) * 1000); //3 missing digits
         /*** long ***/
         long timestamp = (digits * 1000) + decimalDigits;
         /*** string ***/
         
         NSString *timestampString = [NSString stringWithFormat:@"%ld%03d",digits ,decimalDigits];
         self.lblNumber.text=[self formatStringAsVisa:timestampString];
         
         NSString *str=timestampString;
         self.imgqrcpde.image=[str qrCodeImage:self.imgqrcpde.frame.size.width height:self.imgqrcpde.frame.size.height];
         
         NSLog(@"self dict :%@",self.dictClub);
         if([self.dictClub objectForKey:@"details"])
         {
    
             NSString *strd = [NSString stringWithFormat:@"%@",[self.dictClub valueForKey:@"clubname"]];
         NSMutableString *result = [strd mutableCopy];
         [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
                                    options:NSStringEnumerationByWords
                                 usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                     [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                           withString:[[substring substringToIndex:1] uppercaseString]];
                                 }];
         
         self.lblclubname.text=result;
         self.lblDate.text=[NSString stringWithFormat:@"%@",[self.dictClub valueForKey:@"date"]];
         
         int discount= [[self.dictClub valueForKey:@"cost"] floatValue]*[[self.dictMain valueForKey:@"OfferForTable"] floatValue]/100;
         int dicountamount = [[self.dictClub valueForKey:@"cost"] floatValue] - discount;
         
         self.lblCoupleorgirl.text=[NSString stringWithFormat:@"Table For %@ With Full Cover Of %d Rs",[self.dictClub valueForKey:@"size"],dicountamount];
         
         int fullamount=0;
         if(dicountamount <= 10000)
         {
             fullamount = (dicountamount*50)/100;
         }
         else if(dicountamount <= 20000)
         {
             fullamount = (dicountamount*30)/100;
         }
         else if(dicountamount <= 50000)
         {
             fullamount = (dicountamount*25)/100;
         }
         else if(dicountamount <=200000)
         {
             fullamount = (dicountamount*20)/100;
         }
         
         int totablepayableamount = dicountamount - fullamount;
         self.lblNote.text=[NSString stringWithFormat:@"%d Rs Need To Pay At Club ",totablepayableamount];
         }else
         {
         if([self.sttype isEqualToString:@"1"])
         {
             
              self.lblDate.text=[NSString stringWithFormat:@"%@",[self.dictClub valueForKey:@"date"]];
             
             NSString *str = [NSString stringWithFormat:@"%@",[self.dictClub valueForKey:@"clubname"]];
             NSMutableString *result = [str mutableCopy];
             [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
                                        options:NSStringEnumerationByWords
                                     usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                         [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                               withString:[[substring substringToIndex:1] uppercaseString]];
                                     }];
             
             self.lblclubname.text=[NSString stringWithFormat:@"%@",result];
             
             if([self.strCouple isEqualToString:@"One"])
             {
                 self.lblCoupleorgirl.text=@"One Couple is Allowed";
                 
             }
             else if ([self.strGirl isEqualToString:@"only"])
             {
                 self.lblCoupleorgirl.text=@"Max Three Girls are Allowed";
             }
             self.lblNote.text=@"Entry Valid Till 11 PM only After That Club Charge Will Apply.";
             self.lblNote.textColor=[UIColor colorWithRed:220/255.0f green:93/255.0f blue:93/255.0f alpha:1];
             
         }
         else
         {
             self.lblDate.text=[NSString stringWithFormat:@"%@",[self.dictClub valueForKey:@"date"]];
             
             NSString *str = [NSString stringWithFormat:@"%@",[self.dictClub valueForKey:@"clubname"]];
             NSMutableString *result = [str mutableCopy];
             [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
                                        options:NSStringEnumerationByWords
                                     usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                         [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                               withString:[[substring substringToIndex:1] uppercaseString]];
                                     }];
             
             
             self.lblclubname.text=[NSString stringWithFormat:@"%@",result];
             
             if([self.strCouple intValue]>0 && [self.strStage intValue]>0 && [self.strGirl intValue]>0)
             {
                 self.lblCoupleorgirl.text=[NSString stringWithFormat:@"%@ Couple , %@ Stag and %@ Girl is Allowed ",self.strCouple,self.strStage,self.strGirl];
             }
             else  if([self.strCouple intValue]>0 && [self.strStage intValue]>0 )
             {
                 self.lblCoupleorgirl.text=[NSString stringWithFormat:@"%@ Couple , %@ Stag is Allowed ",self.strCouple,self.strStage];
             }
             else  if([self.strStage intValue]>0 && [self.strGirl intValue]>0)
             {
                 self.lblCoupleorgirl.text=[NSString stringWithFormat:@"%@ Stag , %@ Girl is Allowed ",self.strStage,self.strGirl];
             }
             else  if([self.strCouple intValue]>0 && [self.strGirl intValue]>0)
             {
                 self.lblCoupleorgirl.text=[NSString stringWithFormat:@"%@ Couple , %@ Girl is Allowed ",self.strCouple,self.strGirl];
             }
             else  if([self.strCouple intValue]>0)
             {
                 self.lblCoupleorgirl.text=[NSString stringWithFormat:@"%@ Couple is Allowed ",self.strCouple];
             }
             else  if([self.strGirl intValue]>0)
             {
                 self.lblCoupleorgirl.text=[NSString stringWithFormat:@"%@ Girl is Allowed ",self.strGirl];
             }
             else  if([self.strStage intValue]>0)
             {
                 self.lblCoupleorgirl.text=[NSString stringWithFormat:@"%@ Stag is Allowed ",self.strGirl];
             }
             else
             {
                 self.lblCoupleorgirl.text=[NSString stringWithFormat:@"%@ Couple , %@ Stag and %@ Girl is Allowed ",self.strCouple,self.strStage,self.strGirl];
             }
             
             self.lblNote.text=[NSString stringWithFormat:@"As FULL COVER %@ Rs is All Paid",self.strAmount];
         }
         
         }
         
     }else
     {
        [self createQrCode];
     }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
        self.tabBarController.tabBar.hidden = true;
}


#pragma mark - creae qr code :

-(void)createQrCode
{
    NSLog(@"self dict :%@",self.dictClub);
    
    NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]); //double
    long digits = (long)time; //first 10 digits
    int decimalDigits = (int)(fmod(time, 1) * 1000); //3 missing digits
    /*** long ***/
    long timestamp = (digits * 1000) + decimalDigits;
    /*** string ***/
    NSString *timestampString = [NSString stringWithFormat:@"%ld%03d",digits ,decimalDigits];
    self.lblNumber.text=[self formatStringAsVisa:timestampString];
    
    
    NSString *str=timestampString;
    self.imgqrcpde.image=[str qrCodeImage:self.imgqrcpde.frame.size.width height:self.imgqrcpde.frame.size.height];

   // self.lblDate.text=[NSString stringWithFormat:@"%@",[self.dictClub valueForKey:@"date"]];
    
    if([self.dictClub objectForKey:@"date"])
    {
        self.lblDate.text=[NSString stringWithFormat:@"%@",[self.dictClub valueForKey:@"date"]];
      // dateStr= [NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"date"]];
    }
    else
    {
        self.lblDate.text=[NSString stringWithFormat:@"%@",[self.dictClub valueForKey:@"eventDate"]];
        //dateStr= [NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"eventDate"]];
        
    }
    
    if([self.dictClub objectForKey:@"details"])
    {
        
        NSString *str = [NSString stringWithFormat:@"%@",[self.dictClub valueForKey:@"clubname"]];
        NSMutableString *result = [str mutableCopy];
        [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
                                   options:NSStringEnumerationByWords
                                usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                    [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                          withString:[[substring substringToIndex:1] uppercaseString]];
                                }];
        
        self.lblclubname.text=[NSString stringWithFormat:@"%@",result];
        self.lblCoupleorgirl.text=[NSString stringWithFormat:@"Table For %@ With Full Cover Of %@ Rs",[self.dictClub valueForKey:@"size"],[self.dictClub valueForKey:@"cost"]];
        
        int discount= [[self.dictClub valueForKey:@"cost"] floatValue]*[[self.dictMain valueForKey:@"OfferForTable"] floatValue]/100;
        int dicountamount = [[self.dictClub valueForKey:@"cost"] floatValue] - discount;
        
        int fullamount=0;
        if(dicountamount <= 10000)
        {
            fullamount = (dicountamount*50)/100;
        }
        else if(dicountamount <= 20000)
        {
            fullamount = (dicountamount*30)/100;
        }
        else if(dicountamount <= 50000)
        {
            fullamount = (dicountamount*25)/100;
        }
        else if(dicountamount <=200000)
        {
            fullamount = (dicountamount*20)/100;
        }
        
        int totablepayableamount = dicountamount - fullamount;
        self.lblNote.text=[NSString stringWithFormat:@"%d Rs Need To Pay At Club ",totablepayableamount];
        
    }
    else
    {
        if([self.sttype isEqualToString:@"1"])
        {
            NSString *str = [NSString stringWithFormat:@"%@",[self.dictClub valueForKey:@"clubname"]];
            NSMutableString *result = [str mutableCopy];
            [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
                                       options:NSStringEnumerationByWords
                                    usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                        [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                              withString:[[substring substringToIndex:1] uppercaseString]];
                                    }];

             self.lblclubname.text=[NSString stringWithFormat:@"%@",result];

            if([self.strCouple isEqualToString:@"One"])
            {
                self.lblCoupleorgirl.text=@"One Couple is Allowed";
                
            }
            else if ([self.strGirl isEqualToString:@"only"])
            {
                self.lblCoupleorgirl.text=@"Max Three Girls are Allowed";
            }
             self.lblNote.text=@"Entry Valid Till 11 PM Only After That Club Charge Will Apply.";
            self.lblNote.textColor=[UIColor colorWithRed:220/255.0f green:93/255.0f blue:93/255.0f alpha:1];
            
        }
        else
        {
            
            NSString *str = [NSString stringWithFormat:@"%@",[self.dictClub valueForKey:@"clubname"]];
            NSMutableString *result = [str mutableCopy];
            [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
                                       options:NSStringEnumerationByWords
                                    usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                        [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                              withString:[[substring substringToIndex:1] uppercaseString]];
                                    }];

            
            self.lblclubname.text=[NSString stringWithFormat:@"%@",result];
            
            if([self.strCouple intValue]>0 && [self.strStage intValue]>0 && [self.strGirl intValue]>0)
            {
                self.lblCoupleorgirl.text=[NSString stringWithFormat:@"%@ Couple , %@ stag and %@ Girl is allowed ",self.strCouple,self.strStage,self.strGirl];
            }
            else  if([self.strCouple intValue]>0 && [self.strStage intValue]>0 )
            {
                self.lblCoupleorgirl.text=[NSString stringWithFormat:@"%@ Couple , %@ stag is allowed ",self.strCouple,self.strStage];
            }
            else  if([self.strStage intValue]>0 && [self.strGirl intValue]>0)
            {
                self.lblCoupleorgirl.text=[NSString stringWithFormat:@"%@ Stag , %@ Girl is allowed ",self.strStage,self.strGirl];
            }
            else  if([self.strCouple intValue]>0 && [self.strGirl intValue]>0)
            {
                self.lblCoupleorgirl.text=[NSString stringWithFormat:@"%@ Couple , %@ Girl is allowed ",self.strCouple,self.strGirl];
            }
            else  if([self.strCouple intValue]>0)
            {
                self.lblCoupleorgirl.text=[NSString stringWithFormat:@"%@ Couple is allowed ",self.strCouple];
            }
            else  if([self.strGirl intValue]>0)
            {
                self.lblCoupleorgirl.text=[NSString stringWithFormat:@"%@ Girl is allowed ",self.strGirl];
            }
            else  if([self.strStage intValue]>0)
            {
                self.lblCoupleorgirl.text=[NSString stringWithFormat:@"%@ Stag is allowed ",self.strGirl];
            }
            else
            {
                self.lblCoupleorgirl.text=[NSString stringWithFormat:@"%@ Couple , %@ Stag and %@ Girl is allowed ",self.strCouple,self.strStage,self.strGirl];
            }
            
             self.lblNote.text=[NSString stringWithFormat:@"As FULL COVER %@ Rs is all paid",self.strAmount];
            
        }
        
    }
    
}

#pragma mark - done :

- (IBAction)onclickfordone:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - back :

- (IBAction)onClickforBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)formatStringAsVisa:(NSString*)aNumber
{
    NSMutableString *newStr = [NSMutableString new];
    for (NSUInteger i = 0; i < [aNumber length]; i++)
    {
         if (i > 0 && i % 3 == 0)
            [newStr appendString:@" "];
        unichar c = [aNumber characterAtIndex:i];
        [newStr appendString:[[NSString alloc] initWithCharacters:&c length:1]];
    }
    
    
    return newStr;
    
    
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
