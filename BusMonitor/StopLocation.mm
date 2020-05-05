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
