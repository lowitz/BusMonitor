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
    if (favoriteSwitch.isOn) {
        [StopLocation addFavorite:_stopLocation];
    } else {
        [StopLocation removeFavorite:_stopLocation];
    }
}

@end
