//
//  AboutusVC.m
//  GuestList
//
//  Created by Angel on 06/04/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "AboutusVC.h"

@interface AboutusVC ()

@end

@implementation AboutusVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = true;

}

#pragma mark - back :

- (IBAction)onClickforBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - memory mgnt :

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
