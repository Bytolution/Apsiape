//
//  BYLocalePickerViewController.m
//  Apsiape
//
//  Created by Dario Lass on 14.11.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYLocalePickerViewController.h"
#import "Constants.h"

@interface BYLocalePickerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableViewData;

- (NSString*)preferredCurrencyCode;
- (void)setPreferredCurrencyCode:(NSString*)preferredCurrencyCode;

- (void)reloadTableView;

@end

@implementation BYLocalePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (!self.tableView) self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        [self.view addSubview:self.tableView];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
    
    [self reloadTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)reloadTableView
{
    NSString *userpreferredAppLocaleIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:BYApsiapeUserPreferredAppLocaleIdentifier];
    NSString *preferredCurrencyCode = [[NSLocale localeWithLocaleIdentifier:userpreferredAppLocaleIdentifier] objectForKey:NSLocaleCurrencyCode];
    
    NSMutableArray *mutableTableViewData = [NSMutableArray new];
    
    for (NSString *currencyCode in [NSLocale commonISOCurrencyCodes]) {
        NSMutableDictionary *rowData = [NSMutableDictionary new];
        NSString *currencyName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCurrencyCode value:currencyCode];
        [rowData setObject:currencyName forKey:@"currencyName"];
        if ([preferredCurrencyCode isEqualToString:currencyCode]) {
            [rowData setObject:[NSNumber numberWithBool:YES] forKey:@"checkmark"];
        } else {
            [rowData setObject:[NSNumber numberWithBool:NO] forKey:@"checkmark"];
        }
        [mutableTableViewData addObject:rowData];
    }
    
    self.tableViewData = [mutableTableViewData copy];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.tableViewData.count;
            break;
        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL_ID"];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"None";
    } else {
        cell.textLabel.text = [self.tableViewData[indexPath.row] objectForKey:@"currencyName"];
    }
    
    if ([self.tableViewData[indexPath.row] objectForKey:@"checkmark"] == [NSNumber numberWithBool:YES]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.section == 0) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:BYApsiapeUserPreferredAppLocaleIdentifier]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    if (indexPath.section == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:BYApsiapeUserPreferredAppLocaleIdentifier];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSLocale localeIdentifierFromComponents:@{NSLocaleCurrencyCode: [NSLocale commonISOCurrencyCodes][indexPath.row]}] forKey:BYApsiapeUserPreferredAppLocaleIdentifier];
    }
    
    [self reloadTableView];
}

@end
