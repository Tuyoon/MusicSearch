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

@interface HistoryDataSource ()

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

- (void)updateHistory {
    self.items = [[Searcher sharedInstance] searchHistory];
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
