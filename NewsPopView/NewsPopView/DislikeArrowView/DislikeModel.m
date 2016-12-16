//
//  DislikeModel.m
//  KG_Video
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年 zhangyanlin. All rights reserved.
//

#define kDislikeReasonKey   @"/config/dislike.json"

#import "DislikeModel.h"
//#import "KGCacheManager.h"


@implementation DislikeModel

+ (void)saveDislikeReasonFromResponseObject:(id)object {
//    [KGCacheManager saveCache:[self dataArrayFromResponseObject:object] forKey:kDislikeReasonKey];
}

+ (NSArray *)readDislikeReasons {
//    NSArray *cacheArray = [KGCacheManager cacheForKey:kDislikeReasonKey];
//    if (cacheArray.count) {
//        return cacheArray;
//    }
    NSArray *defaultReasonTitles = @[@"重复、旧闻", @"标题党", @"来源:聚合笑话", @"不能逗我开心"];
    NSMutableArray *defaultReasons = [NSMutableArray array];
    for (NSInteger idx = 0; idx < defaultReasonTitles.count; idx++) {
        DislikeModel *dislike = [self new];
        dislike.dislikeId = idx + 1;
        dislike.dislikeText = defaultReasonTitles[idx];
        [defaultReasons addObject:dislike];
    }
    return [defaultReasons copy];
}

@end
