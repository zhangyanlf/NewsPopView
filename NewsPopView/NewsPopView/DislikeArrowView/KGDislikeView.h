//
//  KGDislikeView.h
//  test
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年 zhangyanlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DislikeModel.h"

@class KGDislikeView;
typedef void(^KGDislikeViewBlock)(KGDislikeView *dislikeView, NSString *reasonString);

@interface KGDislikeView : UIView

+ (instancetype)showFromView:(UIView *)aView items:(NSArray <DislikeModel *> *)items dislikeBlock:(KGDislikeViewBlock)dislikeBlock;

@end
