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
@property (strong, nonatomic) NSString *type; // VAS, LDT (Long Distance Train), REG (Regional train), BUS, BOAT, TRAM, TAXI (Taxi/Telebus)
@property (strong, nonatomic) NSString *track;
@property (strong, nonatomic) NSString *direction;
@property (strong, nonatomic) NSString *accessibility; // = ["wheelChair" or "lowFloor"] if set

// Departure time
@property (strong, nonatomic) NSString *rtTime; // Real time time (hh:mm) (if available)
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *rtDate; // Real time date (YYYY-MM-DD) (if available)
@property (strong, nonatomic) NSString *date;

// Journey details
@property (nonatomic) NSInteger journeyID;
@property (strong, nonatomic) NSString *journeyDetailRef;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
-(NSString*)departsInMin;

@end
