//
//  ViewController.h
//  VichiApp
//
//  Created by Hiren Dhamecha on 2/5/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)onClickforDone:(id)sender;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) IBOutlet UITextField *txtname;
- (IBAction)onClickforStartActivity:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtmob;
@property (strong, nonatomic) IBOutlet UITextField *txtconfmob;
@property (strong, nonatomic) IBOutlet UIButton *btnstart;

- (IBAction)onClickforAge:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnage;


@end

