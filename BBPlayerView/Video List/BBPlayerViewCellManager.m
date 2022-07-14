//
//  BBPlayerViewCellManager.m
//  BBPlayerView
//
//  Created by ebamboo on 2021/3/27.
//

#import "BBPlayerViewCellManager.h"
#import "VideoTableViewCell.h"

@interface PlayerViewCellManager ()

// 所管理的 cells 列表，使用弱引用列表进行存储，不需要主动释放cell
@property (nonatomic, retain, nonnull) NSPointerArray *cellList;

@end

@implementation PlayerViewCellManager

#pragma mark - life circle

- (instancetype)init {
    self = [super init];
    if (self) {
        _cellList = [NSPointerArray weakObjectsPointerArray];
    }
    return self;
}

+ (instancetype)shared {
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[PlayerViewCellManager alloc] init];
    });
    return obj;
}

#pragma mark - public method

- (void)addCell:(VideoTableViewCell *)cell {
    [_cellList compact];
    if (![_cellList.allObjects containsObject:cell]) {
        [_cellList addPointer:(__bridge void * _Nullable)(cell)];
    }
}

- (void)removeCell:(VideoTableViewCell *)cell {
    [_cellList compact];
    NSArray *allCells = _cellList.allObjects;
    if ([allCells containsObject:cell]) {
        [_cellList removePointerAtIndex:[allCells indexOfObject:cell]];
    }
    [_cellList compact];
}

- (void)pauseAllCells {
    [_cellList compact];
    for (VideoTableViewCell *cell in _cellList) {
        [cell tryPause];
    }
}

- (BOOL)someOneIsPlaying {
    [_cellList compact];
    for (VideoTableViewCell *cell in _cellList) {
        if (cell.status == VideoTableViewCellStatusPlaying) {
            return YES;
        }
    }
    return NO;
}

@end
