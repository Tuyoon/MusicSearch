//
//  Searcher.h
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SearcherCompletionBlock)(NSArray *items);

@interface Searcher : NSObject

+ (instancetype)sharedInstance;
- (void)searchWithTerm:(NSString *)term withCompletion:(SearcherCompletionBlock)completion;
- (NSArray *)searchHistory;

@end
