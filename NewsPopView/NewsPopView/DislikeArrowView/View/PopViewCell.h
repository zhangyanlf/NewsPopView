//
//  PopViewCell.h
//  newsPopView
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年 zhangyanlin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PopViewModel;
@protocol AddrListEditTableViewCellDelegate <NSObject>
/**删除*/
-(void)onAddrDelWithIndex:(NSInteger)index;

@end
@interface PopViewCell : UITableViewCell
@property (nonatomic) NSInteger index;
@property (nonatomic,weak) id<AddrListEditTableViewCellDelegate> delegate;
/**关闭按钮*/
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic,strong) PopViewModel *newsTopic;
@end
