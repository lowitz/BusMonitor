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
#import "MonitorWrapper.h"

@interface LocationDetailsViewController()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *favoriteSwitch;

@property (strong, nonatomic) StopLocation *stopLocation;
@property (strong, nonatomic) MonitorWrapper *monitor;

@end

@implementation LocationDetailsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _monitor = [[MonitorWrapper alloc] init];
    [_monitor getAccessToken:^{
        [self->_monitor getDepartureTimesForID:[self->_stopLocation stopID] date:[NSDate date] maxDeparturesPerLine:3 handler:^(NSMutableArray* departures) {
            // Fill table with data
        }];
    }];
}

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

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"departureCell" forIndexPath:indexPath];

    UILabel *nameLabel = static_cast<UILabel*>([cell viewWithTag:1]);
    UILabel *timeLabel = static_cast<UILabel*>([cell viewWithTag:2]);
    UILabel *dirLabel  = static_cast<UILabel*>([cell viewWithTag:3]);
    [nameLabel setText:@"FillerName"];
    [timeLabel setText:@"5"];
    [dirLabel  setText:@"A"];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

@end
