//
//  MonitorWrapper.m
//  FromStay
//
//  Created by Love Mowitz on 2020-03-25.
//  Copyright © 2020 Love Mowitz. All rights reserved.
//

#import "MonitorWrapper.h"
#import "StopLocation.h"
#import <UIKit/UIDevice.h>

#define KEY @"8aOzt2RmMIG0OXSyIgjM2IkHvAoa" // Sample credentials
#define SECRET @"OMxjxjaXblXdpn8E1gYFehHyx3Ea"

#define URL_TOKEN @"https://api.vasttrafik.se/token"
#define URL_GET_BASE @"https://api.vasttrafik.se/bin/rest.exe/v2/"
#define URL_LOCATION_NAME @"https://api.vasttrafik.se/bin/rest.exe/v2/location.name?input=utlandagatan&format=json"
#define URL_DEPARTURE_BOARD @"https://api.vasttrafik.se/bin/rest.exe/v2/departureBoard"

@interface MonitorWrapper()

@property (nonatomic) NSDate *accesTokenExpirationDate;

@end

@implementation MonitorWrapper

- (void)getAccessToken:(void (^)())handler {
    // If current date is earlier than expiration date, we're good
    NSDate *currentDate = [NSDate date];
    if (_accesTokenExpirationDate && [currentDate compare:_accesTokenExpirationDate] == NSOrderedAscending) {
        handler();
        return;
    }
    
    // If we don't have token or if it has expired, request a new one
    [self requestNewAccessToken:handler];
}

-(void)requestNewAccessToken:(void (^)())handler {
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL_TOKEN]];
    
    // Create the Method "GET" or "POST"
    [theRequest setHTTPMethod:@"POST"];
    
    // Set content type
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // Set the authorization ("key + ':' + shared secret" in base64)
    NSData *keyAndSecret = [KEY @":" SECRET
                            dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [keyAndSecret base64EncodedStringWithOptions:0];
    [theRequest setValue:[@"Basic " stringByAppendingString:base64Encoded] forHTTPHeaderField:@"Authorization"];
    
    // Set request session with default configuration
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *theSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    // Get unique id for device and app
    UIDevice *device = [UIDevice currentDevice];
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    
    // Set grant type with user unique scope
    NSData *postData = [[@"grant_type=client_credentials&scope=" stringByAppendingString:currentDeviceId] dataUsingEncoding:NSUTF8StringEncoding];
    [theRequest setHTTPBody:postData];
    
    // Send POST and receive token with callback
    NSURLSessionDataTask *postDataTask = [theSession dataTaskWithRequest:theRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSError *jsonError;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                if (jsonError) {
                    // Error parsing JSON
                    NSLog(@"Error parsing json response at token request");
                } else {
                    // Success parsing JSON
                    [self setAccessToken:(NSString*)[jsonResponse objectForKey:@"access_token"]];
                    
                    // Set expiration date
                    NSDate *currentDate = [NSDate date];
                    NSInteger expirationTimeSeconds = [[jsonResponse objectForKey:@"expires_in"] integerValue];
                    [self setAccesTokenExpirationDate:[currentDate dateByAddingTimeInterval:expirationTimeSeconds]];
                    handler();
                }
            } else {
                // Server is returning an error
            }
        } else {
            // Fail
            NSLog(@"Error: %@", error.description);
        }
        
    }];
    [postDataTask resume];
}

- (void)getLocationName:(NSString*)location handler:(void (^)(NSMutableArray* stopLocations))handler {
    NSString* percentEncodedLocation = [location stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlString = [NSString stringWithFormat:(URL_GET_BASE @"location.name?input=%@&format=json"), percentEncodedLocation];
    
    // URL format is '<base-url>/<function called>?input=<location>&format=<format (JSON/xml)>'
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];

    // Create the Method "GET" or "POST"
    [theRequest setHTTPMethod:@"GET"];

    // Set the token
    [theRequest setValue:[@"Bearer " stringByAppendingString:_accessToken] forHTTPHeaderField:@"Authorization"];
    
    // Set something? Not sure what for but it's needed
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    // Send request
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *theSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];

    // Send POST and receive token with callback
    NSURLSessionDataTask *postDataTask = [theSession dataTaskWithRequest:theRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSError *jsonError;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                if (jsonError) {
                    // Error parsing JSON
                    NSLog(@"Error parsing json response at token request");
                } else {
                    NSMutableArray *stopLocations = [self parseLocations:jsonResponse];
                    handler(stopLocations);
                }
            } else {
                // Server is returning an error
            }
        } else {
            // Fail
            NSLog(@"Error: %@", error.description);
        }
        
    }];
    [postDataTask resume];
}

- (void)getDepartureTimes {
    // OBS! Hours and minutes in the request should be separated by the string "%3A", not a literal ":"
    // URL format is '<base-url>/<function called>?id=<stop id>&date=<YYYY-MM-DD>&time=<hh:mm>(&<Here we can put optional options, see API>)&format=json
    // Example:
    // https://api.vasttrafik.se/bin/rest.exe/v2/departureBoard?id=9021014001390000&date=2020-04-26&time=20%3A08&maxDeparturesPerLine=3&format=json
    
    /* Get formated date
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    */
    
}

#pragma mark - JSON parsing

-(NSMutableArray*)parseLocations:(NSDictionary *)jsonResponse {
    NSArray *jsonLocations = jsonResponse[@"LocationList"][@"StopLocation"];
    // If the response only contains one element it does not contain an array of dictionaries, just a dictionary
    // Cast to array
    if (![jsonLocations isKindOfClass:NSArray.class]) {
        jsonLocations = [[NSArray alloc] initWithObjects:jsonLocations, nil];
    }
    
    NSMutableArray* locations = [NSMutableArray arrayWithCapacity:jsonLocations.count];
    for (NSDictionary *jsonLocation in jsonLocations) {
        StopLocation *stopLocation = [StopLocation alloc];
        for (NSString *key in jsonLocation.allKeys) {
            if ([key isEqualToString:@"id"]) {
                [stopLocation setStopID:[jsonLocation[key] integerValue]];
            } else if ([key isEqualToString:@"name"]) {
                [stopLocation setName:jsonLocation[key]];
            }
        }
        [locations addObject:stopLocation];
    }

    return  locations;
}


@end
