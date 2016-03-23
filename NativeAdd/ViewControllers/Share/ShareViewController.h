//
//  ShareViewController.h
//  Unity-iPhone
//
//  Created by Karl on 2016/3/7.
//
//

#import "KLViewController.h"
#import "CCTimeLine.h"
#import "TimelineCell.h"

@protocol ShareViewDelegate <NSObject>

- (void)shareViewBtnClickWithType:(NSString*)type andTitle:(NSString*)title isShareImage:(BOOL)isShare;
- (void)dissmisShareViewWith:(NSIndexPath*)indexPath;

@end

@interface ShareViewController : KLViewController
@property (nonatomic,assign) id<ShareViewDelegate> delegate;
@property (nonatomic,assign) BOOL myself;
@property (nonatomic,strong) CCTimeLine *timeline;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) BOOL onlyShare;
@property (nonatomic,assign) BOOL isShareImage;
@property (nonatomic,strong) TimelineCell *timelineCell;
@end
