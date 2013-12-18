//
//  AddContactsNewMeetingViewController.h
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 16/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddContactsNewMeetingViewController : UITableViewController <UISearchDisplayDelegate>

//@property (nonatomic, strong) NSArray *Contacts;
- (IBAction)ContactSwitched:(id)sender;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnNext;

@end
