//
//  RequiredContactsNewMeetingViewController.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 18/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import "RequiredContactsNewMeetingViewController.h"
#import "ContactCell.h"
#import "SelectTimeViewController.h"

@interface RequiredContactsNewMeetingViewController ()

@end

@implementation RequiredContactsNewMeetingViewController{
    NSArray *searchResults;
}

@synthesize Contacts;

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
 data received from the previous viewcontroller (addcontact)
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
 sets or removes the required bool from the chosen contact in the Contacts array
 using the tag from the switch
 *\param sender pressed button
 */
- (IBAction)ContactSwitched:(id)sender {
    UISwitch *contactSwitch = (UISwitch *)sender;
    int rowIndex = contactSwitch.tag;
    ContactCell *cell = (ContactCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
    cell.contactSwitch.on = contactSwitch.on;
    
    if (contactSwitch.on) {
        [Contacts replaceObjectAtIndex:rowIndex withObject:[[Contacts objectAtIndex:rowIndex] mutableCopy]];
        [[Contacts objectAtIndex:rowIndex] setObject:@YES forKey:@"required"];
    }else{
        [Contacts replaceObjectAtIndex:rowIndex withObject:[[Contacts objectAtIndex:rowIndex] mutableCopy]];
        [[Contacts objectAtIndex:rowIndex] removeObjectForKey:@"required"];
    }
    
}

/*!
 filters the Contacts array using the searchText string and saves the results in searchResults
 *\param searchText the text to be searched in the Contacts array (via firstname and lastname)
 */
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    searchResults = [Contacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FirstName contains[c] %@) OR (LastName contains[c] %@)", searchText, searchText]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

/*!
 sends the contacts (inc the required tags) to the next viewcontroller
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toSelectTime"]) {
        SelectTimeViewController *dest = segue.destinationViewController;
        dest.Contacts = self.Contacts;
    }
}
@end
