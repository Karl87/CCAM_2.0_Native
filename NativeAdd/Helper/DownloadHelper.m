//
//  DownloadHelper.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/9.
//
//

#import "DownloadHelper.h"
#import "CCamSegmentContentCell.h"
#import "CCamSerieContentCell.h"
#import "AFURLSessionManager.h"
#import "CCSerie.h"
#import "CCamCharacterCell.h"
#import "CCStickerCell.h"
#import <M13ProgressSuite/M13ProgressViewBorderedBar.h>
#import "CCamSerieContentSurfaceView.h"

@implementation DownloadHelper
+ (DownloadHelper*)sharedManager
{
    static dispatch_once_t pred;
    static DownloadHelper *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
- (id)init{
    if (self = [super init]) {
        _downloadInfos = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return  self;
}
- (void)downloadSticker:(CCSticker *)sticker{
    
    NSString *dirPath = [NSString stringWithFormat:@"%@/CharacterCamera/Sticker",CCamDocPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir;
    
    if (![fileManager fileExistsAtPath:dirPath isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CCamHost,sticker.image_Res]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        [_downloadInfos setObject:[NSString stringWithFormat:@"%f",(CGFloat)downloadProgress.fractionCompleted] forKey:[NSString stringWithFormat:@"Sticker%@",sticker.stickerID]];
        M13ProgressViewBorderedBar *cellBar = (M13ProgressViewBorderedBar*)[[DataHelper sharedManager].ccamVC.stickerSetContentCollection viewWithTag:9000+[sticker.stickerID intValue]];
        [cellBar setHidden:NO];
        [cellBar setProgress:(CGFloat)downloadProgress.fractionCompleted animated:YES];
        if(downloadProgress.fractionCompleted == 1.0){
            [cellBar setHidden:YES];
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:@"CharacterCamera" isDirectory:YES];
        documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:@"Sticker" isDirectory:YES];
        documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",sticker.stickersetID,[response suggestedFilename]]];
        return documentsDirectoryURL;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"文件路径：%@",filePath);
        NSString *path = [NSString stringWithFormat:@"%@",filePath];
        NSLog(@"%@",path);
        if (!error) {
            
        }else{
            NSLog(@"error:%@",error);
        }
        [_downloadInfos removeObjectForKey:[NSString stringWithFormat:@"Sticker%@",sticker.stickerID]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    [downloadTask resume];
}
- (void)downloadCharacter:(CCCharacter *)character{
    
    NSString *dirPath = [NSString stringWithFormat:@"%@/CharacterCamera/S%@C%@",CCamDocPath,character.serieID,character.characterID];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir;
    
    if (![fileManager fileExistsAtPath:dirPath isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
   
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:character.assetBundle];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        [_downloadInfos setObject:[NSString stringWithFormat:@"%f",(CGFloat)downloadProgress.fractionCompleted] forKey:[NSString stringWithFormat:@"Character%@",character.characterID]];
//        NSLog(@"=========>Character%@ progress = %@",character.characterID,[_downloadInfos objectForKey:[NSString stringWithFormat:@"Character%@",character.characterID]]);
//        [[NSNotificationCenter defaultCenter] postNotificationName:character.characterID object:nil];
        if ([[[DataHelper sharedManager].ccamVC.serieContentCollection viewWithTag:8000+[character.characterID intValue]] isKindOfClass:[M13ProgressViewBorderedBar class]]) {
            M13ProgressViewBorderedBar *cellBar = (M13ProgressViewBorderedBar*)[[DataHelper sharedManager].ccamVC.serieContentCollection viewWithTag:8000+[character.characterID intValue]];
            [cellBar setHidden:NO];
            [cellBar setProgress:(CGFloat)downloadProgress.fractionCompleted animated:YES];
            if(downloadProgress.fractionCompleted == 1.0){
                [cellBar setHidden:YES];
            }
        }

        if ([[[DataHelper sharedManager].ccamVC.serieContentCollection viewWithTag:7000+[character.characterID intValue]] isKindOfClass:[CCamSerieContentSurfaceView class]]) {
            CCamSerieContentSurfaceView *surface = (CCamSerieContentSurfaceView*)[[DataHelper sharedManager].ccamVC.serieContentCollection viewWithTag:7000+[character.characterID intValue]];
            [surface.surfaceProgress setHidden:NO];
            [surface.surfaceProgress setProgress:(CGFloat)downloadProgress.fractionCompleted animated:YES];
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {

        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:@"CharacterCamera" isDirectory:YES];
        documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"S%@C%@",character.serieID,character.characterID] isDirectory:YES];
        documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.assetbundle",character.version]];
        return documentsDirectoryURL;
    
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"文件路径：%@",filePath);
        NSString *path = [NSString stringWithFormat:@"%@",filePath];
        NSLog(@"%@",path);
        if (!error) {
            [[DataHelper sharedManager]getLocalSeriesInfo];
        }
        [_downloadInfos removeObjectForKey:[NSString stringWithFormat:@"Character%@",character.characterID]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    [downloadTask resume];
}
- (void)refreshCharacterDownloadProgress:(CCCharacter *)character progress:(float)progress{
    
}

@end
