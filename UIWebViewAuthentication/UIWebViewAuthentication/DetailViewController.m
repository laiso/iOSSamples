//
//  DetailViewController.m
//  UIWebViewAuthentication

#import "DetailViewController.h"

/** 
 * Google Toolbox for Mac
 * http://code.google.com/p/google-toolbox-for-mac/ 
 */
#import "GTMStringEncoding.h"

@interface DetailViewController() <UIWebViewDelegate> {
  IBOutlet UIWebView* _webView;
}
- (void)configureView;
@end

@implementation DetailViewController

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

- (void)configureView
{
  NSString* url = DEFAULT_URL;
  [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self configureView];
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  if([request valueForHTTPHeaderField:@"Authorization"]){
    return YES;
  }
  
  
  NSMutableURLRequest* req = (NSMutableURLRequest*)request;  
  NSString* authToken = [NSString stringWithFormat:@"%@:%@", USER, PASSWORD];
  
  GTMStringEncoding *coder = [GTMStringEncoding rfc4648Base64WebsafeStringEncoding];
  [req addValue:[NSString stringWithFormat:@"Basic %@", [coder encodeString:authToken]]
    forHTTPHeaderField:@"Authorization"];
  
  [webView loadRequest:req];
  
  return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  NSLog(@"webViewDidFinishLoad: \n%@", webView.request);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  NSLog(@"didFailLoadWithError: \n%@ \n%@", webView.request, [error localizedDescription]);
}

@end
