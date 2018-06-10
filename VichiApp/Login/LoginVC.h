//
//  LoginVC.h
//  GuestList
//
//  Created by Hiren Dhamecha on 31/05/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController

- (IBAction)onClickforDone:(id)sender;
- (IBAction)onClickforCancel:(id)sender;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) IBOutlet UITextField *txtname;
- (IBAction)onClickforStartActivity:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtmob;
@property (strong, nonatomic) IBOutlet UITextField *txtconfmob;
@property (strong, nonatomic) IBOutlet UIButton *btnstart;

- (IBAction)onClickforAge:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnage;

@end
