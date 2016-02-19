//
//  DataHelper.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/16.
//
//

#import <Foundation/Foundation.h>
#import "CCCharacter.h"

#import "CCamViewController.h"
#import "CCSerieViewController.h"

@interface DataHelper : NSObject

@property (nonatomic,strong) NSMutableArray * series;
@property (nonatomic,strong) NSMutableArray * stickerSets;

@property (nonatomic,weak) CCamViewController *ccamVC;
@property (nonatomic,weak) CCSerieViewController *serieVC;
@property (nonatomic,assign) BOOL serieUpdating;

+ (DataHelper*)sharedManager;

- (NSString *)getTargetSerie;
- (void)setTargetSerie:(NSString *)serieid;

- (void)updateSeriesInfo;
- (void)getLocalSeriesInfo;
- (void)updateAnimationInfo:(CCCharacter*)character;
- (void)updateStickerSetsInfo;
- (void)getLocalStickerSetsInfo;


@end
