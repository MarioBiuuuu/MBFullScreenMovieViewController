//
//  MBImagesLaunghViewController.m
//  MBFullScreenMovieDemo
//
//  Created by 张晓飞 on 2017/2/25.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "MBImagesLaunghViewController.h"
#import "MBImageObject.h"

@interface MBImagesLaunghViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation MBImagesLaunghViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = self.view.frame;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        _webView.userInteractionEnabled = NO;
    }
    return _webView;
}

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
}

- (void)setImageObject:(MBImageObject *)imageObject {
    if (imageObject.localGifData) {
        [self.view addSubview:self.webView];
        [self.webView loadData:imageObject.localGifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];

    } else if (imageObject.gifUrl) {
        [self.view addSubview:self.webView];

        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mb_laungh_placeholder.jpeg" ofType:nil]];
        
        self.imageView.image = image;
        
        __weak typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[imageObject gifUrl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.webView loadData:imageData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
            });
        });
        
    } else if ([imageObject localImagePath]) {
        [self.view addSubview:self.imageView];
        
        UIImage *image = [UIImage imageWithContentsOfFile:[imageObject localImagePath]];
        self.imageView.image = image;
    } else if ([imageObject imageUrl]) {
        [self.view addSubview:self.imageView];

        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mb_laungh_placeholder.jpeg" ofType:nil]];
        
        self.imageView.image = image;
        
        __weak typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[imageObject imageUrl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.imageView.image = [UIImage imageWithData:imageData];
            });
        });
    } else {
        [self.view addSubview:self.imageView];
        
        self.imageView.image = [imageObject localImage];
    }
}

@end
