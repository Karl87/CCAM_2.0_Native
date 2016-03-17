//
//  FollowCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/2/23.
//
//
#define profileSize 30.0

#import "FollowCell.h"
#import "CCUserViewController.h"
#import <SDAutoLayout/UIView+SDAutoLayout.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface FollowCell ()<UIAlertViewDelegate>
@property (nonatomic,assign) NSInteger ifFollow;
@property (nonatomic,strong) UIAlertView *deleteFollowAlert;
@end

@implementation FollowCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpFollowCell];
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)setUpFollowCell{
    _profile = [UIImageView new];
    [_profile.layer setMasksToBounds:YES];
    [_profile.layer setCornerRadius:profileSize/2];
    
    _userName = [UILabel new];
    [_userName setBackgroundColor:[UIColor clearColor]];
    [_userName setTextAlignment:NSTextAlignmentLeft];
    [_userName setTextColor:CCamGrayTextColor];
    [_userName setFont:[UIFont boldSystemFontOfSize:14.0]];
    
    _funcBtn = [UIButton new];
    [_funcBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_funcBtn.layer setMasksToBounds:YES];
    [_funcBtn.layer setCornerRadius:profileSize/2];
    [_funcBtn addTarget:self action:@selector(followBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *views = @[_profile,_userName,_funcBtn];
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    UIView *contentView = self.contentView;
    _profile.sd_layout
    .leftSpaceToView(contentView,10)
    .topSpaceToView(contentView,7)
    .heightIs(profileSize)
    .widthIs(profileSize);
    
    _userName.sd_layout
    .leftSpaceToView(_profile,10)
    .topEqualToView(_profile)
    .heightIs(profileSize)
    .widthIs(200);
    
    _funcBtn.sd_layout
    .rightSpaceToView(contentView,10)
    .topEqualToView(_profile)
    .heightIs(profileSize)
    .widthIs(100);
}
- (void)setUser:(NSDictionary *)user{
    _user = user;
    [_profile sd_setImageWithURL:[NSURL URLWithString:[_user objectForKey:@"image_url"]] placeholderImage:nil];
    [_userName setText:[_user objectForKey:@"name"]];
    _ifFollow =[[_user objectForKey:@"follow"] integerValue];
    [self initFuncButton];
}
- (void)initFuncButton{
    if ( _ifFollow== 0) {
        [_funcBtn setTitle:Babel(@"关注") forState:UIControlStateNormal];
        [_funcBtn setBackgroundColor:[UIColor whiteColor]];
        [_funcBtn setTitleColor:CCamRedColor forState:UIControlStateNormal];
        [_funcBtn.layer setBorderColor:CCamRedColor.CGColor];
        [_funcBtn.layer setBorderWidth:1.0];
    }else if (_ifFollow == -1){
        [_funcBtn setHidden:YES];
    }else{
        [_funcBtn setTitle:Babel(@"已关注") forState:UIControlStateNormal];
        [_funcBtn setBackgroundColor:CCamYellowColor];
        [_funcBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_funcBtn.layer setBorderColor:CCamYellowColor.CGColor];
        [_funcBtn.layer setBorderWidth:1.0];
    }
}
- (void)followBtnOnClick{
    if ([_funcBtn.currentTitle isEqualToString:Babel(@"关注")]) {
        [self followUser];
    }else if ([_funcBtn.currentTitle isEqualToString:Babel(@"已关注")]){
        NSString *alertMsg = [NSString stringWithFormat:@"%@%@%@？",Babel(@"是否取消对"),[_user objectForKey:@"name"],Babel(@"的关注")];
        _deleteFollowAlert = [[UIAlertView alloc] initWithTitle:@"提醒" message:alertMsg delegate:self cancelButtonTitle:Babel(@"保持关注") otherButtonTitles:Babel(@"取消关注"), nil];
        [_deleteFollowAlert show];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)followUser{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_parent.view animated:YES];
    hud.labelText = Babel(@"关注用户中");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *userToken = [[AuthorizeHelper sharedManager] getUserToken];
    NSDictionary *parameters = @{@"bymemberid":[_user objectForKey:@"memberid"],@"token":userToken};
    [manager POST:CCamFollowURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *state =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",state);
        if ([state isEqualToString:@"1"]||[state isEqualToString:@"-2"]) {
            _ifFollow = 1;
            [hud hide:YES];
            [self initFuncButton];
        }else{
            hud.mode = MBProgressHUDModeText;
            hud.labelText = Babel(@"关注失败");
            [hud hide:YES afterDelay:1.0];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = Babel(@"网络故障");
        [hud hide:YES afterDelay:1.0];
    }];
    
}
- (void)deleteFollowUser{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_parent.view animated:YES];
    hud.labelText = Babel(@"取消关注中");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *userToken = [[AuthorizeHelper sharedManager] getUserToken];
    NSDictionary *parameters = @{@"bymemberid":[_user objectForKey:@"memberid"],@"token":userToken};
    [manager POST:CCamDeleteFollowURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *state =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",state);
        if ([state isEqualToString:@"1"]) {
            _ifFollow = 0;
            [hud hide:YES];
            [self initFuncButton];
        }else{
            hud.mode = MBProgressHUDModeText;
            hud.labelText = Babel(@"取消关注失败");
            [hud hide:YES afterDelay:1.0];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = Babel(@"网络故障");
        [hud hide:YES afterDelay:1.0];
    }];
    
}
#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == _deleteFollowAlert) {
        NSLog(@"%ld",buttonIndex);
        if (buttonIndex == 1) {
            [self deleteFollowUser];
        }
    }
}
@end
