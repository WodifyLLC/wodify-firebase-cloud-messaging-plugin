#import "AppDelegate+OSFirebaseCloudMessaging.h"
#import <objc/runtime.h>
#import <OSFirebaseMessagingLib/OSFirebaseMessagingLib-Swift.h>

@implementation AppDelegate (OSFirebaseCloudMessaging)

+ (void)load {
    Class capacitorClass = NSClassFromString(@"Capacitor.CAPBridge");
    if (capacitorClass) {
        // Capacitor App - This plugin will be included as a Pod, and so the below app delegate methods won't be called
        //  Instead, the calls below are injected into the application's AppDelegate for Capacitor iOS apps
        return;
    }
    Method original = class_getInstanceMethod(self, @selector(application:didFinishLaunchingWithOptions:));
    Method swizzled = class_getInstanceMethod(self, @selector(application:firebaseCloudMessagingPluginDidFinishLaunchingWithOptions:));
    method_exchangeImplementations(original, swizzled);
}

- (BOOL)application:(UIApplication *)application firebaseCloudMessagingPluginDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self application:application firebaseCloudMessagingPluginDidFinishLaunchingWithOptions:launchOptions];    

    (void)[FirebaseMessagingApplicationDelegate.shared application:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSDictionary *updatedUserInfo = [self fixSoundPath:userInfo];

    // Automatically set badge from ExtraDataItem in Firebase notification payload
    // Expected Firebase payload format:
    // ExtraDataItem with key: "os_badge_number" (case-sensitive)
    // Value: Text string representing a base-10 non-negative integer (0 to 2147483647)
    // The badge value is an absolute count to set, not an increment.
    // If key is present but value is invalid, badge is not changed.
    // If key is absent, do nothing.
    id badgeValue = updatedUserInfo[@"os_badge_number"];
    if ([badgeValue isKindOfClass:[NSString class]]) {
        NSString *badgeString = [(NSString *)badgeValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        // Validate: non-empty, represents valid non-negative integer
        if (badgeString.length > 0) {
            NSScanner *scanner = [NSScanner scannerWithString:badgeString];
            NSInteger badge = 0;
            if ([scanner scanInteger:&badge] && [scanner isAtEnd] && badge >= 0 && badge <= INT_MAX) {
                [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
            }
            // If validation fails, silently ignore (don't change badge)
        }
    }
    // If key absent or not a string, do nothing

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    (void)[FirebaseMessagingApplicationDelegate.shared application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (NSDictionary *)fixSoundPath:(NSDictionary *)userInfo {
    NSMutableDictionary *mutableUserInfo = [userInfo mutableCopy];
    
    id notificationValue = userInfo[@"notification"];
    if (![notificationValue isKindOfClass:[NSString class]]) {
        return userInfo;
    }
    
    NSData *notificationData = [(NSString *)notificationValue dataUsingEncoding:NSUTF8StringEncoding];
    if (!notificationData) {
        return userInfo;
    }
    
    NSError *jsonError = nil;
    NSMutableDictionary *notificationDict = [NSJSONSerialization JSONObjectWithData:notificationData options:NSJSONReadingMutableContainers error:&jsonError];
    if (![notificationDict isKindOfClass:[NSDictionary class]] || jsonError) {
        return userInfo;
    }
    
    NSString *sound = notificationDict[@"sound"];
    if ([sound isKindOfClass:[NSString class]] && ![sound hasPrefix:@"www/"]) {
        notificationDict[@"sound"] = [@"www/" stringByAppendingString:sound];
        
        NSData *updatedData = [NSJSONSerialization dataWithJSONObject:notificationDict options:0 error:&jsonError];
        if (updatedData && !jsonError) {
            NSString *updatedString = [[NSString alloc] initWithData:updatedData encoding:NSUTF8StringEncoding];
            if (updatedString) {
                mutableUserInfo[@"notification"] = updatedString;
                return [mutableUserInfo copy];
            }
        }
    }
    
    return userInfo;
}

@end
