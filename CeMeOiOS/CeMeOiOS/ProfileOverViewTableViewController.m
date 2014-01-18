//
//  ProfileOverViewTableViewController.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 08/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import "ProfileOverViewTableViewController.h"
#import "UserHolder.h"
#import "NameCell.h"
#import "InfoCell.h"
#import "LocationCell.h"

@interface ProfileOverViewTableViewController ()

@end

@implementation ProfileOverViewTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

/*!
 Sets the profile information in a table view a la contacts app
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0) {
        static NSString *CellIdentifier = @"NameCell";
        NameCell *cell = (NameCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell.lblUsername setText:[[UserHolder UserData] valueForKey:@"UserName"]];
        return cell;
    }else if([indexPath row] == 1){
        static NSString *CellIdentifier = @"InfoCell";
        InfoCell *cell = (InfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell.lblSoort setText:@"First name"];
        [cell.lblContent setText:[[UserHolder UserData] valueForKey:@"FirstName"]];
        return cell;
    }else if([indexPath row] == 2){
        static NSString *CellIdentifier = @"InfoCell";
        InfoCell *cell = (InfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell.lblSoort setText:@"Last name"];
        [cell.lblContent setText:[[UserHolder UserData] valueForKey:@"LastName"]];
        return cell;
    }else if([indexPath row] == 3){
        static NSString *CellIdentifier = @"InfoCell";
        InfoCell *cell = (InfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell.lblSoort setText:@"Email"];
        [cell.lblContent setText:[[UserHolder UserData] valueForKey:@"EMail"]];
        return cell;
    }else if([indexPath row] == 4){
        static NSString *CellIdentifier = @"LocationCell";
        LocationCell *cell = (LocationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if(![[[UserHolder UserData] objectForKey:@"PreferedLocation"] isKindOfClass:[NSNull class]]){
            [cell.lblLocationName setText:[[[UserHolder UserData] objectForKey:@"PreferedLocation"] valueForKey:@"Name"]];
            [cell.lblAddress setText:[NSString stringWithFormat:@"%@ %@",[[[UserHolder UserData] objectForKey:@"PreferedLocation"] valueForKey:@"Street"], [[[UserHolder UserData] objectForKey:@"PreferedLocation"] valueForKey:@"Number"]]];
            [cell.lblCity setText:[NSString stringWithFormat:@"%@ %@",[[[UserHolder UserData] objectForKey:@"PreferedLocation"] valueForKey:@"Zip"], [[[UserHolder UserData] objectForKey:@"PreferedLocation"] valueForKey:@"City"]]];
            [cell.lblCountry setText:[[[UserHolder UserData] objectForKey:@"PreferedLocation"] valueForKey:@"Country"]];
        }else{
            [cell.lblLocationName setText:@"Not set"];
            [cell.lblCity setText:@""];
            [cell.lblAddress setText:@""];
            [cell.lblCountry setText:@""];
        }
        return cell;
    }
    
    return nil;
}

/*!
 Gives the cell a height depending on what kind if cell it is
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == 0) {
        return 60;
    }else if([indexPath row] == 4){
        return 110;
    }else{
        return 50;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

@end
