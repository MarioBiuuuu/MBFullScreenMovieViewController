//
//  MBMoviePlayerViewController.h
//  MBFullScreenMovieDemo
//
//  Created by ZhangXiaofei on 17/2/24.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <AVKit/AVKit.h>

@class MBMoviePlayerViewController, MBImageObject;
@protocol MBMoviePlayerViewControllerDelegate <NSObject>
- (void)mb_movieViewController:(MBMoviePlayerViewController *)playerViewController playComplate:(NSTimeInterval)totalInterval;
- (void)mb_movieViewControllerLoopEnd:(MBMoviePlayerViewController *)playerViewController;

@end

@interface MBMoviePlayerViewController : AVPlayerViewController

/**
 *  视频路径(本地/网络)
 */
@property (nonatomic, strong) NSURL *videoUrl;

/**
 *  0. 无限循环 1.播放一次 2.播放两次 .....
 */
@property (nonatomic, assign) NSUInteger loopCount;

@property (nonatomic, weak) id<MBMoviePlayerViewControllerDelegate> playerDelegate;

@end
