//
//  ProfileVC.m
//  VichiApp
//
//  Created by Hiren Dhamecha on 2/6/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "ProfileVC.h"
#import "AppDelegate.h"
#import "VAConstant.h"

@interface ProfileVC ()<UITextFieldDelegate>
{
    int flag;
}

@end

@implementation ProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    flag=0;
    [self setDetails];

}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = false;
}

#pragma mark - set details :

-(void)setDetails
{
    
    NSDictionary *dict=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_USER_DATA];
    if(dict != nil)
    {
        if([dict objectForKey:@"mob"])
        {
            self.txtmob.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"mob"]];
        }
        if([dict objectForKey:@"email"])
        {
          self.txtname.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"email"]];
        }
        
    }else
    {
        self.txtmob.text=@"Guest";
        self.txtname.text=@"";
    }

    self.txtname.userInteractionEnabled=NO;
    self.txtmob.userInteractionEnabled=NO;
    
    self.txtmob.inputAccessoryView=self.toolbar;
    
    self.helpview.layer.cornerRadius=3;
    self.helpview.clipsToBounds=YES;
    
    self.aboutview.layer.cornerRadius=3;
    self.aboutview.clipsToBounds=YES;
    
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];

    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(self.txtname==textField)
    {
        
        [UIView animateWithDuration:0
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.view.frame = CGRectMake(0, -150, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];

        
    }else
    {
        [UIView animateWithDuration:0
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.view.frame = CGRectMake(0, -200, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];

    }
}

#pragma mark - call

- (IBAction)onClickforCall:(id)sender
{
    NSString *phoneNumber = [@"tel://" stringByAppendingString:self.txtmob.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (IBAction)onClcikforAboutus:(id)sender
{
    [self performSegueWithIdentifier:SEGUE_TO_ABOUT sender:nil];
}


- (IBAction)onClcikforEdit:(id)sender
{
    if(flag==0)
    {
        self.txtname.userInteractionEnabled=YES;
        self.txtmob.userInteractionEnabled=YES;
        flag=1;
        [self.txtname becomeFirstResponder];
        
    }else
    {
        flag=0;
        self.txtname.userInteractionEnabled=NO;
        self.txtmob.userInteractionEnabled=NO;
        
        NSMutableDictionary *dictr=[[NSMutableDictionary alloc] init];
        [dictr setValue:self.txtname.text forKey:@"email"];
        [dictr setValue:self.txtmob.text forKey:@"mob"];
        [[NSUserDefaults standardUserDefaults] setValue:dictr forKey:PREF_USER_DATA];
        [[AppDelegate sharedAppDelegate] showToastMessage:@"Update Successfully !"];
    }
    
}

- (IBAction)onClickforDone:(id)sender
{
    [self.txtmob resignFirstResponder];
    [UIView animateWithDuration:0
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished)
                    {
                     }];

}

#pragma mark - memroy mgnt :

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
