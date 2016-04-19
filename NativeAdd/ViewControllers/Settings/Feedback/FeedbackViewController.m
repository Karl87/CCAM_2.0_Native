//
//  FeedbackViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/3/3.
//
//

#import "FeedbackViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface FeedbackViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *feedback;
@property (nonatomic,strong) UITextView *contactInfo;
@property (nonatomic,strong) UITextView *feedbackInfo;
@property (nonatomic,strong) NSArray *titles;
@end

@implementation FeedbackViewController

- (void)submitFeedback{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (_contactInfo.text.length == 0) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = Babel(@"请留下您的联系方式");
        [hud hide:YES afterDelay:1.0f];
        return;
    }
    if (_feedbackInfo.text.length ==0) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = Babel(@"请填写您的意见或反馈");
        [hud hide:YES afterDelay:1.0f];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"token" :[[AuthorizeHelper sharedManager] getUserToken],@"message":[_feedbackInfo.text copy],@"contact":[_contactInfo.text copy]};
    
    [manager POST:CCamFeedbackURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = Babel(@"反馈发布成功");
        hud.detailsLabelText = Babel(@"您的意见对我们十分重要，我们将尽快处理");
        [hud hide:YES afterDelay:2.0f];
        
        _feedbackInfo.text = @"";
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.mode = MBProgressHUDModeText;
        [hud setLabelText:Babel(@"网络故障")];
        [hud hide:YES afterDelay:1.0f];
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *submit =[[UIBarButtonItem alloc] initWithTitle:Babel(@"提交") style:UIBarButtonItemStylePlain target:self action:@selector(submitFeedback)];
    [self.navigationItem setRightBarButtonItem:submit];
    
    _titles = @[Babel(@"请留下您的联系方式"),Babel(@"请填写您的意见或反馈")];
    
    _feedback = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [_feedback registerClass:[UITableViewCell class] forCellReuseIdentifier:@"contactCell"];
    [_feedback registerClass:[UITableViewCell class] forCellReuseIdentifier:@"feedbackCell"];
    [self.view addSubview:_feedback];
    [_feedback setBackgroundColor:CCamViewBackgroundColor];
    [_feedback setSeparatorColor:CCamViewBackgroundColor];
    [_feedback setDelegate:self];
    [_feedback setDataSource:self];
    if (self.hidesBottomBarWhenPushed) {
        [_feedback setContentInset:UIEdgeInsetsMake(0, 0, 64, 0)];
        
    }else{
        [_feedback setContentInset:UIEdgeInsetsMake(0, 0, 64+49, 0)];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"contactCell";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    static NSString *identifier = @"feedbackCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        if (!_contactInfo) {
            _contactInfo = [UITextView new];
            [_contactInfo setFrame:CGRectMake(10, 4, cell.bounds.size.width-20, cell.bounds.size.height-8)];
            [cell.contentView addSubview:_contactInfo];
        }else{
            [cell.contentView addSubview:_contactInfo];
        }

    }else{
        if (!_feedbackInfo) {
            _feedbackInfo = [UITextView new];
            [_feedbackInfo setFrame:CGRectMake(10, 4, cell.bounds.size.width-20, cell.bounds.size.height-8)];
            [cell.contentView addSubview:_feedbackInfo];
        }else{
            [cell.contentView addSubview:_feedbackInfo];
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 44;
    }else{
        return 200;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *identifier = @"header";
    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    [view setFrame:CGRectMake(0, 0, CCamViewWidth, 30)];
    
    UILabel *lab = [UILabel new];
    [lab setFrame:CGRectMake(10, 0, CCamViewWidth-20, 30)];
    [view addSubview:lab];
    [lab setText:[_titles objectAtIndex:section]];
    [lab setTextColor:CCamGrayTextColor];
    [lab setFont:[UIFont boldSystemFontOfSize:14.0]];
    
    return view;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    view.tintColor = CCamViewBackgroundColor;
}
@end
