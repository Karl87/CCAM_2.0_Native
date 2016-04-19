//
//  TimelineCommentView.m
//  Unity-iPhone
//
//  Created by Karl on 2016/4/7.
//
//

#import "TimelineCommentView.h"
#import "UIView+SDAutoLayout.h"
#import "CCTimeLine.h"
#import "MLLinkLabel.h"
#import "CCComment.h"
#import "Constants.h"
#import "TimelineCell.h"

@interface TimelineCommentView() <MLLinkLabelDelegate>
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSMutableArray *commentLabels;
@end

@implementation TimelineCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}
- (void)setupViews{
    if (!_commentLabels) {
        _commentLabels = [NSMutableArray new];
    }
    _placeholderLabel = [UILabel new];
    [self addSubview:_placeholderLabel];
}
- (void)setComments:(NSArray *)comments{
    _comments = comments;
    long originalLabelsCount = _commentLabels.count;
    long needsToAddCount = comments.count > originalLabelsCount ? (comments.count - originalLabelsCount) : 0;
    for (int i = 0; i < needsToAddCount; i++) {
        MLLinkLabel *label = [MLLinkLabel new];
        label.dataDetectorTypes = MLDataDetectorTypeAll;
        label.allowLineBreakInsideLinks = YES;
        label.linkTextAttributes = nil;
        label.activeLinkTextAttributes = nil;
        [label setTextColor:CCamGrayTextColor];
        label.font = [UIFont systemFontOfSize:13];
        label.delegate = self;
        [self addSubview:label];
        [_commentLabels addObject:label];
    }
    
    for (int i = 0; i < comments.count; i++) {
        CCComment *model = comments[i];
        MLLinkLabel *label = _commentLabels[i];
        [label setBeforeAddLinkBlock:^(MLLink *link) {
            if (link.linkType==MLLinkTypeOther) {
                if ([model.userID isEqualToString:@"count"]){
                    link.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:13]};
                }else{
                    link.linkTextAttributes = @{NSForegroundColorAttributeName:CCamRedColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:13]};
                }
            }else{
                link.linkTextAttributes = @{NSForegroundColorAttributeName:kDefaultLinkColorForMLLinkLabel};
            }
        }];
        label.attributedText = [self generateAttributedStringWithCommentItemModel:model];
    }
}
- (NSMutableArray *)commentLabels
{
    if (!_commentLabels) {
        _commentLabels = [NSMutableArray new];
    }
    return _commentLabels;
}
- (void)setupCommentItemsArray:(NSArray *)comments{
    
    self.comments = comments;
    
    [_placeholderLabel sd_clearAutoLayoutSettings];
    _placeholderLabel.frame = CGRectZero;
    
    if (_commentLabels.count) {
        [_commentLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            [label sd_clearAutoLayoutSettings];
            label.frame = CGRectZero;
        }];
    }
    
    _placeholderLabel.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(self, 5)
    .autoHeightRatio(0);
    
    _placeholderLabel.isAttributedContent = YES;
    
    UIView *lastTopView = _placeholderLabel;
    
    for (int i = 0; i < _comments.count; i++) {
        UILabel *label = (UILabel *)_commentLabels[i];
        CGFloat topMargin = i == 0 ? 5 : 5;
        label.sd_layout
        .leftSpaceToView(self, 5)
        .rightSpaceToView(self, 5)
        .topSpaceToView(lastTopView, topMargin)
        .autoHeightRatio(0);
            
        label.isAttributedContent = YES;
        lastTopView = label;
    }
    [self setupAutoHeightWithBottomView:lastTopView bottomMargin:0];
}
#pragma mark - private actions

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(CCComment *)model
{
    NSString* name = model.userName;
    NSString* userid = model.userID;
    NSString *comment = model.comment;
//    NSLog(@"fuck %@;%@;%@",name,userid,comment);
    
    if (!name || !userid || !comment) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@""];
        return attString;
    }
    
    NSString *text = model.userName;
    
    if (model.replyUserID.length && model.replyUserName.length) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@" 回复 %@", model.replyUserName]];
    }
    if ([model.userID isEqualToString:@"count"]) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"%@", model.comment]];

    }else{
        text = [text stringByAppendingString:[NSString stringWithFormat:@" : %@", model.comment]];

    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = CCamRedColor;
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.userID} range:[text rangeOfString:model.userName]];
    
    if (model.replyUserName) {
        [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.replyUserID} range:[text rangeOfString:model.replyUserName]];
    }
    
    return attString;
}


#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    NSLog(@"LinkType:%lu",(unsigned long)link.linkType);
    NSLog(@"LinkText:%@", linkText);
    NSLog(@"LinkValue:%@", link.linkValue);
    
    if (_parent && [_parent isKindOfClass:[TimelineCell class]]&&link.linkType==MLLinkTypeOther) {
        if ([link.linkValue isEqualToString:@"count"]) {
            TimelineCell*cell = (TimelineCell*)_parent;
            [cell callCommentPage:nil];
        }else{
            TimelineCell*cell = (TimelineCell*)_parent;
            [cell openUserPageWithID:link.linkValue andName:linkText];
        }
    }
}
@end
