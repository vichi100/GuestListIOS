//
//  BookingInfoVC.m
//  VichiApp
//
//  Created by Angel on 06/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "BookingInfoVC.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+GGQRCode.h"

@interface BookingInfoVC ()<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation BookingInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self createQrCode];
    [self design];

}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = true;
}

#pragma mark - design :

-(void)design
{
    NSString *timestampString = [NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"QRnumber"]];
    
    self.lblQrCode.text=[self formatStringAsVisa:timestampString];
    
    NSString *strd=timestampString;
    self.imgQr.image=[strd qrCodeImage:self.imgQr.frame.size.width height:self.imgQr.frame.size.height];
    
    NSString *str = [NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubname"]];
    NSMutableString *result = [str mutableCopy];
    [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
                               options:NSStringEnumerationByWords
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                      withString:[[substring substringToIndex:1] uppercaseString]];
                            }];
    
    
    self.lblclubName.text=[NSString stringWithFormat:@"%@",result];
    self.lblDate.text=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"eventDate"]];
  
    if([[self.dictstore valueForKey:@"costafterdiscount"] intValue]>0)
    {
        // discount !
        if([[self.dictstore valueForKey:@"tickettype"] isEqualToString:@"guest list"])
        {
            self.lbldetails.text = [NSString stringWithFormat:@"%@ is allowed",[self.dictstore valueForKey:@"ticketDetails"]];
            self.lblEntry.text = @"Entry After 11 PM Club Charges Will Apply";
        }
        
        if([[self.dictstore valueForKey:@"tickettype"] isEqualToString:@"pass"])
        {
            self.lbldetails.text = [NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"ticketDetails"]];
            self.lblEntry.text = [NSString stringWithFormat:@"As FULL COVER of %@ Rs is All Paid",[self.dictstore valueForKey:@"costafterdiscount"]];
        }
        
        if([[self.dictstore valueForKey:@"tickettype"] isEqualToString:@"table"])
        {
            self.lbldetails.text = [NSString stringWithFormat:@"%@ with FULL COVER of %@ Rs",[self.dictstore valueForKey:@"ticketDetails"],[self.dictstore valueForKey:@"costafterdiscount"]];
            self.lblEntry.text = [NSString stringWithFormat:@"%@ Rs Need To Pay At Club ",[self.dictstore valueForKey:@"remainingamount"]];
        }
      
    }else
    {
        // without discount !
        
        if([[self.dictstore valueForKey:@"tickettype"] isEqualToString:@"guest list"])
        {
            self.lbldetails.text = [NSString stringWithFormat:@"%@ is Allowed",[self.dictstore valueForKey:@"ticketDetails"]];
            self.lblEntry.text = @"Entry After 11 PM Club Charges Will Apply";
        }
        
        if([[self.dictstore valueForKey:@"tickettype"] isEqualToString:@"pass"])
        {
            self.lbldetails.text = [NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"ticketDetails"]];
            self.lblEntry.text = [NSString stringWithFormat:@"As FULL COVER of %@ Rs is All Paid",[self.dictstore valueForKey:@"costafterdiscount"]];
        }
        
        if([[self.dictstore valueForKey:@"tickettype"] isEqualToString:@"table"])
        {
            self.lbldetails.text = [NSString stringWithFormat:@"%@ With FULL COVER Of %@ Rs",[self.dictstore valueForKey:@"ticketDetails"],[self.dictstore valueForKey:@"costafterdiscount"]];
            self.lblEntry.text = [NSString stringWithFormat:@"%@ Rs Need To Pay At Club ",[self.dictstore valueForKey:@"remainingamount"]];
        }
        
    }
    
}

//#pragma mark - creae qr code :
//
//-(void)createQrCode
//{
//    NSLog(@"self dict :%@",self.dictstore);
//
//    NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]); //double
//    long digits = (long)time; //first 10 digits
//    int decimalDigits = (int)(fmod(time, 1) * 1000); //3 missing digits
//    /*** long ***/
//    long timestamp = (digits * 1000) + decimalDigits;
//    /*** string ***/
//    NSString *timestampString = [NSString stringWithFormat:@"%ld%03d",digits ,decimalDigits];
//    NSString *strd=timestampString;
//    self.imgqrcpde.image=[strd qrCodeImage:self.imgqrcpde.frame.size.width height:self.imgqrcpde.frame.size.height];
//
//
//
//    NSString *str = [NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubname"]];
//    NSMutableString *result = [str mutableCopy];
//    [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
//                               options:NSStringEnumerationByWords
//                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//                                [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
//                                                      withString:[[substring substringToIndex:1] uppercaseString]];
//                            }];
//
//     self.lblclubname.text=result;
//
//    self.lblDate.text=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"eventDate"]];
//
//    if([[self.dictstore valueForKey:@"tickettype"] isEqualToString:@"table"])
//    {
//        self.lblinfotable.text=[NSString stringWithFormat:@"Table for 5 with Full Cover of %@ Rs ",[self.dictstore valueForKey:@"cost"]];
//        self.lblinfotable.textColor=[UIColor colorWithRed:93/255.0f green:144/255.0f blue:220/255.0f alpha:1];
//        self.lblcouple.text=@"";
//
//    }else if([[self.dictstore valueForKey:@"tickettype"] isEqualToString:@"guest list"])
//    {
//        self.lblinfotable.text=@"Entry after 11 PM club charges will apply";
//        self.lblinfotable.textColor=[UIColor colorWithRed:220/255.0f green:93/255.0f blue:93/255.0f alpha:1];
//        self.lblcouple.text=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"ticketDetails"]];
//    }
//    else
//    {
//        self.lblinfotable.text=@"";
//        self.lblcouple.text=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"ticketDetails"]];
//    }
//
//}

#pragma mark - done :

- (IBAction)onclickfordone:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - memory mgnt :

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
