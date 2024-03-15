//
//  NSData+Deflate.h
//  
//
//  Created by Nikolai Borovennikov on 20.06.2022.
//
@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Deflate)

- (NSData *)deflate;
- (NSData *)inflate;

@end

NS_ASSUME_NONNULL_END
