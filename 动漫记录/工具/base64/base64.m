//
//  base64.m

//
//  Created by beyond on 16/10/3.
//  Copyright © 2016年 beyond. All rights reserved.
//

#import "base64.h"

@implementation base64







const UInt8 kBase64EncodeTable[64] = {
    'A',     'B',     'C',     'D',
    'E',     'F',     'G',     'H',
    'I',     'J',     'K',     'L',
    'M',     'N',     'O',     'P',
    'Q',     'R',     'S',     'T',
    'U',     'V',     'W',     'X',
    'Y',     'Z',     'a',     'b',
    'c',     'd',     'e',     'f',
    'g',     'h',     'i',     'j',
    'k',     'l',     'm',     'n',
    'o',     'p',     'q',     'r',
    's',     't',     'u',     'v',
    'w',     'x',     'y',     'z',
    '0',     '1',     '2',     '3',
    '4',     '5',     '6',     '7',
    '8',     '9',     '+',     '/'
};



const SInt8 kBase64DecodeTable[128] = {
    -5,      -3,      -3,      -3,
    -3,      -3,      -3,      -3,
    -3,      -2,      -2,      -2,
    -2,      -2,      -3,      -3,
    -3,      -3,      -3,      -3,
    -3,      -3,      -3,      -3,
    -3,      -3,      -3,      -3,
    -3,      -3,      -3,      -3,
    -2,     -3,     -3,     -3,
    -3,     -3,     -3,     -3,
    -3,     -3,     -3,     62,
    -3,     -3,     -3,     63,
    52,     53,     54,     55,
    56,     57,     58,     59,
    60,     61,     -3,     -3,
    -3,     -1,     -3,     -3,
    -3,     0,      1,      2,
    3,      4,      5,      6,
    7,      8,      9,     10,
    11,     12,     13,     14,
    15,     16,     17,     18,
    19,     20,     21,     22,
    23,     24,     25,     -3,
    -3,     -3,     -3,     -3,
    -3,     26,     27,     28,
    29,     30,     31,     32,
    33,     34,     35,     36,
    37,     38,     39,     40,
    41,     42,     43,     44,
    45,     46,     47,     48,
    49,     50,     51,     -3,
    -3,     -3,     -3,     -3
};

const UInt8 kBits_00000011 = 0x03;
const UInt8 kBits_00001111 = 0x0F;
const UInt8 kBits_00110000 = 0x30;
const UInt8 kBits_00111100 = 0x3C;
const UInt8 kBits_00111111 = 0x3F;
const UInt8 kBits_11000000 = 0xC0;
const UInt8 kBits_11110000 = 0xF0;
const UInt8 kBits_11111100 = 0xFC;

size_t EstimateBas64EncodedDataSize(size_t inDataSize)
{
    size_t theEncodedDataSize = (int)ceil(inDataSize / 3.0) * 4;
    theEncodedDataSize = theEncodedDataSize / 72 * 74 + theEncodedDataSize % 72;
    return(theEncodedDataSize);
}

size_t EstimateBas64DecodedDataSize(size_t inDataSize)
{
    size_t theDecodedDataSize = (int)ceil(inDataSize / 4.0) * 3;
    //theDecodedDataSize = theDecodedDataSize / 72 * 74 + theDecodedDataSize % 72;
    return(theDecodedDataSize);
}

bool Base64EncodeData(const void *inInputData, size_t inInputDataSize, char *outOutputData, size_t *ioOutputDataSize, BOOL wrapped)
{
    size_t theEncodedDataSize = EstimateBas64EncodedDataSize(inInputDataSize);
    if (*ioOutputDataSize < theEncodedDataSize)
        return(false);
    *ioOutputDataSize = theEncodedDataSize;
    const UInt8 *theInPtr = (const UInt8 *)inInputData;
    UInt32 theInIndex = 0, theOutIndex = 0;
    for (; theInIndex < (inInputDataSize / 3) * 3; theInIndex += 3)
    {
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_11111100) >> 2];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_00000011) << 4 | (theInPtr[theInIndex + 1] & kBits_11110000) >> 4];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex + 1] & kBits_00001111) << 2 | (theInPtr[theInIndex + 2] & kBits_11000000) >> 6];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex + 2] & kBits_00111111) >> 0];
        if (wrapped && (theOutIndex % 74 == 72))
        {
            outOutputData[theOutIndex++] = '\r';
            outOutputData[theOutIndex++] = '\n';
        }
    }
    const size_t theRemainingBytes = inInputDataSize - theInIndex;
    if (theRemainingBytes == 1)
    {
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_11111100) >> 2];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_00000011) << 4 | (0 & kBits_11110000) >> 4];
        outOutputData[theOutIndex++] = '=';
        outOutputData[theOutIndex++] = '=';
        if (wrapped && (theOutIndex % 74 == 72))
        {
            outOutputData[theOutIndex++] = '\r';
            outOutputData[theOutIndex++] = '\n';
        }
    }
    else if (theRemainingBytes == 2)
    {
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_11111100) >> 2];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_00000011) << 4 | (theInPtr[theInIndex + 1] & kBits_11110000) >> 4];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex + 1] & kBits_00001111) << 2 | (0 & kBits_11000000) >> 6];
        outOutputData[theOutIndex++] = '=';
        if (wrapped && (theOutIndex % 74 == 72))
        {
            outOutputData[theOutIndex++] = '\r';
            outOutputData[theOutIndex++] = '\n';
        }
    }
    return(true);
}

bool Base64DecodeData(const void *inInputData, size_t inInputDataSize, void *ioOutputData, size_t *ioOutputDataSize)
{
    memset(ioOutputData, '.', *ioOutputDataSize);
    
    size_t theDecodedDataSize = EstimateBas64DecodedDataSize(inInputDataSize);
    if (*ioOutputDataSize < theDecodedDataSize)
        return(false);
    *ioOutputDataSize = 0;
    const UInt8 *theInPtr = (const UInt8 *)inInputData;
    UInt8 *theOutPtr = (UInt8 *)ioOutputData;
    size_t theInIndex = 0, theOutIndex = 0;
    UInt8 theOutputOctet;
    size_t theSequence = 0;
    for (; theInIndex < inInputDataSize; )
    {
        SInt8 theSextet = 0;
        
        SInt8 theCurrentInputOctet = theInPtr[theInIndex];
        theSextet = kBase64DecodeTable[theCurrentInputOctet];
        if (theSextet == -1)
            break;
        while (theSextet == -2)
        {
            theCurrentInputOctet = theInPtr[++theInIndex];
            theSextet = kBase64DecodeTable[theCurrentInputOctet];
        }
        while (theSextet == -3)
        {
            theCurrentInputOctet = theInPtr[++theInIndex];
            theSextet = kBase64DecodeTable[theCurrentInputOctet];
        }
        if (theSequence == 0)
        {
            theOutputOctet = (theSextet >= 0 ? theSextet : 0) << 2 & kBits_11111100;
        }
        else if (theSequence == 1)
        {
            theOutputOctet |= (theSextet >- 0 ? theSextet : 0) >> 4 & kBits_00000011;
            theOutPtr[theOutIndex++] = theOutputOctet;
        }
        else if (theSequence == 2)
        {
            theOutputOctet = (theSextet >= 0 ? theSextet : 0) << 4 & kBits_11110000;
        }
        else if (theSequence == 3)
        {
            theOutputOctet |= (theSextet >= 0 ? theSextet : 0) >> 2 & kBits_00001111;
            theOutPtr[theOutIndex++] = theOutputOctet;
        }
        else if (theSequence == 4)
        {
            theOutputOctet = (theSextet >= 0 ? theSextet : 0) << 6 & kBits_11000000;
        }
        else if (theSequence == 5)
        {
            theOutputOctet |= (theSextet >= 0 ? theSextet : 0) >> 0 & kBits_00111111;
            theOutPtr[theOutIndex++] = theOutputOctet;
        }
        theSequence = (theSequence + 1) % 6;
        if (theSequence != 2 && theSequence != 4)
            theInIndex++;
    }
    *ioOutputDataSize = theOutIndex;
    return(true);
}

@end
