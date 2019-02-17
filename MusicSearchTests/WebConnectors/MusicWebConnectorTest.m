//
//  MusicWebConnectorTest.m
//  MusicSearchTests
//
//  Created by AT on 15/02/2019.
//  Copyright © 2019 t. All rights reserved.
//

#import "MusicWebConnectorTest.h"

@implementation MusicWebConnectorTest

- (void)searchWithQuery:(NSString *)query success:(WebConnectorSuccessBlock)success failure:(WebConnectorFailBlock)failure {
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"music" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        failure(error);
    } else {
        success(dictionary);
    }
}

@end
