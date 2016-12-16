//
//  DislikeModel.h
//  KG_Video
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年 zhangyanlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DislikeModel : NSObject

@property (nonatomic, assign) NSInteger dislikeId;
@property (nonatomic,   copy) NSString  *dislikeText;

+ (void)saveDislikeReasonFromResponseObject:(id)object;
+ (NSArray *)readDislikeReasons;

@end
