//
//  AppDelegate.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 11/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import "AppDelegate.h"
#import "UserHolder.h"

@implementation AppDelegate

/*!
 Restore the drafts from the plist
  */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIRemoteNotificationType notiTypes= UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert;
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    [application registerForRemoteNotificationTypes:notiTypes];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"Drafts.plist"];
    [UserHolder setDrafts:[NSMutableArray arrayWithContentsOfFile:plistPath]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

/*!
Save the drafts in a plist
*/
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager;
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"Drafts.plist"];
    if (![fileManager fileExistsAtPath: plistPath])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Drafts" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:plistPath error:&error];
    }
    [[UserHolder Drafts] writeToFile:plistPath atomically: YES];
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

/*!
 Save the deviceToken for sending after login
 */
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"%@", deviceToken);
    
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [UserHolder setDevice:devToken];
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
   
}

@end
