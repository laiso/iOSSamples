#import <Foundation/Foundation.h>

@interface QiitaAPI : NSObject

+ (void)loadItemsWithTag:(NSString *)tag
       completionHandler:(void (^)(NSArray* items, NSError* error))handler;

+ (void)loadItemsWithTag:(NSString *)tag
       completionHandler:(void (^)(NSArray* items, NSError* error))handler
                 baseURL:(NSString *)aBaseURL;

@end
