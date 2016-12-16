//
//  KGDislikeArrowView.m
//  KG_Video
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年 zhangyanlin. All rights reserved.
//

#import "KGDislikeArrowView.h"

@implementation KGDislikeArrowView {
    KGDislikeArrowDirection _arrowDirection;
}

+ (instancetype)arrowViewWithFrame:(CGRect)frame arrowDirection:(KGDislikeArrowDirection)arrowDirection {
    return [[self alloc] initWithFrame:frame arrowDirection:arrowDirection];
}

- (instancetype)initWithFrame:(CGRect)frame arrowDirection:(KGDislikeArrowDirection)arrowDirection {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _arrowDirection = arrowDirection;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGSize currentSize = rect.size;
    
    UIColor *color = [UIColor whiteColor];
    [color set];
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    aPath.lineWidth = 1.0;
    aPath.lineCapStyle = kCGLineCapRound;
    switch (_arrowDirection) {
        case KGDislikeArrowDirectionDown: {
            [aPath moveToPoint:CGPointMake(0, currentSize.height)];
            [aPath addQuadCurveToPoint:CGPointMake(currentSize.width, 0) controlPoint:CGPointMake(currentSize.width * kScale, currentSize.height * kScale)];
            [aPath addQuadCurveToPoint:CGPointMake(currentSize.width, currentSize.height) controlPoint:CGPointMake(currentSize.width * kScale, currentSize.height * kScale)];
        }
            break;
        case KGDislikeArrowDirectionUp: {
            [aPath moveToPoint:CGPointMake(0, 0)];
            [aPath addQuadCurveToPoint:CGPointMake(currentSize.width, currentSize.height) controlPoint:CGPointMake(currentSize.width * kScale, currentSize.height * (1 - kScale))];
            [aPath addQuadCurveToPoint:CGPointMake(currentSize.width, 0) controlPoint:CGPointMake(currentSize.width * kScale, currentSize.height * (1 - kScale))];
        }
            break;
            
        default:
            break;
    }
    
    
    [aPath fill];
}

@end
