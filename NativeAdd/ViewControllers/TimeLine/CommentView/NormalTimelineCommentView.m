//
//  NormalTimelineCommentView.m
//  Unity-iPhone
//
//  Created by Karl on 2016/3/10.
//
//

#import "NormalTimelineCommentView.h"
#import <SDAutoLayout/UIView+SDAutoLayout.h>
#import "MLLinkLabel.h"
#import "CCComment.h"
#import "Constants.h"
@interface NormalTimelineCommentView ()<MLLinkLabelDelegate>
@property (nonatomic,strong) NSMutableArray *comments;
@property (nonatomic, strong) NSMutableArray *commentLabelsArray;
@end

@implementation NormalTimelineCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}
- (NSMutableArray *)commentLabelsArray
{
    if (!_commentLabelsArray) {
        _commentLabelsArray = [NSMutableArray new];
    }
    return _commentLabelsArray;
}
- (void)setupViews
{
//    _bgImageView = [UIImageView new];
//    UIImage *bgImage = [[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
//    _bgImageView.image = bgImage;
//    [self addSubview:_bgImageView];
//    
//    _likeLabel = [UILabel new];
//    [self addSubview:_likeLabel];
//    
//    _likeLableBottomLine = [UIView new];
//    _likeLableBottomLine.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:_likeLableBottomLine];
//    
//    _bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}
- (void)setComments:(NSMutableArray *)comments
{
    _comments = comments;
    
    long originalLabelsCount = self.commentLabelsArray.count;
    long needsToAddCount = comments.count > originalLabelsCount ? (comments.count - originalLabelsCount) : 0;
    for (int i = 0; i < needsToAddCount; i++) {
        MLLinkLabel *label = [MLLinkLabel new];
        UIColor *highLightColor = CCamRedColor;
        label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
        label.font = [UIFont systemFontOfSize:14];
        label.delegate = self;
        [self addSubview:label];
        [self.commentLabelsArray addObject:label];
    }
    
    for (int i = 0; i < comments.count; i++) {
        CCComment *model = comments[i];
        MLLinkLabel *label = self.commentLabelsArray[i];
        label.attributedText = [self generateAttributedStringWithCommentItemModel:model];
    }

}
- (void)setUpWithComments:(NSMutableArray *)comments
{
    _comments = comments;
    
    if (self.commentLabelsArray.count) {
        [self.commentLabelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            [label sd_clearAutoLayoutSettings];
            label.frame = CGRectZero;
        }];
    }
    
    CGFloat margin = 5;

    UIView *lastTopView;
    
    for (int i = 0; i < self.comments.count; i++) {
        UILabel *label = (UILabel *)self.commentLabelsArray[i];
        CGFloat topMargin = i == 0 ? 10 : 5;
        label.sd_layout
        .leftSpaceToView(self, 8)
        .rightSpaceToView(self, 5)
        .topSpaceToView(lastTopView, topMargin)
        .autoHeightRatio(0);
        
        label.isAttributedContent = YES;
        lastTopView = label;
    }
    
    [self setupAutoHeightWithBottomView:lastTopView bottomMargin:6];
    
}
#pragma mark - private actions

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(CCComment *)model
{
    NSString *text = model.userName;
    
    text = [text stringByAppendingString:[NSString stringWithFormat:@"    %@", model.comment]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = CCamRedColor;
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.userID} range:[text rangeOfString:model.userName]];
    
    return attString;
}


#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    NSLog(@"%@", link.linkValue);
}

@end
