//
//  IPHolder.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 19/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import "IPHolder.h"

@implementation IPHolder

static NSString* IP = @"http://cemeo.azurewebsites.net";

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
