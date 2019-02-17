//
//  MusicSearchTests.m
//  MusicSearchTests
//
//  Created by Mac on 04.05.16.
//  Copyright © 2016 t. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MusicWebConnectorTest.h"

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

@end
