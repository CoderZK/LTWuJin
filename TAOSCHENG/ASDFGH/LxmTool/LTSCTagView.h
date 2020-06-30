//
//  LTSCTagView.h
//  54校园
//
//  Created by songnaiyin on 2018/8/14.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LTSCTagViewDidSelectedBlock)(NSString *str, NSInteger index);

@interface LTSCTagView : UIView

@property (nonatomic, copy) LTSCTagViewDidSelectedBlock didSelectedBlock;
//默认-1 不选中
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)setTags:(NSArray <NSString *>*)tags;

- (CGFloat)getViewHeight;

@property (nonatomic, assign) NSInteger cellFontSize;
@property (nonatomic, assign) NSInteger cellHeight;
@property (nonatomic, assign) CGFloat cellCornerRadius;

@property (nonatomic, strong) UIColor *textNormalColor;
@property (nonatomic, strong) UIColor *textSelectedColor;
@property (nonatomic, strong) UIColor *bgNormalColor;
@property (nonatomic, strong) UIColor *bgSelectedColor;
@property (nonatomic, strong) UIColor *borderNormalColor;
@property (nonatomic, strong) UIColor *borderSelectedColor;


@end


@interface LTSCTagViewCell: UICollectionViewCell

@property (nonatomic, assign) NSInteger cellFontSize;
@property (nonatomic, assign) CGFloat cellCornerRadius;

@property (nonatomic, strong) UIColor *textNormalColor;
@property (nonatomic, strong) UIColor *textSelectedColor;
@property (nonatomic, strong) UIColor *bgNormalColor;
@property (nonatomic, strong) UIColor *bgSelectedColor;
@property (nonatomic, strong) UIColor *borderNormalColor;
@property (nonatomic, strong) UIColor *borderSelectedColor;

@property (nonatomic, strong) UILabel *label;

@end
