//
//  ViewController.m
//  cffsas
//
//  Created by resober on 2019/3/28.
//  Copyright © 2019 resober. All rights reserved.
//

#import "ViewController.h"
#import "CFFSAS.h"
#import <mach-o/dyld.h>
#import <dlfcn.h>
#import <mach-o/getsect.h>

#ifdef __LP64__
typedef struct section_64 resober_Section;
typedef uint64_t resober_uint;
#define resober_getsectbynamefromheader getsectbynamefromheader_64
#else
typedef struct section resober_Section;
typedef uint32_t resober_uint;
#define resober_getsectbynamefromheader getsectbynamefromheader
#endif


@interface ViewController ()

@end

void printHelloWorld() {
    // 在这里存入
    CFFSAS_WRITE_FUNCTION("reserved key", (void *)(printHelloWorld));
    printf("Hello, World\n");
}

void load_image(const struct mach_header *mh, intptr_t vm_slide) {
    Dl_info info;
    if (dladdr(mh, &info) == 0) {
        return;
    }
    const void *mach_header = info.dli_fbase;
    const resober_Section *section = resober_getsectbynamefromheader(mach_header, CFFSAS_SEGMENT, CFFSAS_SECTION);
    if (!section) {
        return;
    }
    for (resober_uint offset = section->offset; offset < section->offset + section->size; offset += sizeof(struct ResoberFunctionData)) {
        struct ResoberFunctionData data = *(struct ResoberFunctionData *)(mach_header + offset);
        __unused const char *key = data.key;
        const void *function = data.value;
        if (function) {
            ((void(*)(void))function)();
        }
    }
}

@implementation ViewController

+ (void)initialize {
    // 在这里准备读取
    _dyld_register_func_for_add_image(load_image);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

@end
