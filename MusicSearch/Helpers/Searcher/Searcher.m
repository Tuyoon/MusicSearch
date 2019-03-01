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
    id<MusicWebConnectorProtocol> _webConnector;
}

- (instancetype)initWithWebConnector:(id<MusicWebConnectorProtocol>) webConnector {
    self = [super init];
    if (self) {
        _webConnector = webConnector;
        [self configure];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configure];
    }
    
    return self;
}

- (void)configure {
    _musicStorage = [[MusicStorage alloc] init];
    _historyStorage = [[HistoryStorage alloc] init];
    _webConnector = [[MusicWebConnector alloc] init];
}

- (void)save:(id)result {
    NSError *error = nil;
    NSArray<MusicItem *> *items = [MusicItem arrayOfModelsFromDictionaries:result error:&error];
    if (!error) {
        [_musicStorage saveItems:items];
    }
}

- (NSArray *)searchInStorage:(NSString *)query {
    return [_musicStorage itemsWithQuery:query];
}

- (void)saveQueryToHistory:(NSString *)query {
    HistoryItem *item = [[HistoryItem alloc] initWithQuery:query];
    [_historyStorage saveItems:@[item]];
}

#pragma mark - SearcherProtocol

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

- (NSArray *)searchHistory {
    return [_historyStorage allItems];
}

@end
