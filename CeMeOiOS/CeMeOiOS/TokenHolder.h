//
//  Token.h
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 14/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TokenHolder : NSObject

@property id token;
+(id) Token;
+(void) setToken:(id) token;

@end
