//
//  BBPlayerViewCellManager.h
//  BBPlayerView
//
//  Created by ebamboo on 2021/3/27.
//
//  https://github.com/ebamboo/BBPlayerView
//

#import <Foundation/Foundation.h>

@class VideoTableViewCell;
@interface PlayerViewCellManager : NSObject

@property (class, readonly) PlayerViewCellManager *shared;

/// 添加播放视频的 cell，表示管理该 cell
- (void)addCell:(VideoTableViewCell *)cell;

/// 移除 cell，表示不再管理该 cell
- (void)removeCell:(VideoTableViewCell *)cell;

/// 使所有 cell 暂停播放
/// 一般当某个 cell 播放视频时，其他 cells 应该暂停播放
- (void)pauseAllCells;

/// 是否有正在播放视频的 cell
- (BOOL)someOneIsPlaying;

@end
