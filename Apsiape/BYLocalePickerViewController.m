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
@property (nonatomic, strong) NSArray *commonCurrencyCodes;
@property (nonatomic, strong) NSString *preferredCurrencyCode;
@property (nonatomic, strong) NSIndexPath *checkmarkIndexPath;

@end

@implementation BYLocalePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (!self.tableView) self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self.commonCurrencyCodes = [NSLocale commonISOCurrencyCodes];
        
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
            return [self.commonCurrencyCodes count];
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
        NSString *currencyName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCurrencyCode value:self.commonCurrencyCodes[indexPath.row]];
        cell.textLabel.text = currencyName;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:BYApsiapeUserPreferredAppLocaleIdentifier];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSLocale localeIdentifierFromComponents:@{NSLocaleCurrencyCode: self.commonCurrencyCodes[indexPath.row]}] forKey:BYApsiapeUserPreferredAppLocaleIdentifier];
    }
}

@end
