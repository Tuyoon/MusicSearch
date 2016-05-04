//
//  API.h
//  MusicSearch
//
//  Created by Mac on 04.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;

typedef void(^SuccessCompletionBlock)(id result);
typedef void(^FailureCompletionBlock)(NSError *error);

@interface API : NSObject

+ (instancetype)apiWithObject:(id)object;
+ (instancetype)apiWithObject:(id)object withSuccessBlock:(SuccessCompletionBlock)successBlock withFailure:(FailureCompletionBlock)failureBlock;

@end

@interface API ()

@property (nonatomic, copy) SuccessCompletionBlock successBlock;
@property (nonatomic, copy) FailureCompletionBlock failureBlock;
@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

+ (AFHTTPSessionManager *)httpClient;
- (NSString *)path;
- (NSString *)method;
- (NSMutableDictionary*)parameters;
- (void)startRequest;
- (void)didCompletedWithResult:(id)result;
- (void)didReturnError:(NSError*)error;
- (void)cancel;
- (BOOL)requestInProgres;

@end
