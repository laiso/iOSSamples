#import <Nocilla/Nocilla.h>

#import "SenAsyncTestCase.h"

#import "QiitaAPI.h"
#import "TestHelper.h"

@interface TestWithNocilla : SenAsyncTestCase
@end


@implementation TestWithNocilla

-(void)setUp
{
  [super setUp];
  
  [[LSNocilla sharedInstance] start];
}

-(void)tearDown
{
  [[LSNocilla sharedInstance] stop];
  
  [super tearDown];
}

- (void)testRequest
{
  NSString* body = [TestHelper readResponse:@"fixtures/item.json"];

  stubRequest(@"GET", @"https://qiita.com/api/v1/tags/iOS/items").
  andReturn(200).
  withHeaders(@{@"Content-Type": @"application/json"}).
  withBody(body);
  
  
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
