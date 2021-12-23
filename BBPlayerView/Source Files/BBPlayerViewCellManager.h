//
//  BBPlayerViewCellManager.h
//  BBPlayerView
//
//  Created by ebamboo on 2021/3/27.
//
//  https://github.com/ebamboo/BBPlayerView
//

#import <Foundation/Foundation.h>

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
