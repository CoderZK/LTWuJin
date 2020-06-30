//
//  LTSCStarView.m
//  DefineStarSelected
//
//  Created by 李晓满 on 15/11/13.
//  Copyright © 2015年 李晓满. All rights reserved.
//

#import "LTSCStarView.h"

@interface LTSCStarView ()
{
    NSMutableArray *_starState;
    NSInteger _aa;
}

@end

@implementation LTSCStarView
-(instancetype)initWithFrame:(CGRect)frame withSpace:(CGFloat)space {
    if (self=[super initWithFrame:frame]) {
        [self setupSubViewsAndSpace:space];
    }
    return self;
}

-(void)setupSubViewsAndSpace:(CGFloat)space {
    
    _starState=[NSMutableArray array];
    
    for (int i=0; i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(((self.frame.size.width - 4*space)/5+space)*i, (self.frame.size.height-(self.frame.size.width-4*space)/5)/2, (self.frame.size.width-4*space)/5, (self.frame.size.width-4*space)/5);
        [btn setBackgroundImage:[UIImage imageNamed:@"star_n"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"star_y"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i;
        [self addSubview:btn];
        [_starState addObject:btn];
    }
}

-(void)btnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(LTSCStarView:didClickStar:)]) {
        [self.delegate LTSCStarView:self didClickStar:btn.tag + 1];
    }
    [self setStarNum:btn.tag+1];
}

-(void)setStarNum:(NSUInteger)starNum {
    if (starNum <= _starState.count) {
        _starNum = starNum;
        for (int i = 0; i < _starState.count; i ++) {
            UIButton * btn = [_starState objectAtIndex:i];
            btn.selected = btn.tag<_starNum;
        }
    }
}

@end
