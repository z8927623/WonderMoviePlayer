//
//  WonderMoviePlayerConstants.h
//  WonderMoviePlayer
//
//  Created by Zhuang Yanjun on 13-8-26.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#ifndef WonderMoviePlayer_WonderMoviePlayerConstants_h
#define WonderMoviePlayer_WonderMoviePlayerConstants_h

#ifndef QQImage
#include "UIImageEx.h"
#define QQImage(src) [UIImageEx loadAndCacheImageFromApp:src]
#endif

#ifndef QQVideoPlayerImage
#define QQVideoPlayerImage(src) [UIImageEx loadAndCacheImageFromApp:[NSString stringWithFormat:@"function_videoplayer_%@", src]]
#endif

// define colors
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a / 255.f]
#define QQColor(colorName) colorName

#ifndef QQColor
#define QQColor(colorName) Color(#colorName)
#endif

#define videoplayer_title_color         RGBAColor(0xb2, 0xb2, 0xb2, 0xff)
#define videoplayer_subtitle_color      RGBAColor(0x8d, 0x8d, 0x8d, 0xff)
#define videoplayer_downloaded_color    RGBAColor(0x8d, 0x8d, 0x8d, 0xff)

#define kProgressViewPadding 16
#define kWonderMovieControlDimDuration              0.8f
#define kWonderMovieControlShowDuration             0.2f

#endif