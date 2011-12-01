//
//  CHCSVParserSampleTests.m
//  CHCSVParserSampleTests
//
//  Created by  on 12/1/11.

#import "CHCSVParserSampleTests.h"

#import "CHCSV.h"

@interface CHCSVParserSampleTests(){
  NSString* csvPath;
  NSString* documentsDir;
}
@end

@implementation CHCSVParserSampleTests

- (void)setUp
{
  [super setUp];
  csvPath = [[NSBundle mainBundle] pathForResource:@"tepco.csv" ofType:nil];
  documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)tearDown
{
  [super tearDown];
  
  /** テスト用に書き出したCSVファイルを削除 */
  NSFileManager* fm = [NSFileManager defaultManager];
  [[fm contentsOfDirectoryAtPath:documentsDir error:nil] enumerateObjectsUsingBlock:^(NSString* path, NSUInteger idx, BOOL *stop) {
    [fm removeItemAtPath:[documentsDir stringByAppendingPathComponent:path] error:nil];
  }];
}

- (void)testRead
{
  NSError* err;
  NSArray* values = [NSArray arrayWithContentsOfCSVFile:csvPath encoding:NSUTF8StringEncoding error:&err];
  
  STAssertTrue([values count] > 0, @"読み込めたかどうか確認");
  STAssertTrue([[values objectAtIndex:0] isKindOfClass:[NSArray class]], nil);
  NSLog(@"%@", values);
}

- (void)testWrite
{
  NSError* err;
  NSArray* values = [NSArray arrayWithContentsOfCSVFile:csvPath encoding:NSUTF8StringEncoding error:&err];
  NSMutableArray* newValues = [values mutableCopy];
  [newValues addObject:[NSArray arrayWithObjects:@"2011/12/1", @"10:00", @"4043", @"0", nil]];
  NSString* savePath = [documentsDir stringByAppendingPathComponent:@"testWrite.csv"];
  BOOL success = [newValues writeToCSVFile:savePath atomically:YES error:&err];
  STAssertTrue(success, @"追記して保存できるかどうか確認");  
}

- (void)testCheck
{
  NSError* err;
  NSArray* values = [NSArray arrayWithContentsOfCSVFile:csvPath encoding:NSUTF8StringEncoding error:&err];
  NSMutableArray* newValues = [values mutableCopy];
  [newValues addObject:[NSArray arrayWithObjects:@"2011/12/1", @"10:00", @"4043", @"0", nil]];
  NSString* savePath = [documentsDir stringByAppendingPathComponent:@"testCheck.csv"];
  BOOL success = [newValues writeToCSVFile:savePath atomically:YES error:&err];
  STAssertTrue(success, nil);
  
  NSArray* restoreValues = [NSArray arrayWithContentsOfCSVFile:savePath encoding:NSUTF8StringEncoding error:&err];
  STAssertTrue([restoreValues count] > [values count], @"保存したデータの件数がちゃんと増加しているか確認");
}

@end