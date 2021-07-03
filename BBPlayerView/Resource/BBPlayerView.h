//
//  BBPlayerView.h
//  BBCommonKits
//
//  Created by 征国科技 on 2021/3/24.
//

#import <UIKit/UIKit.h>
#import "BBPlayerViewCellManager.h"

typedef NS_ENUM(NSInteger, BBPlayerViewStatus) {
    BBPlayerViewStatusUnknown       = 0,
    BBPlayerViewStatusReadyToPlay   = 1,
    BBPlayerViewStatusFailed        = 2
};

@protocol BBPlayerViewDelegate <NSObject>
@optional

/**
 播放进度更新回调
 当播放结束后可以决定是否循环播放
 */
- (void)bb_playerViewProgressDidUpdatedAtTime:(CGFloat)currentTime
                                    totalTime:(CGFloat)totalTime
                                     progress:(CGFloat)progress;

/** 播放状态变化回调 */
- (void)bb_playerViewStatusDidUpdated:(BBPlayerViewStatus)status;

/** 预加载进度回调 */
- (void)bb_playerViewDidPreloadData:(CGFloat)startTime
                       durationTime:(CGFloat)durationTime
                    totalLoadedTime:(CGFloat)totalLoadedTime
                          totalTime:(CGFloat)totalTime;

@end

@interface BBPlayerView : UIView

/**
 代理
 通过代理方法可以获取播放状态、播放进度、预加载进度的变化
 确保在调用 -bb_loadDataWithURL: 方法之前设置代理属性（如果不需要代理则不用设置）
 */
@property (nonatomic, weak, nullable) IBOutlet id <BBPlayerViewDelegate> bb_delegate;

/**
 加载媒体资源或切换媒体资源
 如果新加载的媒体资源 URL 和当前载入的 ULR 相同且播放器处于 BBPlayerViewStatusReadyToPlay 状态，则忽略本次加载操作
 每次真正载入媒体资源时，都会自动调用一次 -bb_release 方法
 */
- (void)bb_loadDataWithURL:(nullable NSString *)url;
/** 清空播放器 */
- (void)bb_release;

/**
 播放
 由于 AVPlayer 的属性 actionAtItemEnd 设置为 AVPlayerActionAtItemEndPause （默认值）
 所以在媒体资源播放结束后 AVPlayer 的 rate 会设为 0.0
 在媒体资源结尾处调用该方法无效（进度不变仍处在 1.0）
 
 注意：在加载某些媒体资源时，播放结束后调用 -bb_play/-bb_pause 方法可能会改变 AVPlayer 的 rate 值为 1.0/0.0
 那么再去调用 -bb_seekToProgress:completionHandler: 方法，可能在跳转成功后处于 播放/暂停 状态
 所以确保媒体资源播放结束后不要调用 -bb_play/-bb_pause 方法
 */
- (void)bb_play;
/** 暂停 */
- (void)bb_pause;

/// 跳转至指定进度。
/// 该方法完成后不会改变播放速率
/// 该方法是异步操作
/// @param progress 指定进度。取值范围：0.0 ~ 1.0
/// @param completionHandler 结束回调。finished 参数：YES 表示跳转完成；NO 表示跳转失败或取消了
- (void)bb_seekToProgress:(CGFloat)progress completionHandler:(void (^ _Nullable)(BOOL finished))completionHandler;

@end
