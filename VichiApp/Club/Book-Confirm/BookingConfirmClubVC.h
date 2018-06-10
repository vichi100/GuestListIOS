//
//  BookingConfirmClubVC.h
//  VichiApp
//
//  Created by Angel on 06/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingConfirmClubVC : UIViewController

@property (strong, nonatomic)NSMutableDictionary *dictMain;
@property (strong, nonatomic)NSString *sttype;
@property (strong, nonatomic)NSString *strCouple;
@property (strong, nonatomic)NSString *strGirl;
@property (strong, nonatomic)NSString *strStage;
@property (strong, nonatomic)NSString *strAmount;

@property (strong, nonatomic)NSDictionary *dictClub;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;

@property (weak, nonatomic) IBOutlet UILabel *lblclubname;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIButton *btndone;
- (IBAction)onclickfordone:(id)sender;
- (IBAction)onClickforBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgqrcpde;
@property (weak, nonatomic) IBOutlet UILabel *lblCoupleorgirl;
@property (weak, nonatomic) IBOutlet UILabel *lblNote;

@property (weak, nonatomic) IBOutlet UIView *preview;


@end
