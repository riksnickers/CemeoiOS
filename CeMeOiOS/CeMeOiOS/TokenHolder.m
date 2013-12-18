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

+(void)setToken:(id)token{
    cToken = token;
}

+(id)Token{
    return cToken;
}

@end
