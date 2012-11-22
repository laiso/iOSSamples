#import "NSURLConnectionVCR.h"

#import "SenAsyncTestCase.h"

#import "QiitaAPI.h"
#import "TestHelper.h"

@interface WithNSURLConnectionVCRTests : SenAsyncTestCase
@end


@implementation WithNSURLConnectionVCRTests

// 他のテストに影響が出る: 混ぜるな危険

/*
- (void)setUp
{
  [super setUp];
  NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"vcr_cassettes"];
  [NSURLConnectionVCR startVCRWithPath:path error:nil];
}


-(void)tearDown
{
  [NSURLConnectionVCR stopVCRWithError:nil];
  [super tearDown];
}

- (void)testRequest
{
  [QiitaAPI loadItemsWithTag:@"iOS" completionHandler:^(NSArray *items, NSError *error) {
    STAssertNil(error, nil);
    STAssertEquals(items.count, 20U, @"一度キャッシュされたアイテムを読み込んでる");
    [self notify:SenAsyncTestCaseStatusSucceeded];
  }];
  [self waitForTimeout:3];
}
*/

@end