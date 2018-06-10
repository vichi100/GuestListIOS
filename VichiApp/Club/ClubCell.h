//
//  ClubCell.h
//  VichiApp
//
//  Created by Hiren Dhamecha on 2/6/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgItem;
@property (strong, nonatomic) IBOutlet UILabel *lblname;

@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UIButton *btnmap;


@end
