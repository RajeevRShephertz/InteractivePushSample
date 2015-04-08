//
//  ViewController.m
//  App42InteractivePush
//
//  Created by Rajeev Ranjan on 01/04/15.
//  Copyright (c) 2015 Rajeev Ranjan. All rights reserved.
//

#import "ViewController.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "App42Constants.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)sendPush:(id)sender
{
    PushNotificationService *pushnotificationService = [App42API buildPushService];
    
    NSMutableDictionary *pushMessageDict = [NSMutableDictionary dictionary];
    [pushMessageDict setObject:@"It is an interactive push. Pull down to interact." forKey:@"alert"];
    [pushMessageDict setObject:@"default" forKey:@"sound"];
    [pushMessageDict setObject:@"increment" forKey:@"badge"];
    [pushMessageDict setObject:INTERACTIVE_CATEGORY forKey:@"category"];
    
    
    [pushnotificationService sendPushMessageToUser:USER_NAME withMessageDictionary:pushMessageDict completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            NSLog(@"%s...%@",__func__,responseObj);
        }
        else
        {
            NSLog(@"%s...%@",__func__,exception.reason);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
