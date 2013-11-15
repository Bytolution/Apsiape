//
//  BYPreferencesViewController.m
//  Apsiape
//
//  Created by Dario Lass on 05.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "Constants.h"
#import "BYPreferencesViewController.h"
#import "BYLocalePickerViewController.h"

@interface BYPreferencesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISwitch *createOnLaunchSwitch;

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
    
    if (!self.createOnLaunchSwitch) self.createOnLaunchSwitch = [[UISwitch alloc]init];
    
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
    [self.createOnLaunchSwitch setOn:[[NSUserDefaults standardUserDefaults]boolForKey:BYApsiapeCreateOnLaunchPreferenceKey] animated:NO];
}

#pragma mark - UITableView implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Apsiape can present the expense creation view everytime it opens";
            break;
        case 1:
            return @"Apsiape will determine the current locale using location services. You can also set it manually.";
            break;
        default:
            return Nil;
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
                    [self.createOnLaunchSwitch addTarget:self action:@selector(createOnLaunchSwitchToggled:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = self.createOnLaunchSwitch;
                    break;
            }
            break;
        case 1:
            cell.textLabel.text = @"Preferred Currency";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:[[BYLocalePickerViewController alloc]init] animated:YES];
}

#pragma mark Button state change handling

- (void)createOnLaunchSwitchToggled:(UISwitch *)createOnLaunchSwitch
{
    [[NSUserDefaults standardUserDefaults] setBool:createOnLaunchSwitch.on forKey:BYApsiapeCreateOnLaunchPreferenceKey];
}

@end
