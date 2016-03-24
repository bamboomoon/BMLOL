//
//  BMLOLTests.m
//  BMLOLTests
//
//  Created by donglei on 2/23/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BMCustomTabBarController.h"
#import "BMTabBarBtn.h"
@interface BMLOLTests : XCTestCase

@property(nonatomic,strong) BMCustomTabBarController *customTestVc;

@end

@implementation BMLOLTests

- (void)setUp {
    [super setUp];
    _customTestVc = [[BMCustomTabBarController alloc] init];
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

@end
