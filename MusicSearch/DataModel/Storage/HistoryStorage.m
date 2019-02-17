//
//  HistoryStorage.m
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "HistoryStorage.h"
#import "HistoryItem.h"
#import "History.h"

@implementation HistoryStorage

- (void)translateFromItem:(NSObject *)item toEntity:(ManagedObject *)entity {
    HistoryItem *fromItem = (HistoryItem *)item;
    History *toEntity = (History *)entity;
    toEntity.historyId = @(fromItem.historyId);
    toEntity.query = fromItem.query;
}

- (void)translateFromEntity:(ManagedObject *)entity toItem:(NSObject *)item {
    HistoryItem *toItem = (HistoryItem *)item;
    History *fromEntity = (History *)entity;
    toItem.historyId = [fromEntity.historyId doubleValue];
    toItem.query = fromEntity.query;
}

- (NSObject *)newItem {
    return [[HistoryItem alloc] init];
}

- (NSString *)entityClassName {
    return NSStringFromClass([History class]);
}

- (NSSortDescriptor *)sortDescriptor {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:@"historyId" ascending:NO];
    return descriptor;
}

- (NSPredicate *)predicateForEntityForItem:(NSObject *)item {
    HistoryItem *historyItem = (HistoryItem *)item;
    return [NSPredicate predicateWithFormat:@"query LIKE[c] %@", historyItem.query];
}

@end
