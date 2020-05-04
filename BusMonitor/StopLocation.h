//
//  LocationStop.h
//  BusMonitor
//
//  Created by Love Mowitz on 2020-05-01.
//  Copyright © 2020 Love Mowitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopLocation : NSObject

@property (strong, nonatomic) NSString* name;
@property (nonatomic) long stopID;

-(bool)isFavorite;

@end
