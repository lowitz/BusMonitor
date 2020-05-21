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
#import "Departure.h"
#import "MonitorWrapper.h"
#import "DepartureCell.h"

@interface LocationDetailsViewController()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *favoriteSwitch;
@property (weak, nonatomic) IBOutlet UITableView *departuresTable;

@property (strong, nonatomic) StopLocation *stopLocation;
@property (strong, nonatomic) MonitorWrapper *monitor;
@property (strong, nonatomic) NSMutableArray *departures;

@end

@implementation LocationDetailsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _monitor = [[MonitorWrapper alloc] init];
    [_monitor getAccessToken:^{
        [self->_monitor getDepartureTimesForID:[self->_stopLocation stopID] date:[NSDate date] maxDeparturesPerLine:3 handler:^(NSMutableArray* departures) {
            self->_departures = departures;
            [self->_departuresTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
    DepartureCell *departureCell = static_cast<DepartureCell*>([tableView dequeueReusableCellWithIdentifier:@"departureCell" forIndexPath:indexPath]);
    Departure *departure = [_departures objectAtIndex:indexPath.row];

    [departureCell setSignLabelText:departure.sname withTextColor:departure.fgColor withBackgroundColor:departure.bgColor];
    [departureCell setDirectionLabelText:departure.direction];
    [departureCell setTimeLabelText:departure.departsInMin];
    [departureCell setTrackLabelText:departure.track];

    return departureCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_departures count];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

@end
