//
//  OfferDetailsVC.m
//  GuestList
//
//  Created by Hiren Dhamecha on 4/5/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "OfferDetailsVC.h"
#import "VAConstant.h"
#import "UIImageView+Download.h"
#import "AppDelegate.h"
#import "ClubTableVC.h"
#import "ClubPassVC.h"
#import "GuestListVC.h"
#import "SocketIO.h"


@interface OfferDetailsVC ()<SocketIODelegate>
{
    NSMutableDictionary *dictstored;
    NSMutableArray *arrticketTable,*arrEventDetails;
    SocketIO *socketIO;
    NSMutableDictionary *dictpass;
    
}
@end

@implementation OfferDetailsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;
    dictstored=[[NSMutableDictionary alloc] init];
    arrEventDetails=[[NSMutableArray alloc] init];
    arrticketTable=[[NSMutableArray alloc] init];
    dictpass=[[NSMutableDictionary alloc] init];
    [self setDetails];
   
    NSDictionary *dictr=[[NSUserDefaults standardUserDefaults] objectForKey:STORE_OFFER];
    
    if (dictr == nil)
    {
       NSString *strClubId=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubid"]];
        NSString *streventDate=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"date"]];
        [self establishclublist:strClubId :streventDate];
        
        NSString *dateStr = [NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"date"]];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MMM/yyyy"];
        
        NSDate *date = [dateFormat dateFromString:dateStr];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE"];
        NSString *dayName = [dateFormatter stringFromDate:date];
        //self.lblDay.text = dayName;
        self.lblDate.text=dateStr;

        self.lbltitle.text = [NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubname".capitalizedString]];
       
        self.lblmusic.text = [NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"djname".capitalizedString]];
        self.lblmusicDetails.text = [NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"eventName".capitalizedString]];
        
        NSString *stroff = @"%";
        self.lblpassoff.text = [NSString stringWithFormat:@"PASS : %@ %@ off",[self.dictstore valueForKey:@"offerForPass"],stroff];
        self.lbltableoff.text = [NSString stringWithFormat:@"TABLE : %@ %@ off",[self.dictstore valueForKey:@"OfferForTable"],stroff];
        [self.imgBg downloadFromURL:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[self.dictstore valueForKey:@"imageURL"]] withPlaceholder:[UIImage imageNamed:@"place"]];
        
    }
    else
    {
        NSString *strClubId=[NSString stringWithFormat:@"%@",[dictr valueForKey:@"clubid"]];
        NSString *streventDate=[NSString stringWithFormat:@"%@",[dictr valueForKey:@"date"]];
        [self establishclublist:strClubId :streventDate];
        
        NSString *strper=@"%";
        self.lblpassoff.text=[NSString stringWithFormat:@"PASS : %@%@ off",[dictr valueForKey:@"passdiscount"],strper];
        self.lbltableoff.text=[NSString stringWithFormat:@"TABLE : %@%@ off",[dictr valueForKey:@"tablediscount"],strper];
        self.lbltitle.text=[NSString stringWithFormat:@"%@",[dictr valueForKey:@"clubname".capitalizedString]];
        self.lblDate.text=[NSString stringWithFormat:@"%@",[dictr valueForKey:@"eventDate"]];
        [self.imgBg downloadFromURL:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[dictr valueForKey:@"imageURL"]] withPlaceholder:[UIImage imageNamed:@"place"]];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
        self.tabBarController.tabBar.hidden = true;
}

#pragma mark -
#pragma mark - establlish club list :

-(void)establishclublist :(NSString *)clubid :(NSString *)eventDate
{
    if([socketIO isConnected])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"getEventDetailsForOfferFromDatabase" forKey:@"action"];
        [dict setObject:clubid forKey:@"clubid"];
        [dict setObject:eventDate forKey:@"date"];
        NSError * err;
        NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
        NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
        NSLog(@" my json string : %@",myString);
        [socketIO sendMessage:myString];
        [[AppDelegate sharedAppDelegate] showLoadingWithTitle:@"Please Wait"];
    }
    else
    {
        socketIO = [[SocketIO alloc] initWithDelegate:self];
        [socketIO connectToHost:IP_URL onPort:3080];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"getEventDetailsForOfferFromDatabase" forKey:@"action"];
        [dict setObject:clubid forKey:@"clubid"];
        [dict setObject:eventDate forKey:@"date"];
        NSError * err;
        NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
        NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
        NSLog(@" my json string : %@",myString);
        [socketIO sendMessage:myString];
        [[AppDelegate sharedAppDelegate] showLoadingWithTitle:@"Please Wait"];
    }
    
}


#pragma mark - details :

-(void)setDetails
{
   
    self.lblDay.text=@"";
    self.lblDate.text=@"";
    self.lblmusic.text=@"";
    self.lbltitle.text=@"";
    self.lblmusicDetails.text=@"";
    
    
    
    self.imgBg.clipsToBounds=YES;
    
    self.btntbl.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btntbl.layer.borderWidth=1;
    
        self.btnpass.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btnpass.layer.borderWidth=1;
    
    self.btnguest.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btnguest.layer.borderWidth=1;
    
    
    
}

- (IBAction)onClickforback:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onClickforGuestList:(id)sender
{
  
    [self performSegueWithIdentifier:SEGUE_TO_OFFER_TO_GUESTLIST sender:nil];
}

- (IBAction)onClcikforPasses:(id)sender
{
   
        [self performSegueWithIdentifier:SEGUE_TO_OFFER_TO_CLUBPASSES sender:nil];

}

- (IBAction)onClickforTable:(id)sender
{
    if(arrticketTable.count>0)
    {
        
      [self performSegueWithIdentifier:SEGUE_TO_OFFER_TO_TABLE sender:nil];
    }
    else
    {
        [[AppDelegate sharedAppDelegate] showToastMessage:@"No Table Avaiable !"];
    }
}

#pragma mark - preppare for segue :

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SEGUE_TO_OFFER_TO_TABLE])
    {
        NSString *str=[NSString stringWithFormat:@"%@%@",IMAGE_URL,[dictpass valueForKey:@"imageURL"]];
        
        ClubTableVC *clb=[segue destinationViewController];
        clb.arrTableList=arrticketTable;
        clb.prodimg=str;
        clb.dictMain=self.dictstore;
        
    }else if ([segue.identifier isEqualToString:SEGUE_TO_OFFER_TO_CLUBPASSES])
    {
        ClubPassVC *cv=[segue destinationViewController];
        if(dictpass.count > 0 )
        {
            cv.dictstore=dictpass;
            cv.dictMain=dictpass;
            cv.dictMain=self.dictstore;
        }else
        {
            cv.dictstore=self.dictstore;
            cv.dictMain=self.dictstore;
        }
        
    }else if ([segue.identifier isEqualToString:SEGUE_TO_OFFER_TO_GUESTLIST])
    {
        GuestListVC *gb=[segue destinationViewController];
        if(dictpass.count > 0 )
        {
            gb.dictstore=dictpass;
            gb.dictmain= self.dictstore;
        }
        else
        {
           gb.dictstore=self.dictstore;
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
    
    NSLog(@"details :=> \n  %@",json);
    
    if(json !=nil)
    {
        NSArray *ard=[json valueForKey:@"eventsDetailList"];
        NSArray *articket=[json valueForKey:@"ticketDetailsList"];
        
        arrticketTable=[[NSMutableArray alloc] init];
        
        if(articket.count>0)
        {
            for(int i=0;i<articket.count;i++)
            {
                NSDictionary *dict=[articket objectAtIndex:i];
                if([[dict valueForKey:@"size"] intValue]>0)
                {
                    [arrticketTable addObject:dict];
                }
            }
        }

        if(ard.count>0)
        {
            
            NSDictionary *dictstorez=[ard objectAtIndex:0];
            dictpass=[ard objectAtIndex:0];
            
           // [self.imgBg downloadFromURL:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[dictstorez valueForKey:@"imageURL"]] withPlaceholder:[UIImage imageNamed:@"place"]];
            
           // self.lblDate.text=[NSString stringWithFormat:@"%@",[dictstorez valueForKey:@"date"]];
            
            NSString *dateStr = [NSString stringWithFormat:@"%@",[dictstorez valueForKey:@"date"]];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd/MMM/yyyy"];
            
            NSDate *date = [dateFormat dateFromString:dateStr];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE"];
            NSString *dayName = [dateFormatter stringFromDate:date];
            
            self.lblDay.text=[NSString stringWithFormat:@"%@",dayName];
           
            
            NSString *strdj = [NSString stringWithFormat:@"%@",[dictpass valueForKey:@"djname"]];
            NSMutableString *resultdj = [strdj mutableCopy];
            [resultdj enumerateSubstringsInRange:NSMakeRange(0, [resultdj length])
                                       options:NSStringEnumerationByWords
                                    usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                        [resultdj replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                              withString:[[substring substringToIndex:1] uppercaseString]];
                                    }];
            
            self.lblmusic.text=[NSString stringWithFormat:@"%@",resultdj];
            
            NSString *strmusic = [NSString stringWithFormat:@"%@",[dictpass valueForKey:@"music"]];
            NSMutableString *resultmusic = [strmusic mutableCopy];
            [resultmusic enumerateSubstringsInRange:NSMakeRange(0, [resultmusic length])
                                         options:NSStringEnumerationByWords
                                      usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                          [resultmusic replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                                  withString:[[substring substringToIndex:1] uppercaseString]];
                                      }];

            self.lblmusicDetails.text=[NSString stringWithFormat:@"Music : %@",resultmusic];
            
        }
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
