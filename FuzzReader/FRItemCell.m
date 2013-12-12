//
//  FRItemCell.m
//  FuzzReader
//
//  Created by Andrew Glsuchenko on 12.12.13.
//  Copyright (c) 2013 Andrew Glsuchenko. All rights reserved.
//

#import "FRItemCell.h"
#import "FRModel.h"
#import "FRAsynchronousImageView.h"

@interface FRItemCell ()

@property (retain, nonatomic) IBOutlet FRAsynchronousImageView *itemImage;
@property (retain, nonatomic) IBOutlet UILabel *itemText;

@end

@implementation FRItemCell

- (void)dealloc {
    [_itemImage release];
    [_itemText release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setItem:(FRItem *)item {
    if ( item != _item ) {
        [_item release];
        _item = [item retain];
        [self updateUI];
    }
}

- (void)updateUI {
    self.itemImage.hidden = [self.item isTextItem];
    self.itemText.hidden = [self.item isPhotoItem];
    if ( [self.item isPhotoItem] ) {
        [self.itemImage setImageWithURL:self.item.itemData placeholderImage:nil];
    }
    else if ( [self.item isTextItem] ) {
        self.itemText.text = self.item.itemData;
    }
}

@end
