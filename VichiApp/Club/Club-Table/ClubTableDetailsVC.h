//
//  ClubTableDetailsVC.h
//  VichiApp
//
//  Created by Angel on 07/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubTableDetailsVC : UIViewController

@property (strong, nonatomic)NSMutableDictionary *dictMain;
@property (strong, nonatomic)NSMutableDictionary *dictstore;
@property (strong, nonatomic)NSString *imgProd;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lbltblDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblguest;
@property (weak, nonatomic) IBOutlet UILabel *lbldpersonalservices;
@property (weak, nonatomic) IBOutlet UILabel *lblcost;
@property (weak, nonatomic) IBOutlet UILabel *lblNote;

@property (weak, nonatomic) IBOutlet UIButton *btnbook;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UIImageView *imgItem;

- (IBAction)onClcikforBook:(id)sender;
- (IBAction)onClickforBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblbookinamount;
@property (weak, nonatomic) IBOutlet UILabel *lblsubnotebooking;

@end
