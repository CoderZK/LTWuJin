//
//  LTSCHomeItemView.m
//  mag
//
//  Created by 李晓满 on 2018/7/3.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LTSCBianMinItemView.h"
#import "LTSCPagingLayout.h"
@interface LTSCBianMinItemView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , strong)UICollectionView * collectionView;

@property (nonatomic , strong)NSArray * items;

@property (nonatomic, strong) UIPageControl *pageControl;

@end
@implementation LTSCBianMinItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        LTSCPagingLayout * layout = [[LTSCPagingLayout alloc] init];
        layout.itemSize = CGSizeMake(ScreenW / 5.0 , 90);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.pagingEnabled = YES;
        [self addSubview:self.collectionView];
        [self.collectionView registerClass:[LTSCBianMinItemCell class] forCellWithReuseIdentifier:@"LTSCBianMinItemCell"];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.bounds.size.width - 100)*0.5, CGRectGetMaxY(self.collectionView.frame)+ 5, 100, 5)];
        self.pageControl.hidesForSinglePage = YES;
        self.pageControl.pageIndicatorTintColor = CharacterGrayColor;
        self.pageControl.currentPageIndicatorTintColor = SCRedColor;
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr{
    self.items = dataArr;
    NSInteger page = ceil(self.items.count/10.0);
    self.pageControl.numberOfPages = page;
    CGSize size = [self.pageControl sizeForNumberOfPages:page];
    self.pageControl.frame = CGRectMake((self.bounds.size.width - size.width)*0.5, CGRectGetMaxY(self.collectionView.frame)+ 5, size.width, 5);
    self.pageControl.backgroundColor = UIColor.redColor;
    [self.collectionView reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger toN =  scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.pageControl.currentPage = toN;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LTSCBianMinItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCBianMinItemCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    LTSCPublicModel *model = self.items[indexPath.item];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.type_pic] placeholderImage: [UIImage imageNamed:[NSString stringWithFormat:@"%d",(int)(indexPath.item+1)]] options:SDWebImageRetryFailed];
    cell.titleLab.text = model.type_name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.didselectItem) {
        self.didselectItem(self.items[indexPath.item]);
    }
}

@end



@implementation LTSCBianMinItemCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [[UIImageView alloc] init];
        self.imgView.layer.cornerRadius = 25;
        self.imgView.layer.masksToBounds = YES;
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.textColor = CharacterDarkColor;
        self.titleLab.font = [UIFont systemFontOfSize:14];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.imgView];
        [self addSubview:self.titleLab];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.centerX.equalTo(self);
            make.width.height.equalTo(@50);
        }];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(5);
            make.leading.equalTo(self).offset(3);
            make.right.equalTo(self).offset(-3);
            make.height.equalTo(@20);
        }];
        
    }
    return self;
}
@end

