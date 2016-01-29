//
//  DataHelper.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/16.
//
//

#import "DataHelper.h"
#import "CCamHelper.h"
#import "Constants.h"
#import "AFHTTPSessionManager.h"

#import "CCSerie.h"
#import "CCCharacter.h"
#import "CCAnimation.h"
#import "CCSticker.h"
#import "CCStickerSet.h"

#import <M13ProgressSuite/M13ProgressHUD.h>
#import <M13ProgressSuite/M13ProgressViewRing.h>

@interface DataHelper (){
    M13ProgressHUD *dataHUD;
}

@end

@implementation DataHelper
+ (DataHelper*)sharedManager
{
    static dispatch_once_t pred;
    static DataHelper *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}



- (void)updateStickerSetsInfo{
    
    NSLog(@"Start request Stickers info");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:CCamGetStickersURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%lu",(unsigned long)[responseObject length]);
        if ([responseObject length]==1) {
            //            NSLog(@"\n***Current is updated version***\n");
        }else{
            //Print Series info
            //NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            
            //Delete old data
            [[CoreDataHelper sharedManager] deleteStoreInfoWithEntity:@"CCStickerSet"];
            //init core data context
            NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
            
            NSError *error;
            NSArray *receiveArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            
            NSLog(@"tempStickerset count = %lu",(unsigned long)receiveArray.count);
            for (int i = 0; i<[receiveArray count]; i++) {
                NSDictionary *tempStickerSet = [receiveArray objectAtIndex:i];
                CCStickerSet *stickerSet = [NSEntityDescription insertNewObjectForEntityForName:@"CCStickerSet" inManagedObjectContext:context];
                [stickerSet initStickerSetWith:tempStickerSet];
                NSArray *tempStickers = (NSArray*)[tempStickerSet objectForKey:@"sticker"];
                NSLog(@"--->stickerset name is %@ ,includ %lu characters",stickerSet.nameCN,(unsigned long)tempStickers.count);
                NSMutableArray *theStickers = [[NSMutableArray alloc] initWithCapacity:0];
                [theStickers removeAllObjects];
                for (int j = 0; j<[tempStickers count]; j++) {
                    NSDictionary *tempSticker = [tempStickers objectAtIndex:j];
                    CCSticker *sticker = [NSEntityDescription insertNewObjectForEntityForName:@"CCSticker" inManagedObjectContext:context];
                    [sticker initStickerWith:tempSticker];
                    NSLog(@"-------->sticker name is %@",sticker.name);
                    [theStickers addObject:sticker];
                    if (![context save:&error]) {
                        NSLog(@"角色%@保存失败",sticker.name);
                    }
                }
                [stickerSet setStickers:[[NSOrderedSet alloc] initWithArray:theStickers]];
                if (![context save:&error]) {
                    NSLog(@"系列%@保存失败",stickerSet.nameCN);
                }
                [self destroyMutableArray:theStickers];
                theStickers = nil;
                tempStickerSet = nil;
            }
            receiveArray = nil;
        }
        [self getLocalStickerSetsInfo];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Request stickers fail");
        [self getLocalStickerSetsInfo];
    }];
}
- (void)getLocalStickerSetsInfo{
    NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CCStickerSet" inManagedObjectContext:context];
    [request setEntity:entity];
    NSError *error;
    NSArray *infos = [context executeFetchRequest:request error:&error];
    if ([infos count] == 0) {
        NSLog(@"本地无数据，需要联网同步数据");
        [self updateStickerSetsInfo];
        return;
    }else{
        NSLog(@"本地数据库读取%lu个系列",(unsigned long)infos.count);
    }
    
    if(self.stickerSets == nil){
        self.stickerSets = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [self.stickerSets removeAllObjects];
    [self.stickerSets addObjectsFromArray:[context executeFetchRequest:request error:&error]];
    
    NSLog(@"=========>本地大头贴系列数%lu",(unsigned long)self.stickerSets.count);
    for (CCStickerSet *stickerSet in self.stickerSets) {
        NSLog(@"=========>大头贴系列名称: %@",stickerSet.nameCN);
        for (CCSticker *sticker in stickerSet.stickers) {
            NSLog(@"===>大头贴名称:%@",sticker.name);
            NSLog(@"===>大头贴资源:%@",sticker.image_Res);
        }
    }
    [_ccamVC updateStickerSetCollection];

}
- (void)updateSeriesInfo{
    self.serieUpdating = YES;
    NSLog(@"Start request Series info");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *token = [[AuthorizeHelper sharedManager] getUserToken];
    NSString *version = [[SettingHelper sharedManager] getSettingAttributeWithKey:CCamSettingTagInfoVersion];
    NSDictionary *parameters = @{@"token" :token,@"version":version};
    
    [manager POST:CCamGetSeriesURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%lu",(unsigned long)[responseObject length]);
        if ([responseObject length]==1) {
            NSLog(@"\n***Current is updated version***\n");
        }else{
            //Print Series info
            //NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            
            //Delete old data
            [[CoreDataHelper sharedManager] deleteStoreInfoWithEntity:@"CCSerie"];
            //init core data context
            NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
            
            NSError *error;
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            NSString *currentVersion = [receiveDic objectForKey:@"version"];
            [[SettingHelper sharedManager] setSettingAttributeWithKey:CCamSettingTagInfoVersion andValue:currentVersion];
            NSArray * tempSeries = (NSArray*)[receiveDic objectForKey:@"series"];
            NSLog(@"tempSeris count = %lu",(unsigned long)tempSeries.count);
            for (int i = 0; i<[tempSeries count]; i++) {
                NSDictionary *tempSerie = [tempSeries objectAtIndex:i];
                CCSerie *serie = [NSEntityDescription insertNewObjectForEntityForName:@"CCSerie" inManagedObjectContext:context];
                [serie initSerieWith:tempSerie];
                NSArray *tempCharacters = (NSArray*)[tempSerie objectForKey:@"characters"];
                NSLog(@"--->serie name is %@ ,includ %lu characters",serie.nameCN,(unsigned long)tempCharacters.count);
                NSMutableArray *theCharacters = [[NSMutableArray alloc] initWithCapacity:0];
                [theCharacters removeAllObjects];
                for (int j = 0; j<[tempCharacters count]; j++) {
                    NSDictionary *tempCharacter = [tempCharacters objectAtIndex:j];
                    CCCharacter *character = [NSEntityDescription insertNewObjectForEntityForName:@"CCCharacter" inManagedObjectContext:context];
                    [character initCharacterWith:tempCharacter];
                    NSLog(@"-------->character name is %@",character.nameCN);
                    [theCharacters addObject:character];
                    if (![context save:&error]) {
                        NSLog(@"角色%@保存失败",character.nameCN);
                    }
                }
                [serie setCharacters:[[NSOrderedSet alloc] initWithArray:theCharacters]];
                if (![context save:&error]) {
                    NSLog(@"系列%@保存失败",serie.nameCN);
                }
                [self destroyMutableArray:theCharacters];
                tempCharacters = nil;
                tempSerie = nil;
            }
            tempSeries = nil;
        }
        [self getLocalSeriesInfo];
        self.serieUpdating = NO;
        if (_serieVC) {
            [self.serieVC.serieTable.refresh endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Request series fail");
        [self getLocalSeriesInfo];
        self.serieUpdating = NO;
        if (_serieVC) {
            [self.serieVC.serieTable.refresh endRefreshing];
        }
    }];
}
- (void)updateAnimationInfo:(CCCharacter*)character{
    NSLog(@"Start request Animation info");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *token = [[AuthorizeHelper sharedManager] getUserToken];
//    NSString *version = character.version;
    NSString *characterID = character.characterID;
    NSDictionary *parameters = @{@"token" :token,@"version":@"",@"character_id":characterID};
    
    [[DownloadHelper sharedManager].downloadInfos setObject:@"0.001" forKey:[NSString stringWithFormat:@"Character%@",character.characterID]];
    
    
    [manager POST:CCamGetAnimationURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%lu",(unsigned long)[responseObject length]);
        if ([responseObject length]==1) {
            NSLog(@"\n***Current is updated version***\n");
        }else{
            
            //init core data context
            NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
            NSError *error;
            
            NSEntityDescription *entityObj = [NSEntityDescription entityForName:@"CCAnimation" inManagedObjectContext:context];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"characterID = %@",characterID]];
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setIncludesPropertyValues:NO];
            [request setEntity:entityObj];
            [request setPredicate:predicate];
            
            NSArray *datas = [context executeFetchRequest:request error:&error];
            NSLog(@"动画数量为%lu",(unsigned long)[datas count]);
            if (!error && datas && [datas count])
            {
                for (CCAnimation *obj in datas){
                    [context deleteObject:obj];
                }
                if (![context save:&error]){
                    NSLog(@"角色%@删除现有动作失败",character.nameCN);
                }
            }
            
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            NSArray * tempAnimations = (NSArray*)[receiveDic objectForKey:@"animations"];
            NSLog(@"角色包含%lu个动画",(unsigned long)tempAnimations.count);
            NSMutableArray *animations = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i = 0; i<tempAnimations.count; i++) {
                NSDictionary *tempAnimation = [tempAnimations objectAtIndex:i];
                CCAnimation *animation = [NSEntityDescription insertNewObjectForEntityForName:@"CCAnimation" inManagedObjectContext:context];
                [animation initAnimationWith:tempAnimation];
                if (![context save:&error]) {
                    NSLog(@"动画%@保存失败",animation.nameCN);
                }
                [animations addObject:animation];
            }
            NSFetchRequest *addRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *addEntity = [NSEntityDescription entityForName:@"CCCharacter" inManagedObjectContext:context];
            NSPredicate *addPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"characterID = %@",characterID]];
            [addRequest setEntity:addEntity];
            [addRequest setPredicate:addPredicate];
            
            NSArray *characters = [context executeFetchRequest:addRequest error:&error];
            NSLog(@"搜索角色数量%lu个",(unsigned long)characters.count);
            
            if (!error) {
                for (CCCharacter *character in characters) {
                    [character setAnimations:[[NSOrderedSet alloc] initWithArray:animations]];
                    if (![context save:&error]) {
                        NSLog(@"角色动画%@保存失败",character.nameCN);
                    }
                    for (CCAnimation*ani in character.animations) {
                        NSLog(@"%@",ani.nameCN);
                    }
                    [[DownloadHelper sharedManager] downloadCharacter:character];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Request series fail");
        [[DownloadHelper sharedManager].downloadInfos removeObjectForKey:[NSString stringWithFormat:@"Character%@",character.characterID]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}
- (void)getLocalSeriesInfo{
    NSManagedObjectContext *context = [[CoreDataHelper sharedManager] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CCSerie" inManagedObjectContext:context];
    [request setEntity:entity];
    NSError *error;
    NSArray *infos = [context executeFetchRequest:request error:&error];
    if ([infos count] == 0) {
        NSLog(@"本地无数据，需要联网同步数据");
        [self updateSeriesInfo];
        return;
    }else{
        NSLog(@"本地数据库读取%lu个系列",(unsigned long)infos.count);
    }
    
    if(self.series == nil){
        self.series = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [self.series removeAllObjects];
    [self.series addObjectsFromArray:[context executeFetchRequest:request error:&error]];
    
    NSLog(@"=========>本地系列数%lu",(unsigned long)self.series.count);
    for (CCSerie *serie in self.series) {
        NSLog(@"=========>系列名称: %@",serie.nameCN);
        for (CCCharacter *character in serie.characters) {
            NSLog(@"===>角色名称:%@",character.nameCN);
            for (CCAnimation*ani in character.animations) {
                NSLog(@"==>动画类型%@，名称%@",ani.type,ani.nameCN);
            }
        }
    }
    [_ccamVC updateSerieCollection];
    [_serieVC reloadSerieData];
}
- (void)destroyMutableArray:(NSMutableArray *)array{
    [array removeAllObjects];
    array = nil;
}
- (id)init{
    if (self = [super init]) {
//        [self addObserver:self forKeyPath:@"series" options:NSKeyValueObservingOptionNew context:nil];
    }
    return  self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"series"]) {
        NSLog(@"<---------- 系列数据已更新 ---------->");
        if (_ccamVC != nil) {
            [_ccamVC updateSerieCollection];
        }
    }
}
@end
