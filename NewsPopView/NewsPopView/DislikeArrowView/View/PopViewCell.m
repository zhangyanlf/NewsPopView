//
//  PopViewCell.m
//  newsPopView
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年 zhangyanlin. All rights reserved.
//

#import "PopViewCell.h"
#import "KGDislikeView.h"
#import "DislikeModel.h"
#import "PopViewModel.h"

@interface PopViewCell ()
/**标题*/
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**日期*/
@property (weak, nonatomic) IBOutlet UILabel *newsData;


@end

@implementation PopViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setNewsTopic:(PopViewModel *)newsTopic
{
    _newsTopic = newsTopic;
    self.titleLabel.text = newsTopic.content;
    self.newsData.text = newsTopic.updatetime;
}

- (IBAction)closeButton:(id)sender
{
    [KGDislikeView showFromView:self items:[DislikeModel readDislikeReasons] dislikeBlock:^(KGDislikeView *dislikeView, NSString *reasonString) {
        
    }];
    if (self.delegate) {
        [self.delegate onAddrDelWithIndex:self.index];
    };
}

@end
