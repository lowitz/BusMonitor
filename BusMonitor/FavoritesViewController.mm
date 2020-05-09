//
//  FavoritesViewController.m
//  BusMonitor
//
//  Created by Love Mowitz on 2020-05-06.
//  Copyright © 2020 Love Mowitz. All rights reserved.
//

#import "FavoritesViewController.h"
#import "LocationDetailsViewController.h"
#import "StopLocation.h"

@interface FavoritesViewController()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray* favoriteStopLocations;

@end

@implementation FavoritesViewController

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Need to manually deselect cell since we're using a normal view controller
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    
    _favoriteStopLocations = [StopLocation getFavorites];
    [_tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"locationSelected"]) {
        if ([sender isKindOfClass:NSIndexPath.class]) {
            NSIndexPath *indexPath = static_cast<NSIndexPath*>(sender);
            auto vc = static_cast<LocationDetailsViewController*>([segue destinationViewController]);
            [vc setLocation:[_favoriteStopLocations objectAtIndex:indexPath.row]];
        }
    }
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stopCell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel*)[cell viewWithTag:1];
    [label setText:[[_favoriteStopLocations objectAtIndex:indexPath.row] name]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_favoriteStopLocations count];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"locationSelected" sender:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

@end
