//
//  GLBAddInfoTVCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/25.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBAddInfoTVCell.h"


@interface GLBAddInfoTVCell ()



@end

@implementation GLBAddInfoTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _textView = [[DCTextView alloc] init];
    _textView.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _textView.font = PFRFont(14);
    _textView.placeholder = @"详细地址：如道路、门牌号、小区、楼栋号、单元室等";
    _textView.placeholderColor = [UIColor dc_colorWithHexString:@"#999999"];
    [_textView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];

    [self.contentView addSubview:_textView];
    
    [self layoutIfNeeded];
}


#pragma mark - 监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (object == _textView && [keyPath isEqualToString:@"text"]) {
        if (_textViewBlock) {
            _textViewBlock(_textView.text);
        }
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 5, 0, 5));
        make.height.equalTo(90);
    }];
}


- (void)dealloc {
    [_textView removeObserver:self forKeyPath:@"text"];
}

@end
