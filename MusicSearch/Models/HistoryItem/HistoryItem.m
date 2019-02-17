//
//  HistoryItem.m
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "HistoryItem.h"

@implementation HistoryItem

- (instancetype)init {
    self = [super init];
    if (self) {
        _historyId = [[NSDate new] timeIntervalSince1970];
    }
    
    return self;
}

- (instancetype)initWithQuery:(NSString *)query {
    self = [self init];
    if (self) {
        _query = query;
    }
    
    return self;
}

@end
