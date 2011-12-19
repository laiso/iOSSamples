//
//  DCIntrospectDemo
//
//  Created by Domestic Cat on 29/04/11.
//

#import "AppDelegate.h"

#import "DCIntrospectDemoViewController.h"

#import <DCIntrospect/DCIntrospect.h>

@implementation AppDelegate

@synthesize window;
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// create a custom tap gesture recognizer so introspection can be invoked from a device
	// this one is a three finger double tap
	UITapGestureRecognizer *defaultGestureRecognizer = [[UITapGestureRecognizer alloc] init];
	defaultGestureRecognizer.cancelsTouchesInView = NO;
	defaultGestureRecognizer.delaysTouchesBegan = NO;
	defaultGestureRecognizer.delaysTouchesEnded = NO;
	defaultGestureRecognizer.numberOfTapsRequired = 3;
	defaultGestureRecognizer.numberOfTouchesRequired = 2;
	[DCIntrospect sharedIntrospector].invokeGestureRecognizer = defaultGestureRecognizer;
  
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
  
	// always insert this AFTER makeKeyAndVisible so statusBarOrientation is reported correctly.
	[[DCIntrospect sharedIntrospector] start];
  
	return YES;
}

@end
