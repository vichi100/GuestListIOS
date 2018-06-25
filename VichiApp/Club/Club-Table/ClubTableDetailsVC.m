//
//  ClubTableDetailsVC.m
//  VichiApp
//
//  Created by Angel on 07/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "ClubTableDetailsVC.h"
#import "VAConstant.h"
#import "SocketIO.h"
#import "AppDelegate.h"
#import "PaymentsSDK.h"
#import "AFNetworking.h"
#import "BookingConfirmClubVC.h"
#import "UIImageView+Download.h"
#import "LoginVC.h"

// current time to milsecond and genreate qr code :


@interface ClubTableDetailsVC ()<SocketIODelegate,PGTransactionDelegate>
{
    NSString *strChecksum,*strOrderId;
      SocketIO *socketIO;
    NSArray *strAmount;
    NSString *strPaidAmount,*strRemainingAmount,*stDiscount,*strcostafterdiscount,*strFullAmound_d,*strRemaing_d,*strAfterAmount_Offer_d,*strPaidAmountOffer_d,*strRemainingOffer_d;
    
}
@end

@implementation ClubTableDetailsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    strChecksum=@"";
    [self setDetails];

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
    [self.scrollview setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollview setContentSize:CGSizeMake(self.view.frame.size.width, 800)];
    
}

-(void)setDetails
{
    if(self.dictMain != nil){
        [self.imgItem downloadFromURL:[NSString stringWithFormat:@"%@",[self.dictMain valueForKey:@"imageURL"]] withPlaceholder:[UIImage imageNamed:@"place"]];
    } else{
        [self.imgItem downloadFromURL:[NSString stringWithFormat:@"%@",self->_imgProd] withPlaceholder:[UIImage imageNamed:@"place"]];
    }
    
    
    self.imgItem.clipsToBounds=YES;
    
    NSString *dateStr = [NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"date"]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MMM/yyyy"];
    
    NSDate *date = [dateFormat dateFromString:dateStr];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dayName = [dateFormatter stringFromDate:date];
    
    self.lblDate.text=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"date"]];
    self.lblDay.text=dayName;
    self.lblType.text=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"type"]];
    self.lblguest.text=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"size"]];
    self.lbldpersonalservices.text=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"details"]];
   
    strPaidAmount=[self.dictstore valueForKey:@"cost"];
    
   // int bookingamt = [[self.dictstore valueForKey:@"cost"] floatValue]/[[self.dictstore valueForKey:@"totaltickets"] floatValue];
   // self.lblbookinamount.text=[NSString stringWithFormat:@"%d",bookingamt];
   // self.lblsubnotebooking.text=[NSString stringWithFormat:@"%d Rs need to pay at club",bookingamt];
    
    if([self.dictMain objectForKey:@"OfferForTable"])
    {
        int discount= [[self.dictstore valueForKey:@"cost"] floatValue]*[[self.dictMain valueForKey:@"OfferForTable"] floatValue]/100;
        int dicountamount = [[self.dictstore valueForKey:@"cost"] floatValue] - discount;
        
        NSString *strp=@"%";
        self.lblcost.text=[NSString stringWithFormat:@"%d RS FULL COVER AFTER %@%@ DISCOUNT ",dicountamount,[self.dictMain valueForKey:@"OfferForTable"],strp];
        strRemainingAmount=[NSString stringWithFormat:@"%d",dicountamount];
        strAfterAmount_Offer_d=[NSString stringWithFormat:@"%d",dicountamount];
        int fullamount=0;
        if(dicountamount <= 10000)
        {
            stDiscount =@"50";
            fullamount = (dicountamount*50)/100;
        }
        else if(dicountamount <= 20000)
        {
            stDiscount =@"30";
            fullamount = (dicountamount*30)/100;
        }
        else if(dicountamount <= 50000)
        {
            stDiscount =@"25";
            fullamount = (dicountamount*25)/100;
        }
        else if(dicountamount <=200000)
        {
            stDiscount =@"20";
            fullamount = (dicountamount*20)/100;
        }
        strFullAmound_d=[NSString stringWithFormat:@"%d",fullamount];
       int totablepayableamount = dicountamount - fullamount;
        strcostafterdiscount=[NSString stringWithFormat:@"%d",totablepayableamount];
        strPaidAmountOffer_d=[NSString stringWithFormat:@"%d",fullamount];
        self.lblbookinamount.text=[NSString stringWithFormat:@"%d",fullamount];
        self.lblsubnotebooking.text=[NSString stringWithFormat:@"%d Rs Need To Pay At Club",totablepayableamount];
        strRemainingOffer_d=[NSString stringWithFormat:@"%d",totablepayableamount];
        strRemaing_d=[NSString stringWithFormat:@"%d",totablepayableamount];
        
    }else
    {
        int totalamount = [[self.dictstore valueForKey:@"cost"] intValue];
         self.lblcost.text=[NSString stringWithFormat:@"%@ Rs FULL COVER",[self.dictstore valueForKey:@"cost"]];
        strRemainingAmount=[NSString stringWithFormat:@"%d",totalamount];

        int fullamount=0;
        if(totalamount <= 10000)
        {
            stDiscount =@"50";
            fullamount = (totalamount*50)/100;
        }
        else if(totalamount <= 20000)
        {
            stDiscount =@"30";
            fullamount = (totalamount*30)/100;
        }
        else if(totalamount <= 50000)
        {
            stDiscount =@"25";
            fullamount = (totalamount*25)/100;
        }
        else if(totalamount <=200000)
        {
             stDiscount =@"20";
            fullamount = (totalamount*20)/100;
        }
        
        strFullAmound_d=[NSString stringWithFormat:@"%d",fullamount];
        
        int totablepayableamount = totalamount - fullamount;
        strcostafterdiscount=[NSString stringWithFormat:@"%d",totablepayableamount];
        strRemainingAmount = [NSString stringWithFormat:@"%d",totalamount];
        strRemaing_d=[NSString stringWithFormat:@"%d",totablepayableamount];
        self.lblbookinamount.text=[NSString stringWithFormat:@"%d",fullamount];
        self.lblsubnotebooking.text=[NSString stringWithFormat:@"%d Rs Need To Pay At Club",totablepayableamount ];
    }
    
}

#pragma mark -
#pragma mark - book :


- (IBAction)onClcikforBook:(id)sender
{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_ID];
    if(str != nil)
    {
    NSString *dateStr = [NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"date"]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MMM/yyyy"];
    
    NSDate *date = [dateFormat dateFromString:dateStr];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dayName = [dateFormatter stringFromDate:date];
    
    if([self.dictstore objectForKey:@"date"])
    {
        self.lblDate.text=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"date"]];
    }
    else
    {
            self.lblDate.text=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"eventDate"]];
    }

    self.lblDay.text=dayName;
    self.lblType.text=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"type"]];
    self.lblguest.text=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"size"]];
    self.lbldpersonalservices.text=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"details"]];
    self.lblcost.text=[NSString stringWithFormat:@"%@ Rs FULL COVER",[self.dictstore valueForKey:@"cost"]];
    
    if([socketIO isConnected])
    {
        
        NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]); //double
        long digits = (long)time; //first 10 digits
        int decimalDigits = (int)(fmod(time, 1) * 1000); //3 missing digits
        /*** long ***/
        long timestamp = (digits * 1000) + decimalDigits;
        /*** string ***/
        NSString *timestampString = [NSString stringWithFormat:@"%ld%03d",digits ,decimalDigits];
        
        
        NSString *strdate;
        
        if([self.dictstore objectForKey:@"date"])
        {
            strdate=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"date"]];
        }
        else
        {
            strdate=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"eventDate"]];
        }

        
        NSString *strcid=[[NSUserDefaults standardUserDefaults]objectForKey:PREF_USER_ID];
        NSDictionary *dictro=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_DATA];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"inserOrderDetails" forKey:@"action"];
        [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"type"]] forKey:@"tickettype"];
             [dict setObject:[NSString stringWithFormat:@"Table For %@",[self.dictstore valueForKey:@"size"]] forKey:@"ticketDetails"];
        [dict setObject:[NSString stringWithFormat:@"%@",strdate] forKey:@"date"];
        [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubid"]] forKey:@"clubid"];
        [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubname"]] forKey:@"clubname"];
        [dict setObject:[NSString stringWithFormat:@"%@",timestampString] forKey:@"QRnumber"];
        [dict setObject:[NSString stringWithFormat:@"%@",[dictro valueForKey:@"email"]] forKey:@"cutomername"];
        [dict setObject:[NSString stringWithFormat:@"%@",[dictro valueForKey:@"mob"]] forKey:@"mobile"];
        [dict setObject:strcid forKey:@"customerId"];
     
        if([self.dictMain objectForKey:@"OfferForTable"])
        {
           [dict setObject:[NSString stringWithFormat:@"%@",[self.dictMain valueForKey:@"OfferForTable"]] forKey:@"discount"];
            [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"cost"]] forKey:@"cost"];
              [dict setObject:[NSString stringWithFormat:@"%@",strAfterAmount_Offer_d] forKey:@"costafterdiscount"];
             [dict setObject:[NSString stringWithFormat:@"%@",strPaidAmountOffer_d] forKey:@"paidamount"];
             [dict setObject:[NSString stringWithFormat:@"%@",strRemainingOffer_d] forKey:@"remainingamount"];
        }
        else
        {
             [dict setObject:@"0" forKey:@"discount"];
            [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"cost"]] forKey:@"cost"];
             [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"cost"]] forKey:@"costafterdiscount"];
              [dict setObject:[NSString stringWithFormat:@"%@",strFullAmound_d] forKey:@"paidamount"];
              [dict setObject:[NSString stringWithFormat:@"%@",strRemaing_d] forKey:@"remainingamount"];
            
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
        
        NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]); //double
        long digits = (long)time; //first 10 digits
        int decimalDigits = (int)(fmod(time, 1) * 1000); //3 missing digits
        /*** long ***/
        long timestamp = (digits * 1000) + decimalDigits;
        /*** string ***/
        NSString *timestampString = [NSString stringWithFormat:@"%ld%03d",digits ,decimalDigits];

        NSString *strdate;
        if([self.dictstore objectForKey:@"date"])
        {
            strdate=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"date"]];
        }
        else
        {
            strdate=[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"eventDate"]];
        }
        
        NSString *strcid=[[NSUserDefaults standardUserDefaults]objectForKey:PREF_USER_ID];
        NSDictionary *dictro=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_DATA];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"inserOrderDetails" forKey:@"action"];
        [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"type"]] forKey:@"tickettype"];
        [dict setObject:[NSString stringWithFormat:@"Table For %@",[self.dictstore valueForKey:@"size"]] forKey:@"ticketDetails"];
        [dict setObject:[NSString stringWithFormat:@"%@",strdate] forKey:@"date"];
        [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubid"]] forKey:@"clubid"];
        [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"clubname"]] forKey:@"clubname"];
        [dict setObject:[NSString stringWithFormat:@"%@",timestampString] forKey:@"QRnumber"];
        [dict setObject:[NSString stringWithFormat:@"%@",[dictro valueForKey:@"email"]] forKey:@"cutomername"];
        [dict setObject:[NSString stringWithFormat:@"%@",[dictro valueForKey:@"mob"]] forKey:@"mobile"];
        [dict setObject:strcid forKey:@"customerId"];
   
        if([self.dictMain objectForKey:@"OfferForTable"])
        {
            [dict setObject:[NSString stringWithFormat:@"%@",[self.dictMain valueForKey:@"OfferForTable"]] forKey:@"discount"];
            [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"cost"]] forKey:@"cost"];
            [dict setObject:[NSString stringWithFormat:@"%@",strAfterAmount_Offer_d] forKey:@"costafterdiscount"];
            [dict setObject:[NSString stringWithFormat:@"%@",strPaidAmountOffer_d] forKey:@"paidamount"];
            [dict setObject:[NSString stringWithFormat:@"%@",strRemainingOffer_d] forKey:@"remainingamount"];
        }
        else
        {
            [dict setObject:@"0" forKey:@"discount"];
            [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"cost"]] forKey:@"cost"];
            [dict setObject:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"cost"]] forKey:@"costafterdiscount"];
            [dict setObject:[NSString stringWithFormat:@"%@",strFullAmound_d] forKey:@"paidamount"];
            [dict setObject:[NSString stringWithFormat:@"%@",strRemaing_d] forKey:@"remainingamount"];
            
        }
        NSError * err;
        NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
        NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
        NSLog(@" my json string : %@",myString);
        [socketIO sendMessage:myString];
        [[AppDelegate sharedAppDelegate] showLoadingWithTitle:@"please wait"];
    }

    }else
    {
        LoginVC *add = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:add animated:YES completion:nil];
    //strOrderId=[self generateOrderIDWithPrefix:@"ORD"];
    //[self serviceForChecksum];
    }
    
   // [self performSegueWithIdentifier:SGEUE_TO_BOOKING_CONFRM_FROM_TABLE sender:nil];
}

//Once transaction is completed you get response from this delegate

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
        [dictParam setValue:[self.dictstore valueForKey:@"cost"] forKey:@"amount"];
        
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
        [self performSegueWithIdentifier:SGEUE_TO_BOOKING_CONFRM_FROM_TABLE sender:nil];
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
        [dictParam setValue:[NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"cost"]] forKey:@"TXN_AMOUNT"];
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
                 orderDict[@"TXN_AMOUNT"] = [NSString stringWithFormat:@"%@",[self.dictstore valueForKey:@"cost"]];
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

#pragma mark -
#pragma mark - preppare :

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SGEUE_TO_BOOKING_CONFRM_FROM_TABLE])
    {
        BookingConfirmClubVC *bv=[segue destinationViewController];
        bv.dictClub=self.dictstore;
        bv.dictMain=self.dictMain;
        bv.sttype=@"0";
        
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
