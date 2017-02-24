//
//  MBFullScreenMovieViewController.m
//  MBFullScreenMovieDemo
//
//  Created by ZhangXiaofei on 17/2/24.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "MBFullScreenLaunghViewController.h"

#define DEF_RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define DEF_HEXColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define DEF_HEXColorA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@interface MBFullScreenLaunghViewController () <MBMoviePlayerViewControllerDelegate>

@property (nonatomic, strong) MBMoviePlayerViewController *playerViewController;

@property (nonatomic, strong) UIButton *enterBtn;

@property (nonatomic,copy) mb_moviePlayComplateBlock moviePlayComplate;

@property (nonatomic,copy) mb_moviePlayEnterBtnClickBlock enterBtnClickBlock;

@end

@implementation MBFullScreenLaunghViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (instancetype)initWithLaunghStyle:(MBFullScreenLaunghStyle)style {
    if (self = [super init]) {
        self.launghStyle = style;
        [self setupLaunghView];
    }
    return self;
}

+ (instancetype)mb_fullScreenLaugh:(MBFullScreenLaunghStyle)style {
    return [[self alloc] initWithLaunghStyle:style];
}

- (void)setupLaunghView {
    self.transmitAnimation = YES;
    
    
    switch (self.launghStyle) {
        case MBFullScreenLaunghStyleNormal:
        case MBFullScreenLaunghStyleMovie:
            [self setupMoviePlayerView];
            break;
        case MBFullScreenLaunghStyleImage:
            break;
        case MBFullScreenLaunghStyleGif:
            break;
            
        default:
            break;
    }
    
   
}

- (void)setupMoviePlayerView {
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

- (MBMoviePlayerViewController *)playerViewController {
    if (!_playerViewController) {
        _playerViewController = [[MBMoviePlayerViewController alloc] init];
        _playerViewController.playerDelegate = self;
        _playerViewController.loopCount = self.loopCount;
        _playerViewController.view.frame = self.view.frame;
    }
    return _playerViewController;
}

- (void)mb_moviePlayComplate:(mb_moviePlayComplateBlock)block {
    self.moviePlayComplate = block;
}

- (void)mb_moviePlayEnterBtnClick:(mb_moviePlayEnterBtnClickBlock)block {
    self.enterBtnClickBlock = block;
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
    self.playerViewController.videoUrl = videoUrl;
}

- (void)setLoopCount:(NSUInteger)loopCount {
    _loopCount = loopCount;
    self.playerViewController.loopCount = loopCount;
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

#pragma mark - MBMoviePlayerViewControllerDelegate
- (void)mb_movieViewControllerLoopEnd:(MBMoviePlayerViewController *)playerViewController {
    [self enterRootViewController:nil];
}

- (void)mb_movieViewController:(MBMoviePlayerViewController *)playerViewController playComplate:(NSTimeInterval)totalInterval {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mb_movieViewController:mbPlayerViewController:playComplate:)]) {
        [self.delegate mb_movieViewController:self mbPlayerViewController:playerViewController playComplate:totalInterval];
    } else {
        if (self.moviePlayComplate) {
            self.moviePlayComplate(playerViewController, totalInterval);
        }
    }
}

@end
