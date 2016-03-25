//
//  CCWormView.m
//  CCWormHUD
//
//  Created by Cocos on 16/3/17.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "CCWormView.h"

//动画半径为HUD尺寸的一半
#define HUDWith 40
#define HUDHeight 40

#define HUDWithLarge 80
#define HUDHeightLarge 80

#define LineWidth 6.0f
#define LineWidthLarge 8.0f
#define WormRunTime 1.2f

#define WORM_ANIMATION_KEY_FIRST @"WORM_ANIMATION_KEY_FIRST"
#define WORM_ANIMATION_KEY_SECOND @"WORM_ANIMATION_KEY_SECOND"
#define WORM_ANIMATION_KEY_THIRD @"WORM_ANIMATION_KEY_THIRD"


static NSInteger CCWormHUDViewWith = 0;
static NSInteger CCWormHUDViewHeight = 0;
static NSInteger CCWormHUDLineWidth = 0;
@interface CCWormView ()
@property (nonatomic,strong) CAShapeLayer *firstWormShapeLayer;
@property (nonatomic,strong) CAShapeLayer *secondWormShapeLayer;
@property (nonatomic,strong) CAShapeLayer *thirdWormShapeLayer;

@property (nonatomic) CCWormHUDStyle hudStyle;
/**
 *  用于显示HUD的视图
 */
@property (nonatomic,weak) UIView *presentingView;

@end
@implementation CCWormView

#pragma mark - 指示器操作

+(instancetype)wormHUDWithStyle:(CCWormHUDStyle)style toView:(UIView *)toView{
    
    CCWormView *view;
    if (style == CCWormHUDStyleNormal) {
        CCWormHUDViewWith = HUDWith;
        CCWormHUDViewHeight = HUDHeight;
        CCWormHUDLineWidth = LineWidth;
    }else if (style == CCWormHUDStyleLarge){
        CCWormHUDViewWith = HUDWithLarge;
        CCWormHUDViewHeight = HUDHeightLarge;
        CCWormHUDLineWidth = LineWidthLarge;
    }
    
    CGRect frame = CGRectZero;
    frame.origin.x = toView.frame.origin.x + ( toView.frame.size.width / 2 - CCWormHUDViewWith / 2);
    frame.origin.y = toView.frame.origin.y + (toView.frame.size.height / 2 - CCWormHUDViewHeight / 2);
    frame.size.width = CCWormHUDViewWith;
    frame.size.height = CCWormHUDViewHeight;
    
    view = [[CCWormView alloc] initWithFrame:frame HUDStyle:style];
    view.presentingView = toView;
    view.layer.cornerRadius = M_PI * 4;
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
    return view;
}

-(void)startLodingWormHUD{
    self.isShowing = YES;
    [self.presentingView addSubview:self];
    //动起来
    [self firstWormAnimation];
    [self secondWormAnimation];
    [self thirdWormAnimation];
    
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateKeyframesWithDuration:0.6 delay:0.0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
            self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    } completion: nil];
}

-(void)endLodingWormHUD{
    //隐藏指示器,同时移除动画
    [UIView animateKeyframesWithDuration:0.6 delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        }];
        
    } completion:^(BOOL finished){
        self.isShowing = NO;
        [self.firstWormShapeLayer removeAnimationForKey:WORM_ANIMATION_KEY_FIRST];
        [self.secondWormShapeLayer removeAnimationForKey:WORM_ANIMATION_KEY_SECOND];
        [self.thirdWormShapeLayer removeAnimationForKey:WORM_ANIMATION_KEY_THIRD];
        [self removeFromSuperview];
    }];
}

#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame HUDStyle:(CCWormHUDStyle)style{
    self = [super initWithFrame:frame];
    if (!self){
        return nil;
    }
    self.hudStyle = style;
    
    CAShapeLayer *firstWormShapeLayer = [[CAShapeLayer alloc] init];
    firstWormShapeLayer.path = [self wormRunLongPath];
    firstWormShapeLayer.lineWidth = CCWormHUDLineWidth;
    firstWormShapeLayer.lineCap = kCALineCapRound;
    firstWormShapeLayer.lineJoin = kCALineCapRound;
    firstWormShapeLayer.strokeColor = [UIColor redColor].CGColor;
    firstWormShapeLayer.fillColor = [UIColor clearColor].CGColor;
    firstWormShapeLayer.actions = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNull null],@"strokeStart",[NSNull null],@"strokeEnd", nil];
    
    CAShapeLayer *secondWormShapeLayer = [[CAShapeLayer alloc] init];
    secondWormShapeLayer.path = [self wormRunLongPath];
    secondWormShapeLayer.lineWidth = CCWormHUDLineWidth;
    secondWormShapeLayer.lineCap = kCALineCapRound;
    secondWormShapeLayer.lineJoin = kCALineCapRound;
    secondWormShapeLayer.strokeColor = [UIColor yellowColor].CGColor;
    secondWormShapeLayer.fillColor = [UIColor clearColor].CGColor;
    secondWormShapeLayer.actions = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNull null],@"strokeStart",[NSNull null],@"strokeEnd", nil];

    CAShapeLayer *thirdWormShapeLayer = [[CAShapeLayer alloc] init];
    thirdWormShapeLayer.path = [self wormRunLongPath];
    thirdWormShapeLayer.lineWidth = CCWormHUDLineWidth;
    thirdWormShapeLayer.lineCap = kCALineCapRound;
    thirdWormShapeLayer.lineJoin = kCALineCapRound;
    thirdWormShapeLayer.strokeColor = [UIColor greenColor].CGColor;
    thirdWormShapeLayer.fillColor = [UIColor clearColor].CGColor;
    thirdWormShapeLayer.actions = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNull null],@"strokeStart",[NSNull null],@"strokeEnd", nil];
    
    [self.layer addSublayer:firstWormShapeLayer];
    [self.layer addSublayer:secondWormShapeLayer];
    [self.layer addSublayer:thirdWormShapeLayer];
    self.firstWormShapeLayer = firstWormShapeLayer;
    self.secondWormShapeLayer = secondWormShapeLayer;
    self.thirdWormShapeLayer = thirdWormShapeLayer;

    return self;
}

-(CGPathRef)wormRunLongPath{
    //确定路径起点位置
    CGPoint center;
    if (self.hudStyle == CCWormHUDStyleLarge || self.hudStyle==CCWormHUDStyleNormal) {
        center = CGPointMake(self.frame.size.width * 9 / 10, self.frame.size.height / 2);
    }
    
    //两个连着的半圆
    CGFloat radius = (CCWormHUDViewWith / 2.0) / 2.0;
    UIBezierPath *wormPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:M_PI endAngle:2 * M_PI clockwise:YES];
    [wormPath addArcWithCenter:CGPointMake(center.x  + radius * 2, center.y) radius:radius startAngle:M_PI endAngle:2 * M_PI clockwise:YES];
    
    CGPathRef path = wormPath.CGPath;
    return path;

}

-(CGPathRef)wormRunLongPathWithStartCut:(CGFloat)startCut endCut:(CGFloat)endCut{
    //确定路径起点位置
    CGPoint center;
    if (self.hudStyle == CCWormHUDStyleLarge || self.hudStyle==CCWormHUDStyleNormal) {
        center = CGPointMake(self.frame.size.width * 9 / 10, self.frame.size.height / 2);
    }
    
    //两个连着的半圆
    CGFloat radius = (CCWormHUDViewWith / 2.0) / 2.0;
    UIBezierPath *wormPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:M_PI + startCut endAngle:2 * M_PI clockwise:YES];
    [wormPath addArcWithCenter:CGPointMake(center.x  + radius * 2, center.y) radius:radius startAngle:M_PI endAngle:2 * M_PI - endCut clockwise:YES];
    
    CGPathRef path = wormPath.CGPath;
    return path;
}

/**
 *  第三条虫子嚅动
 */
-(void)thirdWormAnimation{
    
    CAAnimationGroup *animationGroup = [self baseWormAnimationWithEnd1From:0.010 end1To:0.5 end1Duration:0.75 start1From:0 start1To:0.490 start1Duration:0.9 start1Begin:0.25 end2From:0.5 end2To:0.5 + 0.5 end2Duration:0.75 end2Begin:WormRunTime + 0.15 + 0.20 start2From:0.5 start2To:0.5 + 0.5 start2Duration:0.30 start2Begin:0.15 + 0.75 + WormRunTime];
    
    [self.thirdWormShapeLayer addAnimation:animationGroup forKey:WORM_ANIMATION_KEY_THIRD];
}

/**
 *  第二条虫子嚅动
 */
-(void)secondWormAnimation{
    
    CAAnimationGroup *animationGroup = [self baseWormAnimationWithEnd1From:0.010 end1To:0.5 end1Duration:0.75 start1From:0 start1To:0.490 start1Duration:0.70 start1Begin:0.50 end2From:0.5 end2To:0.5 + 0.5 end2Duration:0.75 end2Begin:WormRunTime + 0.15 start2From:0.5 start2To:0.5 + 0.5 start2Duration:0.30 start2Begin:0.15 + 0.75 + WormRunTime];
    
    [self.secondWormShapeLayer addAnimation:animationGroup forKey:WORM_ANIMATION_KEY_SECOND];
}

/**
 *  第一条虫子嚅动 (最底部的那条)
 */
-(void)firstWormAnimation{
    CAAnimationGroup *animationGroup = [self baseWormAnimationWithEnd1From:0 end1To:0.5 end1Duration:0.75 start1From:0 start1To:0.5 start1Duration:0.45 start1Begin:0.75 end2From:0.5 end2To:0.5 + 0.5 end2Duration:0.75 end2Begin:1.2 start2From:0.5 start2To:0.5 + 0.5 start2Duration:0.45 start2Begin:0.75 + WormRunTime];
    
    [self.firstWormShapeLayer addAnimation:animationGroup forKey:WORM_ANIMATION_KEY_FIRST];
}

-(CAAnimationGroup *)baseWormAnimationWithEnd1From:(CGFloat)end1FromValue end1To:(CGFloat)end1ToValue end1Duration:(CGFloat)end1Duration start1From:(CGFloat)start1FromValue start1To:(CGFloat)start1ToValue start1Duration:(CGFloat)start1Duration start1Begin:(CGFloat)start1BeginTime end2From:(CGFloat)end2FromValue end2To:(CGFloat)end2ToValue end2Duration:(CGFloat)end2Duration end2Begin:(CGFloat)end2BeginTime start2From:(CGFloat)start2FromValue start2To:(CGFloat)start2ToValue start2Duration:(CGFloat)start2Duration start2Begin:(CGFloat)start2BeginTime{
    
    
    //虫子拉伸1
    CABasicAnimation *strokeEndAm = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAm.toValue = [NSNumber numberWithFloat:end1ToValue];
    //fromValue 开始画时已经存在的部分的量
    strokeEndAm.fromValue = [NSNumber numberWithFloat:end1FromValue];
    strokeEndAm.duration = end1Duration;
    strokeEndAm.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.42 :0.0 :1.0 :0.55];
    strokeEndAm.fillMode = kCAFillModeForwards;
    
    //虫子缩小1
    CABasicAnimation *strokeStartAm = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAm.toValue = [NSNumber numberWithFloat:start1ToValue];
    strokeStartAm.fromValue = [NSNumber numberWithFloat:start1FromValue];
    strokeStartAm.duration = start1Duration;
    //如果不被Group加入的话,CACurrentMediaTime() + 1 才表示延迟1秒.
    strokeStartAm.beginTime = start1BeginTime;//延迟执行
    strokeStartAm.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeStartAm.fillMode = kCAFillModeForwards;
    
    
    //虫子拉伸2 拉伸的第二阶段,必须让上一层的第二阶段先动
    CABasicAnimation *strokeEndAm2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAm2.toValue = [NSNumber numberWithFloat:end2ToValue];
    //fromValue 开始画时已经存在的部分的量
    strokeEndAm2.fromValue = [NSNumber numberWithFloat:end2FromValue];
    strokeEndAm2.duration = end2Duration;
    strokeEndAm2.beginTime = end2BeginTime;
    strokeEndAm2.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.42 :0.0 :1.0 :0.55];
    strokeEndAm2.fillMode = kCAFillModeForwards;
    
    //虫子缩小2
    CABasicAnimation *strokeStartAm2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAm2.toValue = [NSNumber numberWithFloat:start2ToValue];
    strokeStartAm2.fromValue = [NSNumber numberWithFloat:start2FromValue];
    strokeStartAm2.duration = start2Duration;
    //如果不被Group加入的话,CACurrentMediaTime() + 1 才表示延迟1秒.
    strokeStartAm2.beginTime = start2BeginTime;//延迟一秒执行
    strokeStartAm2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    //平移动画
    CABasicAnimation *xTranslationAm = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    xTranslationAm.toValue = [NSNumber numberWithFloat: ( (CCWormHUDViewWith / 2.0) / -1.0)];
    xTranslationAm.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    xTranslationAm.duration = 1.18;
    xTranslationAm.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *xTranslationAm2 = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    xTranslationAm2.toValue = [NSNumber numberWithFloat: ( (CCWormHUDViewWith / 2.0) / -1.0) * 2];
    xTranslationAm2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    xTranslationAm2.duration = 1.18;
    xTranslationAm2.beginTime = 1.20;
    xTranslationAm2.fillMode = kCAFillModeForwards;
    
    
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects: strokeStartAm, strokeEndAm, xTranslationAm, strokeEndAm2, strokeStartAm2, xTranslationAm2, nil];
    animationGroup.repeatCount = HUGE_VALF;
    //动画总时间应该以组中动画时间最长为标准
    animationGroup.duration = WormRunTime * 2;
    
    return animationGroup;
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
