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

@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) MonitorWrapper *monitorWrapper;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _monitorWrapper = [[MonitorWrapper alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // NSUserDefaults *defaults = [[NSUserDefaults standardUserDefaults] initWithSuiteName:@"group.com.lovemowitz.BusMonitor"];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
