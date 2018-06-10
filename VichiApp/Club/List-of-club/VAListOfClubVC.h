//
//  VAListOfClubVC.h
//  VichiApp
//
//  Created by Angel on 06/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VAListOfClubVC : UIViewController

@property (strong, nonatomic)NSString *strClubmName;
@property (strong, nonatomic)NSString *strclubId;
@property (strong, nonatomic)NSString *clubImg;

@property (weak, nonatomic) IBOutlet UIView *topview;
@property (weak, nonatomic) IBOutlet UITableView *tbllist;
@property (weak, nonatomic) IBOutlet UIImageView *imgItem;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
- (IBAction)onClickforBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle;

@end
