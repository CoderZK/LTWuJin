//
//  LTSCRefreshHeader.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/6/7.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCRefreshHeader.h"
#import <SDWebImage/UIImage+GIF.h>
@implementation LTSCRefreshHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *imgs = [NSMutableArray array];
        UIImage *img = [UIImage sd_imageWithGIFData:[NSData dataWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"refresh.gif" ofType:nil]]];
        
        for (UIImage *imgItem in img.images) {
            NSData *data = UIImagePNGRepresentation(imgItem);
            UIImage *image = [UIImage imageWithData:data scale:3];
            [imgs addObject:image];
        }
        [self setImages:imgs forState:MJRefreshStatePulling];
        [self setImages:imgs forState:MJRefreshStateRefreshing];
        [self setImages:imgs forState:MJRefreshStateIdle];
        self.lastUpdatedTimeLabel.hidden = YES;
        [self setTitle:@"释放即可刷新..." forState:MJRefreshStatePulling];
        [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        [self setTitle:@"下拉即可刷新..." forState:MJRefreshStateIdle];
    }
    return self;
}

@end
