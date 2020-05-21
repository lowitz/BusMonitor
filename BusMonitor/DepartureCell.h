//
//  DepartureCell.h
//  BusMonitor
//
//  Created by Love Mowitz on 2020-05-21.
//  Copyright © 2020 Love Mowitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DepartureCell : UITableViewCell

-(void)setSignLabelText:(NSString*)text withTextColor:(UIColor*)fg withBackgroundColor:(UIColor*)bg;
-(void)setDirectionLabelText:(NSString*)text;
-(void)setTimeLabelText:(NSString*)text;
-(void)setTrackLabelText:(NSString*)text;

@end
