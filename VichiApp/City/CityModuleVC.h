//
//  CityModuleVC.h
//  GuestList
//
//  Created by Angel on 09/04/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityModuleVC : UIViewController

@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
- (IBAction)onClickforStartActivity:(id)sender;

- (IBAction)onClickforBack:(id)sender;
@end
