//
//  AboutViewController.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 05/02/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*!
Open the icons8 website in safari
*/
- (IBAction)btnIcons:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://icons8.com/"]];
}



@end
