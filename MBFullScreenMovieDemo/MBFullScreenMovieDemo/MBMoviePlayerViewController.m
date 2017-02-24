//
//  MBMoviePlayerViewController.m
//  MBFullScreenMovieDemo
//
//  Created by ZhangXiaofei on 17/2/24.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "MBMoviePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MBMoviePlayerViewController ()

@property (nonatomic, assign) NSUInteger reaptCount;

@property (nonatomic, strong) AVPlayer *avPlayer;

@property (nonatomic, strong) AVPlayerItem *item;

@end

@implementation MBMoviePlayerViewController

- (void)dealloc {
    [_item removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_item removeObserver:self forKeyPath:@"status"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showsPlaybackControls = NO;
    self.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [_avPlayer play];
            
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
        [self.playerDelegate mb_movieViewController:self playComplate:total];
    }
}

- (void)reaptPlay {
    if (self.loopCount == 0) {
        [self.player seekToTime:CMTimeMake(0, 1)];
        
        [self.player play];
    } else {
        if (self.reaptCount > 0) {
            self.reaptCount -= 1;
            [self.player seekToTime:CMTimeMake(0, 1)];
            
            [self.player play];
        } else {
            if (self.playerDelegate && [self.playerDelegate respondsToSelector:@selector(mb_movieViewControllerLoopEnd:)]) {
                [self.playerDelegate mb_movieViewControllerLoopEnd:self];
            }
        }
    }
}

- (void)setLoopCount:(NSUInteger)loopCount {
    _loopCount = loopCount;
    if (loopCount > 0) {
        self.reaptCount = 0;
        self.reaptCount += loopCount;
        self.reaptCount -= 1;
    }
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
    NSAssert(videoUrl, @"传入的视频连接为空");
    
    AVAsset *asset = [AVAsset assetWithURL:_videoUrl];
    self.item = [AVPlayerItem playerItemWithAsset:asset];
    [self.item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    // 监听loadedTimeRanges属性
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.item];
    
    self.player = self.avPlayer;
    __weak __typeof(self) weakSelf = self;
    [self.avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
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

@end
