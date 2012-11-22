#import <objc/runtime.h>

#import "SenAsyncTestCase.h"
#import "TestHelper.h"

#import "QiitaAPI.h"

@interface WithMethodSwizzTests : SenAsyncTestCase
@end



@implementation WithMethodSwizzTests


- (void)testRequest
{
  Method original = class_getClassMethod([QiitaAPI class], @selector(loadItemsWithTag:completionHandler:));
  Method sub = class_getInstanceMethod([self class], @selector(loadItemsWithTag:completionHandler:));
  method_exchangeImplementations(original, sub);
  
  [QiitaAPI loadItemsWithTag:@"iOS" completionHandler:^(NSArray *items, NSError *error) {
    STAssertNil(error, nil);
    STAssertEquals(items.count, 1U, nil);
    
    NSDictionary* item = [items lastObject];
    
    STAssertEqualObjects([item objectForKey:@"id"], [NSNumber numberWithInt:10884], nil);
    STAssertEqualObjects([item objectForKey:@"title"], @"keyboardWasShownに関して", nil);
    STAssertEqualObjects([item objectForKey:@"url"], @"http://qiita.com/items/ac6577db608748bb3a78", nil);
    
    method_exchangeImplementations(sub, original);
    [self notify:SenAsyncTestCaseStatusSucceeded];
  }];
  [self waitForTimeout:3];
}

- (void)loadItemsWithTag:(NSString *)tag
       completionHandler:(void (^)(NSArray* items, NSError* error))handler
{
  NSData* body = [TestHelper readResponseData:@"fixtures/item.json"];
  id object = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingAllowFragments error:nil];
  handler(object, nil);
}

- (void)testSwizzRequest
{
  Method original = class_getClassMethod([NSURLConnection class], @selector(sendAsynchronousRequest:queue:completionHandler:));
  Method sub = class_getInstanceMethod([self class], @selector(sendAsynchronousRequest:queue:completionHandler:));
  method_exchangeImplementations(original, sub);
  
  [QiitaAPI loadItemsWithTag:@"iOS" completionHandler:^(NSArray *items, NSError *error) {
    STAssertNil(error, nil);
    STAssertEquals(items.count, 1U, nil);
    
    NSDictionary* item = [items lastObject];
    
    STAssertEqualObjects([item objectForKey:@"id"], [NSNumber numberWithInt:10884], nil);
    STAssertEqualObjects([item objectForKey:@"title"], @"keyboardWasShownに関して", nil);
    STAssertEqualObjects([item objectForKey:@"url"], @"http://qiita.com/items/ac6577db608748bb3a78", nil);
    
    method_exchangeImplementations(sub, original);
    [self notify:SenAsyncTestCaseStatusSucceeded];
  }];
  [self waitForTimeout:3];
}

- (void)sendAsynchronousRequest:(NSURLRequest *)request
                          queue:(NSOperationQueue*) queue
              completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler
{
  NSData* body = [TestHelper readResponseData:@"fixtures/item.json"];
  handler(nil, body, nil);
}

@end