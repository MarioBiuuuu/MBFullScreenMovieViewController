//
//  AppDelegate.m
//  MBFullScreenMovieDemo
//
//  Created by ZhangXiaofei on 17/2/24.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "AppDelegate.h"
#import "MBFullScreenLaunghViewController.h"
#import "MBImageObject.h"
#import "ViewController.h"

@interface AppDelegate () <MBFullScreenMovieViewControllerDelegate>
@property (nonatomic, strong) MBFullScreenLaunghViewController *mb;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.mb = [[MBFullScreenLaunghViewController alloc] initWithLaunghStyle:MBFullScreenLaunghStyleImage];
    
    MBImageObject *obj = [[MBImageObject alloc] init];
    obj.localImage = [UIImage imageNamed:@"1111.jpeg"];
    
    self.mb.imageArray = @[obj];
    
    self.mb.countDownTime = 10;
    
//    self.mb = [[MBFullScreenLaunghViewController alloc] initWithLaunghStyle:MBFullScreenLaunghStyleMovie];
//    self.mb.delegate = self;
//    
//    [self.mb mb_moviePlayComplate:^(MBMoviePlayerViewController *playerViewController, NSTimeInterval totalInterval) {
//        NSLog(@"block ---> complaet : %@", @(totalInterval));
//    }];
//    
//    [self.mb mb_moviePlayEnterBtnClick:^(UIButton *enterBtn) {
//        NSLog(@"block ---> enter : %@", enterBtn);
//    }];
//    self.mb.loopCount = 2;
//
//    self.mb.videoUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video.mp4"ofType:nil]];
    
    self.window.rootViewController = self.mb;

//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    mb.frontViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
    return YES;
}

- (void)mb_movieViewController:(MBFullScreenLaunghViewController *)viewController playComplate:(NSTimeInterval)totalInterval {
    NSLog(@"delegate ---> complaet : %@", @(totalInterval));
}

- (void)mb_movieViewController:(MBFullScreenLaunghViewController *)viewController enterBtnClick:(UIButton *)enterBtn {
    NSLog(@"delegate ---> enter : %@", enterBtn);
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    self.window.rootViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
