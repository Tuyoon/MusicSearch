//
//  HistoryDataSource.m
//  MusicSearch
//
//  Created by Mac on 06.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "HistoryDataSource.h"
#import "HistoryTableViewCell.h"
#import "Searcher.h"

@interface HistoryDataSource () {
    id<SearcherProtocol> _searcher;
}

@property (nonatomic, strong, readwrite) NSArray *items;

@end

@implementation HistoryDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        [self updateHistory];
    }
    
    return self;
}

- (instancetype)initWithSearcher:(id<SearcherProtocol>)searcher {
    self = [super init];
    if (self) {
        _searcher = searcher;
    }
    return self;
}

- (void)updateHistory {
    self.items =  [_searcher searchHistory];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HistoryTableViewCell";
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.item = self.items[(NSUInteger)indexPath.row];
    
    return cell;
}
@end
