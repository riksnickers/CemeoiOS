//
//  MeetingSummaryViewController.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 28/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import "MeetingSummaryViewController.h"

@interface MeetingSummaryViewController ()

@end

@implementation MeetingSummaryViewController{
    NSArray *others;
    NSDictionary *mDetails,*rDetails,*rLocation;
}

@synthesize lblDate,lblDuration,lblRoom,lblAddress1,lblAddress2;
@synthesize meeting;

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
	// Do any additional setup after loading the view.
    others = [meeting objectForKey:@"Others"];
    
    mDetails = [meeting objectForKey:@"Meeting"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDate *startDate = [formatter dateFromString:[mDetails valueForKey:@"BeginTime"]];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:startDate
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    [lblDate setText:dateString];
    
    NSTimeInterval durationInterval = [[mDetails valueForKey:@"Duration"]doubleValue];
    [lblDuration setText:[self stringFromTimeInterval:durationInterval]];
    
    rDetails = [[meeting objectForKey:@"Self"]objectForKey:@"Room"];
    [lblRoom setText:[rDetails valueForKey:@"Name"]];
    
    rLocation = [rDetails objectForKey:@"LocationID"];
    
    NSString *address = [NSString stringWithFormat:@"%@ %@", [rLocation valueForKey:@"Street"], [rLocation valueForKey:@"Number"]];
    [lblAddress1 setText:address];
    
    NSString *city = [NSString stringWithFormat:@"%@ %@", [rLocation valueForKey:@"Zip"], [rLocation valueForKey:@"City"]];
    [lblAddress2 setText:city];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [others count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ContactCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *name = [NSString stringWithFormat:@"%@ %@", [[others objectAtIndex:indexPath.row]valueForKey:@"FirstName"], [[others objectAtIndex:indexPath.row]valueForKey:@"LastName"]];
    
    
    cell.textLabel.text = name;
    return cell;

}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%li Hours %li Minutes", (long)hours, (long)minutes];
}


@end
