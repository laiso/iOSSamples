#import <NLTHTTPStubServer/NLTHTTPStubServer.h>

#import "SenAsyncTestCase.h"

#import "QiitaAPI.h"
#import "TestHelper.h"

@interface WithNLTHTTPStubServerTests : SenAsyncTestCase
@property (nonatomic, weak) NLTHTTPStubServer* server;
@end


@implementation WithNLTHTTPStubServerTests

- (void)setUp
{
  [super setUp];
  self.server = [NLTHTTPStubServer stubServer];
  [self.server startServer];
}


-(void)tearDown
{
  [self.server clear];
  [self.server stopServer];
  [super tearDown];
}

- (void)testRequest
{
  NSData* body = [TestHelper readResponseData:@"fixtures/item.json"];
  
  [[[self.server stub] forPath:@"/api/v1/tags/iOS/items"] andJSONResponse:body];
  
  [QiitaAPI loadItemsWithTag:@"iOS" completionHandler:^(NSArray *items, NSError *error) {
    STAssertNil(error, nil);
    STAssertEquals(items.count, 1U, nil);
    
    NSDictionary* item = [items lastObject];
    
    STAssertEqualObjects([item objectForKey:@"id"], [NSNumber numberWithInt:10884], nil);
    STAssertEqualObjects([item objectForKey:@"title"], @"keyboardWasShownに関して", nil);
    STAssertEqualObjects([item objectForKey:@"url"], @"http://qiita.com/items/ac6577db608748bb3a78", nil);
    
    [self notify:SenAsyncTestCaseStatusSucceeded];
  } baseURL:@"http://localhost:12345"];
  [self waitForTimeout:3];
}

@end