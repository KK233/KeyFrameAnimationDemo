//
//  ViewController.m
//  Animation
//
//  Created by 张琰博 on 15/11/3.
//  Copyright © 2015年 ZYB. All rights reserved.
//

#define kBackgroundColorOrange [UIColor colorWithRed:205/255.0 green:182/255.0 blue:126/255.0 alpha:1]
#define kBackgroundColorGreen [UIColor colorWithRed:74/255.0 green:201/255.0 blue:106/255.0 alpha:1]
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#import "ViewController.h"
#import "UIView+zyb_frame.h"

@interface ViewController ()
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *treeImageView;
@property (nonatomic, strong) UIImageView *sunImageView;
@property (nonatomic, strong) UIImageView *cloudImageView;
@property (nonatomic, strong) UIImageView *houseImageView;
@property (nonatomic, strong) UIImageView *carImageView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation ViewController

static CGFloat sunViewWH = 150;
static CGFloat carWidth = 50;

- (void)viewDidLoad {
    [super viewDidLoad];
    // set backgroudColor
    self.view.backgroundColor = kBackgroundColorOrange;
    
    //add view
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.lineView];
    [self.view insertSubview:self.treeImageView belowSubview:self.bottomView];
    [self.view addSubview:self.sunImageView];
    [self.view addSubview:self.cloudImageView];
    [self.view insertSubview:self.houseImageView belowSubview:self.treeImageView];
    [self.view insertSubview:self.carImageView aboveSubview:self.houseImageView];
    
}

#pragma mark - event response

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self startAnimation];
    
    //set self.view' user interaction to NO
    self.view.userInteractionEnabled = NO;
}

#pragma mark - private method

- (void)startAnimation {
   
    //start animation
    NSTimeInterval totalTime = 5.0;
    CGFloat animationCount = 5.0;
    double eachAnimationTime = 1.0 / animationCount;
    
    [UIView animateKeyframesWithDuration:totalTime delay:0 options:kNilOptions animations:^{
        
        //0.blackline
        [UIView addKeyframeWithRelativeStartTime:eachAnimationTime * 0.0 relativeDuration:eachAnimationTime animations:^{
            self.lineView.width = kScreenWidth * 0.95;
            self.lineView.centerX = kScreenWidth * 0.5;
        }];
        
        //1.tree
        [UIView addKeyframeWithRelativeStartTime:eachAnimationTime * 1.0 relativeDuration:eachAnimationTime animations:^{
            self.treeImageView.alpha = 0.99;
        }];
        
        //2.sun cloud & house
        [UIView addKeyframeWithRelativeStartTime:eachAnimationTime * 2.0 relativeDuration:eachAnimationTime animations:^{
            //sun
            self.sunImageView.width = sunViewWH * 1.2;
            self.sunImageView.height = sunViewWH * 1.2;
            self.sunImageView.center = CGPointMake((kScreenWidth - sunViewWH / 2.0) * 0.3, (kScreenHeight - sunViewWH / 2.0) * 0.35);
            //cloud
            self.cloudImageView.alpha = 0.99;
            //house
            self.houseImageView.y = kScreenHeight - self.bottomView.height - self.houseImageView.height + 50;
        }];
        
        //3. scale sun to origin
        [UIView addKeyframeWithRelativeStartTime:eachAnimationTime * 3.0 relativeDuration:eachAnimationTime animations:^{
            self.sunImageView.width = sunViewWH;
            self.sunImageView.height = sunViewWH;
            self.sunImageView.center = CGPointMake((kScreenWidth - sunViewWH / 2.0) * 0.3, (kScreenHeight - sunViewWH / 2.0) * 0.35);
            self.houseImageView.y = kScreenHeight - self.bottomView.height - self.houseImageView.height;
        }];
        
        //4. car & sun
        [UIView addKeyframeWithRelativeStartTime:eachAnimationTime * 4.0 relativeDuration:eachAnimationTime animations:^{
            //car
            self.carImageView.x = kScreenWidth + self.carImageView.width;
            //sun
            self.sunImageView.x = kScreenWidth - self.sunImageView.x - 200;
            self.sunImageView.y += 50;
        }];
        
    } completion:^(BOOL finished) {
        //set red backgroundcolor
        if (finished) {
            [self setBackgroundColorGreen];
            [self.view addSubview:self.topLabel];
            [self.view addSubview:self.bottomLabel];
            
            //label animation
            [UIView animateWithDuration:2.0 delay:1.5 options:kNilOptions animations:^{
                self.topLabel.alpha = 0.99;
            } completion:^(BOOL finished) {
                
                if (finished) {
                    [UIView animateWithDuration:2.0 animations:^{
                        self.bottomLabel.alpha = 0.99;
                    }];
                }
                self.view.userInteractionEnabled = YES;
            }];
        }
    }];
}

//set backgroundcolor green and start circle animation
- (void)setBackgroundColorGreen {
    int radius = 500;
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius) cornerRadius:radius].CGPath;
    circle.position = CGPointMake(self.view.centerX - radius, self.view.centerY - radius);

    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = kBackgroundColorGreen.CGColor;
    circle.lineWidth = 1000;
    
    //add to circle layer
    [self.view.layer addSublayer:circle];
    
    //animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration = 1.0;
    drawAnimation.repeatCount = 1.0;
    
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0];
    
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];

}

#pragma mark - setter / getter

- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight * 0.7, kScreenWidth, kScreenHeight * 0.3)];
        bottomView.backgroundColor = kBackgroundColorOrange;
        _bottomView = bottomView;
    }
    return _bottomView;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView *lineView = [[UIView alloc] init];
        lineView.center = CGPointMake(kScreenWidth * 0.5, 0);
        lineView.backgroundColor = [UIColor blackColor];
        lineView.height = 1;
        lineView.width = 1;
        _lineView = lineView;
    }
    return _lineView;
}

- (UIImageView *)treeImageView {
    if (!_treeImageView) {
        UIImageView *treeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tree"]];
        treeImageView.height = treeImageView.width / kScreenWidth * treeImageView.height * 0.7;
        treeImageView.width = kScreenWidth * 0.7;
        treeImageView.centerX = kScreenWidth * 0.5;
        treeImageView.y = kScreenHeight - self.bottomView.height - treeImageView.height;
        treeImageView.alpha = 0.0;
        _treeImageView = treeImageView;
    }
    return _treeImageView;
}

- (UIImageView *)cloudImageView {
    if (!_cloudImageView) {
        UIImageView *cloudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud"]];
        //fit screen
        cloudImageView.height = cloudImageView.height * kScreenWidth / cloudImageView.width * 0.8;
        cloudImageView.width = kScreenWidth * 0.8;
        cloudImageView.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.4);

        cloudImageView.alpha = 0.0;
        _cloudImageView = cloudImageView;
    }
    return _cloudImageView;
}

- (UIImageView *)houseImageView {
    if (!_houseImageView) {
        UIImageView *houseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"house"]];
        houseImageView.height =(kScreenWidth * 0.95 - 50) / houseImageView.width * houseImageView.height;
        houseImageView.width = kScreenWidth * 0.95 - 50;
        houseImageView.centerX = kScreenWidth * 0.5;
        houseImageView.y = self.bottomView.y;
        
        _houseImageView = houseImageView;
    }
    return _houseImageView;
}

- (UIImageView *)sunImageView {
    if (!_sunImageView) {
        UIImageView *sunImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sun"]];
        sunImageView.width = 0.1;
        sunImageView.height = 0.1;
        sunImageView.center = CGPointMake((kScreenWidth - sunViewWH / 2.0) * 0.3, (kScreenHeight - sunViewWH / 2.0) * 0.35);
        
        _sunImageView = sunImageView;
    }
    return _sunImageView;
}

- (UIImageView *)carImageView {
    if (!_carImageView) {
        UIImageView *carImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"car"]];
        
        carImageView.height = carWidth / carImageView.width * carImageView.height;
        carImageView.width = carWidth;
        
        carImageView.x = - carWidth;
        carImageView.y = kScreenHeight - self.bottomView.height - carImageView.height;
        
        _carImageView = carImageView;
    }
    return _carImageView;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"AAAB";
        label.font = [UIFont boldSystemFontOfSize:35];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        label.centerX = self.view.centerX;
        label.centerY = self.view.centerY - 50;
        label.alpha = 0.0;
        _topLabel = label;
    }
    return _topLabel;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"CCCDEEFF";
        label.font = [UIFont systemFontOfSize:25];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        label.centerX = self.view.centerX;
        label.centerY = self.view.centerY;
        label.alpha = 0.0;
        _bottomLabel = label;
    }
    return _bottomLabel;
}

@end
