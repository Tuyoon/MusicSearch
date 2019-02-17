//
//  BaseWebConnector.m
//  MusicSearch
//
//  Created by AT on 15/02/2019.
//  Copyright © 2019 t. All rights reserved.
//

#import "BaseWebConnector.h"

static NSString *const kAPIBaseURL = @"https://itunes.apple.com/";

@implementation BaseWebConnector

- (instancetype)init {
    NSURL *baseURL = [NSURL URLWithString:kAPIBaseURL];
    self = [self initWithBaseURL:baseURL];
    return self;
}

- (void)getRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(WebConnectorSuccessBlock)success failure:(WebConnectorFailBlock)failure {
    
    [self GET:url parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(WebConnectorSuccessBlock)success failure:(WebConnectorFailBlock)failure {
    [self POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
