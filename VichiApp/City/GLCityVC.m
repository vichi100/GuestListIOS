//
//  GLCityVC.m
//  GuestList
//
//  Created by Hiren Dhamecha on 4/4/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "GLCityVC.h"
#import "CityCell.h"
#import "VAConstant.h"
#import "VAClubVC.h"

@interface GLCityVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *arrItem,*arrChk;
    NSString *Strname;
}
@end

@implementation GLCityVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrItem=[[NSMutableArray alloc] initWithObjects:@"mumbai",@"pune1",@"delhi",@"bangloore",@"hydrabad",@"chennai", nil];
    arrChk=[[NSMutableArray alloc] initWithObjects:@"1",@"0",@"0",@"0",@"0",@"0", nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
        self.tabBarController.tabBar.hidden = true;
}

#pragma mark - UICollection View - delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrItem.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CityCell *cell=[self.collectionview dequeueReusableCellWithReuseIdentifier:@"ccell" forIndexPath:indexPath];

    [cell.imgitem setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[arrItem objectAtIndex:indexPath.row]]]];
    
    cell.imgitem.clipsToBounds=YES;
    if([[arrChk objectAtIndex:indexPath.row] intValue]==1)
    {
        [cell.bgview setBackgroundColor:[UIColor colorWithRed:0/255.0f green:192/255.0f blue:94/255.0f alpha:1]];
    }
    else
    {
        [cell.bgview setBackgroundColor:[UIColor clearColor]];
    }
    
    return cell;
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    [self.collectionview deselectItemAtIndexPath:indexPath animated:YES];
    
    for(int i=0;i<arrChk.count;i++)
    {
        if(indexPath.row==i)
        {
            [arrChk replaceObjectAtIndex:i withObject:@"1"];
            Strname=[arrItem objectAtIndex:indexPath.row];
        }
        else
        {
            [arrChk replaceObjectAtIndex:i withObject:@"0"];
        }
    }
    
    if(arrChk.count>0)
    {
        [self.collectionview reloadData];
    }
    
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(self.view.frame.size.width/2-5, self.view.frame.size.width/2-5);
    
}

#pragma mark - start activity :

- (IBAction)onClickforStartActivity:(id)sender
{
    [self performSegueWithIdentifier:SEGUE_TO_CITYFROMTABBAR sender:nil];
    
}

- (IBAction)onClickforBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if([segue.identifier isEqualToString:SEGUE_TO_CITYFROMTABBAR])
//    {
//        VAClubVC *sv=[segue destinationViewController];
//        sv.strname=Strname;
//    }
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
