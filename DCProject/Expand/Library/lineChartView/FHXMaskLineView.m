//
//  FHXMaskLineView.m
//
//  Created by hxxc on 2019/2/22.
//  Copyright © 2019年 xjc. All rights reserved.
//

#import "FHXMaskLineView.h"
#import "Masonry.h"
#import "FHXTools.h"
#import "UIColor+Extensions.h"
#import "OtherHelper.h"

static NSInteger baseLineCount = 7;//纵坐标个数

static CGFloat mainView_top_h = 40;
static CGFloat cell_y_h = 23;
static CGFloat cell_y_w = 45;



@implementation FHXMaskLineView{
    
    UILabel *titleLabel;//标题
    UIButton *arrowBtn;//标题箭头
    UILabel *unitLabel;//单位
    UILabel *desLabel1;//描述1
    UILabel *IdentifyLabel1;//颜色
    UILabel *desLabel2;//描述2
    UILabel *IdentifyLabel2;//颜色
    UILabel *desLabel3;//描述3
    UILabel *IdentifyLabel3;//颜色
    UIImageView *lastLineView;//最后一条背景线
    NSMutableArray *pointArray;//拐点数据
    NSMutableArray *xLabelArray;//横坐标
    NSMutableArray *btnArray;//按钮
    NSMutableArray *labelArray;//显示标签
    
    CGPoint lastPoint;//最后一个坐标点
    
    CGFloat maxValue;//y轴最大值
    CGFloat minValue;//y轴最小值
}

- (void)setTitleStr:(NSString *)titleStr{
    
    _titleStr = titleStr;
    [arrowBtn setTitle:titleStr forState:UIControlStateNormal];
    //titleLabel.text = _titleStr;
}

- (void)setUnitStr:(NSString *)unitStr{
    
    _unitStr = unitStr;
    if (unitStr.length == 0) {
        unitLabel.text = @"元";
    }else
        unitLabel.text = _unitStr;

}

- (void)setType:(NSInteger)type{
    
    _type = type;
}

- (void)setArrayX:(NSMutableArray *)arrayX{
    
    _arrayX = arrayX;
}

- (void)setArrayY:(NSMutableArray *)arrayY{
    
    _arrayY = arrayY;
    
    //处理最大值
    maxValue = [[_arrayY valueForKeyPath:@"@max.floatValue"] floatValue];
    //处理最小值
    minValue = [[_arrayY valueForKeyPath:@"@min.floatValue"] floatValue];
    if (minValue < 0) {
        minValue = minValue - 1;
        int minRemainder = (int)(-minValue)%3;
        minValue = minValue + (minRemainder - 3);
        
        //+1 消除浮点型数据带来的误差
        maxValue = maxValue + 1;
        //对3取余数
        int remainder = (int)maxValue%3;
        //确保maxValue能被6整除
        maxValue = maxValue + (3 - remainder);
        
    }else{
        
        //当绩效比最大值小于0.1, maxValue = 0.1
        if (_type == 12) {
            
            if (maxValue < 0.1) {
                maxValue = 0.1;
            }
        }else{
         
            //+1 消除浮点型数据带来的误差
            maxValue = maxValue + 1;
            //对6取余数
            int remainder = (int)maxValue%6;
            //确保maxValue能被6整除
            maxValue = maxValue + (6 - remainder);
        }
    }
    
    //背景线条 + Y轴
    [self initBaseLineViewWithArrayY:nil];
    //X轴
    [self initXLineWithArrayX:_arrayX];
    self.bgScrollView.contentSize = CGSizeMake( (_arrayX.count)*50, self.bounds.size.height - 60+mainView_top_h);
    self.bgScrollView.contentOffset = CGPointMake((_arrayX.count)*50 - CGRectGetWidth(self.bounds)+15, 0);
    //获取拐点
    [self getInflectionPointWithArrayX:nil ArrayY:_arrayY color:0x4162FF];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        labelArray = [NSMutableArray arrayWithCapacity:0];
        btnArray = [NSMutableArray arrayWithCapacity:0];
        pointArray = [NSMutableArray arrayWithCapacity:0];
        xLabelArray = [NSMutableArray arrayWithCapacity:0];
        
        [self addSubview:self.bgScrollView];
        [self initDescribleLables];
    }
    return self;
}

//显示lable
- (void)initDescribleLables{
    
    //标题
    titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor colorWithHex:0x000000];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if(IOS_VERSION > 9.0) {
        titleLabel.font = [UIFont fontWithName:PINGFANGSEMIBOLD size:16];
    }
    
    //标题右箭头
    arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowBtn setTitleColor:[UIColor colorWithHex:0x000000] forState:UIControlStateNormal];
    arrowBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    if (IOS_VERSION > 9.0) {
        arrowBtn.titleLabel.font = [UIFont fontWithName:PINGFANGSEMIBOLD size:16];
    }
    arrowBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [arrowBtn addTarget:self action:@selector(switchSelectTypeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:arrowBtn];
    
    //单位
    unitLabel = [[UILabel alloc]init];
    unitLabel.textColor = [UIColor colorWithHex:0x666666];
    unitLabel.textAlignment = NSTextAlignmentCenter;
    unitLabel.text = @"元";
    unitLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:unitLabel];
    
    //布局约束
    UIEdgeInsets padding = UIEdgeInsetsMake(15, 0, 0, 0);
    [arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).with.offset(padding.top-mainView_top_h);
        make.width.greaterThanOrEqualTo(@85.0);
        make.height.equalTo(@30.0f);
        
    }];
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).with.offset(38-mainView_top_h);
        make.height.equalTo(@20.0f);
        make.left.equalTo(self.mas_left).with.offset(0.0f);
        make.right.equalTo(self.bgScrollView.mas_left).with.offset(5.0f);
        
    }];
    
}

//灰色背景线条 + 纵坐标
- (void)initBaseLineViewWithArrayY:(NSMutableArray *)array{
    
    
    for (int i = 0; i < baseLineCount; i++) {
        
        //灰色背景线条
        UIImageView *lineView = [[UIImageView alloc]init];
        lineView.backgroundColor = [UIColor colorWithHex:0xE2EBF2];
        [self.bgScrollView addSubview:lineView];
        
        if (i == baseLineCount -1) {
            lastLineView = lineView;
            //lastLineView.backgroundColor = [UIColor redColor];
        }
        
        //纵坐标
        UILabel *labelY = [[UILabel alloc]init];
        labelY.textAlignment = NSTextAlignmentCenter;
        labelY.textColor = [UIColor colorWithHex:0x999999];
        labelY.font = [UIFont systemFontOfSize:11];
        
        if (minValue < 0) {
            
            if (i <3) {
                //y坐标间隔
                int interval = maxValue/3.0;
                labelY.text = [NSString stringWithFormat:@"%ld",((baseLineCount-3) - i -1)*interval];
            }
            
            if (i == 3) {
                labelY.text = @"0";
            }
            
            if (i > 3) {
                
                //y坐标间隔
                int interval = -minValue/3.0;
                labelY.text = [NSString stringWithFormat:@"%ld",((baseLineCount-3) - i -1)*interval];
            }
            
        }else{
            
            //y坐标间隔
            
            if (_type == 12) {
                
                CGFloat interval = maxValue/6.0;
                labelY.text = [NSString stringWithFormat:@"%.2f",(baseLineCount - i -1)*interval];
            }else{
                
                int interval = maxValue/6.0;
                labelY.text = [NSString stringWithFormat:@"%ld",(baseLineCount - i -1)*interval];
            }
            
        }
        [self addSubview:labelY];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.bgScrollView.mas_top).with.offset(8+i*cell_y_h);
            make.left.equalTo(self.bgScrollView.mas_left).with.offset(0.0f);
            make.right.equalTo(self.mas_right).with.offset(22.0f);
            make.height.equalTo(@0.3f);
        }];
        
        [labelY mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).with.offset(0.0f);
            make.right.equalTo(self.bgScrollView.mas_left).with.offset(5.0f);
            make.centerY.equalTo(lineView);
            make.height.equalTo(@17.0f);
            
        }];
    }
}

//横坐标
- (void)initXLineWithArrayX:(NSMutableArray *)array{
    
    //横坐标
    for (int i = 0; i < array.count; i++) {
        
        UILabel *labelX = [[UILabel alloc]init];
        labelX.textAlignment = NSTextAlignmentCenter;
        labelX.textColor = [UIColor colorWithHex:0x999999];
        labelX.font = [UIFont systemFontOfSize:12];
        labelX.text = [NSString stringWithFormat:@"%@",array[i]];
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformRotate(transform, M_PI / 180.0 *0);
        transform = CGAffineTransformTranslate(transform, 20, 0);
        labelX.layer.affineTransform = transform;
        [self.bgScrollView addSubview:labelX];
        
        [labelX mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.bgScrollView.mas_left).with.offset(i *(cell_y_w));
            make.top.equalTo(lastLineView.mas_bottom).with.offset(14.0f);
            make.width.greaterThanOrEqualTo(@0.0f);
            make.height.equalTo(@17.0);
        }];
        [xLabelArray addObject:labelX];
    }
    
}

//获取拐点--注册
- (void)getInflectionPointWithArrayX:(NSMutableArray *)xArray ArrayY:(NSMutableArray *)yArray color:(long)color{
    
    [self layoutIfNeeded];
    NSMutableArray *midPointArray = [NSMutableArray arrayWithCapacity:0];
    for (UILabel *label in xLabelArray) {
        //HXLOG(@"-----------------------------%.2f",label.center.x)
        NSValue *point = [NSValue valueWithCGPoint:CGPointMake(label.center.x+cell_y_w/2, 0)];
        [midPointArray addObject:point];
    }
    for (int i = 0; i < yArray.count; i++) {
        
        CGFloat currentData = [yArray[i] floatValue];
        CGFloat possionY = 0;
        if (minValue < 0) {
            if (currentData >= 0) {
                possionY = (cell_y_h*3/maxValue)*(maxValue - currentData) + 8;
            }else{
                possionY = cell_y_h*3 + (72/(minValue))*(currentData) + 8;
            }
            
        }else{
            possionY = (cell_y_h*3*2/maxValue)*(maxValue - currentData) + 8;
        }
        
        NSValue *point = midPointArray[i];
        CGPoint  OriginPoint = point.CGPointValue;
        OriginPoint.y = possionY;
        NSValue *newPoint = [NSValue valueWithCGPoint:OriginPoint];
        [pointArray addObject:newPoint];
        
        //点击buton
        UIButton *pointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pointBtn.frame = CGRectMake(0, 0, 30, 30);
        [pointBtn setImage:[UIImage imageNamed:@"dpoint_blue"] forState:UIControlStateNormal];
        [pointBtn setImage:[UIImage imageNamed:@"dpoint_blue_select"] forState:UIControlStateSelected];
        [pointBtn addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        pointBtn.center = OriginPoint;
        pointBtn.tag = i + 1000;
        [btnArray addObject:pointBtn];
        
        UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        messageBtn.frame = CGRectMake(0, 0, 65, 39);
        messageBtn.tag = i + 2000;
        messageBtn.hidden = YES;
        messageBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        messageBtn.userInteractionEnabled = NO;
        messageBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        //大于-1小于1,保留四位小数,大于0.01,保留2位小数
        if ([_arrayY[i] floatValue] < 1 &&  [_arrayY[i] floatValue] > -1) {
            
            [messageBtn setTitle:[NSString stringWithFormat:@" %@ ",[OtherHelper notRounding:_arrayY[i] afterPoint:4]] forState:UIControlStateNormal];
        }else{
            [messageBtn setTitle:[NSString stringWithFormat:@" %@ ",[OtherHelper notRounding:_arrayY[i] afterPoint:2]] forState:UIControlStateNormal];
        }
        if ([yArray[i] floatValue] > maxValue/2.0f) {
            
            [messageBtn setBackgroundImage:[UIImage imageNamed:@"icon_message_top"] forState:UIControlStateNormal];
            messageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -8, 0);
            messageBtn.center = CGPointMake(OriginPoint.x, OriginPoint.y + 25);
        }else{
            
            [messageBtn setBackgroundImage:[UIImage imageNamed:@"icon_message_down"] forState:UIControlStateNormal];
            messageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 8, 0);
            messageBtn.center = CGPointMake(OriginPoint.x, OriginPoint.y-25);
        }
        
        [labelArray addObject:messageBtn];
    }
    
    //曲线
    //起点往前偏移17.5
    CGPoint  originP = [[pointArray objectAtIndex:0] CGPointValue];
    CGPoint p1 = CGPointMake(originP.x - 27.5, originP.y);
    //CGPoint p1 = [[pointArray objectAtIndex:0] CGPointValue];
    NSMutableArray *newPointArray = [NSMutableArray arrayWithArray:pointArray];
    NSValue *point = [NSValue valueWithCGPoint:p1];
    [newPointArray insertObject:point atIndex:0];
    //直线的连线
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    //beizer.
    [beizer moveToPoint:p1];
    
    /*遮罩*/
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:p1];
    
    for (int i = 0;i<newPointArray.count;i++ ) {
        if (i != 0) {
            
            CGPoint prePoint = [[newPointArray objectAtIndex:i-1] CGPointValue];
            CGPoint nowPoint = [[newPointArray objectAtIndex:i] CGPointValue];
            
            [beizer addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            
            [bezier1 addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            
            if (i == newPointArray.count-1) {
                [beizer moveToPoint:nowPoint];//添加连线
                lastPoint = nowPoint;
            }
        }
    }
    
    /*遮罩*/
    CGFloat bgViewHeight = self.bgScrollView.bounds.size.height;
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint.x;
    //最后一个点对应的X轴的值
    CGPoint lastPointX1 = CGPointMake(lastPointX, bgViewHeight);
    [bezier1 addLineToPoint:lastPointX1];
    //回到原点
    [bezier1 addLineToPoint:CGPointMake(p1.x, bgViewHeight)];
    [bezier1 addLineToPoint:p1];
    
    //遮罩层
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor greenColor].CGColor;
    
    
    //渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(5, 0, 0, self.bgScrollView.bounds.size.height- 50 - 60 - 50);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHex:0x81aeff alpha:0.25].CGColor,(__bridge id)[UIColor colorWithHex:0xb0ccff alpha:0.25].CGColor,(__bridge id)[UIColor colorWithHex:0xffffff alpha:0.25].CGColor];
    gradientLayer.locations = @[@(0.33f),@(0.66f),@(1.00f)];
    
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    [self.bgScrollView.layer addSublayer:baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 1.0f;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(5, 0, 2*lastPoint.x, self.bgScrollView.bounds.size.height)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
    
    //*****************添加动画连线******************//
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor colorWithHex:color].CGColor;
    shapeLayer.lineWidth = 4.0f;
    [self.bgScrollView.layer addSublayer:shapeLayer];
    
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration =1.0f;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
    
    [shapeLayer addAnimation:anmi forKey:@"stroke"];
    
    //添加点击btn
    for (UIButton *btn in btnArray) {
        [self.bgScrollView addSubview:btn];
    }
    
}

- (void)clickButtonAction:(UIButton *)sender{
    
    
    for (UIButton *btn in btnArray) {
        if (sender.tag == btn.tag) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    
    [self showDeslLabel:sender];
}

- (void)showDeslLabel:(UIButton *)sender{
    
    for (int i = 0; i < labelArray.count; i++) {
        
        UIButton *btn = labelArray[i];
        
        if (![self.bgScrollView.subviews containsObject:btn]) {
            
            [self.bgScrollView addSubview:btn];
        }
        
        if (sender.tag + 1000 == btn.tag) {
            btn.hidden = NO;
        }else{
            btn.hidden = YES;
        }
    }
    
}

- (void)switchSelectTypeAction{
    
    if ([self.delegate respondsToSelector:@selector(clickTopTypeAction:)]) {
        
        [self.delegate clickTopTypeAction:_type];
    }
    
}

-(UIScrollView *)bgScrollView{
    
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(48, 60-mainView_top_h, self.bounds.size.width - 10 - 48, self.bounds.size.height - 60+mainView_top_h)];
        _bgScrollView.backgroundColor = [UIColor redColor];
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.backgroundColor = [UIColor whiteColor];
        _bgScrollView.contentSize = CGSizeMake((self.bounds.size.width) *4, self.bounds.size.height - 60+mainView_top_h);
        _bgScrollView.layer.cornerRadius = 6;
//        _bgScrollView.layer.borderWidth = 1;
//        _bgScrollView.layer.borderColor = [UIColor greenColor].CGColor;
    }
    return _bgScrollView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
