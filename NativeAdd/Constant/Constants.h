//
//  Constants.h
//  CCamNativeKit
//
//  Created by Karl on 2015/11/16.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//#ifdef __OPTIMIZE__
//# define NSLog(...) {}
//#else
//# define NSLog(...) NSLog(__VA_ARGS__)
//#endif

#define GetValidString(_x_) (![_x_ isKindOfClass:[NSNull class]] && _x_ != nil) ? [NSString stringWithFormat:@"%@",_x_] : [NSString stringWithFormat:@""]
#define GetValidNumber(_x_) (![_x_ isKindOfClass:[NSNull class]] && _x_ != nil) ? [NSString stringWithFormat:@"%@",_x_] : [NSString stringWithFormat:@"0"]
#define GetValidChar( _x_ ) ( _x_ != NULL ) ? [NSString stringWithFormat:@"%@",_x_] : [NSString stringWithFormat:@""]

#define iOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define iOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#define iOS9 [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0

#define CCamTestToken @"siovphrQ0U"//2222
#define SMSAppKey @"8a2e16d3094a"
#define SMSAppSecret @"e337bbef0f3cfb18fcfc92c8b5f42148"

#define CCamHost @"http://www.c-cam.cc/"
#define CCamString @"CCAM"

#define UnityController @"_plantFormInteractions"

#define CCamDocPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0]

#define CCamNavigationBarHeight 64.0
#define CCamTabBarHeight 49.0
#define CCamViewWidth [UIScreen mainScreen].bounds.size.width
#define CCamViewHeight [UIScreen mainScreen].bounds.size.height
#define CCamSegItemWidth 66.0
#define CCamSegItemHeight 44.0
#define CCamSegSliderHeight 2.0
#define CCamSegSliderWidth 44.0

#define CCamThinNaviHeight 38.0 * [UIScreen mainScreen].bounds.size.height/667
#define CCamThinSegHeight 35.0* [UIScreen mainScreen].bounds.size.height/667//30.0* [UIScreen mainScreen].bounds.size.height/667
#define CCamThinSerieHeight 35.0* [UIScreen mainScreen].bounds.size.height/667

#define CCamScrollInset UIEdgeInsetsMake(0, 0, 64, 0)

#define CCamBarTintColor    [UIColor colorWithRed:23.0/255.0 green:22.0/255.0 blue:30.0/255.0 alpha:1.0]
#define CCamViewBackgroundColor [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]
#define CCamGoldColor [UIColor colorWithRed:245.0/255.0 green:142.0/255.0 blue:9.0/255.0 alpha:1.0]
#define CCamGrayTextColor [UIColor colorWithRed:91.0/255.0 green:88.0/255.0 blue:99.0/255.0 alpha:1.0]


#define CCamCameraNaviColor [UIColor colorWithRed:31.0/255.0 green:31.0/255.0 blue:31.0/255.0 alpha:1.0]
#define CCamRedColor    [UIColor colorWithRed:229.0/255.0 green:48.0/255.0 blue:21.0/255.0 alpha:1.0]
#define CCamYellowColor [UIColor colorWithRed:247.0/255.0 green:188.0/255.0 blue:0.0/255.0 alpha:1.0]
#define CCamExLightGrayColor [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:246.0/255.0 alpha:1.0]
#define CCamPageSelectColor [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0]
#define CCamPageNormalColor [UIColor colorWithRed:173.0/255.0 green:173.0/255.0 blue:173.0/255.0 alpha:1.0]
#define CCamSegmentColor [UIColor colorWithRed:31.0/255.0 green:31.0/255.0 blue:31.0/255.0 alpha:1.0]

#define CCamBackgoundGrayColor [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0]
#define CCamSwitchNormalColor [UIColor colorWithRed:110.0/255.0 green:108.0/255.0 blue:118.0/255.0 alpha:1.0]

#define CCamPhotoSegDarkGray [UIColor colorWithRed:147.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]
#define CCamPhotoSegLightGray [UIColor colorWithRed:199.0/255.0 green:197.0/255.0 blue:197.0/255.0 alpha:1.0]


#define CCamGetSeriesURL @"http://www.c-cam.cc/index.php/Api_new/Getmemberxml/get_series_json.html"
#define CCamGetAnimationURL @"http://www.c-cam.cc/index.php/Api_new/Index/get_animations_json.html"
#define CCamGetStickersURL @"http://www.c-cam.cc/index.php/Api_new/Getsticker/get_sticker_json.html"

#define CCamGetSerieURL @"http://www.c-cam.cc/index.php/Api/Index/get_series_list.html"
#define CCamGetEventURL @"http://www.c-cam.cc/index.php/Api/Index/get_index.html"
#define CCamGetDiscoveryURL @"http://www.c-cam.cc/index.php/Api/Discover/index.html"
#define CCamGetDiscoveryMoreURL @"http://www.c-cam.cc/index.php/Api/Discover/load_work.html"
#define CCamLikePhotoURL @"http://www.c-cam.cc/index.php/Api/Index/like_work.html"

#define CCamGetCurrentContestsURL @"http://www.c-cam.cc/index.php/Api/Uploadphoto/get_contests_info.html"
#define CCamSubmitPhotoURL @"http://www.c-cam.cc/index.php/Api/Uploadphoto/upload.html"

#define  CCamGetTimeLineURL @"http://www.c-cam.cc/index.php/Api_new/Index/get_follow_photos.html"

#define CCamPullUpdate @"下拉列表刷新数据"
#define CCamReleaseUpdate @"释放列表进行刷新"
#define CCamUpdating @"更新数据..."
#define CCamUpdateSuccess @"更新数据成功"
#define CCamUpdateFail @"更新数据失败"

#define CCamPullRefreshPage @"下拉刷新页面"
#define CCamReleaseRefreshPage @"释放进行刷新"
#define CCamUpdatingPage @"刷新页面..."
#define CCamUpdatePageSuccess @"页面加载成功"
#define CCamUpdatePageFail @"页面加载失败"
/////
#define CCamSettingTagInfoVersion @"CCamInfoVersion"

typedef NS_ENUM(NSInteger, CCamCollectionViewType) {
    CCamSegmentCollectionView = 0,
    CCamSegmentContentCollectionView = 1,
    CCamSerieCollectionView = 2,
    CCamSerieContentCollectionView = 3,
    CCamCharacterCollectionView = 4,
    CCamStickerSetCollectionView = 5,
    CCamStickerSetContentCollectionView = 6,
    CCamStickerCollectionView = 7,
    CCamFilterCollectionView = 8
};


#endif /* Constants_h */


