//
//  LoginViewController.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 11/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import "LoginViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "TokenHolder.h"
#import "UpcomingViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*! send username and password for authentication using AFNetworking library,
 receive token and save it in TokeHolder
 */
- (IBAction)doLogin:(id)sender{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSString *password = [self.txtPassword text];
    NSString *username = [self.txtUsername text];
    
    NSDictionary *parameters = @{@"grant_type": @"password", @"username":username, @"password":password};
  
    //wait dialog
    UIAlertView *waitAlert = [[UIAlertView alloc] initWithTitle:@"Login in..."
                                                       message:nil
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil];
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
    loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [waitAlert addSubview:loading];
    [loading startAnimating];
    [waitAlert show];
    
    [manager POST:@"http://192.168.227.137:12429/Token" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([operation.response statusCode] == 200 && [[responseObject valueForKey:@"token_type"]  isEqual: @"bearer"]){
            //save Token in TokenHolder
            [TokenHolder setToken:responseObject];
            [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
            [self performSegueWithIdentifier: @"toUpcoming" sender: self];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Something went wrong"
                                                           message: @"Please try again later"
                                                          delegate: self
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
            
            [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@", error);
        if ([[operation.responseObject valueForKey:@"error"] isEqual: @"invalid_grant"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Wrong login"
                                                           message: @"Wrong username and password combination"
                                                          delegate: self
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
            
            [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Something went wrong"
                                                           message: @"Please try again later"
                                                          delegate: self
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
            
            [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
            [alert show];
        }
    }];
    
    
}
@end
