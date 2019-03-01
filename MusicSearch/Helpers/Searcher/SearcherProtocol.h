//
//  SearcherProtocol.h
//  MusicSearch
//
//  Created by AT on 01/03/2019.
//  Copyright © 2019 t. All rights reserved.
//

typedef void(^SearcherCompletionBlock)(NSArray *items);

@protocol SearcherProtocol <NSObject>

- (void)search:(NSString *)query withCompletion:(SearcherCompletionBlock)completion;
- (NSArray *)searchHistory;

@end
