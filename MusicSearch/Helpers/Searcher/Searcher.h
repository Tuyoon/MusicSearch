//
//  Searcher.h
//  MusicSearch
//
//  Created by Mac on 05.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicWebConnector.h"
#import "SearcherProtocol.h"

@interface Searcher : NSObject<SearcherProtocol>

@property (nonatomic, strong) id<MusicWebConnectorProtocol> webConnector;
- (instancetype)initWithWebConnector:(id<MusicWebConnectorProtocol>) webConnector;
@end
