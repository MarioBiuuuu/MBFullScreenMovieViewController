//
//  MBFullScreenMovieViewController.h
//  MBFullScreenMovieDemo
//
//  Created by ZhangXiaofei on 17/2/24.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBFullScreenMovieViewController;

typedef void(^mb_moviePlayComplateBlock)(NSTimeInterval totalInterval);
typedef void(^mb_moviePlayEnterBtnClickBlock)(UIButton *enterBtn);

@protocol MBFullScreenMovieViewControllerDelegate <NSObject>

@optional

/**
 播放结束回调

 @param viewController 当前对象
 @param totalInterval 视频时长
 */
- (void)mb_movieViewController:(MBFullScreenMovieViewController *)viewController playComplate:(NSTimeInterval)totalInterval;

/**
 点击默认的进入按钮

 @param viewController 当前对象
 @param enterBtn 进入按钮
 */
- (void)mb_movieViewController:(MBFullScreenMovieViewController *)viewController enterBtnClick:(UIButton *)enterBtn;

@end

@interface MBFullScreenMovieViewController : UIViewController

/**
 *  视频路径(本地/网络)
 */
@property (nonatomic, strong) NSURL *videoUrl;

/**
 *  0. 无限循环 1.播放一次 2.播放两次 .....
 */
@property (nonatomic, assign) NSUInteger loopCount;

/**
 *  用户自定义视图(浮动)
 */
@property (nonatomic, strong) UIViewController *frontViewController;

/**
 *  默认进人按钮的文本
 */
@property (nonatomic, strong) UIFont *enterBtnTitleFont;

/**
 *  默认进入按钮的高亮色
 */
@property (nonatomic, strong) UIColor *enterBtnTintColor;

/**
 *  是否开启过渡动画
 */
@property (nonatomic, assign) BOOL transmitAnimation;

/**
 *  代理对象
 */
@property (nonatomic, weak) id<MBFullScreenMovieViewControllerDelegate> delegate;

/**
 播放结束回调

 @param block block
 */
- (void)mb_moviePlayComplate:(mb_moviePlayComplateBlock)block;

/**
 进入按钮点击

 @param block block
 */
- (void)mb_moviePlayEnterBtnClick:(mb_moviePlayEnterBtnClickBlock)block;
@end
