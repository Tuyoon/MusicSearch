//
//  MusicTableViewCell.h
//  MusicSearch
//
//  Created by Mac on 06.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicItem;

@interface MusicTableViewCell : UITableViewCell

@property (nonatomic, strong) MusicItem *item;

@end
