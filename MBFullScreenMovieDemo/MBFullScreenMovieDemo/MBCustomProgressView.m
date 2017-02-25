//
//  CustomProgressView.m
//  CustomProgressOC
//
//  Created by Yuri on 16/9/6.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "MBCustomProgressView.h"

@interface MBCustomProgressView ()

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;

@property (nonatomic, strong) CAShapeLayer *trackLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic, strong) CATextLayer *textLayer;

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGPoint centerPoint;
@end

@implementation MBCustomProgressView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.path = [[UIBezierPath alloc] init];
        self.trackLayer = [[CAShapeLayer alloc] init];
        self.progressLayer = [[CAShapeLayer alloc] init];
        
        self.lineWidth = 2;
        self.trackColor = [UIColor colorWithRed:0.855 green:0.871 blue:0.863 alpha:1.000];
        self.progressColor = [UIColor redColor];
        
        self.radius = CGRectGetWidth(frame) / 2.0 - 2 / 2.0;
        self.centerPoint = CGPointMake(CGRectGetWidth(frame) / 2.0, CGRectGetWidth(frame) / 2.0);
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self.path addArcWithCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                         radius:self.bounds.size.width / 2 - self.lineWidth
                     startAngle:(-90 / 180.0 * M_PI)
                       endAngle:(270.0 / 180.0 * M_PI)
                      clockwise:YES];
    
    self.trackLayer.frame = self.bounds;
    self.trackLayer.fillColor = [UIColor clearColor].CGColor;
    self.trackLayer.strokeColor = self.trackColor.CGColor;
    self.trackLayer.lineWidth = self.lineWidth;
    self.trackLayer.path = self.path.CGPath;
    [self.layer addSublayer:self.trackLayer];
    
    self.progressLayer.frame = self.bounds;
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = self.progressColor.CGColor;
    self.progressLayer.lineWidth = self.lineWidth;
    self.progressLayer.path = self.path.CGPath;
    self.progressLayer.strokeStart = 0;
    self.progressLayer.strokeEnd = self.progress / 100.0;
    [self.layer addSublayer:self.progressLayer];
    
    
//    CALayer *gradientLayer = [CALayer layer];
//    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
//    gradientLayer1.frame = CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height);
//    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor],(id)[[UIColor redColor] CGColor], nil]];
//    [gradientLayer1 setLocations:@[@0.5,@0.9, @1]];
//    [gradientLayer1 setStartPoint:CGPointMake(1.0, 0)];
//    [gradientLayer1 setEndPoint:CGPointMake(0.5, 0.8)];
//    [gradientLayer addSublayer:gradientLayer1];
//    
//    CAGradientLayer *gradientLayer2 =  [CAGradientLayer layer];
//    [gradientLayer2 setLocations:@[@0.1, @0.5, @1]];
//    gradientLayer2.frame = CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height);
//    [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:1.000 green:0.965 blue:0.471 alpha:1.000] CGColor],(id)[[UIColor redColor] CGColor], nil]];
//    [gradientLayer2 setStartPoint:CGPointMake(0.5, 0)];
//    [gradientLayer2 setEndPoint:CGPointMake(0.5, 1)];
//    [gradientLayer addSublayer:gradientLayer2];
//    
//    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    
//    [self.layer addSublayer:gradientLayer];
    
    [self setPercentTextLayer];
}


- (void)setProgress:(NSInteger)progress animated:(BOOL)animated duration:(CGFloat)duration {
    if (self.totalTime == 0) {
        
    } else {
        self.textLayer.string = [NSString stringWithFormat:@"%@", @(self.totalTime)];
    }

    [CATransaction begin];
    [CATransaction setDisableActions:!animated];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [CATransaction setAnimationDuration:duration];
    
    self.progressLayer.strokeEnd = progress / 100.0;

    [CATransaction commit];
    

}

-(void)setPercentTextLayer {

    self.totalTime -= 1;
    self.textLayer = [CATextLayer layer];
    self.textLayer.contentsScale = [[UIScreen mainScreen] scale];
    self.textLayer.string = [NSString stringWithFormat:@"%@", @(self.totalTime)];
    self.textLayer.bounds = self.bounds;
    self.textLayer.font = (__bridge CFTypeRef _Nullable)(@"HiraKakuProN-W3");
    self.textLayer.fontSize = 14.f;
    self.textLayer.alignmentMode = kCAAlignmentCenter;
    self.textLayer.position = CGPointMake(self.centerPoint.x, self.centerPoint.y + self.radius * 0.7);
    self.textLayer.foregroundColor =
    [UIColor blackColor].CGColor;
    [self.layer addSublayer:self.textLayer];
}


@end
