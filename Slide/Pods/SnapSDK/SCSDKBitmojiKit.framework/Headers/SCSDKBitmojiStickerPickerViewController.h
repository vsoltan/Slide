//
//  SCSDKBitmojiStickerPickerViewController.h
//  SCSDKBitmojiKit
//
//  Created by Yang Gao on 5/26/18.
//  Copyright © 2018 Snap, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SCSDKBitmojiStickerPickerConfig.h"
#import "SCSDKBitmojiStickerPickerSearchMode.h"
#import "SCSDKBitmojiIconView.h"

@class SCSDKBitmojiStickerPickerViewController;

@protocol SCSDKBitmojiStickerPickerViewControllerDelegate <NSObject>

@required
/**
 * Called whenever the user selected a Bitmoji sticker to share
 *
 * @param stickerPickerViewController The calling Bitmoji sticker picker view controller
 * @param bitmojiURL The URL pointing to rendered Bitmoji image
 * @param image A UIImage object used to preview the sticker
 */
- (void)bitmojiStickerPickerViewController:(nonnull SCSDKBitmojiStickerPickerViewController *)stickerPickerViewController
                   didSelectBitmojiWithURL:(nonnull NSString *)bitmojiURL
                                     image:(nullable UIImage *)image;

@optional
/**
 * Called whenever the user focuses or defocuses on Bitmoji sticker picker's search input box. It can
 * be used to adjust layout contrainsts in your container UI, i.e. with prompted system keyboard, etc.
 *
 * @param stickerPickerViewController The calling Bitmoji sticker picker view controller
 */
- (void)bitmojiStickerPickerViewController:(nonnull SCSDKBitmojiStickerPickerViewController *)stickerPickerViewController
        searchFieldFocusDidChangeWithFocus:(BOOL)hasFocus;


@optional
/**
 * Called whenever the user taps on a suggested search tag in the sticker picker
 *
 * @param stickerPickerViewController The calling Bitmoji sticker picker view controller
 */
- (void)bitmojiStickerPickerViewControllerDidSelectSearchTag:(nonnull SCSDKBitmojiStickerPickerViewController *)stickerPickerViewController;

@end

/**
 * Provides a Bitmoji sticker picker UI which allows users to link their Snapchat account, and search
 * for and share Bitmoji stickers.
 * For more details, see: https://docs.snapchat.com/docs/bitmoji-kit/#sticker-picker
 */
@interface SCSDKBitmojiStickerPickerViewController : UIViewController

/**
 * The delegate to receive updates from Bitmoji sticker picker, i.e. user selected Bitmoji, etc.
 */
@property (nonatomic, weak, nullable) id<SCSDKBitmojiStickerPickerViewControllerDelegate> delegate;

/**
 * Disabled init methods. Please use `[[SCSDKBitmojiStickerPickerViewController alloc] init]`
 */
- (nonnull instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                                 bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nonnull instancetype)initWithCoder:(nullable NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 * Initialize Bitmoji sticker picker UI with customizable configuration of whether show search bar
 * and tags selector
 */
- (instancetype)initWithConfig:(SCSDKBitmojiStickerPickerConfig *)config;

/**
 * Set a friend's user id that will be used to render friendmoji within the Bitmoji sticker picker.
 * For more details on user id (external id), see:
 * https://docs.snapchat.com/docs/login-kit/#sending-requests-to-get-the-external-id
 *
 * @param friendUserId The external ID of a Snapchat user
 */
- (void)setFriendUserId:(nullable NSString *)friendUserId;

/**
 * Set search term that will be used to refine Bitmoji sticker picker content, i.e. pass in search term
 * Friday and Bitmoji sticker picker will show Friday related Bitmoji stickers
 *
 * @param text The search term
 */
- (void)setSearchTerm:(NSString *)text searchMode:(SCSDKBitmojiStickerPickerSearchMode)searchMode;
- (void)attachBitmojiIcon:(SCSDKBitmojiIconView *)bitmojiIcon;
- (void)removeBitmojiIcon:(SCSDKBitmojiIconView *)bitmojiIcon;

@end
