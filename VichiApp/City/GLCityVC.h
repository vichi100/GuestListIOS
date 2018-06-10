//
//  GLCityVC.h
//  GuestList
//
//  Created by Hiren Dhamecha on 4/4/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLCityVC : UIViewController
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
- (IBAction)onClickforStartActivity:(id)sender;

- (IBAction)onClickforBack:(id)sender;


@end
