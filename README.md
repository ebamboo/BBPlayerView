![BBPlayerView](Assets/title.png)
# BBPlayerView
一个高度封装的视频播放器视图，基于 AVPlayer、AVPlayerLayer、AVPlayerItem。
继承自 UIView，可以当做一般视图使用，适用于 Swift 和 Objective-C。
# Example
![simple](Assets/simple.png)
![multi](Assets/list.PNG)
# Installation
#### Requirements
* Xcode 8 or higher
* iOS 11.0 or higher
* ARC
#### Cocoapods
```
pod 'BBPlayerView'
```
#### Manually
1. 下载 BBPlayerView。
2. 添加 "BBPlayerView/Source Files" 文件夹到项目中。
# Use
#### 导入文件
* Swift 中在需要引用的地方 
```
import BBPlayerView
```
* Objective-C 中在需要引用的地方
```
#import "BBPlayerView.h"
```
#### 使用说明
* 像 UIView 一样代码创建或者在 xib、storyboard 拖拽创建
* 简单使用只需两行代码即可实现
 ```
[_playerView bb_loadDataWithURL:_URLField.text];
[_playerView bb_play];
```
* 支持加载视频/释放视频、播放/暂停、进度跳转、是否重播
* 通过代理方法可以获取播放状态、播放进度、预加载进度的变化
* 通过 BBPlayerViewCellManager 管理播放列表 cell
# API
* Delegate
```
@class BBPlayerView;
@protocol BBPlayerViewDelegate <NSObject>
@optional

/// 播放进度更新回调
/// tips: 当播放结束后可以决定是否循环播放
- (void)bb_playerView:(nullable BBPlayerView *)playerView progressDidUpdatedAtTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime progress:(CGFloat)progress;

/// 播放状态变化回调
- (void)bb_playerView:(nullable BBPlayerView *)playerView statusDidUpdated:(BBPlayerViewStatus)status;

/// 预加载进度回调
- (void)bb_playerView:(nullable BBPlayerView *)playerView didPreloadData:(CGFloat)startTime durationTime:(CGFloat)durationTime totalLoadedTime:(CGFloat)totalLoadedTime totalTime:(CGFloat)totalTime;

@end
```
* Class
```
@interface BBPlayerView : UIView

/// 代理
/// 通过代理方法可以获取播放状态、播放进度、预加载进度的变化
/// ！！！确保在调用 -bb_loadDataWithURL: 方法之前设置代理属性（如果不需要代理则不用设置）！！！
@property (nonatomic, weak, nullable) IBOutlet id <BBPlayerViewDelegate> bb_delegate;

/// 视频填充模式
/// BBPlayerViewGravityScaleFill   -- 填充满视图，可能变形，内容不会缺失
/// BBPlayerViewGravityAspectFill  -- 填充满视图，不变形，可能内容缺失
/// BBPlayerViewGravityAspectFit   -- 不变形填充视图，直到一个边到达视图边界，内容不会缺失
@property(nonatomic) BBPlayerViewGravity bb_videoGravity;

/// 加载媒体资源或切换媒体资源
/// 如果新加载的媒体资源 URL 和当前载入的 ULR 相同且播放器处于 BBPlayerViewStatusReadyToPlay 状态，则忽略本次加载操作
/// 每次真正载入媒体资源时，都会自动调用一次 -bb_release 方法
- (void)bb_loadDataWithURL:(nullable NSString *)url;
/// 清空播放器
- (void)bb_release;

/// 播放/暂停
/// 由于 AVPlayer 的属性 actionAtItemEnd 设置为 AVPlayerActionAtItemEndPause （默认值）
/// 所以在媒体资源播放结束后 AVPlayer 的 rate 会设为 0.0
/// 在媒体资源结尾处调用该方法无效（进度不变仍处在 1.0）
/// 注意：在加载某些媒体资源时，播放结束后调用 -bb_play/-bb_pause 方法可能会改变 AVPlayer 的 rate 值为 1.0/0.0（虽然不会生效）
/// 那么再去调用 -bb_seekToProgress:completionHandler: 方法，可能在跳转成功后处于 播放/暂停 状态
/// 所以确保媒体资源播放结束后不要调用 -bb_play/-bb_pause 方法
- (void)bb_play;
- (void)bb_pause;

/// 跳转至指定进度
/// 该方法完成后不会改变播放速率
/// 该方法是异步操作
/// @param progress 指定进度。取值范围：0.0 ~ 1.0
/// @param completionHandler 结束回调。finished 参数：YES 表示跳转完成；NO 表示跳转失败或取消了
- (void)bb_seekToProgress:(CGFloat)progress completionHandler:(void (^ _Nullable)(BOOL finished))completionHandler;

@end
```
```
@protocol BBPlayerViewCellManagerDelegate <NSObject>
/// 管理的 cell 必须具有 “暂停” 功能
- (void)bb_pause;
@end

@interface BBPlayerViewCellManager : NSObject

@property (class, readonly) BBPlayerViewCellManager *bb_manager;

/// 添加播放视频的 cell
/// 表示管理该 cell
- (void)bb_addCell:(id<BBPlayerViewCellManagerDelegate>)cell;

/// 移除 cell
/// 表示不再管理该 cell
- (void)bb_removeCell:(id<BBPlayerViewCellManagerDelegate>)cell;

/// 使所有 cell 暂停播放
/// 一般当某个 cell 播放视频时，其他 cells 应该暂停播放
- (void)bb_pauseAllCells;

@end
```
# Mind Map
![状态转移图](Assets/read.png)
# License
BBPlayerView is distributed under the MIT license. See LICENSE file for details.
