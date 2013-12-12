//
//  FRAppDelegate.m
//  FuzzReader
//
//  Created by Andrew Glsuchenko on 10.12.13.
//  Copyright (c) 2013 Andrew Glsuchenko. All rights reserved.
//

#import "FRAppDelegate.h"
#import "FRItemsViewController.h"
#import "FRItem+JSONParser.h"

NSString *const kLoadItemsPath = @"http://dev.fuzzproductions.com/MobileTest/test.json";
NSString *const kTransportErrorDomain = @"com.fuzzproductions.FuzzReader.TransportErrors";
NSString *const kItemsDidLoadNotification = @"com.fuzzproductions.FuzzReader.ItemsDidLoadNotification";
NSString *const kItemsDidFailLoadNotification = @"com.fuzzproductions.FuzzReader.ItemsDidFailLoadNotification";
NSString *const kDiskCacheFolder = @"Images";

#define MemoryCacheSize 4*1024*1024
#define DiskCacheSize 20*1024*1024

@interface FRAppDelegate () <UITabBarControllerDelegate>

@end

@implementation FRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self loadItems];
    [self setupCache];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UITabBarController * tabController = (UITabBarController*)[storyBoard instantiateInitialViewController];
    FRItemsViewController *allItemsVC = [storyBoard instantiateViewControllerWithIdentifier:@"SimpleItemsViewController"];
    allItemsVC.filter = SelectAllItems;
    allItemsVC.tabBarItem.image = [UIImage imageNamed:@"all-tab-icon.png"];
    FRItemsViewController *textItemsVC = [storyBoard instantiateViewControllerWithIdentifier:@"SimpleItemsViewController"];
    textItemsVC.filter = SelectText;
    textItemsVC.tabBarItem.image = [UIImage imageNamed:@"text-tab-icon.png"];
    FRItemsViewController *photoItemsVC = [storyBoard instantiateViewControllerWithIdentifier:@"SimpleItemsViewController"];
    photoItemsVC.filter = SelectPhoto;
    photoItemsVC.tabBarItem.image = [UIImage imageNamed:@"image-tab-icon.png"];
    tabController.viewControllers = @[allItemsVC, textItemsVC, photoItemsVC];
    tabController.delegate = self;
    tabController.navigationItem.title = @"Fuzz Reader";
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:tabController] autorelease];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)setupCache {
    NSURLCache *cache = [[[NSURLCache alloc] initWithMemoryCapacity:MemoryCacheSize diskCapacity:DiskCacheSize diskPath:kDiskCacheFolder] autorelease];
    [NSURLCache setSharedURLCache:cache];
}

#pragma mark - Request
- (void)loadItems {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:kLoadItemsPath] options:0 error:&error];
        if ( error ) {
            [self itemsDidLoad:nil withError:error];
            return;
        }
        NSArray *jsonItems = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        if ( jsonItems ) {
            NSArray * parsedItems = [self parseItems:jsonItems];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self itemsDidLoad:parsedItems withError:nil];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError * error = [NSError errorWithDomain:kTransportErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:@"Unable to load items."}];
                [self itemsDidLoad:nil withError:error];
            });
        }
    });
}

- (void)itemsDidLoad:(NSArray*)items withError:(NSError*)error {
    if ( !error ) {
        for (FRItem *newItem in items) {
            [[FRModel sharedInstance] updateWithItem:newItem];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kItemsDidLoadNotification object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kItemsDidFailLoadNotification object:nil];
    }
}

- (NSArray*)parseItems:(NSArray*)jsonItems {
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:[jsonItems count]];
    for (NSDictionary * itemDict in jsonItems ) {
        FRItem * item = [FRItem itemWithJSON:itemDict];
        if ( item ) [result addObject:item];
    }
    return result;
}

#pragma mark - UITabBarControllerDelegate delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ( [viewController isKindOfClass:[FRItemsViewController class]] ) {

    }
    return YES;
}

@end
