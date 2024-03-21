//
//  RMIntroPageView.m
//  IntroOpenGL
//
//  Created by Ilya Rimchikov on 05.12.13.
//  Copyright (c) 2013 Ilya Rimchikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenSize.h"
#import "RMIntroPageView.h"

@implementation RMIntroPageView

#define IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

- (id)initWithFrame:(CGRect)frame headline:(NSString*)headline description:(NSString*)description color:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        //self.backgroundColor=[UIColor redColor];
        
        CGFloat headlineFontSize;
        
        switch ([ScreenSizeProvider screenSize]) {
            case ExtraSmall:
                headlineFontSize = 29.0;
                break;
            case Small:
                headlineFontSize = 37.0;
                break;
            case Medium:
                headlineFontSize = 45.0;
                break;
            case Large:
                headlineFontSize = 45.0;
                break;
            case ExtraLarge:
                headlineFontSize = 45.0;
                break;
            default:
                break;
        }
        
        CGFloat descriptionFontSize;
        
        switch ([ScreenSizeProvider screenSize]) {
            case ExtraSmall:
                descriptionFontSize = 18.0;
                break;
            case Small:
                descriptionFontSize = 20.0;
                break;
            case Medium:
                descriptionFontSize = 22.0;
                break;
            case Large:
                descriptionFontSize = 24.0;
                break;
            case ExtraLarge:
                descriptionFontSize = 28.0;
                break;
            default:
                break;
        }

        CGFloat descriptionOffset;
        
        switch ([ScreenSizeProvider screenSize]) {
            case ExtraSmall:
                descriptionOffset = 50.0;
                break;
            case Small:
                descriptionOffset = 50.0;
                break;
            case Medium:
                descriptionOffset = 70.0;
                break;
            case Large:
                descriptionOffset = 70.0;
                break;
            case ExtraLarge:
                descriptionOffset = 70.0;
                break;
            default:
                break;
        }

        CGFloat descriptionHeight;
        
        switch ([ScreenSizeProvider screenSize]) {
            case ExtraSmall:
                descriptionHeight = 120;
                break;
            case Small:
                descriptionHeight = 120;
                break;
            case Medium:
                descriptionHeight = 100;
                break;
            case Large:
                descriptionHeight = 100;
                break;
            case ExtraLarge:
                descriptionHeight = 100;
                break;
            default:
                break;
        }

        self.opaque=YES;
        _headline=headline;
        
        // MARK: - SwordChanges change pager font here
        UILabel *headlineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 64+8)];
        headlineLabel.font = [UIFont fontWithName:@"Poppins-SemiBold" size: headlineFontSize];
        headlineLabel.text = _headline;
        headlineLabel.textColor = color;
        headlineLabel.textAlignment = NSTextAlignmentCenter;
        headlineLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _headerLabel = headlineLabel;
      
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = IPAD ? 4 : 3;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentCenter;
        

        NSMutableArray *boldRanges = [[NSMutableArray alloc] init];
        
        NSMutableString *cleanText = [[NSMutableString alloc] initWithString:description];
        while (true)
        {
            NSRange startRange = [cleanText rangeOfString:@"**"];
            if (startRange.location == NSNotFound)
                break;
            
            [cleanText deleteCharactersInRange:startRange];
            
            NSRange endRange = [cleanText rangeOfString:@"**"];
            if (endRange.location == NSNotFound)
                break;
            
            [cleanText deleteCharactersInRange:endRange];
            
            [boldRanges addObject:[NSValue valueWithRange:NSMakeRange(startRange.location, endRange.location - startRange.location)]];
        }
        
        _description = [[NSMutableAttributedString alloc]initWithString:cleanText];
        [_description addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, _description.length)];
        [_description addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, _description.length)];
        
        UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, descriptionOffset + (IPAD ? 22 : 0), frame.size.width - 40, descriptionHeight+8+5)];
        descriptionLabel.font = [UIFont fontWithName:@"Poppins-Regular" size: descriptionFontSize];
        descriptionLabel.attributedText = _description;
        descriptionLabel.numberOfLines=0;
        descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:descriptionLabel];
        _descriptionLabel = descriptionLabel;
        
        [self addSubview:headlineLabel];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
