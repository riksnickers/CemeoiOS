
//
//  UserHolder.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 08/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import "UserHolder.h"

@implementation UserHolder

static id cUserData;

+(void)SetUserData:(id)UserData{
    cUserData = UserData;
}

+(id)UserData{
    return cUserData;
}

@end
