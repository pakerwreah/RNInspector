#import "AppDelegate.h"
#import "IOSInspector.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

@interface AppDelegate() <IOSInspectorProtocol>
@end

@implementation AppDelegate {
  NSURL *documentDirectory;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  documentDirectory = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
  
  NSLog(@"%@", documentDirectory.absoluteString);
  
  [IOSInspector initializeWithDelegate:self];
  
  [IOSInspector setCipherKey:@"database_cipher3.db" password:@"123456" version:3];
  [IOSInspector setCipherKey:@"database_cipher4.db" password:@"1234567" version:4];
  
  [self mockDatabases];

  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"RNInspector"
                                            initialProperties:nil];

  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

- (void)mockDatabases {
  NSString *(^path)(NSString *) = ^(NSString *database) {
    return [self->documentDirectory URLByAppendingPathComponent:database].absoluteString;
  };
  [IOSInspector createDatabase:path(@"database.db")];
  [IOSInspector createDatabase:path(@"database_cipher3.db") password:@"123456" version:3];
  [IOSInspector createDatabase:path(@"database_cipher4.db") password:@"1234567" version:4];
}

- (nonnull NSArray<NSString *> *)databaseList {
  NSMutableArray *paths = [NSMutableArray arrayWithCapacity:3];
  for (NSString *name in @[@"database.db", @"database_cipher3.db", @"database_cipher4.db"]) {
    [paths addObject:[documentDirectory URLByAppendingPathComponent:name].absoluteString];
  }
  return paths;
}

@end
