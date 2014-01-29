//
//  Token.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 14/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import "TokenHolder.h"
#import "KeychainItemWrapper.h"

@implementation TokenHolder

static id cToken;

///*!
// Sets the token
// *\param token the token data that needs to be stored
// */
//+(void)setToken:(id)token{
//    cToken = token;
//}

///*!
// Returns the token
// */
//+(id)Token{
//    return cToken;
//}

/*!
 Saves the token in the keychain
 *\param token the token data that needs to be stored
 */
+(void)setToken:(id)token{
    KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserAuthToken" accessGroup:nil];
    [keychainWrapper setObject:[token description] forKey:(__bridge id)(kSecValueData)];
}

/*!
 Receives the token from the keychain
 */
+(id)Token{
    KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserAuthToken" accessGroup:nil];
    if(![[keychainWrapper objectForKey:(__bridge id)(kSecValueData)]length]){
        return nil;
    }else{
        return [[keychainWrapper objectForKey:(__bridge id)(kSecValueData)] propertyList];
    }
}

/*!
 Clears the token from the keychain
 */
+(void)ClearToken{
    KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserAuthToken" accessGroup:nil];
    [keychainWrapper resetKeychainItem];
}

@end
