//
//  HistoryDataSource.h
//  MusicSearch
//
//  Created by Mac on 06.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearcherProtocol.h"

@interface HistoryDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readonly) NSArray *items;
- (instancetype)initWithSearcher:(id<SearcherProtocol>)searcher;
- (void)updateHistory;

@end
