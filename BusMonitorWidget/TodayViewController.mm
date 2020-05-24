//
//  TodayViewController.m
//  BusMonitorWidget
//
//  Created by Love Mowitz on 2020-04-28.
//  Copyright © 2020 Love Mowitz. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#import "Departure.h"
#import "MonitorWrapper.h"
#import "StopLocation.h"

#import "DepartureCell.h"

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UILabel *stopLocationLabel;
@property (weak, nonatomic) IBOutlet UITableView *departuresTableView;

@property (strong, nonatomic) MonitorWrapper *monitorWrapper;
@property (strong, nonatomic) NSMutableArray<StopLocation*> *favoriteLocations;
@property (strong, nonatomic) NSMutableArray<Departure*> *departures;
@property (nonatomic) NCUpdateResult updateResult;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_monitorWrapper) _monitorWrapper = [[MonitorWrapper alloc] init];
    [[self extensionContext] setWidgetLargestAvailableDisplayMode:NCWidgetDisplayModeExpanded];
    
    UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(_departuresTableView.frame.origin.x, _departuresTableView.frame.origin.y, _departuresTableView.frame.size.width, 1)];
    separator.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:separator];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // NSUserDefaults *defaults = [[NSUserDefaults standardUserDefaults] initWithSuiteName:@"group.com.lovemowitz.BusMonitor"];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    if (!_monitorWrapper) _monitorWrapper = [[MonitorWrapper alloc] init];
    [self updateDeparturesTable];

    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    switch (activeDisplayMode) {
        case NCWidgetDisplayModeCompact:
            [self setPreferredContentSize:maxSize];
            break;
        case NCWidgetDisplayModeExpanded:
            CGFloat height = MIN(44.0f * _departures.count, maxSize.height);
            [self setPreferredContentSize:CGSizeMake(maxSize.width, height)];
            break;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    NSInteger updatedVisibleCellCount = [self numberOfTableRowsToDisplay];
    NSInteger currentVisibleCellCount = _departuresTableView.visibleCells.count;
    NSInteger cellCountDifference = updatedVisibleCellCount - currentVisibleCellCount;

    if (cellCountDifference != 0) {
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            [self->_departuresTableView performBatchUpdates:^ {
                NSMutableArray<NSIndexPath*> *indexPaths = [[NSMutableArray alloc] init];
                for (int i = 2; i < 2 + ABS(cellCountDifference); i++) {
                    [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                if (cellCountDifference > 0) {
                    [self->_departuresTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                } else {
                    [self->_departuresTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                }
            } completion:nil];
        } completion:nil];
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
    return [self numberOfTableRowsToDisplay];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

#pragma mark - Utility methods

- (void)updateDeparturesTable {
    _favoriteLocations = [StopLocation getFavorites];
    if (_favoriteLocations.count == 0) return;
    
    [_stopLocationLabel setText:[[_favoriteLocations objectAtIndex:0] name]];
    [_monitorWrapper getAccessToken:^ {
        [self->_monitorWrapper getDepartureTimesForID:[[self->_favoriteLocations objectAtIndex:0] stopID] date:[NSDate date] maxDeparturesPerLine:2 handler:^(NSMutableArray *departures) {
            self->_departures = departures;
            [self->_departuresTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }];
    }];
}

- (NSInteger)numberOfTableRowsToDisplay {
    if ([[self extensionContext] widgetActiveDisplayMode] == NCWidgetDisplayModeCompact) {
        return 2;
    } else {
        return MIN([_departures count], 9);
    }
}

@end
