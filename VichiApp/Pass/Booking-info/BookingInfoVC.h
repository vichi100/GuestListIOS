//
//  BookingInfoVC.h
//  VichiApp
//
//  Created by Angel on 06/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingInfoVC : UIViewController

@property (strong, nonatomic)NSMutableDictionary *dictstore;

//@property (weak, nonatomic) IBOutlet UILabel *lblclubname;
//@property (weak, nonatomic) IBOutlet UILabel *lblDate;
//@property (weak, nonatomic) IBOutlet UIButton *btndone;
- (IBAction)onclickfordone:(id)sender;
- (IBAction)onClickforBack:(id)sender;
//@property (weak, nonatomic) IBOutlet UIImageView *imgqrcpde;
//@property (weak, nonatomic) IBOutlet UILabel *lblinfotable;
//@property (weak, nonatomic) IBOutlet UILabel *lblnote;
//@property (weak, nonatomic) IBOutlet UILabel *lblcouple;
//
//@property (weak, nonatomic) IBOutlet UIView *preview;
@property (strong, nonatomic) IBOutlet UILabel *lblclubName;
@property (strong, nonatomic) IBOutlet UILabel *lblEntry;
@property (strong, nonatomic) IBOutlet UILabel *lblrecommand;
@property (strong, nonatomic) IBOutlet UIView *previewview;
@property (strong, nonatomic) IBOutlet UIImageView *imgQr;

@property (strong, nonatomic) IBOutlet UILabel *lblQrCode;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lbldetails;



@end
