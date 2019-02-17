//
//  BaseWebConnector.h
//  MusicSearch
//
//  Created by AT on 15/02/2019.
//  Copyright © 2019 t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^WebConnectorSuccessBlock)(id object);
typedef void (^WebConnectorFailBlock)(NSError *error);

@interface BaseWebConnector : AFHTTPSessionManager

- (void)getRequestWithUrl:(NSString *)url
               parameters:(NSDictionary *)parameters
                  success:(WebConnectorSuccessBlock)success
                  failure:(WebConnectorFailBlock)failure;

- (void)postRequestWithUrl:(NSString *)url
                parameters:(NSDictionary *)parameters
                   success:(WebConnectorSuccessBlock)success
                   failure:(WebConnectorFailBlock)failure;

@end
