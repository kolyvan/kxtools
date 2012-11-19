//
//  KxBitArray.m
//  kxtools
//
//  Created by Kolyvan on 13.09.12.
//
//

#import "KxBitArray.h"

typedef uint64_t word_t;

const NSUInteger WORD_SIZE = sizeof(word_t) * 8;

#pragma mark - helper funcs

static inline NSUInteger _bitIndex (NSUInteger index)  { return (index / WORD_SIZE); }
static inline NSUInteger _bitOffset(NSUInteger index)  { return (index % WORD_SIZE); }
static inline NSUInteger _numWords(NSUInteger count)   { return (count + WORD_SIZE - 1) / WORD_SIZE; }
static inline NSUInteger _numBytes(NSUInteger count)   { return _numWords(count) * sizeof(word_t); }

static inline bool _testBit(word_t* words, NSUInteger index)
{
    return (words[_bitIndex(index)] >> (_bitOffset(index))) & 0x1;
}

static inline void _setBit(word_t* words, NSUInteger index)
{
    words[_bitIndex(index)] |= ((word_t)0x1 << (_bitOffset(index)));
}

static inline void _clearBit(word_t* words, NSUInteger index)
{
    words[_bitIndex(index)] &= ~((word_t)0x1 << (_bitOffset(index)));
}

static inline void _toggleBit(word_t* words, NSUInteger index)
{
    words[_bitIndex(index)] ^= ((word_t)0x1 << (_bitOffset(index)));
}

@implementation KxBitArray {
    
    word_t *_words;
    NSUInteger _count;
}

+ (id) bits: (NSUInteger) count
{
    return [[KxBitArray alloc] init: count];
}

+ (id) bitsFromString: (NSString *) string
{
    return [[KxBitArray alloc] initFromString: string];    
}

+ (id) bitsFromData: (NSData *) data
{
    return [[KxBitArray alloc] initFromData: data];
}

- (id) init: (NSUInteger) count
{
    self = [super init];
    if (self) {
        _count = count;
        _words = (word_t*) malloc(_numBytes(_count));
        [self clearAll];
    }
    return  self;
}

- (id) initFromString: (NSString *) string
{
    self = [super init];
    if (self) {
        _count = string.length;
        _words = (word_t*) malloc(_numBytes(_count));
        [self clearAll];

        const char *p = [string cStringUsingEncoding:NSASCIIStringEncoding];
        for (int i = 0; i < _count; ++i)
            if (p[i] != '0')
                _setBit(_words, i);
    }
    return  self;
}

- (id) initFromData: (NSData *) data
{
    self = [super init];
    if (self) {
        _count = data.length;
        _words = (word_t*) malloc(_numBytes(_count));
        [self clearAll];
        
        const Byte *p = data.bytes;
        for (int i = 0; i < _count; ++i)
            if (p[i] != 0)
                _setBit(_words, i);
    }
    return  self;
}

- (void) dealloc
{
    free(_words);
    _words = NULL;
}

- (BOOL) testBit: (NSUInteger) index
{
    if (index >= _count)
        [NSException raise:NSRangeException format:@"out of range"];
    
    return _testBit(_words, index);
}

- (void) setBit: (NSUInteger) index
{
    if (index >= _count)
        [NSException raise:NSRangeException format:@"out of range"];
    
    return _setBit(_words, index);
}

- (void) clearBit: (NSUInteger) index
{
    if (index >= _count)
        [NSException raise:NSRangeException format:@"out of range"];
    
    return _clearBit(_words, index);
}

- (void) toggleBit: (NSUInteger) index
{
    if (index >= _count)
        [NSException raise:NSRangeException format:@"out of range"];

    _toggleBit(_words, index);
}

- (void) assignBit: (NSUInteger) index on: (BOOL) on
{
    on ? _setBit(_words, index) : _clearBit(_words, index);
}

- (void) setAll
{
    NSUInteger numBytes = (_count / WORD_SIZE) * sizeof(word_t);
//  memset(_words, 0xFF, _numBytes(_count));
    memset(_words, 0xFF, numBytes);
    NSUInteger tail = numBytes * 8;
    for (NSUInteger i = tail; i < _count; ++i)
        _setBit(_words, i);
}

- (void) clearAll
{
    memset(_words, 0, _numBytes(_count));
}

- (NSUInteger) countBits
{
    NSUInteger result = 0;
        
    for (int i = 0; i < _numWords(_count); ++i) {
        
        if (_words[i] > 0)  {
            
#if 1
            result += __builtin_popcountll(_words[i]);
#else
            
            for (int j = 0; j < WORD_SIZE; ++j)
                if ((_words[i] >> (word_t)j) & (word_t)0x1)
                    result++;
            
#endif
        }
    }
    
    return result;
}

- (NSUInteger) countBits: (BOOL) on
{
    NSUInteger n = [self countBits];
    return on ? n : _count - n;
}

- (NSUInteger) firstSetBit
{
    for (int i = 0; i < _numWords(_count); ++i) {
        
        if (_words[i] > 0)  {
         
            int j = 0;
            while (0 == ((_words[i] >> j) & 0x1))
                j++;
            return j + i * WORD_SIZE;
        }
    }
    
    return NSNotFound;
}

- (BOOL) testAny
{
    for (int i = 0; i < _numWords(_count); ++i)
        if (_words[i] > 0)
            return YES;
    return NO;
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"<%@:%p %ld/%ld>",
            [self class], self, (long)[self countBits: YES], (long)self.count];
}

- (id) copyWithZone:(NSZone *) zone
{
    KxBitArray *result = [[KxBitArray alloc] init];
    if (result) {
        NSUInteger numBytes = _numBytes(_count);
        result->_count = _count;
        result->_words = (word_t*) malloc(numBytes);
        memcpy(result->_words, _words, numBytes);
    }
	return result;
}

- (KxBitArray *) intersectBits: (KxBitArray *) other
{
    if (_count != other->_count)
        [NSException raise:NSRangeException format:@"invalid size"];
    
    KxBitArray *result = [self copy];        
    for (int i = 0; i < _numWords(_count); ++i)
        result->_words[i] &= other->_words[i];
    return result;
}

- (KxBitArray *) unionBits: (KxBitArray *) other
{
    if (_count != other->_count)
        [NSException raise:NSRangeException format:@"invalid size"];
    
    KxBitArray *result = [self copy];
    for (int i = 0; i < _numWords(_count); ++i)
        result->_words[i] |= other->_words[i];    
    return result;
}

- (KxBitArray *) negateBits
{
    KxBitArray *result = [self copy];
    
    NSUInteger num = (_count / WORD_SIZE);
    
    for (int i = 0; i < num; ++i)
        result->_words[i] = ~_words[i];
    
    NSUInteger tail = num * sizeof(word_t) * 8;
    
    for (NSUInteger i = tail; i < _count; ++i)
        if (_testBit(_words, i))
            _clearBit(result->_words, i);
        else
            _setBit(result->_words, i);
    
    return result;
}

- (BOOL) isEqual:(id) other
{
	if (![other isKindOfClass:[KxBitArray class]])
		return NO;
    
    return [self isEqualToBitArray:(KxBitArray *)other];
}

- (BOOL) isEqualToBitArray: (KxBitArray *) other
{
    if (self == other)
		return YES;
    
    if (!other ||
        _count != other->_count)
        return NO;
    
    return 0 == memcmp(_words, other->_words, _numBytes(_count));
}

- (void) enumerateBits: (void(^)(NSUInteger))block
{
    if (!block)
        return;
    
    for (int i = 0; i < _numWords(_count); ++i) {
        
        if (_words[i] > 0)  {
            
            for (int j = 0; j < WORD_SIZE; ++j)
                if ((_words[i] >> (word_t)j) & (word_t)0x1)
                    block(j + i * WORD_SIZE);
        }
    }
}

- (NSArray *) toArray
{
    NSMutableArray *ma = [NSMutableArray array];
    [self enumerateBits:^(NSUInteger i) {
        [ma addObject:[NSNumber numberWithInteger:i]];
    }];
    return [ma copy];
}

- (NSIndexSet *) toIndexSet
{
    NSMutableIndexSet *mis = [NSMutableIndexSet indexSet];
    [self enumerateBits:^(NSUInteger i) {
        [mis addIndex:i];
    }];
    return mis;
}

- (NSString *) toString
{
    char str[_count + 1];
    
    for (int i = 0; i < _count; i++)
        str[i] = _testBit(_words, i) ? '1' : '0';
    str[_count] = 0;
    
    return [NSString stringWithCString:str encoding:NSASCIIStringEncoding];
}

- (NSData *) toData
{
    Byte buf[_count];
    
    for (int i = 0; i < _count; i++)
        buf[i] = _testBit(_words, i) ? 1 : 0;
    
    return [NSData dataWithBytes:buf length:sizeof(buf)];
}

@end
