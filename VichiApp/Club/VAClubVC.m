//
//  VAClubVC.m
//  VichiApp
//
//  Created by Hiren Dhamecha on 2/6/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "VAClubVC.h"
#import "ClubCell.h"
#import "VAConstant.h"
#import "SocketIO.h"
#import "UIImageView+Download.h"
#import "AppDelegate.h"
#import "VAListOfClubVC.h"
#import "SearchVC.h"
#import "EBForeNotification.h"

@interface VAClubVC ()<UITableViewDelegate,UITableViewDataSource,SocketIODelegate,UIActionSheetDelegate>
{
    NSMutableArray *arrList;
    SocketIO *socketIO;
    NSString *strculbid,*clubImg,*strClubName;
    NSTimer *timer;
    NSString *strLatLong;
}
@end

@implementation VAClubVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrList=[[NSMutableArray alloc] init];
    [self design];
    [self establishclublist];
    
    
}


#pragma mark - timer called :

-(void)timerCalled
{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_NOTIFY];
    if(str !=nil)
    {
        NSDictionary *dicts=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_NOTIFICATION];
        [EBForeNotification handleRemoteNotification:dicts soundID:1312 isIos10:NO];
       
        [[NSUserDefaults standardUserDefaults] setObject:dicts forKey:STORE_OFFER];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREF_NOTIFY];
        [self performSegueWithIdentifier:SEGUE_TO_OFFER_FROM_CLUBHOME sender:nil];
    }
    
    // Your Code
}

-(void)viewWillAppear:(BOOL)animated
{
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerCalled) userInfo:nil repeats:YES];

//     NSTimer *aTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(aTime) userInfo:nil repeats:YES];
     [self design];
}



-(void)aTime
{
    NSString  *str=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_NOTIFY];
    if(str!=nil)
    {
        NSDictionary *userInfo=[[[NSUserDefaults standardUserDefaults] objectForKey:PREF_NOTIFICATION] mutableCopy];
        if(userInfo!=nil)
        {
            [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:NO];
        }
    }
    
    
}

#pragma mark - design :

-(void)design
{
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton=YES;
    self.lblTitle.text=@"Mumbai";
    
    self.tabBarController.tabBar.hidden = false;
    //[self.scrollview setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
}

#pragma mark -
#pragma mark - establlish club list :

-(void)establishclublist
{
    if([socketIO isConnected])
    {
        
        NSString *strlat=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_LAT];
        NSString *strlong=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_LONG];
        
        NSString *strFinal = [NSString stringWithFormat:@"%@,%@",strlat,strlong];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"loadClubListFromDatabase" forKey:@"action"];
        [dict setObject:@"mumbai" forKey:@"city"];
        [dict setObject:strFinal forKey:@"latlong"];
        NSError * err;
        NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
        NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
        NSLog(@" my json string : %@",myString);
        [socketIO sendMessage:myString];
        [[AppDelegate sharedAppDelegate] showLoadingWithTitle:@"please wait"];
    }
    else
    {
        NSString *strlat=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_LAT];
        NSString *strlong=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_LONG];
        NSString *strFinal = [NSString stringWithFormat:@"%@,%@",strlat,strlong];
        socketIO = [[SocketIO alloc] initWithDelegate:self];
        [socketIO connectToHost:IP_URL onPort:3080];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"loadClubListFromDatabase" forKey:@"action"];
        [dict setObject:@"mumbai" forKey:@"city"];
        [dict setObject:strFinal forKey:@"latlong"];
        NSError * err;
        NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
        NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
        NSLog(@" my json string : %@",myString);
        [socketIO sendMessage:myString];
        [[AppDelegate sharedAppDelegate] showLoadingWithTitle:@"please wait"];
    }
    
}

#pragma mark -
#pragma mark - search :

- (IBAction)onClickforSearch:(id)sender
{
     [self performSegueWithIdentifier:SEGUE_TO_SEARCH_CLUB sender:nil];
}

#pragma mark -
#pragma mark - map :

- (IBAction)onClickforMap:(id)sender
{
    [self performSegueWithIdentifier:SEGUE_TO_MODULE_CUTY sender:nil];
    
}

#pragma mark - Tableview Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClubCell *cell=[self.tblClub dequeueReusableCellWithIdentifier:@"ccell"];
    
    if(cell == nil)
    {
        cell=[[ClubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ccell"];
    }
    
    cell.imgItem.clipsToBounds=YES;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *dict=[arrList objectAtIndex:indexPath.row];

    NSString *str = [NSString stringWithFormat:@"%@",[dict valueForKey:@"clubname"]];
    NSMutableString *result = [str mutableCopy];
    [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
                               options:NSStringEnumerationByWords
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                      withString:[[substring substringToIndex:1] uppercaseString]];
                            }];
    
    
    
    NSString *strd = result;
    
   
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:strd];
    
    UIColor* textColor = [UIColor colorWithRed:90/255.0f green:140/255.0f blue:220/255.0f alpha:1];
    
    [commentString setAttributes:@{NSUnderlineColorAttributeName:textColor,NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[commentString length])];
    
    cell.lblname.attributedText=commentString;
    
    
    NSString *strdm = [NSString stringWithFormat:@"%@",[dict valueForKey:@"location"]];
    NSMutableString *resultd = [strdm mutableCopy];
    [resultd enumerateSubstringsInRange:NSMakeRange(0, [resultd length])
                               options:NSStringEnumerationByWords
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                [resultd replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                      withString:[[substring substringToIndex:1] uppercaseString]];
                            }];
    
    cell.lblLocation.text=[NSString stringWithFormat:@"%@",resultd];
    
    
    [cell.imgItem downloadFromURL:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[dict valueForKey:@"imageURL"]] withPlaceholder:[UIImage imageNamed:@"place"]];
    
    cell.btnmap.tag = indexPath.row;
    [cell.btnmap addTarget:self action:@selector(onClickedForPass:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tblClub deselectRowAtIndexPath:indexPath animated:YES];
     NSDictionary *dict=[arrList objectAtIndex:indexPath.row];
    strculbid=[NSString stringWithFormat:@"%@",[dict valueForKey:@"clubid"]];
    clubImg=[NSString stringWithFormat:@"%@%@",IMAGE_URL,[dict valueForKey:@"imageURL"]];
    strClubName=[NSString stringWithFormat:@"%@",[dict valueForKey:@"clubname"]];
    [self performSegueWithIdentifier:SEGUE_TO_SUB_LIST sender:nil];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 303.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrList.count;
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
    
   NSLog(@"response %@",json);
    if(json !=nil)
    {
        arrList=[json valueForKey:@"jsonResponseList"];
        if(arrList.count>0)
        {
            [self.tblClub reloadData];
        }
    }
    
}

-(void)socketIODidConnect:(SocketIO *)socket
{
    //NSLog(@"connected !");
     [[AppDelegate sharedAppDelegate] hideLoadingView];
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
#pragma mark - prepareForSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SEGUE_TO_SUB_LIST])
    {
        VAListOfClubVC *vl=[segue destinationViewController];
        vl.strclubId=strculbid;
        vl.clubImg=clubImg;
        vl.strClubmName=strClubName;
    }
    else if ([segue.identifier isEqualToString:SEGUE_TO_SEARCH_CLUB])
    {
        SearchVC *sc=[segue destinationViewController];
        sc.arrAllClubs=arrList;
    }
    
}


#pragma mark -
#pragma mark - onClickedForPass

-(void)onClickedForPass:(UIButton*)sender
{
    NSDictionary *dict=[arrList objectAtIndex:sender.tag];

    NSString *strlatlog=[NSString stringWithFormat:@"%@",[dict valueForKey:@"latlong"]];
    strLatLong =strlatlog;
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Go to in Map" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Google Map",
                            @"Apple Map",
                            nil];
    popup.tag = 1;
    [popup showInView:self.view];
    
    
    
//    NSMutableArray *installedNavigationApps = [[NSMutableArray alloc] initWithObjects:@"Apple Maps", nil];
//
//    if ([[UIApplication sharedApplication] canOpenURL:
//         [NSURL URLWithString:@"comgooglemaps://"]])
//    {
//        [installedNavigationApps addObject:@"Google Maps"];
//    }
//
//    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Selecione um aplicativo" message:@"Abrir com" preferredStyle:UIAlertControllerStyleActionSheet];
//
//
//    for (NSString *app in installedNavigationApps) {
//
//        if([app isEqualToString:@"Apple Maps"])
//        {
//            [actionSheet addAction:[UIAlertAction actionWithTitle:app style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//
//                [[UIApplication sharedApplication] openURL:
//                 [NSURL URLWithString: [NSString stringWithFormat:@"http://maps.apple.com/?ll=%@",strlatlog]]];
//
//            }]];
//
//        }
//        else if([app isEqualToString:@"Google Maps"])
//        {
//            [actionSheet addAction:[UIAlertAction actionWithTitle:app style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//
//                [[UIApplication sharedApplication] openURL:
//                 [NSURL URLWithString: [NSString stringWithFormat:@"comgooglemaps://?ll=%@",strlatlog]]];
//            }]];
//        }
//    }
//    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
//    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self googlemap];
                    break;
                case 1:
                    [self applemap];
                    break;
               
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

-(void)googlemap
{
    NSString *strlat=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_LAT];
    NSString *strlong=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_LONG];
    NSString *str = [NSString stringWithFormat:@"comgooglemaps://?saddr=%@,%@&daddr=%@&zoom=14&views=traffic",strlat,strlong,strLatLong];
    
    //google map
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else
    {
        NSLog(@"Can't use comgooglemaps://");
    }
}

-(void)applemap
{
    NSString *strlat=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_LAT];
    NSString *strlong=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_LONG];
    NSString *strfinal=[NSString stringWithFormat:@"%@,%@",strlat,strlong];
    // Navigate from one coordinate to another
    NSString *url =[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%@&daddr=%@",strfinal,strLatLong];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    
   
}
#pragma mark -
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
