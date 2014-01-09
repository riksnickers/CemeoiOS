//
//  AddContactsNewMeetingViewController.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 16/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import "AddContactsNewMeetingViewController.h"
#import "ContactCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "RequiredContactsNewMeetingViewController.h"
#import "IPHolder.h"
#import "TokenHolder.h"

@interface AddContactsNewMeetingViewController ()

@end

@implementation AddContactsNewMeetingViewController{
    NSArray *searchResults;
    NSMutableArray *Contacts;
    NSMutableArray *chosenContacts;
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

     //preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    //array that saves the chosen contacts
    chosenContacts = [[NSMutableArray alloc] init];
    [self loadContacts];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }else{
        return [Contacts count];
    }
}

/*! Uses a custom cell to display table data,
 checks for the table source (main table of search table) and populates it with the data
 fetched from the external service
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellId = @"ContactCell";
    
    ContactCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellId];
    if(cell == nil){
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.lblContact.text = [[NSString alloc] initWithFormat:@"%@ %@", [[searchResults objectAtIndex:[indexPath row]] valueForKey:@"FirstName"], [[searchResults objectAtIndex:[indexPath row]] valueForKey:@"LastName"]];
        
        //sets the tag of the switch to the index of the element in the original array
        //uses the tag to set the switch status in the original table and to add or remove the chozen element in the
        //chosenContacts array
        cell.contactSwitch.tag = [Contacts indexOfObject:[searchResults objectAtIndex:[indexPath row]]];
        ContactCell *tempCell = (ContactCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[Contacts indexOfObject:[searchResults objectAtIndex:[indexPath row]]] inSection:0]];
        cell.contactSwitch.on = tempCell.contactSwitch.on;
        
        

    }else{
        //sets the tag of the switch to the index of the element in the original array
        //uses the tag to add or remove the chozen element in the chosenContacts array
        cell.contactSwitch.tag = indexPath.row;
        cell.lblContact.text = [[NSString alloc] initWithFormat:@"%@ %@", [[Contacts objectAtIndex:[indexPath row]] valueForKey:@"FirstName"], [[Contacts objectAtIndex:[indexPath row]] valueForKey:@"LastName"]];
    }
    

    return cell;

}

/*!
 adds or removes the contact in the chosenContacts array
 using the tag from the switch
 *\param sender pressed button
 */
- (IBAction)ContactSwitched:(id)sender {
    UISwitch *contactSwitch = (UISwitch *)sender;
    int rowIndex = contactSwitch.tag;
    ContactCell *cell = (ContactCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
    cell.contactSwitch.on = contactSwitch.on;
    
    if (contactSwitch.on) {
        NSMutableDictionary *toAdd = [[Contacts objectAtIndex:rowIndex] mutableCopy];
        [toAdd setObject:@NO forKey:@"Important"];
        [Contacts replaceObjectAtIndex:rowIndex withObject:toAdd];
        [chosenContacts addObject:toAdd];
    }else{
        [chosenContacts removeObject:[Contacts objectAtIndex:rowIndex]];
    }
    
    if([chosenContacts count] > 0){
        [self.btnNext setEnabled:YES];
    }else{
        [self.btnNext setEnabled:NO];
    }
}

/*!
 return to the previous screen in the navigation stack
 */
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*!
 filters the Contacts array using the searchText string and saves the results in searchResults
 *\param searchText the text to be searched in the Contacts array (via firstname and lastname)
 */
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    searchResults = [Contacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FirstName contains[c] %@) OR (LastName contains[c] %@)", searchText, searchText]];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

/*!
 Fetches the contacts from the external service
 in the future this will use the users microsoft exchange data.
 Stores the results in the Contacs array
 */
-(void)loadContacts{
    UIAlertView *waitAlert = [[UIAlertView alloc] initWithTitle:@"Getting contacts..."
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

    
    [manager GET:[IPHolder IPWithPath:@"/api/Meeting/Contacts"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Contacts = [responseObject mutableCopy];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
}

/*!
 sends the chosen contacts to the next viewcontroller
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toRequiredContacts"]) {
        RequiredContactsNewMeetingViewController *dest = segue.destinationViewController;
        dest.Contacts = chosenContacts;
    }
}


@end
