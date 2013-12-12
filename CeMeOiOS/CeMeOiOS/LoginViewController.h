//
//  LoginViewController.h
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 11/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)doLogin:(id)sender;



@end
