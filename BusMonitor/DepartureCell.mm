//
//  DepartureCell.m
//  BusMonitor
//
//  Created by Love Mowitz on 2020-05-21.
//  Copyright © 2020 Love Mowitz. All rights reserved.
//

#import "DepartureCell.h"

@interface DepartureCell()

@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackLabel;

@end

@implementation DepartureCell

- (void)setSignLabelText:(NSString *)text withTextColor:(UIColor *)fg withBackgroundColor:(UIColor *)bg {
    [_signLabel setText:text];
    [_signLabel setTextColor:fg];
    [_signLabel setBackgroundColor:bg];
}

- (void)setDirectionLabelText:(NSString *)text {
    [_directionLabel setText:text];
}

- (void)setTimeLabelText:(NSString *)text {
    [_timeLabel setText:text];
}

- (void)setTrackLabelText:(NSString *)text {
    [_trackLabel setText:text];
}

@end
