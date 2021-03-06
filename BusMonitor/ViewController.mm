//
//  ViewController.m
//  BusMonitor
//
//  Created by Love Mowitz on 2020-04-28.
//  Copyright © 2020 Love Mowitz. All rights reserved.
//

#import "ViewController.h"
#import "MonitorWrapper.h"
#import "StopLocation.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UITableView *stopTable;

@property (strong, nonatomic) NSMutableArray *stopLocations;
@property (weak, nonatomic) UIView *loadingView;

@end

@implementation ViewController {
    MonitorWrapper *_monitor;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _monitor = [MonitorWrapper alloc];
    [_monitor getAccessToken:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_button setEnabled:YES];
        });
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stopCell" forIndexPath:indexPath];

    UILabel *label = (UILabel*)[cell viewWithTag:1];
    [label setText:[[_stopLocations objectAtIndex:indexPath.row] name]];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_stopLocations count];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _textField) {
        [textField resignFirstResponder];
        [self getLocation:[textField text]];
        return NO;
    }
    return YES;
}

#pragma mark - Location search

- (IBAction)buttonTapp:(id)sender {
    [_textField resignFirstResponder];
    [self getLocation:[_textField text]];
}

- (void)getLocation:(NSString*)location {
    // Don't send search if less than three characters
    if ([location length] < 3) return;

    [self showLoadingView];
    [_monitor getLocationName:location handler:^(NSMutableArray* stopLocations) {
        //Update the data
        self->_stopLocations = stopLocations;
        // Update table
        [self->_stopTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        [self removeLoadingView];
    }];
}


#pragma mark - Loading view

- (void)showLoadingView {
    __block UIView* spinnerView = [[UIView alloc] initWithFrame:self.view.bounds];
    spinnerView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    __block UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [ai startAnimating];
    [ai setCenter:spinnerView.center];

    _loadingView = spinnerView;
    dispatch_async(dispatch_get_main_queue(), ^{
        [spinnerView addSubview:ai];
        [self.view addSubview:spinnerView];
    });
}

- (void)removeLoadingView {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_loadingView) [self->_loadingView removeFromSuperview];
        self->_loadingView = nil;
    });
}

@end
