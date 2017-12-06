//
//  ViewController.m
//  WLButtonDemo
//
//  Created by 王垒 on 16/9/6.
//  Copyright © 2016年 王垒. All rights reserved.
//

#import "ViewController.h"

#import "WLButton.h"

#define WLWindowWidth ([[UIScreen mainScreen] bounds].size.width)

#define WLWindowHeight ([[UIScreen mainScreen] bounds].size.height)

@interface ViewController ()
{
    UIView *tabBarView;
    WLButton *myButton;
    BOOL flag; //控制tabbar的显示与隐藏标志
    
}
@property (strong, nonatomic) NSArray *buttonArray;// 弹出的按钮数组
@property BOOL isExpanding;// 是否点击过
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    
    
    
}

- (void)addCustomElements
{
    myButton = [WLButton buttonWithType:UIButtonTypeCustom];
    myButton.MoveEnable = YES;
    myButton.frame = CGRectMake(WLWindowWidth - 40,WLWindowHeight - 40, 40, 40);
    
    //TabBar上按键图标设置
    [myButton setBackgroundImage:[UIImage imageNamed:@"submit_pressed"] forState:UIControlStateNormal];
    [myButton setTag:10];
    flag = NO;//控制tabbar的显示与隐藏标志 NO为隐藏
    
    [myButton addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:myButton];
    [self initButton];
    
}


- (void)initButton{
    
    CGPoint buttonCenter = CGPointMake(myButton.frame.size.width / 2.0f, myButton.frame.size.height / 2.0f);
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"submit_pressed"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Tap) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setCenter:buttonCenter];
    [btn1 setAlpha:0.0f];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"sumitmood"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Tap) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setCenter:buttonCenter];
    [btn2 setAlpha:0.0f];
    [self.view addSubview:btn2];
    
    self.buttonArray = [NSArray arrayWithObjects:btn2, btn1, nil];
}

- (void)btnTap:(WLButton *)sender {
    if (!sender.MoveEnabled) {
        if (!self.isExpanding) {// 初始未展开
            CGAffineTransform angle = CGAffineTransformMakeRotation (0);
            [UIView animateWithDuration:0.3 animations:^{// 动画开始
                [sender setTransform:angle];
            } completion:^(BOOL finished){// 动画结束
                [sender setTransform:angle];
                [myButton setBackgroundImage:[UIImage imageNamed:@"btn_quickoption_route"] forState:UIControlStateNormal];
            }];
            
            [self showButtonsAnimated];
            
            self.isExpanding = YES;
        } else {// 已展开
            CGAffineTransform unangle = CGAffineTransformMakeRotation (0);
            [UIView animateWithDuration:0.3 animations:^{// 动画开始
                [sender setTransform:unangle];
            } completion:^(BOOL finished){// 动画结束
                [sender setTransform:unangle];
                [myButton setBackgroundImage:[UIImage imageNamed:@"submit_pressed"] forState:UIControlStateNormal];
            }];
            
            [self hideButtonsAnimated];
            
            self.isExpanding = NO;
        }
    }
}

// 点击按钮1的响应
- (void)btn1Tap {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"打开简书，关注王垒iOS" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [av show];
    
    
}

// 点击按钮2的响应
- (void)btn2Tap {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"Open the book, Jane attention Wang Lei iOS" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
    
}

// 展开按钮
- (void)showButtonsAnimated {
    NSLog(@"animate");
    float y = [myButton center].y;
    float x = [myButton center].x;
    float endY = y;
    float endX = x;
    
    
    
    for (int i = 0; i < [self.buttonArray count]; ++i) {
        UIButton *button = [self.buttonArray objectAtIndex:i];
        // 最终坐标
        endY -= button.frame.size.height + 30.0f;
        endX += 0.0f;
        // 反弹坐标
        float farY = endY - 30.0f;
        float farX = endX - 0.0f;
        float nearY = endY + 15.0f;
        float nearX = endX + 0.0f;
        
        // 动画集合
        NSMutableArray *animationOptions = [NSMutableArray array];
        
        // 旋转动画
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        [rotateAnimation setValues:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * 2], nil]];
        [rotateAnimation setDuration:0.4f];
        [rotateAnimation setKeyTimes:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:1.0f], nil]];
        [animationOptions addObject:rotateAnimation];
        
        // 位置动画
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        [positionAnimation setDuration:0.4f];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, x, y);
        CGPathAddLineToPoint(path, NULL, farX, farY);
        CGPathAddLineToPoint(path, NULL, nearX, nearY);
        CGPathAddLineToPoint(path, NULL, endX, endY);
        [positionAnimation setPath: path];
        CGPathRelease(path);
        [animationOptions addObject:positionAnimation];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        [animationGroup setAnimations: animationOptions];
        [animationGroup setDuration:0.4f];
        [animationGroup setFillMode: kCAFillModeForwards];
        [animationGroup setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        
        NSDictionary *properties = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:button, [NSValue valueWithCGPoint:CGPointMake(endX, endY)], animationGroup, nil] forKeys:[NSArray arrayWithObjects:@"view", @"center", @"animation", nil]];
        
        [self performSelector:@selector(_expand:) withObject:properties afterDelay:0.1f * ([self.buttonArray count] - i)];
    }
}

// 收起动画
- (void) hideButtonsAnimated {
    CGPoint center = [myButton center];
    float endY = center.y;
    float endX = center.x;
    for (int i = 0; i < [self.buttonArray count]; ++i) {
        UIButton *button = [self.buttonArray objectAtIndex:i];
        
        // 动画集合
        NSMutableArray *animationOptions = [NSMutableArray array];
        
        // 旋转动画
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        [rotateAnimation setValues:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * -2], nil]];
        [rotateAnimation setDuration:0.4f];
        [rotateAnimation setKeyTimes:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:1.0f], nil]];
        [animationOptions addObject:rotateAnimation];
        
        // 透明度？
        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setValues:[NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0f], [NSNumber numberWithFloat:0.0f], nil]];
        [opacityAnimation setDuration:0.4];
        [animationOptions addObject:opacityAnimation];
        
        // 位置动画
        float y = [button center].y;
        float x = [button center].x;
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        [positionAnimation setDuration:0.4f];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, x, y);
        CGPathAddLineToPoint(path, NULL, endX, endY);
        [positionAnimation setPath: path];
        CGPathRelease(path);
        [animationOptions addObject:positionAnimation];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        [animationGroup setAnimations: animationOptions];
        [animationGroup setDuration:0.4f];
        [animationGroup setFillMode: kCAFillModeForwards];
        [animationGroup setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        
        NSDictionary *properties = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:button, animationGroup, nil] forKeys:[NSArray arrayWithObjects:@"view", @"animation", nil]];
        [self performSelector:@selector(_close:) withObject:properties afterDelay:0.1f * ([self.buttonArray count] - i)];
    }
}


// 弹出
- (void) _expand:(NSDictionary*)properties
{
    NSLog(@"expand");
    UIView *view = [properties objectForKey:@"view"];
    CAAnimationGroup *animationGroup = [properties objectForKey:@"animation"];
    NSValue *val = [properties objectForKey:@"center"];
    CGPoint center = [val CGPointValue];
    [[view layer] addAnimation:animationGroup forKey:@"Expand"];
    [view setCenter:center];
    [view setAlpha:1.0f];
}

// 收起
- (void) _close:(NSDictionary*)properties
{
    UIView *view = [properties objectForKey:@"view"];
    CAAnimationGroup *animationGroup = [properties objectForKey:@"animation"];
    CGPoint center = [myButton center];
    [[view layer] addAnimation:animationGroup forKey:@"Collapse"];
    [view setAlpha:0.0f];
    [view setCenter:center];
}

////显示 隐藏tabbar
- (void)tabbarbtn:(WLButton*)btn
{
    //在移动的时候不触发点击事件
    if (!btn.MoveEnabled) {
        if(!flag){
            tabBarView.hidden = NO;
            flag = YES;
        }else{
            tabBarView.hidden = YES;
            flag = NO;
        }
    }
    
}

- (void)buttonClicked:(id)sender
{
    NSLog(@"%ld",(long)[sender tag]);
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self addCustomElements];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
@end

