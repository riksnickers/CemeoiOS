//
//  SelectTimeViewController.h
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 18/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTimeViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property NSArray *Contacts;

@end
