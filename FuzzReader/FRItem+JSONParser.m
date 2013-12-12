//
//  FRItem+JSONParser.m
//  FuzzReader
//
//  Created by Andrew Glsuchenko on 11.12.13.
//  Copyright (c) 2013 Andrew Glsuchenko. All rights reserved.
//

#import "FRItem+JSONParser.h"

@implementation FRItem (JSONParser)

+(instancetype)itemWithJSON:(NSDictionary *)jsonDict {
    NSInteger itemID = [[jsonDict objectForKey:@"id"] integerValue];
    NSString *itemType = [jsonDict objectForKey:@"type"];
    NSString *itemData = [jsonDict objectForKey:@"data"];
    if ( itemID <= 0 || ![self isValidItemType:itemType] ) {
        NSLog(@"Invalid JSON object.");
        return nil;
    }
    else {
        return [[[FRItem alloc] initWithID:itemID type:itemType data:itemData] autorelease];
    }
}

+ (BOOL)isValidItemType:(NSString*)itemType {
    return [itemType isEqualToString:FRItemTypePhoto] || [itemType isEqualToString:FRItemTypeText];
}

@end
