//
//  BYPreferencesViewController.m
//  Apsiape
//
//  Created by Dario Lass on 05.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "Constants.h"
#import "BYPreferencesViewController.h"

@interface BYPreferencesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

- (void)closeButtonTapped:(UIBarButtonItem*)button;

- (void)createOnLaunchSwitchToggled:(UISwitch*)createOnLaunchSwitch;

@end

@implementation BYPreferencesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"Settings";
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeButtonTapped:)];
    self.navigationItem.rightBarButtonItem = closeButton;
    
    if (!self.tableView) self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = self.view.bounds;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    [self.view addSubview:self.tableView];
}

- (void)closeButtonTapped:(UIBarButtonItem *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BYNavigationControllerShouldDismissPreferencesVCNotificationName object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

#pragma mark - UITableView implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CELL_ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = @"UITableViewCell";
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Create on launch";
                    UISwitch *createOnLaunchSwitch = [[UISwitch alloc]init];
                    [createOnLaunchSwitch addTarget:self action:@selector(createOnLaunchSwitchToggled:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = createOnLaunchSwitch;
                    break;
            }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[BYPreferencesViewController alloc]init] animated:YES];
}

#pragma mark Button state change handling

- (void)createOnLaunchSwitchToggled:(UISwitch *)createOnLaunchSwitch
{
    if (createOnLaunchSwitch.on) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:BYApsiapeCreateOnLaunchPreferenceKey];
    }
}

@end
