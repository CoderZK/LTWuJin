//
//  LTSCPagingLayout.h
//  shenbian
//
//  Created by 宋乃银 on 2018/11/11.
//  Copyright © 2018 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTSCPagingLayout : UICollectionViewLayout

/**
 行间距
 */
@property (nonatomic) CGFloat minimumLineSpacing;

/**
 item间距
 */
@property (nonatomic) CGFloat minimumInteritemSpacing;

/**
 item大小
 */
@property (nonatomic) CGSize itemSize;

@property (nonatomic) UIEdgeInsets sectionInset;

- (instancetype)init;



@end

NS_ASSUME_NONNULL_END
