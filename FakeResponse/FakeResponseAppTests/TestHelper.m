#import "TestHelper.h"

@implementation TestHelper

+ (NSString *)readResponse:(NSString *)path
{
  NSString* file = [[NSBundle bundleForClass:[self class]] pathForResource:path ofType:nil];
  
  NSError* err;
  NSString* item = [NSString stringWithContentsOfFile:file
                                             encoding:NSUTF8StringEncoding error:&err];
  if(err){
    NSLog(@"[ERROR] %@", [err description]);
  }
  return item;
}

+ (NSData *)readResponseData:(NSString *)path
{
  NSString* file = [[NSBundle bundleForClass:[self class]] pathForResource:path ofType:nil];
  return [NSData dataWithContentsOfFile:file];
}


@end
