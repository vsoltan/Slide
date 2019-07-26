//
//  SCSDKBitmojiStickerPickerConfig.h
//  SCSDKBitmojiKit
//
//  Created by Yucheng Zhang on 10/22/18.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import "SCSDKBitmojiStickerPickerTheme.h"

#import <Foundation/Foundation.h>

@interface SCSDKBitmojiStickerPickerConfig : NSObject

@property (nonatomic, assign, readonly) BOOL showSearchBar;

@property (nonatomic, assign, readonly) BOOL showSearchPills;

@property (nonatomic, strong, readonly, nonnull) SCSDKBitmojiStickerPickerTheme *theme;

@end

@interface SCSDKBitmojiStickerPickerConfigBuilder : NSObject

- (instancetype)withShowSearchBar:(BOOL)showSearchBar;

- (instancetype)withShowSearchPills:(BOOL)showSearchPills;

- (instancetype)withTheme:(nonnull SCSDKBitmojiStickerPickerTheme *)theme;

- (nonnull SCSDKBitmojiStickerPickerConfig *)build;

@end
