//
//  DownloadHelper.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/9.
//
//

#import <Foundation/Foundation.h>

#import "CCCharacter.h"
#import "CCSticker.h"
#import "DataHelper.h"

@interface DownloadHelper : NSObject
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSMutableDictionary *downloadInfos;
+ (DownloadHelper*)sharedManager;
- (void)downloadCharacter:(CCCharacter*)character;
- (void)downloadSticker:(CCSticker*)sticker;
@end
