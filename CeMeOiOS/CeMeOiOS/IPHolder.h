//
//  IPHolder.h
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 19/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPHolder : NSObject

+(NSString *) IP;

+(NSString *) IPWithPath:(NSString *)path;

@end
