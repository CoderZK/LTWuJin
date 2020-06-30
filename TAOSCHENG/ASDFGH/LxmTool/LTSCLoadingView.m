//
//  LTSCLoadingView.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/6/6.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCLoadingView.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

@interface LTSCLoadingView()

@property (nonatomic, strong) FLAnimatedImageView *loadImgView;

@end

@implementation LTSCLoadingView

- (FLAnimatedImageView *)loadImgView {
    if (!_loadImgView) {
        _loadImgView = [[FLAnimatedImageView alloc] init];
        FLAnimatedImage *img = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"]]];
        _loadImgView.animatedImage = img;
    
    }
    return _loadImgView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.loadImgView];
        [self.loadImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.equalTo(@60);
        }];
    }
    return self;
}

+ (void)show {
    [self dismiss];
    LTSCLoadingView *loadView = [[LTSCLoadingView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    loadView.tag = 123456;
    [[UIApplication sharedApplication].keyWindow addSubview:loadView];
}

+ (void)dismiss {
    UIView *preView = [[UIApplication sharedApplication].keyWindow viewWithTag:123456];
    [preView removeFromSuperview];
}

@end
