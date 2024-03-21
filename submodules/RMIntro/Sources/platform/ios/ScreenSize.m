//
//  ScreenSize.m
//  _LocalDebugOptions
//
//  Created by Tigran Simonyan on 14.08.23.
//

#import <UIKit/UIKit.h>
#import "ScreenSize.h"


@implementation ScreenSizeProvider

+ (ScreenSize)screenSize {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    if (screenWidth <= 320) {
        return ExtraSmall;
    } else if (screenWidth <= 375) {
        return Small;
    } else if (screenWidth <= 393) {
        return Medium;
    } else if (screenWidth <= 414) {
        return Large;
    } else {
        return ExtraLarge;
    }
}

@end
