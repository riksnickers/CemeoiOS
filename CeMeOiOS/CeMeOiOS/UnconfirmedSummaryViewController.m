//
//  UnconfirmedSummaryViewController.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 20/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import "UnconfirmedSummaryViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserHolder.h"
#import "IPHolder.h"
#import "TokenHolder.h"

@interface UnconfirmedSummaryViewController ()

@end

@implementation UnconfirmedSummaryViewController{
    NSDictionary *proposition;
    NSArray *contacts;
    UIAlertView *selectStatus, *confirmStatus, *waitAlert;
    NSString *InviteeID;
    int statusIndex, answer;
}

@synthesize PropositionIndex;
@synthesize lblDate,lblDuration,lblRoom,lblAddress,lblCity,ContactsTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    proposition = [[[UserHolder Propositions]objectAtIndex:PropositionIndex]objectForKey:@"Proposition"];
    contacts = [[[UserHolder Propositions]objectAtIndex:PropositionIndex]objectForKey:@"Others"];
    answer = [[[[UserHolder Propositions]objectAtIndex:PropositionIndex]valueForKey:@"Answer"]intValue];
    InviteeID = [[[UserHolder Propositions]objectAtIndex:PropositionIndex]valueForKey:@"InviteeID"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SS"];
    
    NSDate *startDate = [formatter dateFromString:[proposition valueForKey:@"BeginTime"]];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:startDate
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    [lblDate setText:dateString];
    
    NSDate *endDate = [formatter dateFromString:[proposition valueForKey:@"EndTime"]];
    NSTimeInterval durationInterval = [endDate timeIntervalSinceDate:startDate];
    [lblDuration setText:[self stringFromTimeInterval:durationInterval]];
    
    NSDictionary *room = [proposition objectForKey:@"ProposedRoom"];
    NSDictionary *location = [room objectForKey:@"LocationID"];
    
    [lblRoom setText:[room valueForKey:@"Name"]];
    
    NSString *address = [NSString stringWithFormat:@"%@ %@", [location valueForKey:@"Street"], [location valueForKey:@"Number"]];
    [lblAddress setText:address];
    
    NSString *city = [NSString stringWithFormat:@"%@ %@", [location valueForKey:@"Zip"], [location valueForKey:@"City"]];
    [lblCity setText:city];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*! convert NSTimeInterval to formatter NSString,
 */
- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%li Hours %li Minutes", (long)hours, (long)minutes];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [contacts count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ContactCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *name = [NSString stringWithFormat:@"%@ %@", [[contacts objectAtIndex:indexPath.row]valueForKey:@"FirstName"], [[contacts objectAtIndex:indexPath.row]valueForKey:@"LastName"]];

    
    cell.textLabel.text = name;
    return cell;
}

- (IBAction)sendAnswer:(id)sender {
     selectStatus = [[UIAlertView alloc]
                          initWithTitle:[NSString stringWithFormat:@"Set your meeting answer"]
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Attending", @"Absent", @"Online", nil];
    [selectStatus show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView == selectStatus){
        NSString *status;
        statusIndex = (int)buttonIndex;
    
        if(buttonIndex != 0){
            switch (buttonIndex) {
                case 1:
                    status = @"attending";
                    break;
                case 2:
                    status = @"absent";
                    break;
                case 3:
                    status = @"online";
                default:
                    break;
            }
            
            confirmStatus = [[UIAlertView alloc]
                             initWithTitle:[NSString stringWithFormat:@"You want to set your status as %@ ?", status]
                             message:nil
                             delegate:self
                             cancelButtonTitle:@"No"
                             otherButtonTitles:@"Yes", nil];
            [confirmStatus show];
        }
    
    }else if(alertView == confirmStatus){
        if(buttonIndex != 0){
            [self sendStatus:statusIndex];
        }
    }
}

/*! send the proposition status to the server
 */
-(void)sendStatus:(int)status{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", [[TokenHolder Token] valueForKey:@"access_token"]] forHTTPHeaderField:@"Authorization"];
    
    
    NSDictionary *toSend = [[NSDictionary alloc] initWithObjects:@[InviteeID, [[NSNumber alloc]initWithInt:status]] forKeys:@[ @"InviteeID", @"Answer"]];
    
    waitAlert = [[UIAlertView alloc] initWithTitle:@"Sending data..."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
    loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [waitAlert addSubview:loading];
    [loading startAnimating];
    [waitAlert show];
    
    
    [manager POST:[IPHolder IPWithPath:@"/api/Proposition/PropositionAnswer"] parameters:toSend success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([operation.response statusCode] == 200){
            [self getPropos];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Something went wrong"
                                                           message: @"Please try again later"
                                                          delegate: nil
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
            
            [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@", error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Something went wrong"
                                                       message: @"Please try again later"
                                                      delegate: nil
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
        
        [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }];

}

-(void)getPropos{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", [[TokenHolder Token] valueForKey:@"access_token"]] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:[IPHolder IPWithPath:@"/api/Proposition/All"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //save propositions un userholder
        [UserHolder setPropositions:[responseObject mutableCopy]];
        
        //set the badge count
        [[[[[self tabBarController] tabBar] items]
          objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%ld", (unsigned long)[[[UserHolder Propositions] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Answer = 0)"]]count]]];
        
        [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Send"
                                                       message: @"Your status has been saved"
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        
        
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Something went wrong"
                                                       message: @"Could not get meeting propositions"
                                                      delegate: nil
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
        
        [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
        [alert show];
    }];
}


@end
