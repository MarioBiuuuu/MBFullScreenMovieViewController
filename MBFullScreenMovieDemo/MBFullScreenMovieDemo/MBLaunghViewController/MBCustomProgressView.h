//
//  CustomProgressView.h
//  CustomProgressOC
//
//  Created by Yuri on 16/9/6.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBCustomProgressView : UIView

@property (nonatomic, assign) NSUInteger totalTime;

@property (nonatomic, assign) NSInteger progress;

- (void)setProgress:(NSInteger)progress animated:(BOOL)animated duration:(CGFloat)duration;
@end
