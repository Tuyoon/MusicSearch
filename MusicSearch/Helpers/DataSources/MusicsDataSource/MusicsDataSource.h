//
//  MusicsDataSource.h
//  MusicSearch
//
//  Created by Mac on 06.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicsDataSource;

@protocol MusicsDataSourceDelegate <NSObject>

@optional
- (void)dataSourceChanged:(MusicsDataSource *)dataSource;

@end

@interface MusicsDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readonly) NSArray *items;
@property (nonatomic, weak) id<MusicsDataSourceDelegate> delegate;

- (void)loadMusicsWithQuery:(NSString *)query completion:(void(^)(NSArray *items))completion;

@end
