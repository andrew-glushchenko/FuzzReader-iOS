//
//  FRItemsViewController.h
//  FuzzReader
//
//  Created by Andrew Glsuchenko on 10.12.13.
//  Copyright (c) 2013 Andrew Glsuchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SelectAllItems = 0,
    SelectText,
    SelectPhoto
} FRItemsFilter;

@interface FRItemsViewController : UITableViewController

@property (nonatomic, assign) FRItemsFilter filter;

@end
