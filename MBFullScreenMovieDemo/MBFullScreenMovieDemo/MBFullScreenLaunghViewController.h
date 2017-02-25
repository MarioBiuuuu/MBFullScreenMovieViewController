//
//  MBFullScreenMovieViewController.h
//  MBFullScreenMovieDemo
//
//  Created by ZhangXiaofei on 17/2/24.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBMoviePlayerViewController.h"
#import "MBImagesLaunghViewController.h"

@class MBFullScreenLaunghViewController, MBImageObject;

typedef NS_ENUM(NSInteger, MBFullScreenLaunghStyle) {
    MBFullScreenLaunghStyleNormal = 0,
    MBFullScreenLaunghStyleMovie = 1 << 0,
    MBFullScreenLaunghStyleImage = 2 << 1,
    MBFullScreenLaunghStyleGif = 3 << 2
};

typedef void(^mb_moviePlayComplateBlock)(MBMoviePlayerViewController *playerViewController, NSTimeInterval totalInterval);
typedef void(^mb_moviePlayEnterBtnClickBlock)(UIButton *enterBtn);

@protocol MBFullScreenMovieViewControllerDelegate <NSObject>

@optional

/**
 播放结束回调

 @param viewController 当前对象
 @param playerViewController 视频播放
 @param totalInterval 视频时长
 */
- (void)mb_movieViewController:(MBFullScreenLaunghViewController *)viewController mbPlayerViewController:(MBMoviePlayerViewController *)playerViewController playComplate:(NSTimeInterval)totalInterval;

/**
 点击默认的进入按钮

 @param viewController 当前对象
 @param enterBtn 进入按钮
 */
- (void)mb_movieViewController:(MBFullScreenLaunghViewController *)viewController enterBtnClick:(UIButton *)enterBtn;

@end

@interface MBFullScreenLaunghViewController : UIViewController

/**
 *  图片模型数组
 */
@property (nonatomic, strong) NSArray<MBImageObject *> *imageArray;

/**
 *  图片展示时间
 */
@property (nonatomic, assign) NSUInteger countDownTime;

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
 *  Laungh 类型
 */
@property (nonatomic, assign) MBFullScreenLaunghStyle launghStyle;

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


/**
 构造方法

 @param style 类型
 @return 实例对象
 */
- (instancetype)initWithLaunghStyle:(MBFullScreenLaunghStyle)style;
+ (instancetype)mb_fullScreenLaugh:(MBFullScreenLaunghStyle)style;

@end
