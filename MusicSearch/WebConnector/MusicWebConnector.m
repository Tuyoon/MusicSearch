//
//  MusicWebConnector.m
//  MusicSearch
//
//  Created by AT on 15/02/2019.
//  Copyright © 2019 t. All rights reserved.
//

#import "MusicWebConnector.h"

@implementation MusicWebConnector

- (void)searchWithQuery:(NSString *)query success:(WebConnectorSuccessBlock)success failure:(WebConnectorFailBlock)failure {
    static NSString *kSearchUrl = @"search";
    NSDictionary *parameters = @{@"term": query ?: @"#"};
    [self getRequestWithUrl:kSearchUrl parameters:parameters success:success failure:failure];
}

@end
