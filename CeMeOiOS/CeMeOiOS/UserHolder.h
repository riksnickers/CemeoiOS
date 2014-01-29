//
//  UserHolder.h
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 08/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserHolder : NSObject

+(id)UserData;
+(void)SetUserData:(id)UserData;

+(id)Propositions;
+(void)setPropositions:(id)Propositions;

+(id)Meetings;
+(void)setMeetings:(id)Meetings;

+(id)Drafts;
+(void)setDrafts:(id)Drafts;
+(void)AddDraft:(NSDictionary *)draft;

+(id)DeviceToken;
+(void)setDevice:(id)Device;

@end
