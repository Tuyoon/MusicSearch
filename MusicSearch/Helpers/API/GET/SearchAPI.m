//
//  SearchAPI.m
//  MusicSearch
//
//  Created by Mac on 04.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import "SearchAPI.h"

NSString *const kAPITermKey = @"term";
static NSString *const kAPISearchPath = @"search";

@implementation SearchAPI

- (NSString *)path {
    return kAPISearchPath;
}

- (NSMutableDictionary *)parameters {
    NSMutableDictionary *parameters = [super parameters];
    parameters[kAPITermKey] = self.object[kAPITermKey];
    
    return parameters;
}

@end
