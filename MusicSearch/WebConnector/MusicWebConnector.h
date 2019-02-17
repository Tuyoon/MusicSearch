//
//  MusicWebConnector.h
//  MusicSearch
//
//  Created by AT on 15/02/2019.
//  Copyright © 2019 t. All rights reserved.
//

#import "BaseWebConnector.h"

@protocol MusicWebConnectorProtocol

- (void)searchWithQuery:(NSString *)query success:(WebConnectorSuccessBlock)success failure:(WebConnectorFailBlock)failure;

@end

@interface MusicWebConnector : BaseWebConnector<MusicWebConnectorProtocol>

@end
