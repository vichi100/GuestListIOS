//
//  ClubTableVC.m
//  VichiApp
//
//  Created by Angel on 07/02/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "ClubTableVC.h"
#import "PassesCell.h"
#import "VAConstant.h"
#import "ClubTableDetailsVC.h"

@interface ClubTableVC ()
{
    NSMutableDictionary *dictstore;
}
@end

@implementation ClubTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.arrTableList.count>0)
    {
        [self.tbltable reloadData];
    }
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [self design];
}

#pragma mark - design :

-(void)design
{
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton=YES;
    self.tabBarController.tabBar.hidden = true;
}


#pragma mark - Tableview Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PassesCell *cell=[self.tbltable dequeueReusableCellWithIdentifier:@"tblcell"];
    if(cell == nil)
    {
        cell=[[PassesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tblcell"];
    }
    NSDictionary *dict=[self.arrTableList objectAtIndex:indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    NSString *str = [NSString stringWithFormat:@"%@",[dict valueForKey:@"clubname"]];
    NSMutableString *result = [str mutableCopy];
    [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
                               options:NSStringEnumerationByWords
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                      withString:[[substring substringToIndex:1] uppercaseString]];
                            }];
  
    cell.lblTitle.text=result;
    
    cell.lblsubtitle.text=[NSString stringWithFormat:@"Table For %@",[dict valueForKey:@"size"]];
    cell.lblDate.text=[NSString stringWithFormat:@"%@",[dict valueForKey:@"date"]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tbltable deselectRowAtIndexPath:indexPath animated:YES];
    dictstore=[[NSMutableDictionary alloc] init];
    dictstore=[self.arrTableList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:SEGUE_TO_TABLE_DETAILS sender:nil];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    
    return self.arrTableList.count;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SEGUE_TO_TABLE_DETAILS])
    {
        ClubTableDetailsVC *clb=[segue destinationViewController];
        clb.dictstore=dictstore;
        clb.imgProd=self.prodimg;
        clb.dictMain=self.dictMain;
    }
}

#pragma mark - back :

- (IBAction)onClickforBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];   
    
}

#pragma mark - memrory mgnt :

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
