//
//  MyURLProtocol.m
//  UIWebViewAuthentication
//
//  Created by  on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyURLProtocol.h"

#import "GTMStringEncoding.h"

#define DEFAULT_URL @"http://www.chama.ne.jp/htaccess_sample/index.htm"
#define USER @"chama"
#define PASSWORD @"1111"

@implementation MyURLProtocol

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
  NSMutableURLRequest* req = [request mutableCopy];

  NSString* authToken = [NSString stringWithFormat:@"%@:%@", USER, PASSWORD];
  
  GTMStringEncoding *coder = [GTMStringEncoding rfc4648Base64WebsafeStringEncoding];
  [req addValue:[NSString stringWithFormat:@"Basic %@", [coder encodeString:authToken]]
    forHTTPHeaderField:@"Authorization"];
  return req;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
  return YES;
}

- (void)startLoading
{
}

- (void)stopLoading
{
}

@end
