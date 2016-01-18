//
//  iOSBinding.m
//  Unity-iPhone
//
//  Created by Karl on 14-4-21.
//
//


#import "iOSBindingManager.h"

#define GetStringParam( _x_ ) ( _x_ != NULL ) ? [NSString stringWithUTF8String:_x_] : [NSString stringWithUTF8String:""]
void _homeAddNativeSurface(){
    [[iOSBindingManager sharedManager] homeAddNativeSurface];
}
void _homeRemoveNativeSurface(){
    [[iOSBindingManager sharedManager] homeRemoveNativeSurface];
}
void _InitEditScene(){
    [[iOSBindingManager sharedManager] initEditScene];
}
void _EditAddNativeSurface(){
    [[iOSBindingManager sharedManager] editAddNativeSurface];
}
void _EditRemoveNativeSurface(){
    [[iOSBindingManager sharedManager] editRemoveNativeSurface];
}
void _callLightControl(){
    [[iOSBindingManager sharedManager] callLightControl];
}
void _removeLightControl(){
    [[iOSBindingManager sharedManager] removeLightControl];
}
void _getLightStrength(const char* _strength){
    [[iOSBindingManager sharedManager] setLightStrength:GetStringParam(_strength)];
}
void _getShadowStrength(const char* _strength){
    [[iOSBindingManager sharedManager] setShadowStrength:GetStringParam(_strength)];
}
void _getLightDirection(const char* _direction){
    [[iOSBindingManager sharedManager] setLightDirection:GetStringParam(_direction)];
}
void _callAnimationControl(){
    [[iOSBindingManager sharedManager] callAnimationControl];

}
void _removeAnimationControl(){
    [[iOSBindingManager sharedManager] removeAnimationControl];

}
void _getHeadDirection(const char* _direction){
    
}
void _getPoseInformation(const char* _info){
    
}
void _getAnimationInformation(const char* _info){
    [[iOSBindingManager sharedManager] setAnimationInfo:GetStringParam(_info)];
}
void  _submitPhoto(const char* _contestid,const char* _description,const char* _characterid,const char*_sharelist){
   
}
void _callHomePageAlertView(const char* _note){
}


void _countSerieChoosed(const char* _serieid){
}
void _countCharacterChoosed(const char* _characterid){
}
///////////////////
///禁止iCloud自动备份
///////////////////

void _forbiddeniCloud(const char* _path){
}
/////////////
///启动系列网页
/////////////

void _callSerieWebView(const char* _url){
}
////////////////
///调用设备闪光灯
////////////////
void _callFlash(const char* _state){
}
/////////////////////////////////////
///弹出iOS系统警告，type为类型，note为内容
/////////////////////////////////////
void _callAlertView (const char*_note,const char*_type){
}
///////////////////////
///显示Native场景原生界面
///////////////////////
void _callNative(){
}
///////////////////////
///移除Native场景原生界面
///////////////////////
void _dismissiOSNative (){
}
/////////////////
///显示照片选择界面
/////////////////
void _callAlbum() {
    
}
////////////////////
///将照片存储至系统相册
////////////////////
void _callSavePhotoToAlbum(const char* _photoName, const char* _albumName) {
    
    
}

///////////////
///显示进度条HUB
///////////////
void  _callHubWithProgress(const char* _note){
}
/////////////
///显示文字HUB
/////////////
void  _callHubWithNote(const char* _note){
}
//////////////////
///更新进度条HUB进度
//////////////////
void  _callHubUpdateProgress(const char* _progress){
}
////////////////
///更新文字HUB内容
////////////////
void _callHubUpdateNote(const char* _note){
}
/////////////
///显示状态HUB
/////////////
void _callHubWithStateChange(const char* _note ,const char* _type, const char* _time){
}
//////////
///移除HUB
//////////
void _removeHub(const char* _type,const char* _delay){
}
////////////////
///更改iOS用户设置
////////////////
void _setIOSUserDefaults (const char * _key, const char * _value){
}

////////////////////
///原生界面上传照片完成
////////////////////
void _uploadFinishedInNative(){
    
}

///////////////////////////
//  - CheckSocialMethod  //
///////////////////////////
void _setSubmitSocialBtns(){
}
void _callSubmitAuthor(const char* _type){
}