#import <OHHTTPStubs/OHHTTPStubs.h>

#import "SenAsyncTestCase.h"

#import "QiitaAPI.h"
#import "TestHelper.h"

@interface WithOHHTTPStubsTests : SenAsyncTestCase
@end


@implementation WithOHHTTPStubsTests

-(void)tearDown
{
  [OHHTTPStubs removeAllRequestHandlers];
  [super tearDown];
}

- (void)testRequest
{
  [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse*(NSURLRequest *request, BOOL onlyCheck){
    return [OHHTTPStubsResponse responseWithFile:@"fixtures/item.json" contentType:@"application/json" responseTime:2.0];
  }];
  
  [QiitaAPI loadItemsWithTag:@"iOS" completionHandler:^(NSArray *items, NSError *error) {
    STAssertNil(error, nil);
    STAssertEquals(items.count, 1U, nil);
    
    NSDictionary* item = [items lastObject];
    
    STAssertEqualObjects([item objectForKey:@"id"], [NSNumber numberWithInt:10884], nil);
    STAssertEqualObjects([item objectForKey:@"title"], @"keyboardWasShownに関して", nil);
    STAssertEqualObjects([item objectForKey:@"url"], @"http://qiita.com/items/ac6577db608748bb3a78", nil);
    
    [self notify:SenAsyncTestCaseStatusSucceeded];
  }];
  [self waitForTimeout:3];
}

@end