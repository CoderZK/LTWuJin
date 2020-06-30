//
//  SNY_SearchTagLayout.h
//  Fenxiao
//
//  Created by sny on 15/6/8.
//  Copyright (c) 2015年 sny. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LTSCTagLayoutDelegate;

@interface LTSCTagLayout : UICollectionViewLayout

@property(nonatomic, weak)id<LTSCTagLayoutDelegate,UICollectionViewDataSource> delegate;

- (CGFloat)getSectionHeight:(NSInteger)section forMaxWidth:(CGFloat)width;

@end

@protocol LTSCTagLayoutDelegate <UICollectionViewDelegate>

/**
 返回每个item的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(LTSCTagLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

/**
 section的边距
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(LTSCTagLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
/**
 item的行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(LTSCTagLayout*)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section;
/**
 item的横向间隔
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(LTSCTagLayout*)collectionViewLayout itemSpacingForSectionAtIndex:(NSInteger)section;
/**
 section head size
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(LTSCTagLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
/**
 section foot size
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(LTSCTagLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

@end
