
//
//  UserHolder.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 08/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import "UserHolder.h"

@implementation UserHolder

static id cUserData, cPropositions;

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
 sets the propositions
 */
+(id)Propositions{
    return cPropositions;
}

/*!
 Sets the propositions data
 *\param Propositions the propositions that needs to be stored
 */
+(void)setPropositions:(id) Propositions{
    cPropositions = Propositions;
}

@end
