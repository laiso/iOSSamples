//
//  DetailViewController.m
//  UIWebViewAuthentication

#import "USECredentialStorageViewController.h"

/** 
 * Google Toolbox for Mac
 * http://code.google.com/p/google-toolbox-for-mac/ 
 */
#import "GTMStringEncoding.h"

@interface USECredentialStorageViewController() <UIWebViewDelegate, NSURLConnectionDelegate> {
  UIWebView* _webView;
}
- (void)configureView;
- (void)registerMyCredential;
@end

@implementation USECredentialStorageViewController

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
  [self configureView];
}

- (void)registerMyCredential
{  
  NSURLCredential* creds = [NSURLCredential credentialWithUser:USER password:PASSWORD persistence:NSURLCredentialPersistencePermanent];
  NSURLCredentialStorage* store = [NSURLCredentialStorage sharedCredentialStorage];
  
  NSURL* url = [NSURL URLWithString:DEFAULT_URL];
  NSURLProtectionSpace* space = [[NSURLProtectionSpace alloc] initWithHost:url.host
                                                                      port:[url.port integerValue]
                                                                  protocol:url.scheme 
                                                                     realm:@"Input ID and Password." 
                                                      authenticationMethod:NSURLAuthenticationMethodDefault];
  
  [store setDefaultCredential:creds forProtectionSpace:space];
}

- (void)configureView
{
  NSString* url = DEFAULT_URL;
  [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

@end
