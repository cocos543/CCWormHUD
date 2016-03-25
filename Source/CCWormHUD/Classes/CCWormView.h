//
//  CCWormView.h
//  CCWormHUD
//
//  Created by Cocos on 16/3/17.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

//指示器类型
typedef NS_ENUM(NSInteger, CCWormHUDStyle)
{
    CCWormHUDStyleLarge,  // 80 * 80
    CCWormHUDStyleNormal  // 40 * 40
};

@interface CCWormView : UIView

/**
 *  指示器状态
 */
@property (nonatomic) BOOL isShowing;

+(instancetype)wormHUDWithStyle:(CCWormHUDStyle)style toView:(UIView *)toView;
-(void)startLodingWormHUD;
-(void)endLodingWormHUD;
@end
