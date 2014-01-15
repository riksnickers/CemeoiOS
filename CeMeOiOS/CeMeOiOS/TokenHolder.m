//
//  Token.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 14/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import "TokenHolder.h"

@implementation TokenHolder
static id cToken;

/*!
 Sets the token
 *\param token the token data that needs to be stored
 */
+(void)setToken:(id)token{
    cToken = token;
}

/*!
 Returns the token
 */
+(id)Token{
    return cToken;
}

@end
