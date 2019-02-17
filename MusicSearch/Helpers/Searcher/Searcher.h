//
//  Searcher.h
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicWebConnector.h"

typedef void(^SearcherCompletionBlock)(NSArray *items);

@interface Searcher : NSObject

@property (nonatomic, strong) id<MusicWebConnectorProtocol> webConnector;

+ (instancetype)sharedInstance;
- (void)search:(NSString *)query withCompletion:(SearcherCompletionBlock)completion;
- (NSArray *)searchHistory;

@end
