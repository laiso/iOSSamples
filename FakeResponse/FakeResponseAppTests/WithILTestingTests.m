#import "ILCannedURLProtocol.h"

#import "SenAsyncTestCase.h"

#import "QiitaAPI.h"
#import "TestHelper.h"

@interface WithILTestingTests : SenAsyncTestCase
@end


@implementation WithILTestingTests

- (void)setUp
{
  [super setUp];
  [NSURLProtocol registerClass:[ILCannedURLProtocol class]];
}


-(void)tearDown
{
  [NSURLProtocol unregisterClass:[ILCannedURLProtocol class]];
  [super tearDown];
}

- (void)testRequest
{
  NSData* body = [TestHelper readResponseData:@"fixtures/item.json"];

  [ILCannedURLProtocol setCannedStatusCode:200];
  [ILCannedURLProtocol setCannedHeaders:@{@"Content-Type": @"application/json"}];
  [ILCannedURLProtocol setCannedResponseData:body];
  
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