//
//  RequiredContactsNewMeetingViewController.h
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 18/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequiredContactsNewMeetingViewController : UITableViewController <UISearchDisplayDelegate>
- (IBAction)ContactSwitched:(id)sender;

@property NSMutableArray *Contacts;

@end
