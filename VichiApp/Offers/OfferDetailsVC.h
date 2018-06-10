//
//  OfferDetailsVC.h
//  GuestList
//
//  Created by Hiren Dhamecha on 4/5/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferDetailsVC : UIViewController

@property (strong, nonatomic)NSMutableDictionary *dictstore;
@property (strong, nonatomic) IBOutlet UILabel *lblpassoff;
@property (strong, nonatomic) IBOutlet UILabel *lbltableoff;

@property (strong, nonatomic) IBOutlet UIImageView *imgBg;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblDay;
@property (strong, nonatomic) IBOutlet UILabel *lbltitle;
@property (strong, nonatomic) IBOutlet UILabel *lblmusic;
@property (strong, nonatomic) IBOutlet UILabel *lblmusicDetails;
@property (strong, nonatomic) IBOutlet UIButton *btnguest;
@property (strong, nonatomic) IBOutlet UIButton *btntbl;
@property (strong, nonatomic) IBOutlet UIButton *btnpass;
- (IBAction)onClickforback:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnback;

- (IBAction)onClickforGuestList:(id)sender;
- (IBAction)onClcikforPasses:(id)sender;
- (IBAction)onClickforTable:(id)sender;

@end
