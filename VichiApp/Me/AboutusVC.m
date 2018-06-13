//
//  AboutusVC.m
//  GuestList
//
//  Created by Angel on 06/04/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "AboutusVC.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface AboutusVC ()

@end

@implementation AboutusVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor: RGB(35, 31, 32)];
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
