//
//  LocationCell.h
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 08/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblLocationName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblCountry;


@end
