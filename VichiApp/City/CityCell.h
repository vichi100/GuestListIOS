//
//  CityCell.h
//  GuestList
//
//  Created by Hiren Dhamecha on 4/4/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgitem;
@property (strong, nonatomic) IBOutlet UIView *bgview;
@property (strong, nonatomic) IBOutlet UILabel *lblname;

@end
