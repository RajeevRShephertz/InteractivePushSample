//
//  AppDelegate.m
//  App42InteractivePush
//
//  Created by Rajeev Ranjan on 01/04/15.
//  Copyright (c) 2015 Rajeev Ranjan. All rights reserved.
//

#import "AppDelegate.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "App42Constants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /**
     * Initialize App42API
     */
    [App42API initializeWithAPIKey:APP42_APP_KEY andSecretKey:APP42_SECRET_KEY];
    [App42API enableApp42Trace:YES];
    
    /**
     * Register for your device for user notification settings
     */
    [self registerForPush:application];
    
    return YES;
}


-(void)registerForPush:(UIApplication *)application
{

UIUserNotificationType notificationType = UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound;
UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationType categories:[NSSet setWithObject:[self createCategory]]];
[application registerUserNotificationSettings:notificationSettings];
}

-(UIMutableUserNotificationCategory*)createCategory
{
    //Creating Action 1
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = ACTION1_IDENTIFIER;
    action1.title = @"Action1";
    action1.activationMode = UIUserNotificationActivationModeBackground;
    action1.authenticationRequired = NO;
    action1.destructive = NO;
    
    //Creating Action 2
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
    action2.identifier = ACTION2_IDENTIFIER;
    action2.title = @"Action2";
    action2.activationMode = UIUserNotificationActivationModeBackground;
    action2.authenticationRequired = NO;
    action2.destructive = NO;
    
    //Creating Action 3
    UIMutableUserNotificationAction *action3 = [[UIMutableUserNotificationAction alloc] init];
    action3.identifier = ACTION3_IDENTIFIER;
    action3.title = @"Action3";
    action3.activationMode = UIUserNotificationActivationModeBackground;
    action3.authenticationRequired = NO;
    action3.destructive = NO;
    
    //Creating Action 4
    UIMutableUserNotificationAction *action4 = [[UIMutableUserNotificationAction alloc] init];
    action4.identifier = ACTION4_IDENTIFIER;
    action4.title = @"Action4";
    action4.activationMode = UIUserNotificationActivationModeBackground;
    action4.authenticationRequired = NO;
    action4.destructive = NO;
    
    //Creating Category
    UIMutableUserNotificationCategory *interactiveCategory = [[UIMutableUserNotificationCategory alloc] init];
    interactiveCategory.identifier = INTERACTIVE_CATEGORY;
    [interactiveCategory setActions:@[action1,action2,action3] forContext:UIUserNotificationActionContextDefault];
    [interactiveCategory setActions:@[action1,action2] forContext:UIUserNotificationActionContextMinimal];
    
    return interactiveCategory;
}


#pragma mark- Push Notification Delegates

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    /**
     * Register for your device for remote notifications
     */
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    // Prepare the Device Token for Registration (remove spaces and < >)
    self.devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"My token is: %@", self.devToken);
    [self registerYourDeviceToApp42Cloud];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%s ..error=%@",__FUNCTION__,error);
    [self showAlert:[error localizedDescription]];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%s ..userInfo=%@",__FUNCTION__,userInfo);
}


-(void)registerYourDeviceToApp42Cloud
{
    PushNotificationService *pushnotificationService = [App42API buildPushService];
    [pushnotificationService registerDeviceToken:self.devToken withUser:USER_NAME completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            [self showAlert:@"Your Device is registered successfully to App42Cloud!"];
        }
        else
        {
            [self showAlert:exception.reason];
        }
    }];
}

-(void)showAlert:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

#pragma mark- Push Action Handling

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    NSString *categoryIdentifier = [[userInfo objectForKey:@"aps"] objectForKey:@"category"];
    if ([categoryIdentifier isEqualToString:INTERACTIVE_CATEGORY])
    {
        if ([identifier isEqualToString:ACTION1_IDENTIFIER])
        {
            NSLog(@"ACTION1 triggered");
        }
        else if ([identifier isEqualToString:ACTION2_IDENTIFIER])
        {
            NSLog(@"ACTION2 triggered");
        }
        else if ([identifier isEqualToString:ACTION3_IDENTIFIER])
        {
            NSLog(@"ACTION3 triggered");
        }
    }
    completionHandler();
}


#pragma mark- App State Delegates

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
