//
//  LTSCPagingLayout.m
//  shenbian
//
//  Created by 宋乃银 on 2018/11/11.
//  Copyright © 2018 李晓满. All rights reserved.
//

#import "LTSCPagingLayout.h"

@interface LTSCPagingLayout ()
{
    CGFloat _itemSpacing;
    CGFloat _lineSpacing;
    int _row;
    int _column;
    int _pageNumber;
}
@property (nonatomic, strong) NSMutableArray *attributes;

@end

@implementation LTSCPagingLayout

- (instancetype)init {
    if (self = [super init]) {
        self.attributes = [NSMutableArray new];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout]; //需调用父类方法
    
    CGFloat itemWidth = self.itemSize.width;
    CGFloat itemHeight = self.itemSize.height;
    
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat height = self.collectionView.frame.size.height;
    
    CGFloat contentWidth = (width - self.sectionInset.left - self.sectionInset.right);
    if (contentWidth >= (2*itemWidth+self.minimumInteritemSpacing)) { //如果列数大于2行
        int m = (contentWidth-itemWidth)/(itemWidth+self.minimumInteritemSpacing);
        _column = m+1;
        int n = (int)(contentWidth-itemWidth)%(int)(itemWidth+self.minimumInteritemSpacing);
        if (n > 0) {
            double offset = ((contentWidth-itemWidth) - m*(itemWidth+self.minimumInteritemSpacing))/m;
            _itemSpacing = self.minimumInteritemSpacing + offset;
        } else if (n == 0) {
            _itemSpacing = self.minimumInteritemSpacing;
        }
    } else { //如果列数为一行
        _itemSpacing = 0;
        _column = 1;
    }
    
    CGFloat contentHeight = (height - self.sectionInset.top - self.sectionInset.bottom);
    if (contentHeight >= (2*itemHeight+self.minimumLineSpacing)) { //如果行数大于2行
        int m = (contentHeight-itemHeight)/(itemHeight+self.minimumLineSpacing);
        _row = m+1;
        int n = (int)(contentHeight-itemHeight)%(int)(itemHeight+self.minimumLineSpacing);
        if (n > 0) {
            double offset = ((contentHeight-itemHeight) - m*(itemHeight+self.minimumLineSpacing))/m;
            _lineSpacing = self.minimumLineSpacing + offset;
        } else if (n == 0) {
            _lineSpacing = self.minimumInteritemSpacing;
        }
    } else { //如果行数数为一行
        _lineSpacing = 0;
        _row = 1;
    }
    
    _pageNumber = ceil([self.collectionView numberOfItemsInSection:0]/(_row*_column*1.0));
}
//不要删除 此段代码用作自动网格对齐  不过设置了collectionView.pagingEnabled = YES;暂无用
//- (CGPoint)targetContentOffsetForProposedContentOffset: (CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity //自动对齐到网格
//{
//    //proposedContentOffset是没有对齐到网格时本来应该停下的位置
//    CGFloat offsetY = MAXFLOAT;
//    CGFloat offsetX = MAXFLOAT;
//    CGFloat horizontalCenter = proposedContentOffset.x + self.itemSize.width/2;
//    CGFloat verticalCenter = proposedContentOffset.y + self.itemSize.height/2;
//    CGRect targetRect = CGRectMake(0, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
//    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
//
//    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
//    CGPoint offPoint = proposedContentOffset;
//    for (UICollectionViewLayoutAttributes* layoutAttributes in array)
//    {
//        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
//        CGFloat itemVerticalCenter = layoutAttributes.center.y;
//        if (ABS(itemHorizontalCenter - horizontalCenter) && (ABS(offsetX)>ABS(itemHorizontalCenter - horizontalCenter)))
//        {
//            offsetX = itemHorizontalCenter - horizontalCenter;
//            offPoint = CGPointMake(itemHorizontalCenter, itemVerticalCenter);
//        }
//        if (ABS(itemVerticalCenter - verticalCenter) && (ABS(offsetY)>ABS(itemVerticalCenter - verticalCenter)))
//        {
//            offsetY = itemHorizontalCenter - horizontalCenter;
//            offPoint = CGPointMake(itemHorizontalCenter, itemVerticalCenter);
//        }
//    }
//    return offPoint;
//}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width*_pageNumber, self.collectionView.bounds.size.height);
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect frame;
    frame.size = self.itemSize;
    //下面计算每个cell的frame   可以自己定义
    long number = _row * _column;
    long m = 0;  //初始化 m p //当前第几行
    long p = 0;
    if (indexPath.item >= number) {
        p = indexPath.item/number;  //计算页数不同时的左间距
        m = (indexPath.item%number)/_column;
    } else {
        m = indexPath.item/_column;
    }
    
    long n = indexPath.item%_column; //当前第几个
    frame.origin = CGPointMake(n*self.itemSize.width+(n)*_itemSpacing+self.sectionInset.left+(indexPath.section+p)*self.collectionView.frame.size.width,m*self.itemSize.height + (m)*_lineSpacing+self.sectionInset.top);
    attribute.frame = frame;
    return attribute;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *tmpAttributes = [NSMutableArray new];
    for (int j = 0; j < self.collectionView.numberOfSections; j++) {
        NSInteger count = [self.collectionView numberOfItemsInSection:j];
        for (NSInteger i = 0; i < count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:j];
            [tmpAttributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    self.attributes = tmpAttributes;
    return self.attributes;
}

- (BOOL)shouldinvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    return !CGSizeEqualToSize(oldBounds.size, newBounds.size);
}



@end
