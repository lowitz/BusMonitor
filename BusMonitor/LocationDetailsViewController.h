//
//  LocationDetailsViewController.h
//  BusMonitor
//
//  Created by Love Mowitz on 2020-05-03.
//  Copyright © 2020 Love Mowitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StopLocation;

@interface LocationDetailsViewController : UIViewController

-(void)setLocation:(StopLocation*)location;

@end
