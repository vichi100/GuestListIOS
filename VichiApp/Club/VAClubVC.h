//
//  VAClubVC.h
//  VichiApp
//
//  Created by Hiren Dhamecha on 2/6/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VAClubVC : UIViewController

@property (strong, nonatomic)NSString *strname;

@property (strong, nonatomic) IBOutlet UITableView *tblClub;
@property (strong, nonatomic) IBOutlet UIButton *btnsearch;
- (IBAction)onClickforSearch:(id)sender;
- (IBAction)onClickforMap:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@end
