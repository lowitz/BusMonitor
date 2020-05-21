//
//  DepartureCell.m
//  BusMonitor
//
//  Created by Love Mowitz on 2020-05-21.
//  Copyright © 2020 Love Mowitz. All rights reserved.
//

#import "DepartureCell.h"

@interface DepartureCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackLabel;

@end

@implementation DepartureCell

- (void)setNameLabelText:(NSString *)text withTextColor:(UIColor *)fg withBackgroundColor:(UIColor *)bg {
    [_nameLabel setText:text];
    [_nameLabel setTextColor:fg];
    [_nameLabel setBackgroundColor:bg];
}

- (void)setTimeLabelText:(NSString *)text {
    [_timeLabel setText:text];
}

- (void)setTrackLabelText:(NSString *)text {
    [_trackLabel setText:text];
}

@end
