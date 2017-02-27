//
//  MBImagesLaunghViewController.h
//  MBFullScreenMovieDemo
//
//  Created by 张晓飞 on 2017/2/25.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBImageObject;

@interface MBImagesLaunghViewController : UIViewController
/**
 *  图片模型数组
 */
@property (nonatomic, strong) NSArray<MBImageObject *> *imageArray;

@property (nonatomic, strong) MBImageObject *imageObject;

@end
