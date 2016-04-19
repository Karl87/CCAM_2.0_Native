//
//  CCPhotoViewController.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/20.
//
//

#import "KLViewController.h"
#import "CCTimeLine.h"

@interface CCPhotoViewController : KLViewController
@property (nonatomic,copy) NSString *photoID;
@property (nonatomic,strong) NSMutableArray *reloadIndexs;

@end
