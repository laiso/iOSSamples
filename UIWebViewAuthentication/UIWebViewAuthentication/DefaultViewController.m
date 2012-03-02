//
//  DetailViewController.m
//  UIWebViewAuthentication

#import "DefaultViewController.h"

/** 
 * Google Toolbox for Mac
 * http://code.google.com/p/google-toolbox-for-mac/ 
 */
#import "GTMStringEncoding.h"

@interface DefaultViewController() <UIWebViewDelegate> {
  IBOutlet UIWebView* _webView;
}
- (void)configureView;
@end

@implementation DefaultViewController

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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  NSLog(@"webViewDidFinishLoad: \n%@", webView.request);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  NSLog(@"didFailLoadWithError: \n%@ \n%@", webView.request, [error localizedDescription]);
}

@end
