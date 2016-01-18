//
//  CCSerieViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/11.
//
//

#import "CCSerieViewController.h"
#import "SerieCell.h"
#import "CCSerie.h"
#import "CCamHelper.h"
#import <pop/POP.h>

@interface CCSerieViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign) BOOL needUpdate;
@property (nonatomic,assign) NSInteger serieOrderType;
@property (nonatomic,strong) NSMutableArray *orderSeries;
@property (nonatomic,strong) NSMutableArray *popularSeries;
@property (nonatomic,strong) NSMutableArray *lastestSeries;
@property (nonatomic,strong) UIView *segmentView;
@property (nonatomic,strong) NSMutableArray *segmegtItems;
@property (nonatomic,strong) UIView *segmentSlider;
@end

@implementation CCSerieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _serieOrderType = 0;
    _needUpdate = YES;
    
    _orderSeries = [[NSMutableArray alloc] initWithCapacity:0];
    _popularSeries = [[NSMutableArray alloc] initWithCapacity:0];
    _lastestSeries = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray* segArray = @[@"Best",@"Hot",@"New"];
    _segmegtItems = [[NSMutableArray alloc] initWithCapacity:0];
    
    _segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CCamSegItemWidth*segArray.count, CCamSegItemHeight)];
    [_segmentView setBackgroundColor:[UIColor clearColor]];
    [self.navigationItem setTitleView:_segmentView];
    
    for (int i = 0 ; i <segArray.count; i++) {
        UIButton *segButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [segButton setFrame:CGRectMake(CCamSegItemWidth*i, 0, CCamSegItemWidth, CCamSegItemHeight)];
        [segButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.]];
        [segButton setTitle:[segArray objectAtIndex:i] forState:UIControlStateNormal];
        if (i == 0) {
            [segButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [segButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [segButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [segButton setBackgroundColor:[UIColor clearColor]];
        [segButton setTag:i];
        [segButton addTarget:self action:@selector(segItemOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_segmentView addSubview:segButton];
        [_segmegtItems addObject:segButton];
    }
    
    _segmentSlider = [[UIView alloc] initWithFrame:CGRectMake(0, CCamSegItemHeight-CCamSegSliderHeight, CCamSegItemWidth, CCamSegSliderHeight)];
    [_segmentSlider setBackgroundColor:[UIColor clearColor]];
    UIView *segmentSlider = [[UIView alloc] initWithFrame:CGRectMake((CCamSegItemWidth-CCamSegSliderWidth)/2, 0, CCamSegSliderWidth, CCamSegSliderHeight)];
    [segmentSlider setBackgroundColor:[UIColor whiteColor]];
    [_segmentSlider addSubview:segmentSlider];
    [_segmentView addSubview:_segmentSlider];

    
    
    self.serieTable = [self returnTableViewWithFrame:CGRectMake(0, 0, CCamViewWidth, CCamViewHeight)
                                               style:UITableViewStylePlain
                                      separatorStyle:UITableViewCellSeparatorStyleNone
                                     backgroundColor:CCamViewBackgroundColor
                                        contentInset:CCamScrollInset
                               scrollIndicatorInsets:CCamScrollInset
                                          parentView:self.view];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshSerie)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _serieTable.refresh = header;
    _serieTable.mj_header = _serieTable.refresh;

    [self.serieTable setDelegate:self];
    [self.serieTable setDataSource:self];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self viewDidAppearRefreshData];
}
- (void)viewDidAppearRefreshData{
    if (!self.needUpdate) {
        return;
    }
    [_serieTable.refresh beginRefreshing];
    self.needUpdate = NO;
}
- (void)refreshSerie{
    [[DataHelper sharedManager] updateSeriesInfo];
}
- (void)reloadSerieData{
    
    [_orderSeries removeAllObjects];
    [_popularSeries removeAllObjects];
    [_lastestSeries removeAllObjects];
    
    _orderSeries = [[DataHelper sharedManager].series mutableCopy];
    [_popularSeries addObjectsFromArray:[_orderSeries sortedArrayUsingSelector:@selector(compareSerieWithPopular:)]];
    [_lastestSeries addObjectsFromArray:[_orderSeries sortedArrayUsingSelector:@selector(compareSerieWithTime:)]];
    
    
    NSLog(@"%lu",(unsigned long)[DataHelper sharedManager].series.count);
    NSLog(@"%lu",(unsigned long)self.orderSeries.count);
    NSLog(@"%lu",(unsigned long)self.popularSeries.count);
    NSLog(@"%lu",(unsigned long)self.lastestSeries.count);
    
    [_serieTable reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_serieOrderType == 0) {
        return [_orderSeries count];
    }else if (_serieOrderType == 1){
        return [_popularSeries count];
    }else if (_serieOrderType ==2){
        return [_lastestSeries count];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.serieTable) {
        
        static NSString *identifier = @"SerieCell";
        
        CCSerie *serie;
        
        if (_serieOrderType == 0) {
            serie = (CCSerie*)[_orderSeries objectAtIndex:indexPath.row];
        }else if (_serieOrderType == 1){
            serie = (CCSerie*)[_popularSeries objectAtIndex:indexPath.row];
        }else if (_serieOrderType ==2){
            serie = (CCSerie*)[_lastestSeries objectAtIndex:indexPath.row];
        }
        
        SerieCell *cell = [[SerieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.serieImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CCamHost,serie.image_List]] placeholderImage:[[UIImage alloc] init]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    static NSString *identifier = @"DefaultTableViewCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return (CCamViewWidth-10)*150/640;
}
#pragma mark - SegmentControl
- (void)segItemOnClick:(id)sender{
    UIButton *button  = (UIButton*)sender;
    self.serieOrderType = button.tag;
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.fromValue =[NSValue valueWithCGRect:_segmentSlider.frame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(self.serieOrderType*_segmentSlider.frame.size.width, _segmentSlider.frame.origin.y, _segmentSlider.frame.size.width, _segmentSlider.frame.size.height)];
    anim.beginTime = CACurrentMediaTime();
    anim.duration = 0.25f;
    [_segmentSlider pop_addAnimation:anim forKey:@"position"];
    [self.serieTable reloadData];
}
@end
