//
//  TabBar.m
//  Animated Icon
//
//  Created by 沈凯 on 2018/4/10.
//  Copyright © 2018年 Ssky. All rights reserved.
//

#import "TabBar.h"

@implementation TabBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    设定button大小为适应图片
    UIImage *normalImage = [UIImage imageNamed:@"加"];

    _centerBtn.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width - normalImage.size.width)/2, 0, normalImage.size.width, normalImage.size.height);
    [_centerBtn setImage:normalImage forState:UIControlStateNormal];
    
//    去除选择时高亮
    _centerBtn.adjustsImageWhenHighlighted = NO;
//---------------------------根据需要选择是否保留和设置-------------------------------
//    调整图片突出的位置
    _centerBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - normalImage.size.width)/2.0, - normalImage.size.height/2.0, normalImage.size.width, normalImage.size.height);
//    给按钮设置边框
//    _centerBtn.layer.masksToBounds = YES;
//    _centerBtn.layer.cornerRadius = _centerBtn.frame.size.width / 2;
//    _centerBtn.layer.borderWidth = 5;
//    _centerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    CGFloat borderWidth = 5;
    UIView *btnLayerView = [[UIView alloc]initWithFrame:(CGRect){_centerBtn.frame.origin.x - borderWidth, _centerBtn.frame.origin.y - borderWidth, _centerBtn.frame.size.width + 2 * borderWidth, _centerBtn.frame.size.height + 2 * borderWidth}];
    btnLayerView.backgroundColor = [UIColor whiteColor];
    btnLayerView.layer.masksToBounds = YES;
    btnLayerView.layer.cornerRadius = btnLayerView.frame.size.width / 2;
    [self addSubview:btnLayerView];
//------------------------------------------------------------------------------
    [self addSubview:_centerBtn];
//    去除Tabbar上方黑线
    [self setBackgroundImage:[self ChangeUIColorToUIImage:[UIColor whiteColor]]];
    [self setShadowImage:[self ChangeUIColorToUIImage:[UIColor whiteColor]]];
}
#pragma mark 颜色转化为图片
- (UIImage *)ChangeUIColorToUIImage: (UIColor *) color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.hidden) {
        return [super hitTest:point withEvent:event];
    }else {
//        转换坐标
        CGPoint tempPoint = [self.centerBtn convertPoint:point fromView:self];
//        判断点击的点是否在按钮区域内
        if (CGRectContainsPoint(self.centerBtn.bounds, tempPoint)) {
//            返回按钮
            return _centerBtn;
        }else {
            return [super hitTest:point withEvent:event];
        }
    }
}
@end
