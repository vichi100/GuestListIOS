//
//  ProfileVC.h
//  VichiApp
//
//  Created by Hiren Dhamecha on 2/6/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *aboutview;

- (IBAction)onClcikforAboutus:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtname;
@property (weak, nonatomic) IBOutlet UITextField *txtmob;
- (IBAction)onClcikforEdit:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *helpview;
- (IBAction)onClickforCall:(id)sender;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)onClickforDone:(id)sender;
@end
