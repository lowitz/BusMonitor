//
//  LocationDetailsViewController.m
//  BusMonitor
//
//  Created by Love Mowitz on 2020-05-03.
//  Copyright © 2020 Love Mowitz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LocationDetailsViewController.h"
#import "StopLocation.h"

@interface LocationDetailsViewController()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *favoriteSwitch;

@property (weak, nonatomic) StopLocation *stopLocation;

@end

@implementation LocationDetailsViewController

#pragma mark - UIViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Show navigation bar since set to hidden
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [_nameLabel setText:[_stopLocation name]];
    [_favoriteSwitch setOn:[_stopLocation isFavorite]];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Hide navigation bar since set to hidden
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)setLocation:(StopLocation*)location {
    _stopLocation = location;
}

- (IBAction)favoriteChanged:(UISwitch*)favoriteSwitch {
    NSUserDefaults *defaults = [[NSUserDefaults standardUserDefaults] initWithSuiteName:@"group.com.lovemowitz.BusMonitor"];
    NSMutableArray *favoriteStops = [NSMutableArray arrayWithArray:[defaults objectForKey:@"stopLocationFavorites"]];

    bool hasChanged = false;
    if (favoriteSwitch.isOn) {
        [favoriteStops addObject:_stopLocation];
        hasChanged = true;
    } else {
        if (favoriteStops == nil) return;
        for (int i = 0; i < [favoriteStops count]; i++) {
            auto stop = static_cast<StopLocation*>(favoriteStops[i]);
            if (stop.stopID == _stopLocation.stopID) {
                [favoriteStops removeObjectAtIndex:i];
                hasChanged = true;
            }
        }
    }

    if (hasChanged) {
        [defaults setObject:favoriteStops forKey:@"stopLocationFavorites"];
    }
}

@end
