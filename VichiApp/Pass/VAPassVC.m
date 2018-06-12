//
//  VAPassVC.m
//  VichiApp
//
//  Created by Hiren Dhamecha on 2/6/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "VAPassVC.h"
#import "PassesCell.h"
#import "VAConstant.h"
#import "SocketIO.h"
#import "AppDelegate.h"
#import "UIImageView+Download.h"
#import "ClubTableVC.h"
#import "ClubPassVC.h"
#import "BookingInfoVC.h"

@interface VAPassVC ()<SocketIODelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arrDetails;
    SocketIO *socketIO;
    NSMutableDictionary *dictstore;
    int cost;

}
@end

@implementation VAPassVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrDetails=[[NSMutableArray alloc] init];
 
    
}

-(void)viewWillAppear:(BOOL)animated
{
        self.tabBarController.tabBar.hidden = false;
       [self establishclublist];
}

#pragma mark -
#pragma mark - establlish club list :

-(void)establishclublist
{
    if([socketIO isConnected])
    {
        NSDictionary *dictr=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_DATA];
        NSString *strcid=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_ID];
        if(strcid != nil)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"getbookedTicketFromDatabase" forKey:@"action"];
            [dict setObject:[NSString stringWithFormat:@"%@",[dictr valueForKey:@"mob"]] forKey:@"mobile"];
            [dict setObject:strcid forKey:@"customerId"];
            
            NSError * err;
            NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
            NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
            NSLog(@" my json string : %@",myString);
            [socketIO sendMessage:myString];
            [[AppDelegate sharedAppDelegate] showLoadingWithTitle:@"please wait"];
        }
    }
    else
    {
        socketIO = [[SocketIO alloc] initWithDelegate:self];
        [socketIO connectToHost:IP_URL onPort:3080];
        
        NSDictionary *dictr=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_DATA];
        NSString *strcid=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_ID];
        if(strcid != nil)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@"getbookedTicketFromDatabase" forKey:@"action"];
            [dict setObject:[NSString stringWithFormat:@"%@",[dictr valueForKey:@"mob"]] forKey:@"mobile"];
            [dict setObject:strcid forKey:@"customerId"];

            NSError * err;
            NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
            NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
            NSLog(@" my json string : %@",myString);
            [socketIO sendMessage:myString];
            [[AppDelegate sharedAppDelegate] showLoadingWithTitle:@"please wait"];
        }
    }
    
}

#pragma mark - Tableview Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PassesCell *cell=[self.tblpass dequeueReusableCellWithIdentifier:@"pcell"];
    
    if(cell == nil)
    {
        cell=[[PassesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pcell"];
    }
    
    NSDictionary *dict=[arrDetails objectAtIndex:indexPath.row];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.lblDate.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"eventDate"]];
    
    NSString *str = [NSString stringWithFormat:@"%@",[dict valueForKey:@"clubname"]];
    NSMutableString *result = [str mutableCopy];
    [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
                               options:NSStringEnumerationByWords
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                      withString:[[substring substringToIndex:1] uppercaseString]];
                            }];

    
    cell.lblTitle.text=[NSString stringWithFormat:@"%@",result];
    NSString *strTicketType = [dict valueForKey:@"tickettype"];
    cell.lblsubtitle.text=[NSString stringWithFormat:@"%@",strTicketType.capitalizedString];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tblpass deselectRowAtIndexPath:indexPath animated:YES];
    dictstore=[[NSMutableDictionary alloc] init];
    dictstore=[arrDetails objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:SEGUE_TO_PASSES sender:nil];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84.0f;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrDetails.count;
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
    
    [[AppDelegate sharedAppDelegate] hideHUDLoadingView];
    
    if(json !=nil)
    {
        NSArray *ard=[json valueForKey:@"bookedTicketList"];
        
        if(ard.count>0)
        {
            arrDetails=[[NSMutableArray alloc] initWithArray:ard];
            [self.tblpass reloadData];
        }
        else
        {
            [[AppDelegate sharedAppDelegate] showToastMessage:@"No Passes Found !"];
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

#pragma mark - prepareForSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SEGUE_TO_PASSES])
    {
        BookingInfoVC *bv=[segue destinationViewController];
        bv.dictstore=dictstore;
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
