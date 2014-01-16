//
//  SelectLocationProfileTableViewController.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 09/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import "SelectLocationProfileTableViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "TokenHolder.h"
#import "IPHolder.h"
#import "LocationCell.h"
#import "UserHolder.h"

@interface SelectLocationProfileTableViewController ()

@end

@implementation SelectLocationProfileTableViewController{
    NSArray *Locations;
    NSArray *Results;
    NSDictionary *selected;
}

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
    [self loadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

/*!
 filters the Location array using the searchText string and saves the results in the Results array
 *\param searchText the text to be searched in the Locations array (via Name, Street, City and Country)
 */
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    Results = [Locations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Name contains[c] %@) OR (Street contains[c] %@) OR (City contains[c] %@) OR (Country contains[c] %@)", searchText, searchText, searchText, searchText]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return [Results count];
    }else{
        return [Locations count];
    }
}

/*! Uses a custom cell to display table data,
 checks for the table source (main table of search table) and populates it with the data
 fetched from the external service
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellId = @"LocationCell";
    
    LocationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellId];
    if(cell == nil){
        cell = [[LocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        [cell.lblLocationName setText:[[Results objectAtIndex:indexPath.row]objectForKey:@"Name"]];
        [cell.lblAddress setText:[NSString stringWithFormat:@"%@ %@", [[Results objectAtIndex:indexPath.row]objectForKey:@"Street"], [[Locations objectAtIndex:indexPath.row]objectForKey:@"Number"]]];
        [cell.lblCity setText:[NSString stringWithFormat:@"%@ %@", [[Results objectAtIndex:indexPath.row]objectForKey:@"Zip"], [[Locations objectAtIndex:indexPath.row]objectForKey:@"City"]]];
        [cell.lblCountry setText:[[Results objectAtIndex:indexPath.row]objectForKey:@"Country"]];
    }else{
        [cell.lblLocationName setText:[[Locations objectAtIndex:indexPath.row]objectForKey:@"Name"]];
        [cell.lblAddress setText:[NSString stringWithFormat:@"%@ %@", [[Locations objectAtIndex:indexPath.row]objectForKey:@"Street"], [[Locations objectAtIndex:indexPath.row]objectForKey:@"Number"]]];
        [cell.lblCity setText:[NSString stringWithFormat:@"%@ %@", [[Locations objectAtIndex:indexPath.row]objectForKey:@"Zip"], [[Locations objectAtIndex:indexPath.row]objectForKey:@"City"]]];
        [cell.lblCountry setText:[[Locations objectAtIndex:indexPath.row]objectForKey:@"Country"]];
    }

    
    return cell;
}

/*!
 Gets all locations from the server
 */
-(void)loadData{
    UIAlertView *waitAlert = [[UIAlertView alloc] initWithTitle:@"Getting locations..."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
    loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [waitAlert addSubview:loading];
    [loading startAnimating];
    [waitAlert show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", [[TokenHolder Token] valueForKey:@"access_token"]] forHTTPHeaderField:@"Authorization"];
    
    
    [manager GET:[IPHolder IPWithPath:@"/api/Location"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Locations = [responseObject mutableCopy];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Something went wrong"
                                                       message: @"Please try again later"
                                                      delegate: self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
        
        [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
        [alert show];
    }];
    
    [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
    [self.tableView reloadData];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        selected = [Results objectAtIndex:indexPath.row];
    }else{
        selected = [Locations objectAtIndex:indexPath.row];
    }
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:[NSString stringWithFormat:@"Do you want to set %@ as your prefered location?", [selected valueForKey:@"Name"]]
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"No"
                          otherButtonTitles:@"Yes", nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self SendData];
    }
}

/*!
 Sends chozen locationID to the server for processing.
 Updates the location in the UserHolder.
 *\param data The new location (nsdictionary) that will be converted to json and send
 */
-(void)SendData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", [[TokenHolder Token] valueForKey:@"access_token"]] forHTTPHeaderField:@"Authorization"];
    
    
    NSDictionary *toSend = [[NSDictionary alloc] initWithObjects:@[[selected valueForKey:@"LocationID"]] forKeys:@[@"LocationID"]];
    
    UIAlertView *waitAlert = [[UIAlertView alloc] initWithTitle:@"Sending data..."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
    loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [waitAlert addSubview:loading];
    [loading startAnimating];
    [waitAlert show];

    
    [manager POST:[IPHolder IPWithPath:@"/api/Account/SetLocation"] parameters:toSend success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([operation.response statusCode] == 200){
            [[UserHolder UserData] setObject:selected forKey:@"PreferedLocation"];
            [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Send"
                                                           message: @"Your location has been changed"
                                                          delegate: nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            
            
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Something went wrong"
                                                           message: @"Please try again later"
                                                          delegate: self
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
            
            [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@", error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Something went wrong"
                                                       message: @"Please try again later"
                                                      delegate: self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
        
        [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
        [alert show];
        
    }];
}


@end
