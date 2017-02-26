//
//  MBImageObject.h
//  MBFullScreenMovieDemo
//
//  Created by 张晓飞 on 2017/2/25.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MBImageObject : NSObject

@property (nonatomic, strong) UIImage *localImage;

@property (nonatomic, copy) NSString *localImagePath;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, strong) NSData *localGifData;

@property (nonatomic, strong) NSURL *gifUrl;

@end
