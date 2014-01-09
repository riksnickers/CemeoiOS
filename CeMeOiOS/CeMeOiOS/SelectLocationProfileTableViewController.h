//
//  SelectLocationProfileTableViewController.h
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 09/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectLocationProfileTableViewController : UITableViewController <UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
