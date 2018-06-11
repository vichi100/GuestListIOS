//
//  VAListOfClubVC.m
//  VichiApp
//
//  Created by Angel on 06/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "VAListOfClubVC.h"
#import "VAListCell.h"
#import "VAConstant.h"
#import "SocketIO.h"
#import "AppDelegate.h"
#import "UIImageView+Download.h"
#import "ClubTableVC.h"
#import "ClubPassVC.h"
#import "GuestListVC.h"

@interface VAListOfClubVC ()<UITableViewDelegate,UITableViewDataSource,SocketIODelegate>
{
    NSMutableArray *arrEventDetails,*arrticketTable,*arrPassnext;
    SocketIO *socketIO;
    NSMutableDictionary *dictstore;
    
    NSString  *prodimg;
    NSString *strSelectedDate;
}
@end

@implementation VAListOfClubVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    dictstore=[[NSMutableDictionary alloc] init];
    
    arrPassnext=[[NSMutableArray alloc]init];
    [self.scrollview setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
   // [self getCource];
    [self establishclublist];
}

-(void)viewWillAppear:(BOOL)animated
{
     [self design];
}

#pragma mark - design :

-(void)design
{
    self.navigationController.navigationBarHidden=YES;
    
    self.tabBarController.tabBar.hidden = true;
    
    [self.imgItem downloadFromURL:[NSString stringWithFormat:@"%@",self.clubImg] withPlaceholder:[UIImage imageNamed:@"place"]];
    self.imgItem.clipsToBounds=YES;

    NSString *strdm = [NSString stringWithFormat:@"%@",self.strClubmName];
    NSMutableString *resultd = [strdm mutableCopy];
    [resultd enumerateSubstringsInRange:NSMakeRange(0, [resultd length])
                                options:NSStringEnumerationByWords
                             usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                 [resultd replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                        withString:[[substring substringToIndex:1] uppercaseString]];
                             }];
    
     self.lbltitle.text=[NSString stringWithFormat:@"%@",resultd];
    
    
}


#pragma mark -
#pragma mark - establlish club list :

-(void)establishclublist
{
    if([socketIO isConnected])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"getEventDetailsFromDatabase" forKey:@"action"];
        [dict setObject:self.strclubId forKey:@"clubid"];
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
        [dict setObject:@"getEventDetailsFromDatabase" forKey:@"action"];
        [dict setObject:self.strclubId forKey:@"clubid"];
        NSError * err;
        NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
        NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
        NSLog(@" my json string : %@",myString);
        [socketIO sendMessage:myString];
        [[AppDelegate sharedAppDelegate] showLoadingWithTitle:@"please wait"];
    }
    
}

#pragma mark - getcource :

-(void)getCource
{
    
    arrEventDetails=[[NSMutableArray alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"adm5" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    arrEventDetails = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"json :%@",arrEventDetails);
    [self.tbllist reloadData];
    
    float totalheightcell=40.0f+117.0f;
    float height=arrEventDetails.count*totalheightcell;
    [self.tbllist setFrame:CGRectMake(0, self.topview.frame.size.height, self.tbllist.frame.size.width, height)];
    float finalheight=height+self.topview.frame.size.height;
    [self.scrollview setContentSize:CGSizeMake(self.view.frame.size.width,finalheight)];
    
    
}


#pragma mark - Tableview Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    VAListCell *cell=[self.tbllist dequeueReusableCellWithIdentifier:@"tblcell"];
    
    if(cell == nil)
    {
        cell=[[VAListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tblcell"];
    }
    
    NSDictionary *dict=[arrEventDetails objectAtIndex:indexPath.section];
    NSString *strdm = [NSString stringWithFormat:@"%@",[dict valueForKey:@"djname"]];
    NSMutableString *resultd = [strdm mutableCopy];
    [resultd enumerateSubstringsInRange:NSMakeRange(0, [resultd length])
                                options:NSStringEnumerationByWords
                             usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                 [resultd replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                        withString:[[substring substringToIndex:1] uppercaseString]];
                             }];
    
    cell.lbltitel.text=[NSString stringWithFormat:@"%@",resultd];

    
    NSString *strdmm = [NSString stringWithFormat:@" %@",[dict valueForKey:@"music"]];
    NSMutableString *resultdd = [strdmm mutableCopy];
    [resultdd enumerateSubstringsInRange:NSMakeRange(0, [resultdd length])
                                options:NSStringEnumerationByWords
                             usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                 [resultdd replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                        withString:[[substring substringToIndex:1] uppercaseString]];
                             }];

    
    cell.lblsubTitle.text=[NSString stringWithFormat:@"%@",resultdd];
    
    [cell.imgItem downloadFromURL:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[dict valueForKey:@"imageURL"]] withPlaceholder:[UIImage imageNamed:@"place"]];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.imgItem.clipsToBounds=YES;
  
    NSString *dateStr =[NSString stringWithFormat:@"%@",[dict valueForKey:@"date"]];
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d/LLLL/yyyy"];
    
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    
    NSDate *midnightOfToday = [cal dateFromComponents:comps];
    
    if ([midnightOfToday compare:date] == NSOrderedAscending)
    {
    
        NSLog(@"myDate is EARLIER than today %@",dateStr);
        cell.btnguest.layer.borderColor=[UIColor whiteColor].CGColor;
        cell.btnguest.layer.borderWidth=1;
        
        cell.btntable.layer.borderColor=[UIColor whiteColor].CGColor;
        cell.btntable.layer.borderWidth=1;
        
        cell.btmpass.layer.borderColor=[UIColor whiteColor].CGColor;
        cell.btmpass.layer.borderWidth=1;
        
        cell.btmpass.tag = indexPath.section;
        
        cell.btmpass.userInteractionEnabled= YES;
        cell.btntable.userInteractionEnabled= YES;
        cell.btnguest.userInteractionEnabled= YES;
        
        [cell.btmpass addTarget:self action:@selector(onClickedForPass:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btntable.tag = indexPath.section;
        [cell.btntable addTarget:self action:@selector(onClickedForTable:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnguest.tag = indexPath.section;
        [cell.btnguest addTarget:self action:@selector(onClickedForGuest:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([[NSDate date] compare:date] == NSOrderedDescending)
    {
        NSLog(@"myDate is LATER than today %@",dateStr);
      
        cell.btnguest.layer.borderColor=[UIColor grayColor].CGColor;
        cell.btnguest.layer.borderWidth=1;
        cell.btnguest.tintColor = [UIColor grayColor];
        
        cell.btntable.layer.borderColor=[UIColor grayColor].CGColor;
        cell.btntable.layer.borderWidth=1;
        cell.btntable.tintColor = [UIColor grayColor];
        
        cell.btmpass.layer.borderColor=[UIColor grayColor].CGColor;
        cell.btmpass.layer.borderWidth=1;
        cell.btmpass.tintColor = [UIColor grayColor];
        
        cell.btmpass.userInteractionEnabled= NO;
        cell.btntable.userInteractionEnabled= NO;
        cell.btnguest.userInteractionEnabled= NO;
        
//        cell.btmpass.tag = indexPath.row;
//        [cell.btmpass addTarget:self action:@selector(onClickedForPass:) forControlEvents:UIControlEventTouchUpInside];
//
//        cell.btntable.tag = indexPath.row;
//        [cell.btntable addTarget:self action:@selector(onClickedForTable:) forControlEvents:UIControlEventTouchUpInside];
//
//        cell.btnguest.tag = indexPath.row;
//        [cell.btnguest addTarget:self action:@selector(onClickedForGuest:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([midnightOfToday compare:date] == NSOrderedSame) {
        NSLog(@"myDate and today are THE SAME DATE %@",dateStr);
        
        cell.btnguest.layer.borderColor=[UIColor whiteColor].CGColor;
        cell.btnguest.layer.borderWidth=1;
        
        cell.btntable.layer.borderColor=[UIColor whiteColor].CGColor;
        cell.btntable.layer.borderWidth=1;
        
        cell.btmpass.layer.borderColor=[UIColor whiteColor].CGColor;
        cell.btmpass.layer.borderWidth=1;
        
        cell.btmpass.userInteractionEnabled= YES;
        cell.btntable.userInteractionEnabled= YES;
        cell.btnguest.userInteractionEnabled= YES;
        
        cell.btmpass.tag = indexPath.section;
        [cell.btmpass addTarget:self action:@selector(onClickedForPass:) forControlEvents:UIControlEventTouchUpInside];

        cell.btntable.tag = indexPath.section;
        [cell.btntable addTarget:self action:@selector(onClickedForTable:) forControlEvents:UIControlEventTouchUpInside];

        cell.btnguest.tag = indexPath.section;
        [cell.btnguest addTarget:self action:@selector(onClickedForGuest:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tbllist deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 117.0f;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSDictionary *dict=[arrEventDetails objectAtIndex:section];
//    NSArray *ard=[dict valueForKey:@"sub"];
//    return ard.count;
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrEventDetails.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSDictionary *dict=[arrEventDetails objectAtIndex:section];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@",[dict valueForKey:@"date"]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MMM/yyyy"];
    
    NSDate *date = [dateFormat dateFromString:dateStr];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dayName = [dateFormatter stringFromDate:date];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.0f)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, -3, tableView.frame.size.width/2, 40.0f)];
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    NSString *string =[NSString stringWithFormat:@"%@",dayName];
    /* Section header is in 0th index... */
    [label setTextColor:[UIColor whiteColor]];
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor blackColor]]; //your background color...
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-10, -3, tableView.frame.size.width/2, 40.0f)];
    [label2 setFont:[UIFont boldSystemFontOfSize:13]];
    NSString *string2 =[NSString stringWithFormat:@"%@",dateStr];
    /* Section header is in 0th index... */
    [label2 setTextAlignment:NSTextAlignmentRight];
    [label2 setText:string2];
    [label2 setTextColor:[UIColor darkGrayColor]];
    [view addSubview:label2];
    
    return view;
    
    
}

#pragma mark -
#pragma mark - onClickedForPass

-(void)onClickedForPass:(UIButton*)sender
{
    dictstore=[[NSMutableDictionary alloc] init];
    dictstore=[arrEventDetails objectAtIndex:sender.tag];
    NSLog(@"Select :%@",dictstore);
    [self performSegueWithIdentifier:SEGUE_TO_CLUB_PASS sender:nil];
}

#pragma mark -
#pragma mark - onClickedForTable

-(void)onClickedForTable:(UIButton*)sender
{
    NSLog(@"%@",arrticketTable);
    dictstore=[[NSMutableDictionary alloc]init];
    dictstore=[arrEventDetails objectAtIndex:sender.tag];
    arrPassnext=[[NSMutableArray alloc]init];
    NSDictionary *dictr=[arrEventDetails objectAtIndex:sender.tag];
    strSelectedDate= [NSString stringWithFormat:@"%@",[dictr valueForKey:@"date"]];
    
    if(arrticketTable.count>0)
    {
        for(int i=0;i<arrticketTable.count;i++)
        {
            NSDictionary *dict=[arrticketTable objectAtIndex:i];
            if([[dict valueForKey:@"date"] isEqualToString:strSelectedDate])
            {
                [arrPassnext addObject:dict];
            }
        }
        if(arrPassnext.count>0)
        {
            [self performSegueWithIdentifier:SEGUE_TO_CLUB_TABLE sender:nil];
        }
    }
}


#pragma mark -
#pragma mark - onClickedForGuest

-(void)onClickedForGuest:(UIButton*)sender
{
    dictstore=[[NSMutableDictionary alloc] init];
    dictstore=[arrEventDetails objectAtIndex:sender.tag];
    [self performSegueWithIdentifier:SEGUE_TO_GUEST_LIST sender:nil];
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
        if(ard.count>0)
        {
            arrEventDetails=[[NSMutableArray alloc] initWithArray:ard];
            [self.tbllist reloadData];
        }
        NSArray *ardtckt=[json valueForKey:@"ticketDetailsList"];
        arrticketTable=[[NSMutableArray alloc] init];
        if(ardtckt.count>0)
        {
            for(int i=0;i<ardtckt.count;i++)
            {
                NSDictionary *dic=[ardtckt objectAtIndex:i];
                if([[dic valueForKey:@"type"] isEqualToString:@"table"])
                {
                    [arrticketTable addObject:dic];
                }
            }
            if(arrticketTable.count>0)
            {
                NSLog(@"arrticketTable :%@",arrticketTable);
            }
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SEGUE_TO_CLUB_TABLE])
    {
        ClubTableVC *clb=[segue destinationViewController];
        clb.arrTableList=arrPassnext;
        clb.prodimg=self.clubImg;
        clb.dictMain=dictstore;
        
        
    }else if ([segue.identifier isEqualToString:SEGUE_TO_CLUB_PASS])
    {
        ClubPassVC *cv=[segue destinationViewController];
        cv.dictstore=dictstore;
    }else if ([segue.identifier isEqualToString:SEGUE_TO_GUEST_LIST])
    {
        GuestListVC *gb=[segue destinationViewController];
        gb.dictstore=dictstore;
    }
}


- (IBAction)onClickforBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
