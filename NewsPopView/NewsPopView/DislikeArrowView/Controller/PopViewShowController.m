//
//  PopViewShowController.m
//  newsPopView
//
//  Created by apple on 16/12/8.
//  Copyright © 2016年 zhangyanlin. All rights reserved.
//

#import "PopViewShowController.h"

@interface PopViewShowController ()
/**笑话label*/
@property (weak, nonatomic) IBOutlet UILabel *jokeLabel;

@end

@implementation PopViewShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavView];
    self.jokeLabel.text = self.jokeStr;
    
}
/**返回按钮*/
-(void)createNavView
{
    
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    navButton.frame = CGRectMake(0, 0, 85, 30);
    [navButton setTitle:@"开心麻花" forState:UIControlStateNormal];
    [navButton setImage:[UIImage imageNamed:@"arrow-zc"] forState:UIControlStateNormal];
    [navButton addTarget:self action:@selector(clickbackButton) forControlEvents:UIControlEventTouchUpInside];
    navButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    navButton.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 0);
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    [navButton setTitleColor:[UIColor colorWithRed:13/255.0 green:173/255.0 blue:213/255.0 alpha:1.0] forState:UIControlStateNormal];
    [navButton setTitleColor:[UIColor colorWithRed:114/255.0 green:204/255.0 blue:226/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [navButton setImage:[UIImage imageNamed:@"arrow-press-zc"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = barButton;
    
}

/**点击返回动作*/
- (void) clickbackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
