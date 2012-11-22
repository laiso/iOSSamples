//
//  AppDelegate.m
//  UIWebViewAuthentication


#import "AppDelegate.h"

#import "MasterViewController.h"

@implementation AppDelegate

#define DEFAULT_URL @"http://www.chama.ne.jp/htaccess_sample/index.htm"
#define USER @"chama"
#define PASSWORD @"1111"

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  //[self removeCredentials];
  
  MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
  
  self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
  self.window.rootViewController = self.navigationController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)removeCredentials
{
  NSURLCredentialStorage* store = [NSURLCredentialStorage sharedCredentialStorage];
  [[store allCredentials] enumerateKeysAndObjectsUsingBlock:^(NSURLProtectionSpace* space, NSDictionary* credHash, BOOL *stop) {
    NSURLCredential* cred = [credHash objectForKey:USER];
    [store removeCredential:cred forProtectionSpace:space];
  }];
}

@end
