//
//  TabBarController.m
//  Animated Icon
//
//  Created by 沈凯 on 2018/4/10.
//  Copyright © 2018年 Ssky. All rights reserved.
//

#import "TabBarController.h"
#import "TabBar.h"
@interface TabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) TabBar *tabbar;
@property (assign, nonatomic) BOOL isAnimation;
@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    self.delegate = self;
    _isAnimation = NO;
    
}
- (void)loadUI {
    _tabbar = [TabBar new];
    [_tabbar.centerBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    选中时的颜色
    [self setValue:_tabbar forKey:@"tabBar"];
    
    [self loadViewControllers];
}

- (void)loadViewControllers {
//    中间为设置的图片视图
    NSArray *titles = @[@"Title1",@"Title2",@"",@"Title3",@"Title4"];
    NSMutableArray *clts = [NSMutableArray array];
    for (int i = 0; i < titles.count; i++) {
        UIViewController *vc = [UIViewController new];
        vc.title = titles[i];
//------------------------------根据需求设置Tabbar其他iTem格式--------------------------------
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:18/255.0 green:150/255.0 blue:219/255.0 alpha:1], NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateSelected];
        vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -15);
        CGFloat red = (arc4random() % 255) / 255.0;
        CGFloat green = (arc4random() % 255) / 255.0;
        CGFloat blue = (arc4random() % 255) / 255.0;
        vc.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
//----------------------------------------------------------------------------------------
        [clts addObject:vc];
    }
    self.viewControllers = clts;
}

- (void)buttonAction:(UIButton *)button {
    self.selectedIndex = 2;//关联中间按钮
    if ([_tabbar.centerBtn.layer.animationKeys containsObject:@"key"] && _isAnimation == YES) {
        [self pauseAnimationInCurrentState:YES];
    }else {
        [self rotationAnimation];
    }
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex != 2 && _isAnimation == YES){//选中中间的按钮
        [self pauseAnimationInCurrentState:YES];
    }
}
//旋转动画
- (void)rotationAnimation{
//    继续旋转
    if ([_tabbar.centerBtn.layer.animationKeys containsObject:@"key"]) {
        CFTimeInterval pauseTime = _tabbar.centerBtn.layer.timeOffset;
        CFTimeInterval begin = CACurrentMediaTime() - pauseTime;
        
        [_tabbar.centerBtn.layer setTimeOffset:0];
        [_tabbar.centerBtn.layer setBeginTime:begin];
        
        _tabbar.centerBtn.layer.speed = 1;
        
    }else {
//        开始旋转
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
        rotationAnimation.duration = 2.0;
        rotationAnimation.repeatCount = HUGE;
        [_tabbar.centerBtn.layer addAnimation:rotationAnimation forKey:@"key"];
    }
    _isAnimation = YES;
}

/**
 暂停动画
 @param isCurrent 是否暂停到当前状态
 */
- (void)pauseAnimationInCurrentState:(BOOL)isCurrent{
    if (isCurrent) {
        //1.取出当前时间，转成动画暂停的时间
        CFTimeInterval pauseTime = [_tabbar.centerBtn.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        
        //2.设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
        _tabbar.centerBtn.layer.timeOffset = pauseTime;
        
        //3.将动画的运行速度设置为0， 默认的运行速度是1.0
        _tabbar.centerBtn.layer.speed = 0;

    }else {
        [_tabbar.centerBtn.layer removeAllAnimations];
    }
    _isAnimation = NO;
}
@end
