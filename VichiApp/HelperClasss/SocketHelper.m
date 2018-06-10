//
//  SocketHelper.m
//  VichiApp
//
//  Created by Angel on 13/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "SocketHelper.h"
#import "SocketIO.h"
#import "VAConstant.h"

@implementation SocketHelper

-(id)init
{
    if ((self = [super init]))
    {
        socketIO = [[SocketIO alloc] initWithDelegate:self];
        [socketIO connectToHost:IP_URL onPort:3080];
    }
    return self;
}

-(void)sendMessageSocket :(NSMutableDictionary *)dict
{
    //NSMutableDictionary *dict = [NSMutableDictionary dictionary];
   // [dict setObject:@"loadClubListFromDatabase" forKey:@"action"];
    NSError * err;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    NSLog(@" my json string : %@",myString);
    [socketIO sendMessage:myString];
    
}

#pragma mark -
#pragma mark - socket delegate :


// message delegate
- (void) socketIO:(SocketIO *)socket didReceiveMessage:(NSString *)packet
{
        NSError *jsonError;
        NSData *objectData = [packet dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                             options:NSJSONReadingMutableContainers
    
                                                               error:&jsonError];
    
        NSLog(@"response %@",json);
        jsonresonse=[[NSMutableDictionary alloc] init];
        jsonresonse=[json mutableCopy];
    
}

-(void)socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"connected !");
}

// event delegate
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveEvent >>> data: %@",packet);
    
    
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error
{
    NSLog(@"didReceiveEvent >>> error : ");
}

- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    NSLog(@"socket.io disconnected. did error occur? %@", error);
}

#pragma mark - memroy mgnt :

-(void)getDataFromPath:(NSString *)path withParamData:(NSMutableDictionary *)dictParam withBlock:(RequestCompletionBlock)block
{
    if (block) {
        dataBlock=[block copy];
    }
    NSLog(@"Response: %@", jsonresonse);
    if (dataBlock) {
        if(jsonresonse==nil)
            dataBlock(jsonresonse,nil);
        else
            dataBlock(jsonresonse,nil);
    }
}


@end
