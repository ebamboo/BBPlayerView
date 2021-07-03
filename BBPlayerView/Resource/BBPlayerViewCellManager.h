//
//  BBPlayerViewCellManager.h
//  BBCommonKits
//
//  Created by 姚旭 on 2021/3/27.
//

#import <Foundation/Foundation.h>

@protocol BBPlayerViewCellManagerDelegate <NSObject>
- (void)bb_pause;
@end

@interface BBPlayerViewCellManager : NSObject

@property (class, readonly) BBPlayerViewCellManager *bb_manager;

/**
 添加真实播放视频的 cell
 只在 cell 播放视频时把该 cell 加入到 manager 来管理
 */
- (void)addCell:(id<BBPlayerViewCellManagerDelegate>)cell;

/**
 移除 cell
 在 cell 进入可复用状态调用
 即：在 -prepareForReuse 调用该方法
 */
- (void)removeCell:(id<BBPlayerViewCellManagerDelegate>)cell;

/**
 移除全部 cell
 在列表所在控制器销毁时调用
 即：在 -dealloc 调用该方法
 */
- (void)removeAllCells;

/**
 所有 cell 暂停播放
 指定某个 cell 播放时，其他所有 cell 暂停播放
 */
- (void)pauseAllCellPlayers;

@end
