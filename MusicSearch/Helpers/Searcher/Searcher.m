//
//  Searcher.m
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "Searcher.h"
#import "MusicStorage.h"
#import "HistoryStorage.h"
#import "MusicItem.h"
#import "HistoryItem.h"
#import "MusicWebConnector.h"

@implementation Searcher {
    MusicStorage *_musicStorage;
    HistoryStorage *_historyStorage;
}

+ (instancetype)sharedInstance {
    static Searcher *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Searcher alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _musicStorage = [[MusicStorage alloc] init];
        _historyStorage = [[HistoryStorage alloc] init];
        _webConnector = [[MusicWebConnector alloc] init];
    }
    
    return self;
}

- (void)search:(NSString *)query withCompletion:(SearcherCompletionBlock)completion {
    void (^completeSearch)(void) = ^{
        if (completion) {
            completion([self searchInStorage:query]);
        }
    };
    
    __weak typeof(self) wSelf = self;
    [_webConnector searchWithQuery:query success:^(id object) {
        [wSelf save:object[@"results"]];
        completeSearch();
    } failure:^(NSError *error) {
        completeSearch();
    }];
    
    [self saveQueryToHistory:query];
}

- (void)save:(id)result {
    // TODO: optimize
    NSArray *items = [MusicItem itemsFromDictionariesArray:result];
    [_musicStorage saveItems:items];
}

- (NSArray *)searchInStorage:(NSString *)query {
    return [_musicStorage itemsWithQuery:query];
}

- (void)saveQueryToHistory:(NSString *)query {
    HistoryItem *item = [[HistoryItem alloc] initWithQuery:query];
    [_historyStorage saveItems:@[item]];
}

- (NSArray *)searchHistory {
    return [_historyStorage allItems];
}

@end
