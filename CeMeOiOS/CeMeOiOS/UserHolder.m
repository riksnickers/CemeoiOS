
//
//  UserHolder.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 08/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import "UserHolder.h"

@implementation UserHolder

//NSDictionarys, but saved as id so they can be called as NSArray
static id cUserData, cPropositions, cMeetings, cDeviceToken;

/*!
Sets the user data
 *\param UserData the user data that needs to be stored
 */
+(void)SetUserData:(id)UserData{
    cUserData = UserData;
}

/*!
 returns the user data
 */
+(id)UserData{
    return cUserData;
}

/*!
 Sets the propositions data
 *\param Propositions the propositions that needs to be stored
 */
+(void)setPropositions:(id) Propositions{
    cPropositions = Propositions;
}

/*!
 returns the propositions
 */
+(id)Propositions{
    return cPropositions;
}

/*!
 Sets the meeting data
 *\param Meetings the neetings that needs to be stored
 */
+(void)setMeetings:(id)Meetings{
    cMeetings = Meetings;
}

/*!
 returns the meetings
 */
+(id)Meetings{
    return cMeetings;
}

/*!
 Sets the device token for sending to server after login
 *\param Device the token that needs to be stored
 */
+(void)setDevice:(id)Device{
    cDeviceToken = Device;
}

/*!
 returns the device token
 */
+(id)DeviceToken{
    return cDeviceToken;
}



@end
