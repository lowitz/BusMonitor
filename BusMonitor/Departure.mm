//
//  Departure.m
//  BusMonitor
//
//  Created by Love Mowitz on 2020-05-09.
//  Copyright © 2020 Love Mowitz. All rights reserved.
//

#import "Departure.h"
#import <UIKit/UIColor.h>

@implementation Departure

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
         // Sign-name and color
        self.stroke  = dictionary[@"stroke"];
        self.sname   = dictionary[@"sname"];
        self.bgColor = [Departure colorFromHexString:dictionary[@"fgColor"]];
        self.fgColor = [Departure colorFromHexString:dictionary[@"bgColor"]];

         // What stop, departure name, type, track, direction and accessibility
        self.stopID        = [dictionary[@"stopid"] integerValue];
        self.stopName      = dictionary[@"stop"];
        self.departureName = dictionary[@"name"];
        self.type          = dictionary[@"type"];
        self.track         = dictionary[@"track"];
        self.direction     = dictionary[@"direction"];
        self.accessibility = dictionary[@"accessibility"];

         // Departure time
        self.rtTime = dictionary[@"rtTime"];
        self.time   = dictionary[@"time"];

         // Journey details
        self.journeyNumber    = [dictionary[@"journeyNumber"] integerValue];
        self.journeyID        = [dictionary[@"journeyid"] integerValue];
        self.journeyDetailRef = dictionary[@"JourneyDetailRef"][@"ref"];
    }
    return self;
}


#pragma mark - Color import utility method
// Assumes input like "#00FF00" (#RRGGBB). Might want to move to some support header file
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
