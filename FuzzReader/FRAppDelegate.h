//
//  FRAppDelegate.h
//  FuzzReader
//
//  Created by Andrew Glsuchenko on 10.12.13.
//  Copyright (c) 2013 Andrew Glsuchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRAppDelegate : UIResponder <UIApplicationDelegate>

extern NSString *const kItemsDidLoadNotification;
extern NSString *const kItemsDidFailLoadNotification;

@property (strong, nonatomic) UIWindow *window;

- (void)loadItems;

@end
