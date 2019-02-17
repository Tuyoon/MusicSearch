//
//  MusicTableViewCell.m
//  MusicSearch
//
//  Created by Mac on 06.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "MusicTableViewCell.h"
#import "MusicItem.h"

@implementation MusicTableViewCell {
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_collectionLabel;
    __weak IBOutlet UILabel *_artistNameLabel;
    __weak IBOutlet UIImageView *_artworkImageView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _artworkImageView.image = nil;
}

- (void)updateUI {
    _titleLabel.text = self.item.trackName;
    _collectionLabel.text = self.item.collectionName;
    _artistNameLabel.text = self.item.artistName;
    _artworkImageView.image = self.item.artwork100;
}

- (void)setItem:(MusicItem *)item {
    _item = item;
    [self updateUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
