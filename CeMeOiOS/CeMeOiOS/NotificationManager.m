//
//  NotificationManager.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 29/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import "NotificationManager.h"

@implementation NotificationManager

+(void)ScheduleNotificationsWithMeetings:(NSArray *)Meetings{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    for(NSDictionary *meeting in Meetings){
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SS"];
        
        NSDate *date = [formatter dateFromString:[[meeting objectForKey:@"Meeting"] valueForKey:@"BeginTime"]];
        
        [self scheduleNotificationWithDate:date];
    }
}

+(void)scheduleNotificationWithDate:(NSDate *)meetingDate{
    UILocalNotification *localNotif = [[UILocalNotification alloc]init];
    
    NSTimeInterval diff = [meetingDate timeIntervalSinceNow];
    
    if(diff > 3600){
        localNotif.fireDate = [meetingDate dateByAddingTimeInterval:-3600];
        localNotif.alertBody = @"You have a meeting in one hour";
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
    
}

@end
