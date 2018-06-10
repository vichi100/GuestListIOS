//
//  GuestListVC.h
//  VichiApp
//
//  Created by Angel on 06/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestListVC : UIViewController

@property (strong, nonatomic)NSMutableDictionary *dictstore;
@property (strong, nonatomic)NSMutableDictionary *dictmain;

@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIButton *btncouple;
- (IBAction)onClickforcouple:(id)sender;
- (IBAction)onClickforOnlyGrils:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btngirls;
@property (weak, nonatomic) IBOutlet UIButton *btnbook;
- (IBAction)onClickforBack:(id)sender;
- (IBAction)onClickforBookingUpdate:(id)sender;
- (IBAction)onClickforBooked:(id)sender;

- (IBAction)onClickforBooking:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblNote;
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (strong, nonatomic) IBOutlet UILabel *lblmusic;
- (IBAction)onClickforCpl:(id)sender;
- (IBAction)onClickforGirlMax:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnbookingUpdated;

- (IBAction)onClickforBackUpdated:(id)sender;
- (IBAction)mybooking:(id)sender;

@end
