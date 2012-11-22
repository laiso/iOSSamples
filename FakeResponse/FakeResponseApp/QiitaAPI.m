#import "QiitaAPI.h"

@implementation QiitaAPI

+ (void)loadItemsWithTag:(NSString *)tag
       completionHandler:(void (^)(NSArray* items, NSError* error))handler
{
  [QiitaAPI loadItemsWithTag:tag completionHandler:handler baseURL:@"https://qiita.com"];
}

+ (void)loadItemsWithTag:(NSString *)tag
       completionHandler:(void (^)(NSArray* items, NSError* error))handler
                    baseURL:(NSString *)aBaseURL
{
  NSString* url = [NSString stringWithFormat:@"%@/api/v1/tags/%@/items", aBaseURL, tag];
  NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  
  [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *err) {
    if(err){
      handler(nil, err);
      return;
    }
    
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
    if(err){
      NSLog(@"[ERROR]: %@,\n"
            "%@",
            [err description],
            [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }
    handler(object, err);
  }];
}

@end
