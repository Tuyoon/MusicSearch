//
//  API.m
//  MusicSearch
//
//  Created by Mac on 04.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "API.h"
#import <objc/runtime.h>
#import <AFNetworking/AFHTTPSessionManager.h>


static NSString *const kAPIBaseURL = @"https://itunes.apple.com/";

@implementation API

+ (void)initialize {
    if (self == [API class]) {
        [self createHttpClient];
    }
}

+ (void)createHttpClient {
    NSURL *baseURL = [NSURL URLWithString:kAPIBaseURL];
    AFHTTPSessionManager *httpClient = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:(NSJSONWritingOptions)kNilOptions];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [httpClient setRequestSerializer:requestSerializer];
    [[httpClient reachabilityManager] startMonitoring];
    
    objc_setAssociatedObject(self, @selector(httpClient), httpClient, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (AFHTTPSessionManager*)httpClient {
    return objc_getAssociatedObject(self, _cmd);
}

+ (instancetype)apiWithObject:(id)object {
    return [self apiWithObject:object withSuccessBlock:nil withFailure:nil];
}

+ (instancetype)apiWithObject:(id)object withSuccessBlock:(SuccessCompletionBlock)successBlock withFailure:(FailureCompletionBlock)failureBlock {
    API *api = [[[self class] alloc] initWithObject:object withSuccessBlock:successBlock withFailure:failureBlock];
    
    return api;
}

- (instancetype)initWithObject:(id)object withSuccessBlock:(SuccessCompletionBlock)successBlock withFailure:(FailureCompletionBlock)failureBlock {
    
    self = [self init];
    if (self) {
        self.object = object;
        self.successBlock = successBlock;
        self.failureBlock = failureBlock;
        [self startRequest];
    }
    
    return self;
}

- (void)startRequest {
    NSMutableURLRequest *request = [self request];
    AFHTTPSessionManager *client = [API httpClient];
    
    self.sessionTask = [client dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [self didReturnError:error];
        }
        else {
            [self didCompletedWithResult:responseObject];
        }
        self.sessionTask = nil;
    }];
    [self.sessionTask resume];
}

- (NSMutableURLRequest *)request {
    NSString *path = [self path];
    NSString *method = [self method];
    NSDictionary *parameters = [self parameters];
    
    AFHTTPSessionManager *httpClient = [API httpClient];
    AFHTTPRequestSerializer *serializer = [httpClient requestSerializer];
    
    NSURL *url = [NSURL URLWithString:path relativeToURL:httpClient.baseURL];
    
    NSMutableURLRequest *request = [serializer requestWithMethod:method URLString:[url absoluteString] parameters:parameters error:nil];
    
    return request;
}

- (NSString *)path {
    return nil;
}

- (NSString *)method {
    return nil;
}

- (NSMutableDictionary *)parameters {
    return [NSMutableDictionary new];
}

- (void)didCompletedWithResult:(id)result {
    if (self.successBlock) {
        self.successBlock(result);
    }
}

- (void)didReturnError:(NSError *)error {
    if (self.failureBlock) {
        self.failureBlock(error);
    }
}

- (void)cancel {
    [self.sessionTask cancel];
}

- (BOOL)requestInProgres {
    return  self.sessionTask != nil;
}

@end
