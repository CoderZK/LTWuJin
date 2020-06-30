//
//  WelcomeVC.m
//  Elem1
//
//  Created by sny on 15/9/23.
//  Copyright (c) 2015年 cznuowang. All rights reserved.
//

#import "WelcomeVC.h"

@interface WelcomeVC ()<UIScrollViewDelegate>
{
    UIPageControl *_pageC;
    UIScrollView *_scrollVC;
}
@end

@implementation WelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollVC = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _scrollVC.contentSize = CGSizeMake(_scrollVC.bounds.size.width*self.imgArr.count, _scrollVC.bounds.size.height);
    _scrollVC.pagingEnabled = YES;
    _scrollVC.backgroundColor = [UIColor whiteColor];
    _scrollVC.showsHorizontalScrollIndicator = NO;
    _scrollVC.delegate = self;
    [self.view addSubview:_scrollVC];
    
    for (int i = 0; i<self.imgArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollVC.bounds.size.width*i, 0, _scrollVC.bounds.size.width, _scrollVC.bounds.size.height)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:[self.imgArr objectAtIndex:i]];
        [_scrollVC addSubview:imgView];
        
        
        _pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-100, self.view.bounds.size.height-160, 200, 20)];
        _pageC.numberOfPages = _imgArr.count;
        _pageC.currentPage = 0;
        [_pageC addTarget:self action:@selector(PageClick:) forControlEvents:UIControlEventValueChanged];
        _pageC.currentPageIndicatorTintColor = [UIColor clearColor];
        _pageC.pageIndicatorTintColor = [UIColor lightGrayColor];
//        [self.view addSubview:_pageC];
    }
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((_imgArr.count-1)*self.view.bounds.size.width, self.view.bounds.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height/2)];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollVC addSubview:btn];
}

-(void)btnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(WelcomeVC:)]) {
        [self.delegate WelcomeVC:self];
    }
}

-(void)PageClick:(UIPageControl *)pageControl {
    NSInteger value = pageControl.currentPage;
    [_scrollVC setContentOffset:CGPointMake(value*self.view.bounds.size.width, 0) animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger value = scrollView.contentOffset.x/self.view.bounds.size.width;
    _pageC.currentPage = value;
}


@end
