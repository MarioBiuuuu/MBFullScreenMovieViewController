//
//  MBFullScreenMovieViewController.m
//  MBFullScreenMovieDemo
//
//  Created by ZhangXiaofei on 17/2/24.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "MBFullScreenMovieViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#define DEF_RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define DEF_HEXColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define DEF_HEXColorA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@interface MBFullScreenMovieViewController ()

@property (nonatomic, strong) AVPlayerViewController *playerViewController;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *item;

@property (nonatomic, assign) NSUInteger reaptCount;

@property (nonatomic, strong) UIButton *enterBtn;

@property (nonatomic,copy) mb_moviePlayComplateBlock moviePlayComplate;

@property (nonatomic,copy) mb_moviePlayEnterBtnClickBlock enterBtnClickBlock;

@end

@implementation MBFullScreenMovieViewController

- (void)dealloc {
    [_item removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_item removeObserver:self forKeyPath:@"status"];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transmitAnimation = YES;
    
    self.enterBtnTintColor = DEF_HEXColor(0x44EAAF);
    
    self.enterBtnTitleFont = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.playerViewController.view];
    
    [self.view addSubview:self.enterBtn];
    
    [self enterBtnAnimation];
}

- (void)enterBtnAnimation {
    self.enterBtn.alpha = 0;
    [UIView animateWithDuration:2.0 animations:^{
        self.enterBtn.alpha = 1;
    }];
}

- (UIButton *)enterBtn {
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterBtn.backgroundColor = [UIColor clearColor];
        _enterBtn.frame = CGRectMake(0.5 * (self.view.frame.size.width - self.view.frame.size.height / 4.0), self.view.frame.size.height - 90, self.view.frame.size.height / 4.0, 50.f);
        
        _enterBtn.titleLabel.font = self.enterBtnTitleFont;
        [_enterBtn setTitle:@"进入" forState:UIControlStateNormal];
        [_enterBtn setTitleColor:self.enterBtnTintColor forState:UIControlStateNormal];
        
        _enterBtn.layer.borderColor = self.enterBtnTintColor.CGColor;
        _enterBtn.layer.borderWidth = 2;
        _enterBtn.layer.masksToBounds = YES;
        _enterBtn.layer.cornerRadius = CGRectGetHeight(_enterBtn.frame) / 2.0;
        
        [_enterBtn addTarget:self action:@selector(enterRootViewController:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _enterBtn;
}

- (AVPlayerViewController *)playerViewController {
    if (!_playerViewController) {
        
        _playerViewController = [[AVPlayerViewController alloc] init];
        
        _playerViewController.player = self.player;
        
        _playerViewController.view.frame = self.view.frame;
        
        _playerViewController.showsPlaybackControls = NO;
        
        _playerViewController.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _playerViewController;
}

- (AVPlayer *)player {
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:self.item];
        __weak __typeof(self) weakSelf = self;
        [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            //当前播放的时间
            NSTimeInterval current = CMTimeGetSeconds(time);
            //视频的总时间
            NSTimeInterval total = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
            
            //输出当前播放的时间
//            NSLog(@"total : %f, now %f", total, current);
            if (current >= total) {
                
                [weakSelf sendPlayComplateState:total];
                
                [weakSelf reaptPlay];
            }
        }];
        
    }
    return _player;
}

- (AVPlayerItem *)item {
    if (!_item) {
        NSAssert(self.videoUrl, @"传入的视频连接为空");
        AVAsset *asset = [AVAsset assetWithURL:self.videoUrl];
        _item = [AVPlayerItem playerItemWithAsset:asset];
        [_item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        
        // 监听loadedTimeRanges属性
        [_item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];

    }
    return _item;
}

// AVPlayerItem监听的回调函数
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        double t=[self availableDurationWithplayerItem:_item];
        NSLog(@"loadranges %f",t);
        
    } else if ([keyPath isEqualToString:@"status"]) {
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"playerItem is ready");
            
            //如果视频准备好 就开始播放
            [_player play];
            
        } else if(playerItem.status==AVPlayerStatusUnknown) {
            NSLog(@"playerItem Unknown错误");
        } else if (playerItem.status==AVPlayerStatusFailed) {
            NSLog(@"playerItem 失败");
        }
    }
}

// 计算缓冲进度的函数
- (NSTimeInterval)availableDurationWithplayerItem:(AVPlayerItem *)playerItem {
    NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
    NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (void)sendPlayComplateState:(NSTimeInterval)total {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mb_movieViewController:playComplate:)]) {
        [self.delegate mb_movieViewController:self playComplate:total];
    } else {
        if (self.moviePlayComplate) {
            self.moviePlayComplate(total);
        }
    }
}

- (void)reaptPlay {
    if (self.loopCount == 0) {
        [self.playerViewController.player seekToTime:CMTimeMake(0, 1)];
        
        [self.playerViewController.player play];
    } else {
        if (self.reaptCount > 0) {
            self.reaptCount -= 1;
            [self.playerViewController.player seekToTime:CMTimeMake(0, 1)];
            
            [self.playerViewController.player play];
        } else {
            [self enterRootViewController:nil];
        }
    }
}

- (void)mb_moviePlayComplate:(mb_moviePlayComplateBlock)block {
    self.moviePlayComplate = block;
}

- (void)mb_moviePlayEnterBtnClick:(mb_moviePlayEnterBtnClickBlock)block {
    self.enterBtnClickBlock = block;
}

- (void)setLoopCount:(NSUInteger)loopCount {
    _loopCount = loopCount;
    if (loopCount > 0) {
        self.reaptCount = 0;
        self.reaptCount += loopCount;
        self.reaptCount -= 1;
    }
}

- (void)setFrontViewController:(UIViewController *)frontViewController {
    _frontViewController = frontViewController;
    if (frontViewController) {
        [self.enterBtn removeFromSuperview];
        [self addChildViewController:frontViewController];
        [self.view addSubview:frontViewController.view];
        frontViewController.view.backgroundColor = [UIColor clearColor];
    }
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;

}

- (void)setEnterBtnTintColor:(UIColor *)enterBtnTintColor {
    _enterBtnTintColor = enterBtnTintColor;
    
    [self.enterBtn setTitleColor:self.enterBtnTintColor forState:UIControlStateNormal];
    
    self.enterBtn.layer.borderColor = self.enterBtnTintColor.CGColor;
}

- (void)setEnterBtnTitleFont:(UIFont *)enterBtnTitleFont {
    _enterBtnTitleFont = enterBtnTitleFont;
    
    [self.enterBtn setTitleColor:self.enterBtnTintColor forState:UIControlStateNormal];

}

- (void)enterRootViewController:(UIButton *)btn {
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mb_movieViewController:enterBtnClick:)]) {
        [self.delegate mb_movieViewController:self enterBtnClick:nil];
        
    } else {
        if (self.enterBtnClickBlock) {
            self.enterBtnClickBlock(btn);
        }
    }
    
    [self transmitAnimationFunc];
}

- (void)transmitAnimationFunc {
    
    if (self.transmitAnimation) {
        UIViewController *rootViewController = [[UIApplication sharedApplication].delegate window].rootViewController;
        [rootViewController.view addSubview:self.view];
        rootViewController.view.alpha = 0.5;
        [UIView animateWithDuration:1.0 animations:^{
            self.view.alpha = 0.0;
            
            [UIView animateWithDuration:1.0 animations:^{
                rootViewController.view.alpha = 1;
            }];
            
        } completion:^(BOOL finished) {
            if (finished) {
                [self.view removeFromSuperview];
            }
        }];
    }
    
}

@end
