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
#import "UserHolder.h"
#import "IPHolder.h"

@interface LoginViewController ()

@end

@implementation LoginViewController{
    UIAlertView *waitAlert;
}


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
    waitAlert = [[UIAlertView alloc] initWithTitle:@"Login in..."
                                                       message:nil
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil];
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
    loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [waitAlert addSubview:loading];
    [loading startAnimating];
    [waitAlert show];
    
    [manager POST:[IPHolder IPWithPath:@"/Token"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([operation.response statusCode] == 200 && [[responseObject valueForKey:@"token_type"]  isEqual: @"bearer"]){
            //save Token in TokenHolder
            [TokenHolder setToken:responseObject];
            [self getUserData];
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

-(void)getUserData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", [[TokenHolder Token] valueForKey:@"access_token"]] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:[IPHolder IPWithPath:@"/api/Account/Profile"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //save Userdata un userholder
        [UserHolder SetUserData:[responseObject mutableCopy]];
        [self getPropos];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Something went wrong"
                                                       message: @"Could not get user data"
                                                      delegate: self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
        
        [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
        [alert show];
    }];
    
}

-(void)getPropos{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", [[TokenHolder Token] valueForKey:@"access_token"]] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:[IPHolder IPWithPath:@"/api/Proposition/Propositions"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //save propositions un userholder
        [UserHolder setPropositions:[responseObject mutableCopy]];
        [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
        [self performSegueWithIdentifier: @"toUpcoming" sender: self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Something went wrong"
                                                       message: @"Could not get meeting propositions"
                                                      delegate: self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
        
        [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
        [alert show];
    }];

}

@end
