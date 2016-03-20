//
//  CCWormView.m
//  CCWormHUD
//
//  Created by 郑克明 on 16/3/17.
//  Copyright © 2016年 郑克明. All rights reserved.
//

/*
 CCWormView对每一个父View都提供唯一的HUD,同一个父View多次调用loding将反复出现同一个HUD.
 */
#import "CCWormView.h"

#define HUDWith 40
#define HUDHeight 40
#define LineWidth 5.0f

@interface CCWormView ()
@property (nonatomic,strong) CAShapeLayer *firstWormShapeLayer;
@property (nonatomic,strong) CAShapeLayer *secondWormShapeLayer;
@property (nonatomic,strong) CAShapeLayer *thirdWormShapeLayer;
@end
@implementation CCWormView

#pragma mark - 指示器操作

+(instancetype)startLodingWormHUD{
    return nil;
}

+(instancetype)endLodingWormHUD{
    return nil;
}

#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self){
        return nil;
    }
    
    CAShapeLayer *firstWormShapeLayer = [[CAShapeLayer alloc] init];
    firstWormShapeLayer.path = [self wormRunLongPath];
    firstWormShapeLayer.lineWidth = LineWidth;
    firstWormShapeLayer.lineCap = kCALineCapRound;
    firstWormShapeLayer.strokeColor = [UIColor redColor].CGColor;
    firstWormShapeLayer.fillColor = [UIColor clearColor].CGColor;
    firstWormShapeLayer.actions = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNull null],@"strokeStart",[NSNull null],@"strokeEnd", nil];
    
    CAShapeLayer *secondWormShapeLayer = [[CAShapeLayer alloc] init];
    secondWormShapeLayer.path = [self wormRunLongPath];
    secondWormShapeLayer.lineWidth = LineWidth;
    secondWormShapeLayer.lineCap = kCALineCapRound;
    secondWormShapeLayer.lineJoin = kCALineCapRound;
    secondWormShapeLayer.strokeColor = [UIColor yellowColor].CGColor;
    secondWormShapeLayer.fillColor = [UIColor clearColor].CGColor;
    secondWormShapeLayer.actions = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNull null],@"strokeStart",[NSNull null],@"strokeEnd", nil];

    CAShapeLayer *thirdWormShapeLayer = [[CAShapeLayer alloc] init];
    thirdWormShapeLayer.path = [self wormRunPath];
    thirdWormShapeLayer.lineWidth = LineWidth;
    thirdWormShapeLayer.lineCap = kCALineCapRound;
    thirdWormShapeLayer.strokeColor = [UIColor greenColor].CGColor;
    thirdWormShapeLayer.fillColor = [UIColor clearColor].CGColor;
    thirdWormShapeLayer.actions = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNull null],@"strokeStart",[NSNull null],@"strokeEnd", nil];
    
    
    [self.layer addSublayer:firstWormShapeLayer];
    [self.layer addSublayer:secondWormShapeLayer];
//    [self.layer addSublayer:thirdWormShapeLayer];
    
    self.firstWormShapeLayer = firstWormShapeLayer;
        self.secondWormShapeLayer = secondWormShapeLayer;
//        self.thirdWormShapeLayer = thirdWormShapeLayer;
    
    [self firstWormAnimation];
    [self secondWormAnimation];
//    [self thirdWormAnimation];
    
    
    return self;
}

-(CGPathRef)wormRunPath{
    //画一个半圆
    return [self wormRunPathWithStartCut:0 endCut:0];
}

-(CGPathRef)wormRunPathWithStartCut:(CGFloat)startCut endCut:(CGFloat)endCut{
    //画一个半圆
    UIBezierPath *wormPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(HUDWith / 2.0, HUDHeight / 2.0) radius:HUDWith / 2.0 - 5 startAngle:M_PI - startCut endAngle:2 * M_PI - endCut clockwise:YES];
    CGPathRef path = wormPath.CGPath;
    return path;
}

-(CGPathRef)wormRunLongPath{
    //画两个连着的半圆
    CGFloat radius = HUDWith / 2.0 - 5;
    UIBezierPath *wormPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(HUDWith / 2.0, HUDHeight / 2.0) radius:radius startAngle:M_PI endAngle:2 * M_PI clockwise:YES];
    [wormPath addArcWithCenter:CGPointMake(radius * 2 + HUDWith / 2.0, HUDHeight / 2.0) radius:radius startAngle:M_PI endAngle:2 * M_PI clockwise:YES];
    
    CGPathRef path = wormPath.CGPath;
    return path;
}

/**
 *  第三条虫子嚅动
 */
-(void)thirdWormAnimation{
    
}



/**
 *  第二条虫子嚅动
 */
-(void)secondWormAnimation{
    //虫子拉伸
    CABasicAnimation *strokeEndAm = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAm.toValue = [NSNumber numberWithFloat:0.5];
    //fromValue 开始画时已经存在的部分的量
    strokeEndAm.fromValue = [NSNumber numberWithFloat:0];
    strokeEndAm.duration = 0.75;
    strokeEndAm.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.42 :0.0 :1.0 :0.55];
    strokeEndAm.fillMode = kCAFillModeForwards;
    
    //虫子缩小
    CABasicAnimation *strokeStartAm = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAm.toValue = [NSNumber numberWithFloat:0.5];
    strokeStartAm.fromValue = [NSNumber numberWithFloat:0];
    strokeStartAm.duration = 0.85;
    //如果不被Group加入的话,CACurrentMediaTime() + 1 才表示延迟1秒.
    strokeStartAm.beginTime = 0.35;//延迟一秒执行
    strokeStartAm.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeStartAm.fillMode = kCAFillModeForwards;
    
    
    //虫子拉伸2 拉伸的第二阶段,必须让上一层的第二阶段先动
    CABasicAnimation *strokeEndAm2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAm2.toValue = [NSNumber numberWithFloat:0.5 + 0.5];
    //fromValue 开始画时已经存在的部分的量
    strokeEndAm2.fromValue = [NSNumber numberWithFloat:0.5];
    strokeEndAm2.duration = 0.75;
    strokeEndAm2.beginTime = 1.2;
    strokeEndAm2.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.42 :0.0 :1.0 :0.55];
    strokeEndAm2.fillMode = kCAFillModeForwards;
    
    //虫子缩小2
    CABasicAnimation *strokeStartAm2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAm2.toValue = [NSNumber numberWithFloat:0.5 + 0.5];
    strokeStartAm2.fromValue = [NSNumber numberWithFloat:0.5 + 0];
    strokeStartAm2.duration = 0.45;
    //如果不被Group加入的话,CACurrentMediaTime() + 1 才表示延迟1秒.
    strokeStartAm2.beginTime = 0.75 + 1.2;//延迟一秒执行
    strokeStartAm2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    //平移动画
    CABasicAnimation *xTranslationAm = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    xTranslationAm.toValue = [NSNumber numberWithFloat: (HUDWith / -1.0 + 10)];
    xTranslationAm.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    xTranslationAm.duration = 1.18;
    xTranslationAm.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *xTranslationAm2 = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    xTranslationAm2.toValue = [NSNumber numberWithFloat: (HUDWith / -1.0 + 10) * 2];
    xTranslationAm2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    xTranslationAm2.duration = 1.18;
    xTranslationAm2.beginTime = 1.20;
    xTranslationAm2.fillMode = kCAFillModeForwards;
    
    
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects: strokeStartAm, strokeEndAm, xTranslationAm, strokeEndAm2, strokeStartAm2, xTranslationAm2, nil];
    animationGroup.repeatCount = HUGE_VALF;
    //动画总时间应该以组中动画时间最长为标准
    animationGroup.duration = 1.2 * 2;
    [self.secondWormShapeLayer addAnimation:animationGroup forKey:nil];
}
/*
-(void)secondWormAnimation{
    //黄色虫子嚅动要拆分成2部分,一部分是先行于first,第二部分后行于first.两部分的执行顺序依次进行.
    //总长度
    double timeSpan = 0;
    double partOneTimeSpan = 0;
    //第一部分 先行
    //虫子缩小
    CABasicAnimation *strokeStartAm = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAm.delegate = self;
    strokeStartAm.toValue = [NSNumber numberWithFloat:0.88];
    strokeStartAm.fromValue = [NSNumber numberWithFloat:0];
    strokeStartAm.duration = 0.85;
    //如果不被Group加入的话,CACurrentMediaTime() + 1 才表示延迟1秒.
    strokeStartAm.beginTime = 0.35;//延迟一秒执行
    strokeStartAm.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //虫子拉伸
    CABasicAnimation *strokeEndAm = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAm.toValue = [NSNumber numberWithFloat:1];
    strokeEndAm.fromValue = [NSNumber numberWithFloat:0.12];
    strokeEndAm.duration = 0.75;
    strokeEndAm.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.42 :0.0 :1.0 :0.55];
    //    strokeEndAm.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    //平移动画
    CABasicAnimation *xTranslationAm = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    xTranslationAm.toValue = [NSNumber numberWithFloat: (HUDWith / -1.0 + 10)];
    timeSpan = partOneTimeSpan = xTranslationAm.duration = 1.2;
    xTranslationAm.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

    
    
    //第二部分 后行,开始时间为'先行'结束后,再延迟一段时间再执行,第二部分的总长度和第一部分一样
    CFTimeInterval tempTimeSpan = 0.2;
    CFTimeInterval delayTimeSpan = partOneTimeSpan + tempTimeSpan;
    //所有动画执行时间必须减去 额外延迟执行的时间tempTimeSpan
    CFTimeInterval startDuration = 0.85 - tempTimeSpan;
    CFTimeInterval endDuration = 0.75 - tempTimeSpan;
    //虫子缩小
    CABasicAnimation *strokeStartAm2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAm2.delegate = self;
    //toValue 消失到最后剩下的部分的量
    strokeStartAm2.toValue = [NSNumber numberWithFloat:0.88];
    strokeStartAm2.fromValue = [NSNumber numberWithFloat:0];
    strokeStartAm2.duration = startDuration;
    strokeStartAm2.beginTime = 0.35 + delayTimeSpan;
    strokeStartAm2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //虫子拉伸
    CABasicAnimation *strokeEndAm2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAm2.toValue = [NSNumber numberWithFloat:0.50];
    strokeEndAm2.fromValue = [NSNumber numberWithFloat:0.12];
    strokeEndAm2.duration = endDuration;
    strokeEndAm2.beginTime = delayTimeSpan;
    strokeEndAm2.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.42 :0.0 :1.0 :0.55];
    //    strokeEndAm.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    //平移动画
    CABasicAnimation *xTranslationAm2 = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    xTranslationAm2.toValue = [NSNumber numberWithFloat: (HUDWith / -1.0 + 10)];
    xTranslationAm2.duration = partOneTimeSpan;
    xTranslationAm2.beginTime = partOneTimeSpan;
    xTranslationAm2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    timeSpan += partOneTimeSpan;
    
    //饶中心点旋转
//    CABasicAnimation *zRotationAm2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    zRotationAm2.fromValue = [NSNumber numberWithFloat:0];
//    zRotationAm2.toValue = [NSNumber numberWithFloat: (M_PI * 2) / 20 ];
//    zRotationAm2.duration = partOneTimeSpan;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects: strokeEndAm, strokeStartAm, xTranslationAm,strokeEndAm2, strokeStartAm2, xTranslationAm2, nil];
    animationGroup.repeatCount = HUGE_VALF;
    animationGroup.duration = timeSpan;
    [self.secondWormShapeLayer addAnimation:animationGroup forKey:nil];
//    self.secondWormShapeLayer.strokeEnd = 0.12;
}
*/

/**
 *  第一条虫子嚅动 (最底部的那条)
 */
-(void)firstWormAnimation{
    //虫子拉伸
    CABasicAnimation *strokeEndAm = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAm.toValue = [NSNumber numberWithFloat:0.5];
    //fromValue 开始画时已经存在的部分的量
    strokeEndAm.fromValue = [NSNumber numberWithFloat:0];
    strokeEndAm.duration = 0.75;
    strokeEndAm.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.42 :0.0 :1.0 :0.55];
    strokeEndAm.fillMode = kCAFillModeForwards;
    
    //虫子缩小
    CABasicAnimation *strokeStartAm = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAm.toValue = [NSNumber numberWithFloat:0.5];
    strokeStartAm.fromValue = [NSNumber numberWithFloat:0];
    strokeStartAm.duration = 0.45;
    //如果不被Group加入的话,CACurrentMediaTime() + 1 才表示延迟1秒.
    strokeStartAm.beginTime = 0.75;//延迟一秒执行
    strokeStartAm.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeStartAm.fillMode = kCAFillModeForwards;
    
    
    //虫子拉伸2
    CABasicAnimation *strokeEndAm2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAm2.toValue = [NSNumber numberWithFloat:0.5 + 0.5];
    //fromValue 开始画时已经存在的部分的量
    strokeEndAm2.fromValue = [NSNumber numberWithFloat:0.5 + 0];
    strokeEndAm2.duration = 0.75;
    strokeEndAm2.beginTime = 1.2;
    strokeEndAm2.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.42 :0.0 :1.0 :0.55];
    strokeEndAm2.fillMode = kCAFillModeForwards;
    
    //虫子缩小2
    CABasicAnimation *strokeStartAm2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAm2.toValue = [NSNumber numberWithFloat:0.5 + 0.5];
    strokeStartAm2.fromValue = [NSNumber numberWithFloat:0.5 + 0];
    strokeStartAm2.duration = 0.45;
    //如果不被Group加入的话,CACurrentMediaTime() + 1 才表示延迟1秒.
    strokeStartAm2.beginTime = 0.75 + 1.2;//延迟一秒执行
    strokeStartAm2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    //平移动画
    CABasicAnimation *xTranslationAm = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    xTranslationAm.toValue = [NSNumber numberWithFloat: (HUDWith / -1.0 + 10)];
    xTranslationAm.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    xTranslationAm.duration = 1.18;
    xTranslationAm.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *xTranslationAm2 = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    xTranslationAm2.toValue = [NSNumber numberWithFloat: (HUDWith / -1.0 + 10) * 2];
    xTranslationAm2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    xTranslationAm2.duration = 1.18;
    xTranslationAm2.beginTime = 1.20;
    xTranslationAm2.fillMode = kCAFillModeForwards;
    
    
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects: strokeStartAm, strokeEndAm, xTranslationAm, strokeEndAm2, strokeStartAm2, xTranslationAm2, nil];
    animationGroup.repeatCount = HUGE_VALF;
    //动画总时间应该以组中动画时间最长为标准
    animationGroup.duration = 1.2 * 2;
    [self.firstWormShapeLayer addAnimation:animationGroup forKey:nil];
}
/*
-(void)firstWormAnimation{
    //虫子缩小
    CABasicAnimation *strokeStartAm = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    //注意这里的delegate为strong
    strokeStartAm.delegate = self;
    //toValue 消失到最后剩下的部分的量
    strokeStartAm.toValue = [NSNumber numberWithFloat:0.88];
    strokeStartAm.fromValue = [NSNumber numberWithFloat:0];
    strokeStartAm.duration = 0.45;
    strokeStartAm.beginTime = 0.75;//延迟一秒执行
    strokeStartAm.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //虫子拉伸
    CABasicAnimation *strokeEndAm = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAm.toValue = [NSNumber numberWithFloat:1];
    //fromValue 开始画时已经存在的部分的量
    strokeEndAm.fromValue = [NSNumber numberWithFloat:0.12];
    strokeEndAm.duration = 0.75;
    strokeEndAm.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.42 :0.0 :1.0 :0.55];
    
    //平移动画
    CABasicAnimation *xTranslationAm = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    xTranslationAm.toValue = [NSNumber numberWithFloat: (HUDWith / -1.0 + 10)];
    xTranslationAm.duration = 1.2;
    xTranslationAm.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects: strokeEndAm, strokeStartAm, xTranslationAm, nil];
    animationGroup.repeatCount = HUGE_VALF;
    //动画总时间应该以组中动画时间最长为标准
    animationGroup.duration = 1.2;
    [self.firstWormShapeLayer addAnimation:animationGroup forKey:nil];
}
*/

//-(CAAnimationGroup *)wormAnimationFactory{
//    
//}



-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
}







#pragma mark - 测试用

-(CGPathRef)testPath{
    //画一个半圆
    UIBezierPath* wormPath = UIBezierPath.bezierPath;
    [wormPath moveToPoint: CGPointMake(5,20)];
    [wormPath addLineToPoint:CGPointMake(35, 20)];
    CGPathRef path = wormPath.CGPath;
    return path;
}

-(void)testAnimation{
    CABasicAnimation *strokeStartAm = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAm.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    strokeStartAm.toValue = [NSNumber numberWithFloat:0.2];
    strokeStartAm.fromValue = [NSNumber numberWithFloat:1];
    strokeStartAm.duration = 2;
    strokeStartAm.repeatCount = 100;
    
    CABasicAnimation *strokeEndAm = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAm.toValue = [NSNumber numberWithFloat:1];
    strokeEndAm.fromValue = [NSNumber numberWithFloat:0];
    strokeEndAm.duration = 2;
    strokeEndAm.repeatCount = 100;
    
    [self.firstWormShapeLayer addAnimation:strokeEndAm forKey:nil];
}
@end
