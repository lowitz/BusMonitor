//
//  LocationStop.m
//  BusMonitor
//
//  Created by Love Mowitz on 2020-05-01.
//  Copyright © 2020 Love Mowitz. All rights reserved.
//

#import "StopLocation.h"

#import <Foundation/Foundation.h>


@implementation StopLocation

- (bool)isFavorite {
    NSUserDefaults *defaults = [[NSUserDefaults standardUserDefaults] initWithSuiteName:@"group.com.lovemowitz.BusMonitor"];
    
    NSArray* favorites = static_cast<NSArray*>([defaults objectForKey:@"stopLocationFavorites"]);
    if (!favorites) return false;
    for (StopLocation *location in favorites) {
        if (location->_stopID == self->_stopID) return true;
    }
    return false;
}

@end
