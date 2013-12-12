//
//  FRAsynchronousImageView.m
//  FuzzReader
//
//  Created by Andrew Glsuchenko on 12.12.13.
//  Copyright (c) 2013 Andrew Glsuchenko. All rights reserved.
//

#import "FRAsynchronousImageView.h"

#define kMinImageSize 8192

@interface FRAsynchronousImageView ()<NSURLConnectionDataDelegate>

@property (nonatomic, retain) NSURLConnection *imageLoader;
@property (nonatomic, retain) UIImage *placeholderImage;
@property (nonatomic, assign) int statusCode;
@property (nonatomic, retain) NSMutableData *imageData;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *downloadIndicator;

@end

@implementation FRAsynchronousImageView

- (void)dealloc {
    [self cancelImageLoading];
    [_imageLoader release];
    [_placeholderImage release];
    [_imageData release];
    [_downloadIndicator release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setImageWithURL:(NSString*)imageURL placeholderImage:(UIImage*)placeholderImage {
    [self cancelImageLoading];
    self.image = nil;
    if ( [imageURL length] > 0 ) {
        [self.downloadIndicator startAnimating];
        NSMutableURLRequest * imageLoadRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
        imageLoadRequest.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
        self.imageLoader = [NSURLConnection connectionWithRequest:imageLoadRequest delegate:self];
    }
    if ( placeholderImage ) {
        self.image = placeholderImage;
    }
}

- (void)cancelImageLoading {
    [self.downloadIndicator stopAnimating];
    [self.imageLoader cancel];
    self.imageLoader = nil;
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    self.statusCode = [response statusCode];
    if ( self.statusCode < 200 || self.statusCode >= 300 ) {
        NSLog(@"HTTP error: %d", self.statusCode);
    }
    long long contentLength = [response expectedContentLength];
    self.imageData = [NSMutableData dataWithCapacity:contentLength != NSURLResponseUnknownLength ? contentLength : kMinImageSize];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.downloadIndicator stopAnimating];    
    self.image = [UIImage imageWithData:self.imageData];
    self.imageData = nil;
    self.imageLoader = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Did fail loading image {%@}", [error localizedDescription]);
    [self.downloadIndicator stopAnimating];
    self.imageLoader = nil;
    self.imageData = nil;
}


@end
