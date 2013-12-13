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

- (void)openMailApp;

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
    return 3;
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
        case 2:
            return @"Apsiape is open-source and availible on GitHub";
        default:
            return Nil;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CELL_ID";
    
    if (indexPath.section == 2) {
        cellIdentifier = @"CELL_ID_ACTION";
    } else {
        cellIdentifier = @"CELL_ID_SELECTION";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        if (indexPath.section == 2) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        } else {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
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
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Preferred Currency";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.textLabel.text = @"Contact Support";
                    cell.backgroundColor = [UIColor robinEggColor];
                    break;
                default:
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
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [tableView deselectRowAtIndexPath:indexPath animated:NO];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self.navigationController pushViewController:[[BYLocalePickerViewController alloc]init] animated:YES];
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    [self openMailApp];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

#pragma mark Button state change handling

- (void)createOnLaunchSwitchToggled:(UISwitch *)createOnLaunchSwitch
{
    [[NSUserDefaults standardUserDefaults] setBool:createOnLaunchSwitch.on forKey:BYApsiapeCreateOnLaunchPreferenceKey];
}

#pragma mark Open Mail App

- (void)openMailApp
{
    /* create mail subject */
    NSString *subject = [NSString stringWithFormat:@"Support Request"];
    
    /* define email address */
    NSString *mail = [NSString stringWithFormat:@"support@bytolution.com"];
    
    /* create the URL */
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                                [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    
    /* load the URL */
    [[UIApplication sharedApplication] openURL:url];
}

@end
