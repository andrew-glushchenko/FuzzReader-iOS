//
//  FRItem+JSONParser.h
//  FuzzReader
//
//  Created by Andrew Glsuchenko on 11.12.13.
//  Copyright (c) 2013 Andrew Glsuchenko. All rights reserved.
//

#import "FRModel.h"

@interface FRItem (JSONParser)

+(instancetype)itemWithJSON:(NSDictionary *)jsonDict;

@end
