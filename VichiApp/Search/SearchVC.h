//
//  SearchVC.h
//  GuestList
//
//  Created by Angel on 07/04/18.
//  Copyright © 2018 Hiren Dhamecha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchVC : UIViewController

@property (strong, nonatomic) NSMutableArray* filteredTableData;

@property (strong, nonatomic) NSMutableArray* arrAllClubs;

@property (nonatomic, assign) bool isFiltered;

- (IBAction)onClcikforBack:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtsearch;
- (IBAction)onClickforSearch:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tblclub;
- (IBAction)searching:(id)sender;

@end
