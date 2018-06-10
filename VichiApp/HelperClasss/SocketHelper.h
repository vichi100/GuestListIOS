//
//  SocketHelper.h
//  VichiApp
//
//  Created by Angel on 13/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"

typedef void (^RequestCompletionBlock)(id response, NSError *error);

@interface SocketHelper : NSObject<SocketIODelegate>
{
    //blocks
    RequestCompletionBlock dataBlock;
    SocketIO *socketIO;
    NSMutableDictionary *jsonresonse;
    
}

-(id)init;
-(void)getDataFromPath:(NSString *)path withParamData:(NSMutableDictionary *)dictParam withBlock:(RequestCompletionBlock)block;
-(void)sendMessageSocket :(NSMutableDictionary *)dict;

@end
