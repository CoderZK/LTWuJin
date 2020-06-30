//
//  LTSCGuiGeView.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2019/5/17.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LTSCGuiGeView.h"
#import "ORSKUDataFilter.h"
#import "LTSCTagLayout.h"
@interface LTSCGuiGeView()<LTSCTagLayoutDelegate,UICollectionViewDataSource, UICollectionViewDelegate,ORSKUDataFilterDataSource>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) LTSCGuiGeTopView *topView;//商品部分

@property (nonatomic, strong) UICollectionView *collectionView;//规格部分

@property (nonatomic, strong) LTSCGuiGeNumView *guiGeNumView;

@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) LTSCGoodsGuiGeBottomView *bottomView1;

@property (nonatomic, strong) ORSKUDataFilter *filter;

@property (nonatomic, assign) CGFloat resH;

@property (nonatomic, strong) LTSCGoodsDetailSUKModel *currentModel;

@property (nonatomic, strong) NSString *tempNum;

@property (nonatomic, assign) BOOL isfull;//规格是否选全

@end

@implementation LTSCGuiGeView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _filter = [[ORSKUDataFilter alloc] initWithDataSource:self];
        [self addTarget:self action:@selector(selfClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.contentView];
        [self initSubViews];
        [self setConstrains];
        [self bottomAction];
    }
    return self;
}

- (void)selfClick {
    [self dismiss];
}

- (void)initSubViews {
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.collectionView];
//    [self.contentView addSubview:self.bottomView];
    [self.contentView addSubview:self.sureButton];
    [self.contentView addSubview:self.bottomView1];
}

- (void)setConstrains {
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@110);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.trailing.leading.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-50);
    }];
//    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.collectionView.mas_bottom);
//        make.leading.trailing.equalTo(self.contentView);
//        make.height.equalTo(@100);
//    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    if (kDevice_Is_iPhoneX) {
        [self.bottomView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.contentView);
            make.height.equalTo(@50);
            make.bottom.equalTo(self.contentView).offset(-TableViewBottomSpace);
        }];
    }else {
        [self.bottomView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.equalTo(self.contentView);
            make.height.equalTo(@50);
        }];
    }
   
}


/**
 初始化子视图
 */
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 400, self.bounds.size.width, 400)];
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}
- (LTSCGuiGeTopView *)topView {
    if (!_topView) {
        _topView = [[LTSCGuiGeTopView alloc] init];
        [_topView.closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        LTSCTagLayout *layout = [[LTSCTagLayout alloc] init];
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 110) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PropertyCell class] forCellWithReuseIdentifier:@"PropertyCell"];
        [_collectionView registerClass:[PropertyHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PropertyHeader"];
        [_collectionView registerClass:[LTSCGuiGeNumView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LTSCGuiGeNumView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
    }
    return _collectionView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        [_sureButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _sureButton;
}

- (LTSCGoodsGuiGeBottomView *)bottomView1 {
    if (!_bottomView1) {
        _bottomView1 = [[LTSCGoodsGuiGeBottomView alloc] init];
        _bottomView1.backgroundColor = [LineColor colorWithAlphaComponent:0.5];
        _bottomView1.hidden = YES;
    }
    return _bottomView1;
}

- (void)sureButtonClick {
    if (self.sureBlock) {
        self.sureBlock(self.currentModel, self.guiGeNumView ? self.guiGeNumView.numTF.text.integerValue : _tempNum.integerValue);
    }
}

- (void)show {
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.resH = ScreenH * 0.8;
    _contentView.frame = CGRectMake(0, ScreenH, ScreenW, self.resH);
    WeakObj(self);
    [UIView animateWithDuration:0.4 animations:^{
        selfWeak.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.contentView.frame = CGRectMake(0, ScreenH - self.resH, ScreenW, self.resH);
    }];
    [_collectionView reloadData];
}

- (void)dismiss {
    WeakObj(self);
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.contentView.frame = CGRectMake(0, ScreenH, ScreenW, self.resH);
    } completion:^(BOOL finished) {
        [selfWeak removeFromSuperview];
    }];
}

- (void)closeView {
    if (self.closeBlock) {
        self.closeBlock(YES);
    }
    [self dismiss];
}

- (void)setIsGoods:(BOOL)isGoods {
    _isGoods = isGoods;
    self.bottomView1.hidden = NO;
    if (_isGoods) {
        self.sureButton.hidden = YES;
    }else {
        self.sureButton.hidden = NO;
    }
}

- (void)updateCurrentSelectedModel:(LTSCGoodsDetailSUKModel *)skuModel {
    _tempNum = skuModel.num;
    NSArray *arr = [skuModel.properties mj_JSONObject];
    for (int i = 0; i < _guigeArr.count; i++) {
        LTSCGoodsDetailGuiGeModel *guigeModel = _guigeArr[i];
        for (int j = 0; j < guigeModel.propsArr.count; j++) {
            NSString *prop = guigeModel.propsArr[j];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            BOOL isSelected = NO;
            for (NSDictionary *dict in arr) {
                NSString *name = dict[@"name"];
                NSString *value = dict[@"value"];
                if ([name isEqualToString:guigeModel.property] && [value isEqualToString:prop]) {
                    isSelected = YES;
                    break;
                }
            }
            if (isSelected) {
                [self collectionView:_collectionView didSelectItemAtIndexPath:indexPath];
            }
        }
    }
    [_collectionView reloadData];
}

- (void)reloadData {
    self.guigeArr = [self.guigeArr sortedArrayUsingComparator:^NSComparisonResult(LTSCGoodsDetailGuiGeModel * obj1, LTSCGoodsDetailGuiGeModel *obj2) {
        return obj1.id.integerValue > obj2.id.integerValue;
    }];
    for (LTSCGoodsDetailGuiGeModel *guigeModel in self.guigeArr) {
        [guigeModel.propsArr removeAllObjects];
        for (LTSCGoodsDetailSUKModel *skuModel in self.skuArr) {
            if (skuModel.properties) {
                NSArray *arr = [skuModel.properties mj_JSONObject];
                if (arr && [arr isKindOfClass:NSArray.class]) {
                    for (NSDictionary *dict in arr) {
                        NSString *Id = [NSString stringWithFormat:@"%@", dict[@"id"]];
                        NSString *value = [NSString stringWithFormat:@"%@", dict[@"value"]];
                        if ([Id isEqualToString:guigeModel.id] && ![guigeModel.propsArr containsObject:value]) {
                            [guigeModel.propsArr addObject:value];
                        }
                    }
                }
            }
        }
    }
    [_filter reloadData];
    [_collectionView reloadData];
}

#pragma mark -- collectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _guigeArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *arr = _guigeArr[section].propsArr;
    return arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PropertyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PropertyCell" forIndexPath:indexPath];
    LTSCGoodsDetailGuiGeModel *model = _guigeArr[indexPath.section];
    NSArray *arr = model.propsArr;
    cell.propertyL.text = arr[indexPath.row];
    
    if ([_filter.availableIndexPathsSet containsObject:indexPath]) {
        cell.propertyL.backgroundColor = BGGrayColor;
        cell.propertyL.layer.borderColor = BGGrayColor.CGColor;
        cell.propertyL.textColor = CharacterDarkColor;
    } else {
        cell.propertyL.backgroundColor = BGGrayColor;
        cell.propertyL.layer.borderColor = BGGrayColor.CGColor;
        cell.propertyL.textColor = [UIColor lightGrayColor];
    }
    if ([_filter.selectedIndexPaths containsObject:indexPath]) {
        cell.propertyL.backgroundColor = [MineColor colorWithAlphaComponent:0.3];
        cell.propertyL.layer.borderColor = MineColor.CGColor;
        cell.propertyL.textColor = MineColor;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PropertyHeader *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"PropertyHeader" forIndexPath:indexPath];
        LTSCGoodsDetailGuiGeModel *model = _guigeArr[indexPath.section];
        view.guigeLabel.text = model.property;
        return view;
    }else {
        if (indexPath.section == _guigeArr.count - 1) {
            LTSCGuiGeNumView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"LTSCGuiGeNumView" forIndexPath:indexPath];
            self.guiGeNumView = view;
            if (_tempNum.integerValue > 0) {
                view.numTF.text = _tempNum;
            }
            return view;
        }else {
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            view.hidden = YES;
            return view;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_filter didSelectedPropertyWithIndexPath:indexPath];
    [collectionView reloadData];
    LTSCGoodsDetailSUKModel *result = _filter.currentResult;
    if (result) {
        self.isfull = YES;
        self.currentModel = result;
        NSArray *propertiesArr = [result.properties mj_JSONObject];
        propertiesArr = [propertiesArr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary * obj1, NSDictionary * obj2) {
            return [obj1[@"id"] integerValue] > [obj2[@"id"] integerValue];
        }];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *tempDict in propertiesArr) {
            [arr addObject:[NSString stringWithFormat:@"%@",tempDict[@"value"]]];
        }
        self.topView.yxggLabel.text = [NSString stringWithFormat:@"已选: %@",[arr componentsJoinedByString:@";"]];
        self.topView.yxggLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.topView.kucunLabel.text = [NSString stringWithFormat:@"库存%@件",result.goodNum];
        self.topView.priceLabel.text = [NSString stringWithFormat:@"价格: ¥%.2f",result.goodPrice.floatValue];
    }else {
        self.isfull = NO;
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < _guigeArr.count; i++) {
            LTSCGoodsDetailGuiGeModel *guigeModel = _guigeArr[i];
            for (int j = 0; j < guigeModel.propsArr.count; j++) {
                NSString *prop = guigeModel.propsArr[j];
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                if ([_filter.selectedIndexPaths containsObject:indexPath]) {
                    [arr addObject:[NSString stringWithFormat:@"%@:%@",guigeModel.property,prop]];
                }
            }
        }
        self.topView.yxggLabel.text = [NSString stringWithFormat:@"已选: %@",[arr componentsJoinedByString:@";"]];
        self.topView.yxggLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.topView.priceLabel.text = [NSString stringWithFormat:@"价格: ¥%@",_goodsModel.normalPrice.getPriceStr];
        self.topView.kucunLabel.text = [NSString stringWithFormat:@"库存%@件",_goodsModel.goodNum];
//        self.topView.kucunLabel.text = @"库存:";
//        self.topView.priceLabel.text = @"价格: ";
    }
    result.yixuanStr = self.topView.yxggLabel.text;
    WeakObj(self);
    if (selfWeak.currentSKUDidChanged) {
        selfWeak.currentSKUDidChanged(result, self.topView.yxggLabel.text, selfWeak.guiGeNumView.numTF.text.intValue);
    }
}

#pragma mark - tagview delegate
/**
 返回每个item的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(LTSCTagLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    LTSCGoodsDetailGuiGeModel *model = _guigeArr[indexPath.section];
    NSArray *arr = model.propsArr;
    CGSize size = [arr[indexPath.row] getSizeWithMaxSize:CGSizeMake(ScreenW-30, 100) withFontSize:13];
    return CGSizeMake(size.width + 30, 30);
}

/**
 section的边距
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(LTSCTagLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 15, 10, 15);
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

/**
 section head size
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(LTSCTagLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenW, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(LTSCTagLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == self.guigeArr.count - 1) {
        return CGSizeMake(ScreenW, 100);
    }else {
        return CGSizeZero;
    }
}

#pragma mark -- ORSKUDataFilterDataSource

//属性种类个数
- (NSInteger)numberOfSectionsForPropertiesInFilter:(ORSKUDataFilter *)filter {
    return _guigeArr.count;
}

/*
 * 每个种类所有的的属性值
 * 这里不关心具体的值，可以是属性ID, 属性名，字典、model
 */
- (NSArray *)filter:(ORSKUDataFilter *)filter propertiesInSection:(NSInteger)section {
    LTSCGoodsDetailGuiGeModel *model = [_guigeArr objectAtIndex:section];
    return model.propsArr;
}

//满足条件 的 个数
- (NSInteger)numberOfConditionsInFilter:(ORSKUDataFilter *)filter {
    return _skuArr.count;
}

/*
 * 对应的条件式
 * 这里条件式的属性值，需要和propertiesInSection里面的数据类型保持一致
 */
- (NSArray *)filter:(ORSKUDataFilter *)filter conditionForRow:(NSInteger)row {
    LTSCGoodsDetailSUKModel *model = _skuArr[row];
    NSArray *propertiesArr = [model.properties mj_JSONObject];
    propertiesArr = [propertiesArr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary * obj1, NSDictionary * obj2) {
        return [obj1[@"id"] integerValue] > [obj2[@"id"] integerValue];
    }];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *tempDict in propertiesArr) {
        [arr addObject:tempDict[@"value"]];
    }
    return arr;
}

//条件式 对应的 结果数据（库存、价格等）
- (id)filter:(ORSKUDataFilter *)filter resultOfConditionForRow:(NSInteger)row {
    LTSCGoodsDetailSUKModel *model = _skuArr[row];
    return model;
}


- (void)setGoodsModel:(LTSCGoodsDetailModel *)goodsModel {
    _goodsModel = goodsModel;
    [self.topView.imgView sd_setImageWithURL:[NSURL URLWithString:_goodsModel.listPic] placeholderImage:[UIImage imageNamed:@"tupian"] ];
    self.topView.priceLabel.text = [NSString stringWithFormat:@"价格: ¥%@",_goodsModel.normalPrice.getPriceStr];
     self.topView.kucunLabel.text = [NSString stringWithFormat:@"库存%@件",_goodsModel.goodNum];
    NSString *str = [NSString stringWithFormat:@"%ld", self.carNum.integerValue ];
    self.bottomView1.numLabel.text = str;
    if (self.carNum.intValue == 0){
        self.bottomView1.numLabel.hidden = YES;
    }else {
        self.bottomView1.numLabel.hidden = NO;
        if (str.length == 1) {
            [self.bottomView1.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@20);
            }];
        }else {
            CGFloat w = [self.bottomView1.numLabel.text getSizeWithMaxSize:CGSizeMake(80, 15) withFontSize:10].width + 8;
            [self.bottomView1.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(w));
            }];
        }
        [self.bottomView1.numLabel layoutIfNeeded];
    }
    
}

- (void)bottomAction {
    WeakObj(self);
    self.bottomView1.shopCarBlock = ^{//点击跳转购物车界面
        [selfWeak dismiss];
        if (selfWeak.pushShopCarVC) {
            selfWeak.pushShopCarVC();
        }
    };
    
    self.bottomView1.dianpuClickBlock = ^{
      [selfWeak dismiss];
       if (selfWeak.dianPuVCBlock) {
           selfWeak.dianPuVCBlock();
        }
    };
    
    self.bottomView1.lijigoumaiBlock = ^{
        [selfWeak endEditing:YES];
        if (selfWeak.currentModel) {
            if (selfWeak.isfull) {
                if (selfWeak.lijiGouMaiBlock) {
                    selfWeak.lijiGouMaiBlock(selfWeak.currentModel, selfWeak.guiGeNumView.numTF.text.intValue);
                }
                [selfWeak dismiss];
            } else {
                [LTSCToastView showInFullWithStatus:@"规格不全!"];
            }
        }else {
            [LTSCToastView showInFullWithStatus:@"规格不全!"];
        }
    };
    
    self.bottomView1.addShopCarBlock = ^{//加入购物车操作
        if (selfWeak.currentModel) {
            if (selfWeak.isfull) {
                [selfWeak addCarAction];
            } else {
                [LTSCToastView showInFullWithStatus:@"规格不全!"];
            }
        }else {
            [LTSCToastView showInFullWithStatus:@"规格不全!"];
        }
    };
}

/**
 加入购物车操作
 */
- (void)addCarAction {
    
    NSLog(@"%@", SESSION_TOKEN);
    
    if (self.guiGeNumView.numTF.text.intValue > self.currentModel.goodNum.intValue) {
        [LTSCToastView showInFullWithStatus:@"库存不足!"];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"num"] = self.guiGeNumView.numTF.text;
    dict[@"skuId"] = self.currentModel.id;
    dict[@"goodId"] = self.currentModel.goodId;
    dict[@"token"] = SESSION_TOKEN;
    [LTSCLoadingView show];
    [LTSCNetworking networkingPOST:add_cart parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [LTSCLoadingView dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [LTSCEventBus sendEvent:@"addCarSuccess" data:nil];
            [LTSCToastView showSuccessWithStatus:@"添加成功!"];
            NSString *data = responseObject[@"result"][@"data"];
            if (data.intValue == 1) {
                [LTSCEventBus sendEvent:@"CarNumInc" data:nil];
                NSString *str = [NSString stringWithFormat:@"%ld", self.carNum.integerValue + 1];
                self.bottomView1.numLabel.text = str;
                self.bottomView1.numLabel.hidden = NO;
                if (str.length == 1) {
                    [self.bottomView1.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@14);
                    }];
                }else {
                    CGFloat w = [self.bottomView1.numLabel.text getSizeWithMaxSize:CGSizeMake(80, 15) withFontSize:10].width;
                    [self.bottomView1.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@(w));
                    }];
                }
                [self.bottomView1.numLabel layoutIfNeeded];
            }
        }else {
            [LTSCToastView showErrorWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LTSCLoadingView dismiss];
    }];
    [self dismiss];
}

@end


@interface LTSCGuiGeTopView()

@end

@implementation LTSCGuiGeTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.closeBtn];
    [self addSubview:self.imgView];
    [self addSubview:self.priceLabel];
    [self addSubview:self.kucunLabel];
    [self addSubview:self.yxggLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.width.height.equalTo(@(22 + 50));
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@90);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
        make.bottom.equalTo(self.kucunLabel.mas_top).offset(-2);
    }];
    [self.kucunLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self.yxggLabel.mas_top).offset(-2);
    }];
    [self.yxggLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imgView.mas_trailing).offset(10);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self.imgView);
    }];
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        _closeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 50, 0);
    }
    return _closeBtn;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"tupian"];
        _imgView.layer.cornerRadius = 5;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = MineColor;
        _priceLabel.text = @"价格: ¥ 0";
        _priceLabel.font = [UIFont systemFontOfSize:16];
    }
    return _priceLabel;
}

- (UILabel *)kucunLabel {
    if (!_kucunLabel) {
        _kucunLabel = [[UILabel alloc] init];
        _kucunLabel.textColor = CharacterGrayColor;
        _kucunLabel.font = [UIFont systemFontOfSize:12];
        _kucunLabel.text = @"库存:";
    }
    return _kucunLabel;
}

- (UILabel *)yxggLabel {
    if (!_yxggLabel) {
        _yxggLabel = [[UILabel alloc] init];
        _yxggLabel.textColor = CharacterDarkColor;
        _yxggLabel.font = [UIFont systemFontOfSize:13];
        _yxggLabel.numberOfLines = 2;
        _yxggLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _yxggLabel.text = @"请选择规格";
    }
    return _yxggLabel;
}

@end


@interface LTSCGuiGeNumView()

@property (nonatomic, strong) UILabel *textLabel;//数量

@property (nonatomic, strong) UIView *numView;//数量

@end
@implementation LTSCGuiGeNumView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.textLabel];
        [self addSubview:self.numView];
        
        [self.numView addSubview:self.decButton];
        [self.numView addSubview:self.numTF];
        [self.numView addSubview:self.incButton];
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.leading.equalTo(self).offset(15);
        }];
        
        [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textLabel.mas_bottom).offset(15);
            make.leading.equalTo(self).offset(15);
            make.width.equalTo(@160);
            make.height.equalTo(@40);
        }];
        
        [self.decButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.equalTo(self.numView);
            make.width.equalTo(@40);
        }];
        [self.numTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.numView);
            make.leading.equalTo(self.decButton.mas_trailing);
            make.trailing.equalTo(self.incButton.mas_leading);
        }];
        [self.incButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.bottom.equalTo(self.numView);
            make.width.equalTo(@40);
        }];
    }
    return self;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"数量";
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.font = [UIFont systemFontOfSize:16];
    }
    return _textLabel;
}

- (UIView *)numView {
    if (!_numView) {
        _numView = [[UIView alloc] init];
        _numView.layer.cornerRadius = 3;
        _numView.backgroundColor = BGGrayColor;
        _numView.layer.masksToBounds = YES;
    }
    return _numView;
}

- (UIButton *)decButton {
    if (!_decButton) {
        _decButton = [[UIButton alloc] init];
        [_decButton setTitle:@"-" forState:UIControlStateNormal];
        [_decButton setTitleColor:LineColor forState:UIControlStateNormal];
        _decButton.titleLabel.font = [UIFont systemFontOfSize:18];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(40 - 0.5, 0, 0.5, 40);
        layer.backgroundColor = UIColor.whiteColor.CGColor;
        [_decButton.layer addSublayer:layer];
        [_decButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _decButton;
}

- (UITextField *)numTF {
    if (!_numTF) {
        _numTF = [[UITextField alloc] init];
        _numTF.textColor = CharacterDarkColor;
        _numTF.font = [UIFont systemFontOfSize:15];
        _numTF.textAlignment = NSTextAlignmentCenter;
        _numTF.keyboardType = UIKeyboardTypeNumberPad;
        _numTF.text = @"1";
    }
    return _numTF;
}

- (UIButton *)incButton {
    if (!_incButton) {
        _incButton = [[UIButton alloc] init];
        [_incButton setTitle:@"+" forState:UIControlStateNormal];
        [_incButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _incButton.titleLabel.font = [UIFont systemFontOfSize:18];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 0.5, 40);
        layer.backgroundColor = UIColor.whiteColor.CGColor;
        [_incButton.layer addSublayer:layer];
        [_incButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _incButton;
}

- (void)btnClick:(UIButton *)btn {
    NSInteger num =  _numTF.text.intValue;
    if (btn == _decButton) {
        if (_numTF.text.intValue > 1) {
            num --;
        }else {
            [LTSCToastView showInFullWithStatus:@"受不了了,不能再少了!"];
        }
    }else {
        num ++;
    }
    _numTF.text = [NSString stringWithFormat:@"%ld", num];
}

@end

@implementation LTSCGoodsBottomButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.textLabel];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_centerY).offset(5);
            make.size.equalTo(@18);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.mas_centerY).offset(10);
        }];
    }
    return self;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
    }
    return _iconImgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.font = [UIFont systemFontOfSize:9];
    }
    return _textLabel;
}

@end


@interface LTSCGoodsGuiGeBottomView()

@property (nonatomic, strong) LTSCGoodsBottomButton *dianpuButton;//店铺

@property (nonatomic, strong) LTSCGoodsBottomButton *shopCarButton;//购物车



@end
@implementation LTSCGoodsGuiGeBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.dianpuButton];
        [self addSubview:self.shopCarButton];
        [self.shopCarButton addSubview:self.numLabel];
        [self addSubview:self.lijiButton];
        [self addSubview:self.addCarButton];
        [self.dianpuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.bottom.equalTo(self);
            make.width.equalTo(@70);
        }];
        [self.shopCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self.dianpuButton.mas_trailing);
            make.bottom.equalTo(self);
            make.width.equalTo(@70);
        }];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.shopCarButton.iconImgView.mas_trailing).offset(-2);
            make.top.equalTo(self.shopCarButton.iconImgView).offset(-5);
            make.height.equalTo(@14);
        }];
        [self.lijiButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self.shopCarButton.mas_trailing);
            make.bottom.equalTo(self);
            make.trailing.equalTo(self.addCarButton.mas_leading);
            make.width.equalTo(self.addCarButton);
        }];
        [self.addCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.bottom.equalTo(self);
            make.width.equalTo(self.lijiButton);
        }];
    }
    return self;
}

- (LTSCGoodsBottomButton *)dianpuButton {
    if (!_dianpuButton) {
        _dianpuButton = [[LTSCGoodsBottomButton alloc] init];
        _dianpuButton.iconImgView.image = [UIImage imageNamed:@"dianpu"];
        _dianpuButton.textLabel.text = @"店铺";
        _dianpuButton.backgroundColor = BGGrayColor;
        [_dianpuButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dianpuButton;
}

- (LTSCGoodsBottomButton *)shopCarButton {
    if (!_shopCarButton) {
        _shopCarButton = [[LTSCGoodsBottomButton alloc] init];
        _shopCarButton.iconImgView.image = [UIImage imageNamed:@"shopcar"];
        _shopCarButton.textLabel.text = @"购物车";
        _shopCarButton.backgroundColor = BGGrayColor;
        [_shopCarButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shopCarButton;
}

- (UIButton *)lijiButton {
    if (!_lijiButton) {
        _lijiButton = [[UIButton alloc] init];
        [_lijiButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [_lijiButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _lijiButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_lijiButton setBackgroundImage:[UIImage imageNamed:@"orange"] forState:UIControlStateNormal];
        [_lijiButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lijiButton;
}

- (UIButton *)addCarButton {
    if (!_addCarButton) {
        _addCarButton = [[UIButton alloc] init];
        [_addCarButton setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
        [_addCarButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_addCarButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _addCarButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_addCarButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addCarButton;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textColor = UIColor.whiteColor;
        _numLabel.layer.cornerRadius = 7;
        _numLabel.layer.masksToBounds = YES;
        _numLabel.backgroundColor = MineColor;
        _numLabel.font = [UIFont systemFontOfSize:8];
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

- (void)btnClick:(UIButton *)btn {
    if (btn == _dianpuButton) {
        if (self.dianpuClickBlock) {
            self.dianpuClickBlock();
        }
    } else if (btn == _shopCarButton) {
        if (self.shopCarBlock) {
            self.shopCarBlock();
        }
    } else if (btn == _lijiButton) {
        if (self.lijigoumaiBlock) {
            self.lijigoumaiBlock();
        }
    } else {
        if (self.addShopCarBlock) {
            self.addShopCarBlock();
        }
    }
}

@end


@implementation PropertyCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.propertyL];
        [self.propertyL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)propertyL {
    if (!_propertyL) {
        _propertyL = [[UILabel alloc] init];
        _propertyL.textColor = CharacterDarkColor;
        _propertyL.textAlignment = NSTextAlignmentCenter;
        _propertyL.font = [UIFont systemFontOfSize:13];
        _propertyL.layer.cornerRadius = 5;
        _propertyL.layer.borderColor = BGGrayColor.CGColor;
        _propertyL.layer.borderWidth = 0.5;
        _propertyL.layer.masksToBounds = YES;
    }
    return _propertyL;
}

@end

@implementation PropertyHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.guigeLabel];
        [self.guigeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)guigeLabel {
    if (!_guigeLabel) {
        _guigeLabel = [[UILabel alloc] init];
        _guigeLabel.text = @"规格";
        _guigeLabel.textColor = CharacterDarkColor;
        _guigeLabel.font = [UIFont systemFontOfSize:16];
    }
    return _guigeLabel;
}

@end
