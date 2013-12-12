//
//  FRModel.m
//  FuzzReader
//
//  Created by Andrew ; on 10.12.13.
//  Copyright (c) 2013 Andrew Glsuchenko. All rights reserved.
//

#import "FRModel.h"

NSString *const FRItemTypeText = @"text";
NSString *const FRItemTypePhoto = @"image";


@implementation FRItem

- (void)dealloc {
    [_itemData release];
    [_itemType release];
    [super dealloc];
}

- (instancetype)initWithID:(NSInteger)itemID type:(NSString*)itemType data:(NSString*)itemData {
    self = [super init];
    if ( self ) {
        _itemID = itemID;
        _itemData = [itemData copy];
        _itemType = [itemType copy];
    }
    return self;
}

- (BOOL)isEqual:(FRItem*)object {
    return self.itemID == object.itemID;
}

- (NSUInteger)hash {
    return self.itemID;
}

- (BOOL)isTextItem {
    return [self.itemType isEqualToString:FRItemTypeText];
}

- (BOOL)isPhotoItem {
    return [self.itemType isEqualToString:FRItemTypePhoto];
}

@end


@interface FRModel ()

@property (nonatomic, retain) NSMutableSet *items;

@end

@implementation FRModel

#pragma mark - Singleton methods
static FRModel *sharedInterface = nil;

+ (FRModel*)sharedInstance {
    @synchronized(self) {
        if ( sharedInterface == nil ) {
            sharedInterface = [[super allocWithZone:NULL] init];
        }
        return sharedInterface;
    }
}

+(id)allocWithZone:(struct _NSZone *)zone {
    return [[self sharedInstance] retain];
}

- (instancetype)init {
    self = [super init];
    if ( self ) {
        _items = [[NSMutableSet alloc] init];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(id)retain
{
    return self;
}

-(oneway void)release
{ // do nothing, just for singleton
}

- (void)dealloc {
    [_items release];
    [super dealloc];
}

#pragma mark - Data read
- (NSArray*)allItems {
    return [[self.items allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"itemID" ascending:YES]]];
}

- (NSArray*)textItems {
    return [self itemsFilteredByType:FRItemTypeText];
}

- (NSArray*)photoItems {
    return [self itemsFilteredByType:FRItemTypePhoto];
}

- (NSArray*)itemsFilteredByType:(NSString*)itemType {
    return [[[self.items filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"itemType == %@", itemType]] allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"itemID" ascending:YES]]];
}

#pragma mark — Data update
- (void)updateWithItem:(FRItem*)item {
    [self.items addObject:item];
}

@end
