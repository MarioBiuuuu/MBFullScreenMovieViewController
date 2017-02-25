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

@end

@implementation MBImagesLaunghViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
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

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    if (imageArray.count > 1) {
        
    } else {
        self.imageView.image = [imageArray.firstObject localImage];
    }
}

@end
