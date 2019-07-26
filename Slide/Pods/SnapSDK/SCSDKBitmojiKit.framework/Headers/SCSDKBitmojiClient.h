//
//  SCSDKBitmojiClient.h
//  SCSDKBitmojiKit
//
//  Created by Luke Zhao on 2017-11-03.
//  Copyright © 2017 Bitmoji. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kSCSDKBitmojiClientRequiredScope;

/**
 * Callback when Bitmoji profile image fetch completed
 *
 * @param avatarURL The URL pointing to rendered Bitmoji profile image
 * @param error Network or server error encountered
 */
typedef void(^BitmojiGetAvatarURLCompletionBlock)(NSString * _Nullable avatarURL, NSError * _Nullable error);

/**
 * This is the interface for fetching Bitmoji content from resource servers
 */
@interface SCSDKBitmojiClient : NSObject

/**
 * Retrieve the URL of a user's Bitmoji profile image
 *
 * @param completion Callback when data fetch completed
 */
+ (void)fetchAvatarURLWithCompletion:(nonnull BitmojiGetAvatarURLCompletionBlock)completion;

@end
