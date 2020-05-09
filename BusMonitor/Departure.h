//
//  Departure.h
//  BusMonitor
//
//  Created by Love Mowitz on 2020-05-09.
//  Copyright © 2020 Love Mowitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIColor;

@interface Departure : NSObject

// Sign-name and color
@property (strong, nonatomic) NSString *stroke; // Brush?
@property (strong, nonatomic) NSString *sname;
@property (strong, nonatomic) UIColor *bgColor;
@property (strong, nonatomic) UIColor *fgColor;

// What stop, departure name, type, track, direction and accessibility
@property (nonatomic) NSInteger stopID;
@property (strong, nonatomic) NSString *stopName;
@property (strong, nonatomic) NSString *departureName; // Full name
@property (strong, nonatomic) NSString *type; // Bus, tram, etc.
@property (strong, nonatomic) NSString *track;
@property (strong, nonatomic) NSString *direction;
@property (strong, nonatomic) NSString *accessibility;

// Departure time
@property (strong, nonatomic) NSString *rtTime; // rt? Is this the estimated time?
@property (strong, nonatomic) NSString *time;

// Journey details
@property (nonatomic) NSInteger journeyNumber;
@property (nonatomic) NSInteger journeyID; // Wtf is journey number then?
@property (strong, nonatomic) NSString *journeyDetailRef;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
