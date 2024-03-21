//
//  MTTransportSchemeKey.m
//  MtProtoKitFramework
//
//  Created by Tigran Simonyan on 23.06.23.
//

#import <Foundation/Foundation.h>
#import <MtProtoKit/MTTransportSchemeKey.h>

@implementation MTTransportSchemeKey

+(BOOL) supportsSecureCoding {
    return YES;
}

- (instancetype)initWithDatacenterId:(NSInteger)datacenterId isProxy:(bool)isProxy isMedia:(bool)isMedia {
    self = [super init];
    if (self != nil) {
        _datacenterId = datacenterId;
        _isProxy = isProxy;
        _isMedia = isMedia;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithDatacenterId:[aDecoder decodeIntegerForKey:@"datacenterId"] isProxy:[aDecoder decodeBoolForKey:@"isProxy"] isMedia:[aDecoder decodeBoolForKey:@"isMedia"]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_datacenterId forKey:@"datacenterId"];
    [aCoder encodeBool:_isProxy forKey:@"isProxy"];
    [aCoder encodeBool:_isMedia forKey:@"isMedia"];
}

- (instancetype)copyWithZone:(NSZone *)__unused zone {
    return self;
}

- (NSUInteger)hash {
    return _datacenterId * 31 * 31 + (_isProxy ? 1 : 0) * 31 + (_isMedia ? 1 : 0);
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[MTTransportSchemeKey class]]) {
        return false;
    }
    MTTransportSchemeKey *other = (MTTransportSchemeKey *)object;
    if (_datacenterId != other->_datacenterId) {
        return false;
    }
    if (_isProxy != other->_isProxy) {
        return false;
    }
    if (_isMedia != other->_isMedia) {
        return false;
    }
    return true;
}

@end
