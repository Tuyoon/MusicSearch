//
//  HistoryItem.h
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryItem : NSObject

@property (nonatomic, assign) NSTimeInterval historyId;
@property (nonatomic, strong) NSString *query;
- (instancetype)initWithQuery:(NSString *)query;

@end
