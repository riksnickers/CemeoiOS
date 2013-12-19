//
//  IPHolder.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 19/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import "IPHolder.h"

@implementation IPHolder

static NSString* IP = @"http://192.168.227.136:12429";

+(NSString *) IP{
    return IP;
}

+(NSString *) IPWithPath:(NSString *)path{
    return [[NSString alloc] initWithFormat:@"%@%@", IP, path];
}

@end
