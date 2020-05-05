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
    NSData *data = [defaults objectForKey:@"stopLocationFavorites"];

    NSMutableArray* favoriteStops = nil;
    if (data != nil) {
        NSMutableArray *tempArray = [[NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:NSMutableArray.class, StopLocation.class, nil] fromData:data error:nil] mutableCopy];
        if (tempArray) {
            favoriteStops = [[NSMutableArray alloc] initWithArray:tempArray];
        } else {
            favoriteStops = [[NSMutableArray alloc] init];
        }
    } else {
        favoriteStops = [[NSMutableArray alloc] init];
    }

    for (int i = 0; i < [favoriteStops count]; i++) {
        auto stop = static_cast<StopLocation*>(favoriteStops[i]);
        if (stop.stopID == self.stopID) {
            return true;
        }
    }
    return false;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    if (self) {
        self.name = [[aDecoder decodeObjectForKey:@"name"] copy];
        self.stopID = [aDecoder decodeIntegerForKey:@"stopID"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.stopID forKey:@"stopID"];
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
