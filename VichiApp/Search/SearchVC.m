//
//  SearchVC.m
//  GuestList
//
//  Created by Angel on 07/04/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import "SearchVC.h"
#import "ClubCell.h"
#import "UIImageView+Download.h"
#import "VAConstant.h"
#import "VAListOfClubVC.h"

@interface SearchVC ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
       NSString *strculbid,*clubImg,*strClubName;
        NSString *strLatLong;
}
@end

@implementation SearchVC
@synthesize isFiltered,filteredTableData;

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    isFiltered=false;
    
    self.tblclub.hidden=YES;
    strculbid=@"";
    clubImg=@"";
    strClubName=@"";

}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = true;
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -
#pragma mark - textfeild :

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.tblclub.hidden=NO;
    return YES;
}


#pragma mark - Tableview Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClubCell *cell=[self.tblclub dequeueReusableCellWithIdentifier:@"ccell"];
    if(cell == nil)
    {
        cell=[[ClubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ccell"];
    }
    
    cell.imgItem.clipsToBounds=YES;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if(isFiltered)
    {
        NSDictionary *dict=[filteredTableData objectAtIndex:indexPath.row];
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict valueForKey:@"clubname"]];
        NSMutableString *result = [str mutableCopy];
        [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
                                   options:NSStringEnumerationByWords
                                usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                    [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                          withString:[[substring substringToIndex:1] uppercaseString]];
                                }];
        
        
        
        NSString *strd = result;
        
        
        NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:strd];
        
        UIColor* textColor = [UIColor colorWithRed:90/255.0f green:140/255.0f blue:220/255.0f alpha:1];
        
        [commentString setAttributes:@{NSUnderlineColorAttributeName:textColor,NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[commentString length])];
        
        cell.lblname.attributedText=commentString;
        
        
        NSString *strdm = [NSString stringWithFormat:@"%@",[dict valueForKey:@"location"]];
        NSMutableString *resultd = [strdm mutableCopy];
        [resultd enumerateSubstringsInRange:NSMakeRange(0, [resultd length])
                                    options:NSStringEnumerationByWords
                                 usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                     [resultd replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                            withString:[[substring substringToIndex:1] uppercaseString]];
                                 }];
        
        cell.lblLocation.text=[NSString stringWithFormat:@"%@",resultd];
        
        [cell.imgItem downloadFromURL:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[dict valueForKey:@"imageURL"]] withPlaceholder:[UIImage imageNamed:@"place"]];
        
        cell.btnmap.tag = indexPath.row;
        [cell.btnmap addTarget:self action:@selector(onClickedForPass:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else
    {
        NSDictionary *dict=[self.arrAllClubs objectAtIndex:indexPath.row];
        
        NSString *str = [NSString stringWithFormat:@"%@",[dict valueForKey:@"clubname"]];
        NSMutableString *result = [str mutableCopy];
        [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
                                   options:NSStringEnumerationByWords
                                usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                    [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                          withString:[[substring substringToIndex:1] uppercaseString]];
                                }];
        
        NSString *strd = result;
        
        
        NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:strd];
        
        UIColor* textColor = [UIColor colorWithRed:90/255.0f green:140/255.0f blue:220/255.0f alpha:1];
        
        [commentString setAttributes:@{NSUnderlineColorAttributeName:textColor,NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[commentString length])];
        
        cell.lblname.attributedText=commentString;


        NSString *strdm = [NSString stringWithFormat:@"%@",[dict valueForKey:@"location"]];
        NSMutableString *resultd = [strdm mutableCopy];
        [resultd enumerateSubstringsInRange:NSMakeRange(0, [resultd length])
                                    options:NSStringEnumerationByWords
                                 usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                     [resultd replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                            withString:[[substring substringToIndex:1] uppercaseString]];
                                 }];
        
        cell.lblLocation.text=[NSString stringWithFormat:@"%@",resultd];
        
        [cell.imgItem downloadFromURL:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[dict valueForKey:@"imageURL"]] withPlaceholder:[UIImage imageNamed:@"place"]];
        
        cell.btnmap.tag = indexPath.row;
        [cell.btnmap addTarget:self action:@selector(onClickedForPass:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      if(isFiltered)
      {
          [self.tblclub deselectRowAtIndexPath:indexPath animated:YES];
          NSDictionary *dict=[filteredTableData objectAtIndex:indexPath.row];
          strculbid=[NSString stringWithFormat:@"%@",[dict valueForKey:@"clubid"]];
          clubImg=[NSString stringWithFormat:@"%@%@",IMAGE_URL,[dict valueForKey:@"imageURL"]];
           strClubName=[NSString stringWithFormat:@"%@",[dict valueForKey:@"clubname"]];
          [self performSegueWithIdentifier:SEGUET_SEARCH_TO_DETAILS sender:nil];
      }
      else
      {
          [self.tblclub deselectRowAtIndexPath:indexPath animated:YES];
          NSDictionary *dict=[self.arrAllClubs objectAtIndex:indexPath.row];
          strculbid=[NSString stringWithFormat:@"%@",[dict valueForKey:@"clubid"]];
          clubImg=[NSString stringWithFormat:@"%@%@",IMAGE_URL,[dict valueForKey:@"imageURL"]];
           strClubName=[NSString stringWithFormat:@"%@",[dict valueForKey:@"clubname"]];
          [self performSegueWithIdentifier:SEGUET_SEARCH_TO_DETAILS sender:nil];
      }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 303.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isFiltered)
    {
        return filteredTableData.count;
    }
    else
    {
        return self.arrAllClubs.count;
    }
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self googlemap];
                    break;
                case 1:
                    [self applemap];
                    break;
                    
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

-(void)googlemap
{
    NSString *strlat=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_LAT];
    NSString *strlong=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_LONG];
    NSString *str = [NSString stringWithFormat:@"comgooglemaps://?saddr=%@,%@&daddr=%@&zoom=14&views=traffic",strlat,strlong,strLatLong];
    
    //google map
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else
    {
        NSLog(@"Can't use comgooglemaps://");
    }
}

-(void)applemap
{
    NSString *strlat=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_LAT];
    NSString *strlong=[[NSUserDefaults standardUserDefaults] objectForKey:PREF_LONG];
    NSString *strfinal=[NSString stringWithFormat:@"%@,%@",strlat,strlong];
    // Navigate from one coordinate to another
    NSString *url =[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%@&daddr=%@",strfinal,strLatLong];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    
    
}

#pragma mark -
#pragma mark - onClickedForPass

-(void)onClickedForPass:(UIButton*)sender
{
     if(isFiltered)
     {
         NSDictionary *dict=[filteredTableData objectAtIndex:sender.tag];
         
         NSString *strlatlog=[NSString stringWithFormat:@"%@",[dict valueForKey:@"latlong"]];
         strLatLong =strlatlog;
         UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Go to in Map" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                 @"Google Map",
                                 @"Apple Map",
                                 nil];
         popup.tag = 1;
         [popup showInView:self.view];
         
        /* NSDictionary *dict=[filteredTableData objectAtIndex:sender.tag];
        
        NSString *strlatlog=[NSString stringWithFormat:@"%@",[dict valueForKey:@"latlong"]];
        
        NSMutableArray *installedNavigationApps = [[NSMutableArray alloc] initWithObjects:@"Apple Maps", nil];
        
        if ([[UIApplication sharedApplication] canOpenURL:
             [NSURL URLWithString:@"comgooglemaps://"]])
        {
            [installedNavigationApps addObject:@"Google Maps"];
        }
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Selecione um aplicativo" message:@"Abrir com" preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        for (NSString *app in installedNavigationApps) {
            
            if([app isEqualToString:@"Apple Maps"])
            {
                [actionSheet addAction:[UIAlertAction actionWithTitle:app style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    [[UIApplication sharedApplication] openURL:
                     [NSURL URLWithString: [NSString stringWithFormat:@"http://maps.apple.com/?ll=%@",strlatlog]]];
                    
                }]];
                
            }
            else if([app isEqualToString:@"Google Maps"])
            {
                [actionSheet addAction:[UIAlertAction actionWithTitle:app style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    [[UIApplication sharedApplication] openURL:
                     [NSURL URLWithString: [NSString stringWithFormat:@"comgooglemaps://?ll=%@",strlatlog]]];
                }]];
            }
        }
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:actionSheet animated:YES completion:nil];
         */
     }
     else
     {
         NSDictionary *dict=[filteredTableData objectAtIndex:sender.tag];
         
         NSString *strlatlog=[NSString stringWithFormat:@"%@",[dict valueForKey:@"latlong"]];
         strLatLong =strlatlog;
         UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Go to in Map" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                 @"Google Map",
                                 @"Apple Map",
                                 nil];
         popup.tag = 1;
         [popup showInView:self.view];
         
        /* NSDictionary *dict=[self.arrAllClubs objectAtIndex:sender.tag];
         
         NSString *strlatlog=[NSString stringWithFormat:@"%@",[dict valueForKey:@"latlong"]];
         
         NSMutableArray *installedNavigationApps = [[NSMutableArray alloc] initWithObjects:@"Apple Maps", nil];
         
         if ([[UIApplication sharedApplication] canOpenURL:
              [NSURL URLWithString:@"comgooglemaps://"]])
         {
             [installedNavigationApps addObject:@"Google Maps"];
         }
         
         UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Selecione um aplicativo" message:@"Abrir com" preferredStyle:UIAlertControllerStyleActionSheet];
         
         
         for (NSString *app in installedNavigationApps) {
             
             if([app isEqualToString:@"Apple Maps"])
             {
                 [actionSheet addAction:[UIAlertAction actionWithTitle:app style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                     
                     [[UIApplication sharedApplication] openURL:
                      [NSURL URLWithString: [NSString stringWithFormat:@"http://maps.apple.com/?ll=%@",strlatlog]]];
                     
                 }]];
                 
             }
             else if([app isEqualToString:@"Google Maps"])
             {
                 [actionSheet addAction:[UIAlertAction actionWithTitle:app style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                     
                     [[UIApplication sharedApplication] openURL:
                      [NSURL URLWithString: [NSString stringWithFormat:@"comgooglemaps://?ll=%@",strlatlog]]];
                 }]];
             }
         }
         [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
         [self presentViewController:actionSheet animated:YES completion:nil];
         */
     }
    
}


#pragma mark - memroy mgnt :

- (IBAction)onClcikforBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickforSearch:(id)sender
{
    
}

#pragma mark - searching :

- (IBAction)searching:(id)sender
{
    self.tblclub.hidden=NO;
    
    if(self.txtsearch.text.length ==0)
    {
        //[searchBar resignFirstResponder];
        isFiltered=false;
        self.tblclub.hidden = YES;
        [self.tblclub reloadData];
    }
    else
    {
        self.tblclub.hidden = NO;
        isFiltered = true;
        filteredTableData = [[NSMutableArray alloc] init];

        NSLog(@"txt search :%@",self.txtsearch.text);

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"clubname CONTAINS[c] %@ || location  CONTAINS[c] %@",self.txtsearch.text, self.txtsearch.text]; // if you need case sensitive search avoid '[c]' in the predicate
        // NSArray *arrLocation=[USERDEFAULT objectForKey:PREF_LOCATION_SEARCH];
        NSArray *results = [self.arrAllClubs filteredArrayUsingPredicate:predicate];
        [filteredTableData addObjectsFromArray:results];
        /* for (NSMutableDictionary* item in self.arrProduct)
         {
         //case insensative search - way cool
         NSString *strtxt = [item valueForKey:@"sub_type"];
         NSLog(@"search text %@ \t string is :%@",self.txtSearch.text,string);
         if ([strtxt rangeOfString:string options:NSCaseInsensitivePredicateOption].location != NSNotFound)
         {
         [filteredTableData addObject:item];
         }
         }*/

        [self.tblclub reloadData];
        
    }//end if-else
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SEGUET_SEARCH_TO_DETAILS])
    {
        VAListOfClubVC *vl=[segue destinationViewController];
        vl.strclubId=strculbid;
        vl.clubImg=clubImg;
        vl.strClubmName=strClubName;
    }
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
