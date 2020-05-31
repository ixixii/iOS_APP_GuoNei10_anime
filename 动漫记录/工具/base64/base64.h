//
//  base64.h

//
//  Created by beyond on 16/10/3.
//  Copyright © 2016年 beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
extern size_t EstimateBas64EncodedDataSize(size_t inDataSize);
extern size_t EstimateBas64DecodedDataSize(size_t inDataSize);

extern bool Base64EncodeData(const void *inInputData, size_t inInputDataSize, char *outOutputData, size_t *ioOutputDataSize, BOOL wrapped);
extern bool Base64DecodeData(const void *inInputData, size_t inInputDataSize, void *ioOutputData, size_t *ioOutputDataSize);

@interface base64 : NSObject

@end
