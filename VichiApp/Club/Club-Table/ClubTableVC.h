//
//  ClubTableVC.h
//  VichiApp
//
//  Created by Angel on 07/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubTableVC : UIViewController

@property (strong, nonatomic)NSMutableDictionary *dictMain;
@property (strong, nonatomic)NSMutableArray *arrTableList;
@property (strong, nonatomic)NSString *prodimg;

@property (weak, nonatomic) IBOutlet UITableView *tbltable;

- (IBAction)onClickforBack:(id)sender;

@end
