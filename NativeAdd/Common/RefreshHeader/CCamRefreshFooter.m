//
//  CCamRefreshFooter.m
//  Unity-iPhone
//
//  Created by Karl on 2016/3/22.
//
//

#import "CCamRefreshFooter.h"

@implementation CCamRefreshFooter

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置正在刷新状态的动画图片
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 31; i<35; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh___%lu", (unsigned long)i]];
        [refreshingImages addObject:image];
    }

    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

@end
