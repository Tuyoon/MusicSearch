//
//  HistoryTableViewCell.m
//  MusicSearch
//
//  Created by Mac on 06.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "HistoryTableViewCell.h"
#import "HistoryItem.h"

@interface HistoryTableViewCell () {
    IBOutlet UILabel *_titleLabel;
}

@end
@implementation HistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateUI {
    _titleLabel.text = self.item.term;
}

- (void)setItem:(HistoryItem *)item {
    _item = item;
    [self updateUI];
}

@end
