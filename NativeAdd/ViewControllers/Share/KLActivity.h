//
//  KLActivity.h
//  Unity-iPhone
//
//  Created by Karl on 2016/2/25.
//
//

#import <UIKit/UIKit.h>

@interface KLActivity : UIActivity
@property (nonatomic,strong) UIImage *shareImage;
@property (nonatomic,copy)NSString *URL;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)NSArray *getShareArray;
-(instancetype)initWithImage:(UIImage *)shareImage URL:(NSString *)URL title:(NSString *)title shareContentArray:(NSArray *)shareContentArray;
@end
