//
//  FRModel.h
//  FuzzReader
//
//  Created by Andrew Glsuchenko on 10.12.13.
//  Copyright (c) 2013 Andrew Glsuchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const FRItemTypeText;
extern NSString *const FRItemTypePhoto;

@interface FRItem : NSObject

@property (nonatomic, assign) NSInteger itemID;
@property (nonatomic, copy) NSString *itemType;
@property (nonatomic, copy) NSString *itemData;

- (instancetype)initWithID:(NSInteger)itemID type:(NSString*)itemType data:(NSString*)itemData;
- (BOOL)isTextItem;
- (BOOL)isPhotoItem;

@end

@interface FRModel : NSObject

+(FRModel*)sharedInstance;

- (NSArray*)allItems;
- (NSArray*)textItems;
- (NSArray*)photoItems;
- (void)updateWithItem:(FRItem*)item;


@end
