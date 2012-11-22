#import <Foundation/Foundation.h>

@interface TestHelper : NSObject

+ (NSString *)readResponse:(NSString *)path;
+ (NSData *)readResponseData:(NSString *)path;

@end
