//
//  IPHolder.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 19/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import "IPHolder.h"

@implementation IPHolder

//static NSString* IP = @"http://10.65.134.30:12429";
static NSString* IP = @"https://cemeo.azurewebsites.net";
//static NSString* IP = @"http://app.cemeo.be";
//static NSString* IP = @"http://193.190.154.242";

+(NSString *) IP{
    return IP;
}

/*!
 Returns the server IP with the path (8.8.8.8/Api/Meeting/Schedule)
 *\param path The path that needs to be appended to the IP
 */
+(NSString *) IPWithPath:(NSString *)path{
    return [[NSString alloc] initWithFormat:@"%@%@", IP, path];
}

@end
