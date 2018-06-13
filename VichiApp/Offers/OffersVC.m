//
//  OffersVC.m
//  GuestList
//
//  Created by Hiren Dhamecha on 4/5/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "OffersVC.h"
#import "OffersCell.h"
#import "SocketIO.h"
#import "AppDelegate.h"
#import "VAConstant.h"
#import "OfferDetailsVC.h"

@interface OffersVC ()<UITableViewDelegate,UITableViewDataSource,SocketIODelegate>
{
    NSMutableArray *arrOffers;
    SocketIO *socketIO;
    NSMutableDictionary *dictstore;
    
}
@end

@implementation OffersVC

- (void)viewDidLoad
{
    [super viewDidLoad];

   
   
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    self.tabBarController.tabBar.hidden = false;
    arrOffers=[[NSMutableArray alloc] init];
    
    dictstore=[[NSMutableDictionary alloc] init];
     [self establishclublist];
    
}

#pragma mark - establlish club list :

-(void)establishclublist
{
    if([socketIO isConnected])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"getOffersFromDatabase" forKey:@"action"];
        [dict setObject:@"mumbai" forKey:@"city"];
        NSError * err;
        NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
        NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
        NSLog(@" my json string : %@",myString);
        [socketIO sendMessage:myString];
        //[[AppDelegate sharedAppDelegate] showLoadingWithTitle:@"please wait"];
    }
    else
    {
        socketIO = [[SocketIO alloc] initWithDelegate:self];
        [socketIO connectToHost:IP_URL onPort:3080];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"getOffersFromDatabase" forKey:@"action"];
        [dict setObject:@"mumbai" forKey:@"city"];
        NSError * err;
        NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
        NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
        NSLog(@" my json string : %@",myString);
        [socketIO sendMessage:myString];
       // [[AppDelegate sharedAppDelegate] showLoadingWithTitle:@"please wait"];
    }
    
}


#pragma mark - Tableview Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OffersCell *cell=[self.tbloffer dequeueReusableCellWithIdentifier:@"offercell"];
    
    if(cell == nil)
    {
        cell=[[OffersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"offercell"];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *dict=[arrOffers objectAtIndex:indexPath.row];
    
    NSString *str = [NSString stringWithFormat:@"%@",[dict valueForKey:@"clubname"]];
    NSMutableString *result = [str mutableCopy];
    [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
                               options:NSStringEnumerationByWords
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                      withString:[[substring substringToIndex:1] uppercaseString]];
              
                            }];
    
    
    NSString *dateStr = [dict valueForKey:@"timetoexpire"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MMM/yyyy HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateStr];

    NSLog(@"log :%@",date);
    
    NSString *dateStrstart = [dict valueForKey:@"starttime"];
    NSString *dateStrend = [dict valueForKey:@"timetoexpire"];
    
    NSDateFormatter *dateFormatd = [[NSDateFormatter alloc] init];
    [dateFormatd setDateFormat:@"dd/MMM/yyyy HH:mm:ss"];
    NSDate *dateend = [dateFormatd dateFromString:dateStrend];
    NSDate *datestart = [dateFormatd dateFromString:dateStrstart];
    
     //NSDate *dateend = [NSDate date];
     NSString *strFinalDate=[[AppDelegate sharedAppDelegate] remaningTime:datestart  endDate:dateend];
    
    
    cell.lblTitle.text=[NSString stringWithFormat:@"%@ | %@",result,[dict valueForKey:@"location"]];
    cell.lblOf.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"offername"]];
    cell.lblDate.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"date"]];
    cell.lbltime.text=[NSString stringWithFormat:@"Ending in %@",strFinalDate];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tbloffer deselectRowAtIndexPath:indexPath animated:YES];
    if(arrOffers.count>0)
    {
        dictstore=[arrOffers objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:SEGUE_TO_OFFER_DETIALS sender:nil];
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrOffers.count;
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
        arrOffers=[json valueForKey:@"offersList"];
        if(arrOffers.count>0)
        {
            [self.tbloffer reloadData];
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
    if([segue.identifier isEqualToString:SEGUE_TO_OFFER_DETIALS])
    {
        OfferDetailsVC *of=[segue destinationViewController];
        of.dictstore=dictstore;
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
