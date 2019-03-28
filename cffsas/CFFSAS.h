//
//  CFFSAS.h
//  cffsas
//
//  Created by resober on 2019/3/28.
//  Copyright © 2019 resober. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct ResoberFunctionData {
    const char *key;
    const void *value;
};

#define CFFSAS_SEGMENT "__DATA"
#define CFFSAS_COMMA ","
#define CFFSAS_SECTION "__RESOBER_DATA"
#define CFFSAS_CONCAT(A, B) A ## B
#define CFFSAS_SEGMENT_SECTION CFFSAS_SEGMENT CFFSAS_COMMA CFFSAS_SECTION
#define CFFSAS_FUNCTION_IDENTIFIER(COUNTER) CFFSAS_CONCAT(__RESOBER__, COUNTER)
#define CFFSAS_WRITE_FUNCTION(KEY, VALUE) __attribute__((used, section(CFFSAS_SEGMENT_SECTION))) static struct ResoberFunctionData CFFSAS_FUNCTION_IDENTIFIER(__COUNTER__) = (struct ResoberFunctionData){KEY, VALUE}

NS_ASSUME_NONNULL_END
