//
//  KGDislikeView.m
//  test
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年 zhangyanlin. All rights reserved.
//


#define UIColorFromRGB(rgbValue)	        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

#define important_red_color    UIColorFromRGB(0xFF635A)
#define important_gray_color   UIColorFromRGB(0x333333)
#define separator_line_color   UIColorFromRGB(0xE5E6E5)


#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width

#define KGDislikeViewHeaderHeight             (59.0)
#define KGDislikeViewItemHorizontalPadding    (12.0)
#define KGDislikeViewItemVerticalPadding      (12.0)
#define KGDislikeViewItemWidth                ((kScreenWidth - 45.0) / 2.0)
#define KGDislikeViewItemHeight               (27.0)
#define KGDislikeViewBottomAreaHeight         (22.0)

#define kBaseTag                              (3958)

#import "KGDislikeView.h"
#import "Masonry.h"
#import "KGDislikeArrowView.h"
#import "AppDelegate.h"

@interface KGDislikeView ()

@property (nonatomic,   copy) KGDislikeViewBlock dislikeBlock;

@property (nonatomic,   copy) NSArray <DislikeModel *>  *items;
@property (nonatomic, strong) KGDislikeArrowView *arrowView;

@property (nonatomic, strong) UIView             *reasonView;

@property (nonatomic, strong) UILabel            *titleLabel;
@property (nonatomic, strong) UIButton           *dislikeButton;

@property (nonatomic, strong) NSMutableArray    *dislikeReasonArray;

@end

@implementation KGDislikeView

+ (instancetype)showFromView:(UIView *)aView items:(NSArray <DislikeModel *> *)items dislikeBlock:(KGDislikeViewBlock)dislikeBlock {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIControl *backgroundControl = [UIControl new];
    backgroundControl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    backgroundControl.frame = keyWindow.bounds;
    [backgroundControl addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
    [keyWindow addSubview:backgroundControl];
    CGRect triggerRect = [aView convertRect:aView.bounds toView:keyWindow];
    KGDislikeArrowDirection arrowDirection = KGDislikeArrowDirectionDown;
    CGFloat dislikeViewHeight = kArrowHeight + KGDislikeViewHeaderHeight + ((items.count + 1) / 2) * (KGDislikeViewItemHeight + KGDislikeViewItemVerticalPadding) + (KGDislikeViewBottomAreaHeight - KGDislikeViewItemVerticalPadding);
    if (CGRectGetMaxY(triggerRect) + dislikeViewHeight + 49 > kScreenHeight) {
        arrowDirection = KGDislikeArrowDirectionUp;
    }
    CGRect frame = CGRectZero;
    switch (arrowDirection) {
        case KGDislikeArrowDirectionDown: {
            frame = CGRectMake(10 + (kScreenWidth - 20) / 2., CGRectGetMaxY(triggerRect) - dislikeViewHeight / 2., kScreenWidth - 20, dislikeViewHeight);
        }
            break;
        case KGDislikeArrowDirectionUp: {
            frame = CGRectMake(10 + (kScreenWidth - 20) / 2., CGRectGetMinY(triggerRect) - dislikeViewHeight + dislikeViewHeight / 2. + 80, kScreenWidth - 20, dislikeViewHeight);
        }
            break;
            
        default:
            break;
    }
    KGDislikeView *dislikeView = [[self alloc] initWithFrame:frame items:items direction:arrowDirection dislikeBlock:dislikeBlock];
    [backgroundControl addSubview:dislikeView];
    dislikeView.alpha = 0.0;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:1.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        dislikeView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        dislikeView.alpha = 1.0;
        backgroundControl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.12];
    } completion:^(BOOL finished) {
        
    }];
    return dislikeView;
}

+ (void)hide {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *subview in keyWindow.subviews) {
        if ([subview.subviews.lastObject isKindOfClass:[self class]]) {
            [self hide:(UIControl *)subview];
            break;
        }
    }
}

+ (void)hide:(UIControl *)control {
    for (UIView *subview in control.subviews) {
        if ([subview isKindOfClass:[KGDislikeView class]]) {
            KGDislikeView *dislikeView = (KGDislikeView *)subview;
            [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:1.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                dislikeView.transform = CGAffineTransformMakeScale(0.000001, 0.000001);;
                dislikeView.alpha = 0.0;
                control.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
            } completion:^(BOOL finished) {
                [control removeFromSuperview];
            }];
            return;
        }
    }
    [control removeFromSuperview];
}

#pragma mark - getter & setter
- (NSMutableArray *)dislikeReasonArray {
    if (!_dislikeReasonArray) {
        _dislikeReasonArray = [NSMutableArray array];
    }
    return _dislikeReasonArray;
}

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray <DislikeModel *> *)items direction:(KGDislikeArrowDirection)direction dislikeBlock:(KGDislikeViewBlock)dislikeBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.dislikeBlock = dislikeBlock;
        self.items = items;
        CGRect arrowFrame = CGRectZero;
        CGRect collectionFrame = CGRectZero;
        switch (direction) {
            case KGDislikeArrowDirectionDown: {
                self.layer.anchorPoint = CGPointMake(1.0, 0);
                NSLog(@"frame.size.width Down--%f",frame.size.width);
                arrowFrame = CGRectMake(frame.size.width - (kArrowWidth * (1 + kScale)), -kArrowHeight, kArrowWidth, kArrowHeight);
                collectionFrame = CGRectMake(0, kArrowHeight - kArrowHeight, frame.size.width, frame.size.height - kArrowHeight);
            }
                break;
            case KGDislikeArrowDirectionUp: {
                NSLog(@"frame.size.width Up--%f",frame.size.height);
                self.layer.anchorPoint = CGPointMake(1.0, 1.0);
//                arrowFrame = CGRectMake(frame.size.width - (kArrowWidth * (1 + kScale)), frame.size.height + (9 * kArrowHeight), kArrowWidth, kArrowHeight);
//                collectionFrame = CGRectMake(0, frame.size.height - (10 * kArrowHeight) + 5, frame.size.width, frame.size.height - kArrowHeight);
                arrowFrame = CGRectMake(frame.size.width - (kArrowWidth * (1 + kScale)), frame.size.height - kArrowHeight, kArrowWidth, kArrowHeight);
                collectionFrame = CGRectMake(0, 0, frame.size.width, frame.size.height - kArrowHeight);
            }
                break;
                
            default:
                break;
        }
        self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        KGDislikeArrowView *arrowView = [KGDislikeArrowView arrowViewWithFrame:arrowFrame arrowDirection:direction];
        [self addSubview:arrowView];
        [self buildReasonViewWithFrame:collectionFrame];
    }
    return self;
}

- (void)buildReasonViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 4.0;
    __block typeof(UIButton *) lastButton = nil;
    for (NSInteger idx = 0; idx < self.items.count; idx++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag                 = self.items[idx].dislikeId + kBaseTag;
        button.backgroundColor     = [UIColor whiteColor];
        button.layer.cornerRadius  = 4.0;
        button.layer.borderWidth   = 1.0;
        button.layer.borderColor   = separator_line_color.CGColor;
        button.layer.masksToBounds = YES;
        button.titleLabel.font     = [UIFont systemFontOfSize:13];
        [button setTitle:[NSString stringWithFormat:@"   %@   ", self.items[idx].dislikeText] forState:UIControlStateNormal];
        
        [button setTitleColor:important_gray_color forState:UIControlStateNormal];
        [button setTitleColor:important_red_color forState:UIControlStateSelected];
        [button addTarget:self action:@selector(onClickItemButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KGDislikeViewItemHeight);
            make.width.mas_equalTo(KGDislikeViewItemWidth);
            
            if (lastButton) {
                make.top.equalTo(lastButton.mas_bottom).offset(KGDislikeViewItemVerticalPadding);
            } else {
                make.top.equalTo(view).offset(59);
            }
            if (idx % 2) {
                make.left.equalTo(view.mas_centerX).offset(6);
                make.right.mas_lessThanOrEqualTo(view.mas_right).offset(-12);
                lastButton = button;
            } else {
                make.left.mas_equalTo(12);
                make.right.mas_lessThanOrEqualTo(view.mas_centerX).offset(-6);
            }
        }];
    }
    
    self.titleLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"可选理由, 精准屏蔽";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = important_gray_color;
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(24);
            make.top.mas_equalTo(22);
        }];
        label;
    });
    
    self.dislikeButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = important_red_color;
        button.layer.cornerRadius = 15.0;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
//        [button setBackgroundImage:important_red_color.kg_image forState:UIControlStateNormal];
        [button setTitle:@"不感兴趣" forState:UIControlStateNormal];
        [button setTitle:@"确定" forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onClickDislikeButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.right.equalTo(view.mas_right).offset(-24);
            make.size.mas_equalTo(CGSizeMake(90, 30));
        }];
        button;
    });
    
    self.reasonView = view;
    [self addSubview:view];
}

#pragma mark - UIButton action
- (void)onClickDislikeButton:(UIButton *)button {
    [self.class hide];
    NSString *reasonString = [self.dislikeReasonArray componentsJoinedByString:@","];
    if (self.dislikeBlock) {
        self.dislikeBlock(self, reasonString);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kDelNotification object:nil];
}

- (void)onClickItemButton:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        button.layer.borderColor = important_red_color.CGColor;
        [self.dislikeReasonArray addObject:[NSString stringWithFormat:@"%ld", button.tag - kBaseTag]];
    } else {
        button.layer.borderColor = separator_line_color.CGColor;
        for (NSString *reasonString in self.dislikeReasonArray) {
            if ([reasonString isEqualToString:[NSString stringWithFormat:@"%ld", button.tag - kBaseTag]]) {
                [self.dislikeReasonArray removeObject:reasonString];
                break;
            }
        }
    }
    if (self.dislikeReasonArray.count) {
        self.dislikeButton.selected = YES;
        NSString *titleString = [NSString stringWithFormat:@"已选%ld个理由", (unsigned long)self.dislikeReasonArray.count];
        NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:titleString];
        [mstr addAttribute:NSForegroundColorAttributeName value:important_red_color range:NSMakeRange(2, 1)];
        self.titleLabel.attributedText = [mstr copy];
    } else {
        self.dislikeButton.selected = NO;
        self.titleLabel.text = @"可选理由（可多选）";
    }
    // 设置选中并高亮状态下的title防止出现高亮状态title变化
    [self.dislikeButton setTitle:self.dislikeButton.currentTitle forState:UIControlStateHighlighted | UIControlStateSelected];
}



@end
