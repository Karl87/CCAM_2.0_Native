//
//  CCSerieViewController.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/11.
//
//

#import "KLTableViewController.h"

@interface CCSerieViewController : KLTableViewController

@property (nonatomic,strong) KLTableView *serieTable;

- (void)reloadSerieData;
//- (void)setRefreshControlStateWithRefresh:(UIRefreshControl*)refresh andState:(NSString*)state;
//- (void)serieRefreshEndAnimation;

@end
