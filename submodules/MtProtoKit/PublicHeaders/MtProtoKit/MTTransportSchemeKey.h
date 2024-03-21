//
//  MTTransportSchemeKey.h
//  MtProtoKitFramework
//
//  Created by Tigran Simonyan on 23.06.23.
//

//#ifndef MTTransportSchemeKey_h
//#define MTTransportSchemeKey_h
//
//
//#endif /* MTTransportSchemeKey_h */

@interface MTTransportSchemeKey : NSObject<NSCoding, NSCopying, NSSecureCoding>

@property (nonatomic, readonly) NSInteger datacenterId;
@property (nonatomic, readonly) bool isProxy;
@property (nonatomic, readonly) bool isMedia;

- (instancetype)initWithDatacenterId:(NSInteger)datacenterId isProxy:(bool)isProxy isMedia:(bool)isMedia;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
