//
//  SelectDurationNewMeetingViewController.h
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 06/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectDurationNewMeetingViewController : UIViewController

@property NSArray *Contacts;
@property int DateIndex;
@property NSDate *beforeDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *DurationPicker;



@end
