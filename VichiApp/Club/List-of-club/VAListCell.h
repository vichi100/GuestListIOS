//
//  VAListCell.h
//  VichiApp
//
//  Created by Angel on 06/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VAListCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *lbltitel;
@property (strong, nonatomic) IBOutlet UIImageView *imgItem;
@property (strong, nonatomic) IBOutlet UILabel *lblsubTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnguest;
@property (strong, nonatomic) IBOutlet UIButton *btmpass;
@property (strong, nonatomic) IBOutlet UIButton *btntable;

@end
