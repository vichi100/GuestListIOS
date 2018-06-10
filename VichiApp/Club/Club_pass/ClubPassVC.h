//
//  ClubPassVC.h
//  VichiApp
//
//  Created by Angel on 06/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubPassVC : UIViewController

@property (strong, nonatomic)NSMutableDictionary *dictstore;
@property (strong, nonatomic)NSMutableDictionary *dictMain;


@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UIImageView *imgItem;
- (IBAction)onClcikforBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblQuoteone;
@property (weak, nonatomic) IBOutlet UILabel *lblquotetwo;
@property (weak, nonatomic) IBOutlet UILabel *lblQuotethree;
- (IBAction)onClickforMinusone:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblone;
- (IBAction)onClickforPlusOne:(id)sender;

- (IBAction)onClickforMinusTwo:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbltwo;
- (IBAction)onClickforPlusTwo:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblthree;

- (IBAction)onClickforPlusThree:(id)sender;
- (IBAction)onClickofrMinusThree:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
- (IBAction)onClickforBook:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbdiscount;



@end
