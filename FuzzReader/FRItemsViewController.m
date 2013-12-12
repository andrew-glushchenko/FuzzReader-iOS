//
//  FRItemsViewController.m
//  FuzzReader
//
//  Created by Andrew Glsuchenko on 10.12.13.
//  Copyright (c) 2013 Andrew Glsuchenko. All rights reserved.
//

#import "FRItemsViewController.h"
#import "FRModel.h"
#import "FRItemCell.h"
#import "FRAppDelegate.h"

@interface FRItemsViewController ()

@property (nonatomic, retain) NSArray * items;

@end

@implementation FRItemsViewController

- (void)dealloc {
    [_items release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kItemsDidLoadNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kItemsDidFailLoadNotification object:nil];
    
    [self.refreshControl addTarget:self action:@selector(reloadItems) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setFilter:(FRItemsFilter)filter {
    if ( _filter != filter ) {
        _filter = filter;
        [self reloadDataWithFilter:_filter];
    }
}

- (void)reloadItems {
    [(FRAppDelegate*)[UIApplication sharedApplication].delegate loadItems];
}

- (void)reloadData {
    [self.refreshControl endRefreshing];
    [self reloadDataWithFilter:self.filter];
}

- (void)reloadDataWithFilter:(FRItemsFilter)filter {
    switch (filter) {
        case SelectAllItems: {
            self.tabBarItem.title = @"All";
            self.items = [[FRModel sharedInstance] allItems];
        }
            break;
        case SelectPhoto: {
            self.tabBarItem.title = @"Photo";
            self.items = [[FRModel sharedInstance] photoItems];
        }
            break;
        case SelectText: {
            self.tabBarItem.title = @"Text";
            self.items = [[FRModel sharedInstance] textItems];
        }
            break;
        default: {
            self.tabBarItem.title = @"";
            self.items = [[FRModel sharedInstance] allItems];
        }
            break;
    }
    [self updateUI];
}

- (void)updateUI {
    [self.tableView reloadData];
}

#pragma mark - UITableviewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

static NSString *SimpleItemCellIdentifier = @"SimpleItemCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FRItemCell * cell = [tableView dequeueReusableCellWithIdentifier:SimpleItemCellIdentifier];
    if ( !cell ) {
        cell = [[[FRItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleItemCellIdentifier] autorelease];
    }
    cell.item = [self.items objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate
static NSString *DefaultURL = @"http://fuzzproductions.com";

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DefaultURL]];
}

@end
