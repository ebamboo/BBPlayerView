//
//  BBPlayerViewCellManager.m
//  BBCommonKits
//
//  Created by 姚旭 on 2021/3/27.
//

#import "BBPlayerViewCellManager.h"

@interface BBPlayerViewCellManager ()

@property (nonatomic, retain, nonnull) NSMutableArray <id<BBPlayerViewCellManagerDelegate>> *cellList;

@end

@implementation BBPlayerViewCellManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _cellList = [NSMutableArray array];
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

- (void)addCell:(id<BBPlayerViewCellManagerDelegate>)cell {
    [_cellList enumerateObjectsUsingBlock:^(id<BBPlayerViewCellManagerDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj bb_pause];
    }];
    if (![_cellList containsObject:cell]) {
        [_cellList addObject:cell];
    }
}

- (void)removeCell:(id<BBPlayerViewCellManagerDelegate>)cell {
    [_cellList removeObject:cell];
}

- (void)removeAllCells {
    [_cellList removeAllObjects];
}

- (void)pauseAllCellPlayers {
    [_cellList enumerateObjectsUsingBlock:^(id<BBPlayerViewCellManagerDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj bb_pause];
    }];
}

@end
