//
//  FRAsynchronousImageView.h
//  FuzzReader
//
//  Created by Andrew Glsuchenko on 12.12.13.
//  Copyright (c) 2013 Andrew Glsuchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRAsynchronousImageView : UIImageView

- (void)setImageWithURL:(NSString*)imageURL placeholderImage:(UIImage*)placeholderImage;
- (void)cancelImageLoading;

@end
