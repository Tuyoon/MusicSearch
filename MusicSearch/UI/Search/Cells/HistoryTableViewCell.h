//
//  HistoryTableViewCell.h
//  MusicSearch
//
//  Created by Mac on 06.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HistoryItem;

@interface HistoryTableViewCell : UITableViewCell

@property (nonatomic, strong) HistoryItem *item;

@end
