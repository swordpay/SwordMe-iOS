

#import <Foundation/Foundation.h>

@class MTDatacenterAddress;

@interface MTDatacenterAddressSet : NSObject <NSCoding, NSSecureCoding>

@property (nonatomic, strong, readonly) NSArray *addressList;

- (instancetype)initWithAddressList:(NSArray *)addressList;

- (MTDatacenterAddress *)firstAddress;

@end
