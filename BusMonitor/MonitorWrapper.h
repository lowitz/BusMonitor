//
//  MonitorWrapper.h
//  FromStay
//
//  Created by Love Mowitz on 2020-03-25.
//  Copyright © 2020 Love Mowitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonitorWrapper : NSObject

@property (strong, nonatomic) NSString *accessToken;

-(void)getAccessToken:(void (^)(void))handler;
-(void)getLocationName:(NSString*)location handler:(void (^)(NSMutableArray* stopLocations))handler;
-(void)getDepartureTimesForID:(NSInteger)stopID date:(NSDate*)date maxDeparturesPerLine:(NSInteger)maxDeparturesPerLine handler:(void (^)(NSMutableArray* departures))handler;

@end
