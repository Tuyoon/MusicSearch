//
//  MusicsDataSource.m
//  MusicSearch
//
//  Created by Mac on 06.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "MusicsDataSource.h"
#import "MusicTableViewCell.h"

@interface MusicsDataSource () {
    id<SearcherProtocol> _searcher;
    struct {
        unsigned int changed : 1;
    } _delegateFlags;
}

@property (nonatomic, strong, readwrite) NSArray *items;

@end

@implementation MusicsDataSource

- (instancetype)initWithSearcher:(id<SearcherProtocol>)searcher {
    self = [super init];
    if (self) {
        _searcher = searcher;
    }
    return self;
}

- (void)loadMusicsWithQuery:(NSString *)query completion:(void(^)(NSArray *items))completion {
    [_searcher search:query withCompletion:^(NSArray *items) {
        self.items = items;
        if (completion) {
            completion(items);
        }
        [self informAboutChanging];
    }];
}

- (void)setDelegate:(id<MusicsDataSourceDelegate>)delegate {
    _delegate = delegate;
    if ([delegate respondsToSelector:@selector(dataSourceChanged:)]) {
        _delegateFlags.changed = 1;
    }
}

- (void)informAboutChanging {
    if (_delegateFlags.changed) {
        [self.delegate dataSourceChanged:self];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MusicTableViewCell";
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.item = self.items[(NSUInteger)indexPath.row];
    
    return cell;
}

@end
