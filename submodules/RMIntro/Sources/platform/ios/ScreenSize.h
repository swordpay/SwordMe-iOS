//
//  ScreenSize.h
//  Telegram
//
//  Created by Tigran Simonyan on 14.08.23.
//

#ifndef ScreenSize_h
#define ScreenSize_h


#endif /* ScreenSize_h */

typedef NS_ENUM(NSInteger, ScreenSize) {
    ExtraSmall,
    Small,
    Medium,
    Large,
    ExtraLarge
};

@interface ScreenSizeProvider: NSObject

+(ScreenSize)screenSize;

@end
