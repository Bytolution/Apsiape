//
//  BYPreferencesViewController.m
//  Apsiape
//
//  Created by Dario Lass on 05.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//
#import "InterfaceDefinitions.h"
#import "BYPreferencesViewController.h"
#import "BYTableViewCellBGView.h"

@interface BYPreferencesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BYPreferencesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!self.tableView) self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = self.view.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(NAVBAR_HEIGHT, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    [self.view addSubview:self.tableView];
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
    //TODO: Use modified TVPGroupedTableViewCell w/out REUSE(!!!)
    BYTableViewCellBGViewCellPosition cellPos = 0;
    static NSString *cellIdentifier = nil;
    if (indexPath.row == 0 && [tableView numberOfRowsInSection:indexPath.section] == 1) {
        // single cell
        cellIdentifier = @"CELL_ID_single";
        cellPos = BYTableViewCellBGViewCellPositionSingle;
    } else if (indexPath.row == 0 && [tableView numberOfRowsInSection:indexPath.section] > 1) {
        // top cell
        cellIdentifier = @"CELL_ID_top";
        cellPos = BYTableViewCellBGViewCellPositionTop;
    } else if (indexPath.row == ([tableView numberOfRowsInSection:indexPath.section] - 1)) {
        //bottom cell
        cellIdentifier = @"CELL_ID_bottom";
        cellPos = BYTableViewCellBGViewCellPositionBottom;
    } else {
        //middle cell
        cellIdentifier = @"CELL_ID_middle";
        cellPos = BYTableViewCellBGViewCellPositionMiddle;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundView = [[BYTableViewCellBGView alloc]initWithFrame:cell.bounds cellPosition:cellPos];
    cell.textLabel.text = @"UITableViewCell";
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}

@end
