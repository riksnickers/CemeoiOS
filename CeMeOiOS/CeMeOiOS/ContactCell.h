//
//  ContactCell.h
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 16/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblContact;
@property (weak, nonatomic) IBOutlet UISwitch *contactSwitch;
@property NSInteger *contactId;

@end
