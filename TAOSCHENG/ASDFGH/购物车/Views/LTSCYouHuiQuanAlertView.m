//
//  LTSCYouHuiQuanAlertView.m
//  TAOSCHENG
//
//  Created by 李晓满 on 2020/4/15.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "LTSCYouHuiQuanAlertView.h"
#import "LTSCSubYouHuiQuanVC.h"
#import "LTSCGoodsDetailCell.h"

@interface LTSCYouHuiQuanAlertView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)  UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) LTSCGoodsDetailTopButton *leftButton;

@property (nonatomic, strong) LTSCGoodsDetailTopButton *rightButton;

@property (nonatomic, strong) NSMutableArray <LTSCGoodsDetailTopButton *>*btnArr;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray <LTSCYouHuiQuanModel *>*keyongYouhuiquanArr;//优惠券数据

@property (nonatomic, strong) NSMutableArray <LTSCYouHuiQuanModel *>*bukeyongYouhuiquanArr;//优惠券数据

@end

@implementation LTSCYouHuiQuanAlertView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton * bgBtn =[[UIButton alloc] initWithFrame:self.bounds];
        [bgBtn addTarget:self action:@selector(bgBtnClick) forControlEvents:UIControlEventTouchUpInside];
        bgBtn.tag = 110;
        [self addSubview:bgBtn];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height* 0.4, frame.size.width, frame.size.height * 0.6)];
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self addSubview:self.contentView];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.path = maskPath.CGPath;
        self.contentView.layer.mask = maskLayer;
        
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width - 100) * 0.5, 10, 100, 20)];
        _titleLabel.text = @"优惠券";
        [_contentView addSubview:_titleLabel];
        
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 40, 0, 40, 40)];
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(bgBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_closeBtn];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, frame.size.width, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [_contentView addSubview:_lineView];
        
        
        _leftButton = [[LTSCGoodsDetailTopButton alloc] initWithFrame:CGRectMake(0, 40.5, frame.size.width * 0.5, 40)];
        _leftButton.textLabel.text = @"可用优惠券(0)";
        _leftButton.textLabel.textColor = MineColor;
        _leftButton.textLabel.font = [UIFont systemFontOfSize:15];
        _leftButton.lineView.hidden = NO;
        [_leftButton.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_leftButton.textLabel.mas_bottom).offset(5);
            make.width.equalTo(@15);
            make.height.equalTo(@3);
            make.centerX.equalTo(_leftButton.textLabel);
        }];
        _leftButton.tag = 333;
        [_leftButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_leftButton];
        
        _rightButton = [[LTSCGoodsDetailTopButton alloc] initWithFrame:CGRectMake(frame.size.width * 0.5, 40.5, frame.size.width * 0.5, 40)];
        [_rightButton.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_rightButton.textLabel.mas_bottom).offset(5);
            make.width.equalTo(@15);
            make.height.equalTo(@3);
            make.centerX.equalTo(_rightButton.textLabel);
        }];
        _rightButton.tag = 334;
        _rightButton.textLabel.text = @"不可用优惠券(0)";
        _rightButton.textLabel.font = [UIFont systemFontOfSize:15];
        _rightButton.textLabel.textColor = CharacterDarkColor;
        _rightButton.lineView.hidden = YES;
        [_rightButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_rightButton];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80.5, frame.size.width, _contentView.bounds.size.height - 80.5)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = BGGrayColor;
        [_contentView addSubview:_tableView];
        
        self.btnArr = [NSMutableArray array];
        [self.btnArr addObject:self.leftButton];
        [self.btnArr addObject:self.rightButton];
        self.index = 333;
        self.keyongYouhuiquanArr = [NSMutableArray array];
        self.bukeyongYouhuiquanArr = [NSMutableArray array];
    }
    return self;
}



-(void)bgBtnClick {
    [self dismiss];
}

- (void)show {
    [_tableView reloadData];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
    self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.0];
    CGRect rect = _contentView.frame;
    rect.origin.y = self.bounds.size.height;
    _contentView.frame = rect;
    
    WeakObj(self);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.3];
        CGRect rect = selfWeak.contentView.frame;
        rect.origin.y = selfWeak.bounds.size.height - selfWeak.contentView.frame.size.height;
        selfWeak.contentView.frame = rect;
        
    } completion:nil];
}
-(void)dismiss {
    WeakObj(self);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.0];
        CGRect rect = selfWeak.contentView.frame;
        rect.origin.y = self.bounds.size.height;
        selfWeak.contentView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.index == 333 ? self.keyongYouhuiquanArr.count : self.bukeyongYouhuiquanArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSCSubYouHuiQuanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTSCSubYouHuiQuanCell"];
    if (!cell) {
        cell = [[LTSCSubYouHuiQuanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LTSCSubYouHuiQuanCell"];
    }
    cell.index = [NSString stringWithFormat:@"%ld",self.index];
    if (self.index == 333) {
        cell.userModel = self.keyongYouhuiquanArr[indexPath.section];
    } else {
        cell.userModel = self.bukeyongYouhuiquanArr[indexPath.section];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index == 333) {
        
        LTSCYouHuiQuanModel *model = self.keyongYouhuiquanArr[indexPath.section];
        for (LTSCYouHuiQuanModel *modelNei in self.keyongYouhuiquanArr ) {
            if (model == modelNei && modelNei.isSelect == NO) {
                modelNei.isSelect = YES;
            }else {
                modelNei.isSelect = NO;
            }
        }
        [self.tableView reloadData];
        if (self.didSelectYouHuiQuanModelBlock) {
            if (model.isSelect) {
                self.didSelectYouHuiQuanModelBlock(model);
            }else {
                self.didSelectYouHuiQuanModelBlock(nil);
            }
            
        }
        [self dismiss];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 87;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


- (void)topButtonClick:(LTSCGoodsDetailTopButton *)btn {
    btn.selected = !btn.selected;
   for (LTSCGoodsDetailTopButton *btnn in self.btnArr) {
       btnn.selected = btnn == btn;
       if (btnn.selected) {
           btnn.textLabel.textColor = MineColor;
           btnn.lineView.hidden = NO;
           self.index = btnn.tag;
           [self.tableView reloadData];
       } else {
           btnn.textLabel.textColor = CharacterDarkColor;
           btnn.lineView.hidden = YES;
       }
   }
}

- (void)setYouhuiquanArr:(NSMutableArray<LTSCYouHuiQuanModel *> *)youhuiquanArr {
    _youhuiquanArr = youhuiquanArr;
    for (LTSCYouHuiQuanModel *model in _youhuiquanArr) {
        if (model.type.intValue == 2) {//抵扣
            if (model.reduce_money.doubleValue < self.allPrice) {
                [self.keyongYouhuiquanArr addObject:model];
            } else {
                [self.bukeyongYouhuiquanArr addObject:model];
            }
        } else if (model.type.intValue == 1) {//满减
            if (model.full_money.doubleValue < self.allPrice) {
                [self.keyongYouhuiquanArr addObject:model];
            } else {
                [self.bukeyongYouhuiquanArr addObject:model];
            }
            
        }
    }
    
    _leftButton.textLabel.text = [NSString stringWithFormat:@"可用优惠券(%ld)", self.keyongYouhuiquanArr.count];
    _rightButton.textLabel.text = [NSString stringWithFormat:@"不可用优惠券(%ld)", self.bukeyongYouhuiquanArr.count];
    [self.tableView reloadData];
}


@end
