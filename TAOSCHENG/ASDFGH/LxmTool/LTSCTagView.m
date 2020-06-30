//
//  LTSCTagView.m
//  54校园
//
//  Created by songnaiyin on 2018/8/14.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LTSCTagView.h"
#import "LTSCTagLayout.h"

@interface LTSCTagView () <UICollectionViewDelegate, UICollectionViewDataSource, LTSCTagLayoutDelegate>
{
	UICollectionView *_collectionView;
	LTSCTagLayout *_layout;
	NSArray <NSString *>* _tags;
}
@end

@implementation LTSCTagView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
        _cellHeight = 27;
        _cellFontSize = self.cellFontSize;
        _cellCornerRadius = self.cellCornerRadius;
        _bgNormalColor = BGGrayColor;
        _bgSelectedColor = BGGrayColor;
        _textNormalColor = UIColor.blackColor;
        _textSelectedColor = UIColor.blackColor;
        _borderNormalColor = UIColor.clearColor;
        _borderSelectedColor = UIColor.clearColor;
        
        _selectedIndex = -1;
		self.backgroundColor = [UIColor whiteColor];
		_layout = [[LTSCTagLayout alloc] init];
		_layout.delegate = self;
		_collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
		_collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_collectionView.backgroundColor = [UIColor clearColor];
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		[_collectionView registerClass:[LTSCTagViewCell class] forCellWithReuseIdentifier:@"LTSCTagViewCell"];
		[self addSubview:_collectionView];
	}
	return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [_collectionView reloadData];
}

- (void)setTags:(NSArray <NSString *>*)tags {
	_tags = tags;
	[_collectionView reloadData];
}

- (CGFloat)getViewHeight {
	return [_layout getSectionHeight:0 forMaxWidth:ScreenW];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return _tags.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	LTSCTagViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTSCTagViewCell" forIndexPath:indexPath];
    cell.cellFontSize = _cellFontSize;
    cell.cellCornerRadius = _cellCornerRadius;
    
    cell.textNormalColor = _textNormalColor;
    cell.textSelectedColor = _textSelectedColor;
    cell.bgNormalColor = _bgNormalColor;
    cell.bgSelectedColor = _bgSelectedColor;
    cell.borderNormalColor = _borderNormalColor;
    cell.borderSelectedColor = _borderSelectedColor;
	cell.label.text = _tags[indexPath.item];
    cell.selected = (_selectedIndex == indexPath.item);
	return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.didSelectedBlock) {
        self.didSelectedBlock(_tags[indexPath.item], indexPath.item);
    }
}


#pragma mark - LTSCTagLayoutDelegate

/**
 返回每个item的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(LTSCTagLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	NSString *tag = _tags[indexPath.item];
	CGFloat contentWidth = [tag getSizeWithMaxSize:CGSizeMake(300, 40) withFontSize:13].width;
	return CGSizeMake(contentWidth + 20, _cellHeight) ;
}

/**
 section的边距
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(LTSCTagLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(10, 10, 10, 2);
}
/**
 item的行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(LTSCTagLayout*)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section {
	return 10;
}
/**
 item的横向间隔
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(LTSCTagLayout*)collectionViewLayout itemSpacingForSectionAtIndex:(NSInteger)section {
	return 10;
}

@end

@implementation LTSCTagViewCell

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_label = [[UILabel alloc] initWithFrame:self.bounds];
		_label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_label.backgroundColor = BGGrayColor;
		_label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = CharacterDarkColor;
        _label.layer.borderWidth = 0.5;
        _label.layer.borderColor = BGGrayColor.CGColor;
        _label.layer.masksToBounds = YES;
		[self addSubview:_label];
	}
	return self;
}

- (void)setCellFontSize:(NSInteger)cellFontSize {
    if (_cellFontSize != cellFontSize) {
        _cellFontSize = cellFontSize;
        _label.font = [UIFont systemFontOfSize:_cellFontSize];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.isSelected) {
        _label.backgroundColor = self.bgSelectedColor;
        _label.textColor = self.textSelectedColor;
        _label.layer.borderColor = self.borderSelectedColor.CGColor;
    } else {
        _label.backgroundColor = self.bgNormalColor;
        _label.textColor = self.textNormalColor;
        _label.layer.borderColor = self.borderNormalColor.CGColor;
    }
}

- (void)layoutSubviews {
	[super layoutSubviews];
	_label.layer.cornerRadius = self.cellCornerRadius;
	_label.layer.masksToBounds = true;
}

@end
