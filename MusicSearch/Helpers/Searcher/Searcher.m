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
#import "SearchAPI.h"
#import "MusicItem.h"
#import "HistoryItem.h"

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
    }
    
    return self;
}

- (void)searchWithTerm:(NSString *)term withCompletion:(SearcherCompletionBlock)completion {
    
    void (^searchBlock)(void) = ^{
        if (completion) {
            completion([self searchInStorage:term]);
        }
    };
    [SearchAPI apiWithObject:@{kAPITermKey : term} withSuccessBlock:^(id result) {
        [self save:result[@"results"]];
        searchBlock();
    } withFailure:^(NSError *error) {
        searchBlock();
    }];
    [self saveToHistory:term];
}

- (void)save:(id)result {
    NSArray *items = [MusicItem itemsFromDictionariesArray:result];
    [_musicStorage saveItems:items];
}

- (NSArray *)searchInStorage:(NSString *)term {
    return [_musicStorage itemsWithTerm:term];
}

- (void)saveToHistory:(NSString *)term {
    HistoryItem *item = [[HistoryItem alloc] init];
    item.term = term;
    [_historyStorage saveItems:@[item]];
}

- (NSArray *)searchHistory {
    return [_historyStorage allItems];
}

@end
