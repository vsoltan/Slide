//
//  SCSDKBitmojiStickerPickerTheme.h
//  SCSDKBitmojiKit
//
//  Created by David Xia on 2018-11-30.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCSDKBitmojiStickerPickerThemeBuilder;

@interface SCSDKBitmojiStickerPickerTheme : NSObject

@property (class, nonatomic, strong, nonnull, readonly) SCSDKBitmojiStickerPickerTheme *lightTheme;

@property (class, nonatomic, strong, nonnull, readonly) SCSDKBitmojiStickerPickerTheme *darkTheme;

@property (nonatomic, strong, nonnull, readonly) UIColor *backgroundColor;

@property (nonatomic, strong, nonnull, readonly) UIColor *titleTextColor;

@property (nonatomic, strong, nonnull, readonly) UIColor *subtextColor;

@property (nonatomic, strong, nonnull, readonly) UIColor *borderColor;

@property (nonatomic, strong, nonnull, readonly) UIColor *errorRed;

@property (nonatomic, strong, nonnull, readonly) UIColor *searchColor;

@property (nonatomic, strong, nonnull, readonly) UIColor *navIconColor;

@property (nonatomic, strong, nonnull, readonly) UIColor *searchPillTextColor;

@property (nonatomic, strong, nullable, readonly) NSArray<UIColor *> *searchPillColors;

@property (nonatomic, assign, readonly) BOOL shouldRandomizeSearchPillColors;

@property (nonatomic, strong, nonnull, readonly) UIColor *searchPillShadowColor;

- (nonnull SCSDKBitmojiStickerPickerThemeBuilder *)toBuilder;

@end

@interface SCSDKBitmojiStickerPickerThemeBuilder : NSObject

- (instancetype)withBackgroundColor:(nonnull UIColor *)backgroundColor;

- (instancetype)withTitleTextColor:(nonnull UIColor *)titleTextColor;

- (instancetype)withSubtextColor:(nonnull UIColor *)subtextColor;

- (instancetype)withBorderColor:(nonnull UIColor *)borderColor;

- (instancetype)withErrorRed:(nonnull UIColor *)errorRed;

- (instancetype)withSearchColor:(nonnull UIColor *)searchColor NS_SWIFT_NAME(withSearchColor(_:));

- (instancetype)withNavIconColor:(nonnull UIColor *)navIconColor;

- (instancetype)withSearchPillTextColor:(nonnull UIColor *)searchPillTextColor;

- (instancetype)withSearchPillColors:(nullable NSArray<UIColor *> *)searchPillColors;

- (instancetype)withSearchPillShadowColor:(nonnull UIColor *)searchPillShadowColor;

- (instancetype)withShouldRandomizeSearchPillColors:(BOOL)shouldRandomizeSearchPillColors;

- (nonnull SCSDKBitmojiStickerPickerTheme *)build;

@end
