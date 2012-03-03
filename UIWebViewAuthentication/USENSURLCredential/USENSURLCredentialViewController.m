//
//  DetailViewController.m
//  UIWebViewAuthentication

#import "USENSURLCredentialViewController.h"

/** 
 * Google Toolbox for Mac
 * http://code.google.com/p/google-toolbox-for-mac/ 
 */
#import "GTMStringEncoding.h"

@interface USENSURLCredentialViewController() <UIWebViewDelegate, NSURLConnectionDelegate> {
  UIWebView* _webView;
}
- (void)configureView;
- (void)registerMyCredential;
@end

@implementation USENSURLCredentialViewController

/**
 * chama ベーシック認証 サンプル
 * http://www.chama.ne.jp/access/
 */

#define DEFAULT_URL @"http://www.chama.ne.jp/htaccess_sample/index.htm"
#define USER @"chama"
#define PASSWORD @"1111"

@synthesize webView = _webView;

#pragma mark - Managing the detail item

- (id)init
{
  self = [super init];
  if(!self){
    return self;
  }
   
  self.webView = [[UIWebView alloc] init];
  self.webView.delegate = self;
  
  return self;
}

- (void)loadView
{
  self.view = [[UIView alloc] init];
  self.view.frame = self.parentViewController.view.frame;
  
  self.webView.frame = self.view.frame;
  [self.view addSubview:self.webView];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self registerMyCredential];
  //[self configureView];
}

- (void)registerMyCredential
{
  NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:DEFAULT_URL]] delegate:self];
  [conn start];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
  NSURLCredential* creds = [NSURLCredential credentialWithUser:USER password:PASSWORD persistence:NSURLCredentialPersistencePermanent];
  [[challenge sender] useCredential:creds forAuthenticationChallenge:challenge];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  NSURLCredentialStorage* store = [NSURLCredentialStorage sharedCredentialStorage];
  NSURL* url = [NSURL URLWithString:DEFAULT_URL];

  NSURLProtectionSpace* storedSpace = [[[store allCredentials] allKeys] objectAtIndex:0];
  NSURLProtectionSpace* space = [[NSURLProtectionSpace alloc] initWithHost:url.host
                                                                      port:80
                                                                  protocol:url.scheme 
                                                                     realm:@"Input ID and Password." 
                                                      authenticationMethod:NSURLAuthenticationMethodDefault];

  NSDictionary* extCreds = [store credentialsForProtectionSpace:storedSpace];
  NSAssert(extCreds, @"");
  NSDictionary* actCreds = [store credentialsForProtectionSpace:space];
  NSAssert(actCreds, @"");
  
  [self configureView];
}

- (void)configureView
{
  NSString* url = DEFAULT_URL;
  [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

@end
