//
//  BBPlayerViewCellManager.m
//  BBPlayerView
//
//  Created by ebamboo on 2021/3/27.
//

#import "BBPlayerViewCellManager.h"

@interface BBPlayerViewCellManager ()
// 所管理的 cells 列表，使用弱引用列表进行存储，不需要主动释放cell
@property (nonatomic, retain, nonnull) NSPointerArray *cellList;
@end

@implementation BBPlayerViewCellManager

#pragma mark - life circle

- (instancetype)init {
    self = [super init];
    if (self) {
        _cellList = [NSPointerArray weakObjectsPointerArray];
    }
    return self;
}

+ (instancetype)bb_manager {
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[BBPlayerViewCellManager alloc] init];
    });
    return obj;
}

#pragma mark - public method

- (void)bb_addCell:(id<BBPlayerViewCellManagerDelegate>)cell {
    [_cellList compact];
    for (id<BBPlayerViewCellManagerDelegate> cell in _cellList) {
        [cell bb_pause];
    }
    if (![_cellList.allObjects containsObject:cell]) {
        [_cellList addPointer:(__bridge void * _Nullable)(cell)];
    }
}

- (void)bb_removeCell:(id<BBPlayerViewCellManagerDelegate>)cell {
    [_cellList compact];
    NSArray *allCells = _cellList.allObjects;
    if ([allCells containsObject:cell]) {
        [_cellList removePointerAtIndex:[allCells indexOfObject:cell]];
    }
    [_cellList compact];
}

- (void)bb_pauseAllCells {
    [_cellList compact];
    for (id<BBPlayerViewCellManagerDelegate> cell in _cellList) {
        [cell bb_pause];
    }
}

@end
