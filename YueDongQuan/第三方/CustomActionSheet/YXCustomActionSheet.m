//
//  YXCustomActionSheet.m
//  YXCustomActionSheet
//
//  Created by Houhua Yan on 16/7/14.
//  Copyright © 2016年 YanHouhua. All rights reserved.
//

#import "YXCustomActionSheet.h"

//#define RGB(r, g, b)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define ColumnNum 4

@interface YXCustomActionSheet()
{
    UIView *_backView;
}
@end

@implementation YXCustomActionSheet


- (void) showInView:(UIView *)superView contentArray:(NSArray *)contentArray
{
    if (contentArray == nil || contentArray.count < 1) {
        return;
    }
    self.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    
    [self addBackView:superView];

    CGFloat btnW = 60;
    CGFloat btnH = 60;
    int marginY = 15;
    CGFloat firstY = 10;
    
    for (int i = 0; i < contentArray.count; i++) {
        NSDictionary *dic = [contentArray objectAtIndex:i];
        NSString *name = dic[@"name"];
        NSString *icon = dic[@"icon"];
        YXActionSheetButton *btn = [YXActionSheetButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:name forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor whiteColor];
        
        CGFloat marginX = (self.frame.size.width - ColumnNum * btnW) / (ColumnNum + 1);
        int col = i % ColumnNum;
        int row = i / ColumnNum;
        CGFloat btnX = marginX + (marginX + btnW) * col;
        CGFloat btnY = firstY + (marginY + btnH) * row;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:btn];
    }
    
//    //分享到
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.text = @"分 享";
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.font = [UIFont boldSystemFontOfSize:17];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.textColor = RGB(81, 95, 108);
//    titleLabel.frame = CGRectMake(0, 10, self.frame.size.width, 30);
//    [self addSubview:titleLabel];
    
    
    //计算frame
    [superView addSubview:self];
    
    NSUInteger row = (contentArray.count - 1) / ColumnNum;
    CGFloat height = firstY + 50 + (row +1) * (btnH + marginY);
    
    CGFloat originY = [UIScreen mainScreen].bounds.size.height;
    self.frame = CGRectMake(0, originY, 0, height);
    [UIView animateWithDuration:0.25 animations:^{
        CGRect sF = self.frame;
        sF.origin.y = [UIScreen mainScreen].bounds.size.height - sF.size.height;
        self.frame = sF;
    }];

    //取消
    UIButton *canleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat canW = self.frame.size.width;
    CGFloat canH = 44;
    CGFloat canY = self.frame.size.height - canH;
    canleBtn.backgroundColor = [UIColor colorWithRed:0.9176 green:0.9216 blue:0.9255 alpha:1.0];
    canleBtn.frame = CGRectMake(0, canY, canW, canH);
    [canleBtn setTitle:@"取  消" forState:UIControlStateNormal];
    canleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [canleBtn setTitleColor:[UIColor colorWithRed:0.3725 green:0.3765 blue:0.3804 alpha:1.0] forState:UIControlStateNormal];
    [canleBtn addTarget:self action:@selector(tapBg) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:canleBtn];
    
//    //分割线
//    UIView *line = [[UIView alloc] init];
//    CGFloat lineY = CGRectGetMinY(canleBtn.frame)  - 2;
//    line.frame = CGRectMake(40, lineY, [UIScreen mainScreen].bounds.size.width-80, 0.5);
//    line.backgroundColor = RGB(180, 180, 180);
//    [self addSubview:line];
   
}

- (void)setFrame:(CGRect)frame{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    if (frame.size.height <= 0) {
        frame.size.height = 00;
    }
    frame.origin.x = 0;
    [super setFrame:frame];
}


#pragma mark - 添加背景视图
- (void) addBackView:(UIView *) superView
{
    _backView = [[UIView alloc] init];
    _backView.frame = superView.bounds;
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.4;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBg)];
    [_backView addGestureRecognizer:tap];
    [superView addSubview:_backView];
  
}

#pragma mark 点击背景阴影视图触发的方法
- (void)tapBg{
    [_backView removeFromSuperview];
    _backView = nil;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect sf = self.frame;
        sf.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.frame = sf;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark 按钮被点击了
- (void)btnClick:(YXActionSheetButton *)btn{
    
    if ([_delegate respondsToSelector:@selector(customActionSheetButtonClick:)]) {
        [_delegate customActionSheetButtonClick:btn];
    }
    
    [self tapBg];
}


@end
