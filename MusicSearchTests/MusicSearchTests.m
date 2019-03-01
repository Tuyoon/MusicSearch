//
//  MusicSearchTests.m
//  MusicSearchTests
//
//  Created by Mac on 04.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MusicWebConnectorTest.h"
#import "MusicStorage.h"
#import "MusicItem.h"
#import "HistoryStorage.h"
#import "HistoryItem.h"

@interface MusicSearchTests : XCTestCase

@end

@implementation MusicSearchTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testSearch {
    XCTestExpectation *expectation = [self expectationWithDescription:@"MusicWebConnectorTest search test"];
    MusicWebConnectorTest *webConnector = [MusicWebConnectorTest new];
    [webConnector searchWithQuery:@"#" success:^(id object) {
        [expectation fulfill];
    } failure:^(NSError *error) {
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError * _Nullable error) {
        NSLog(@"Expectation fulfilled");
    }];
}

- (void)testHistoryStorage {
    HistoryStorage *storage = [[HistoryStorage alloc] init];
    HistoryItem *item = [[HistoryItem alloc] initWithQuery:@"#"];
    [storage saveItems:@[item]];
    
    NSArray *allItems = [storage allItems];
    XCTAssert(allItems.count > 0);
    BOOL saved = NO;
    for (HistoryItem *historyItem in allItems) {
        if ([historyItem.query isEqualToString:@"#"]) {
            saved = YES;
            break;
        }
    }
    XCTAssert(saved);
}

- (void)testMusicStorage {
    XCTestExpectation *expectation = [self expectationWithDescription:@"MusicStorage test"];
    MusicStorage *storage = [[MusicStorage alloc] init];
    void (^save)(NSArray *) = ^(NSArray *result){
        NSError *error;
        NSArray<MusicItem *> *items = [MusicItem arrayOfModelsFromDictionaries:result error:&error];
        if (!error) {
            [storage saveItems:items];
            NSArray *allSavedItems = [storage allItems];
            XCTAssert(allSavedItems.count >= items.count);
            [expectation fulfill];
        }
    };
    
    MusicWebConnectorTest *webConnector = [MusicWebConnectorTest new];
    [webConnector searchWithQuery:@"#" success:^(id object) {
        save(object[@"results"]);
    } failure:^(NSError *error) {
        XCTAssert(NO);
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError * _Nullable error) {
        NSLog(@"Expectation fulfilled");
    }];
}

@end
