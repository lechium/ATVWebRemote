#include <stdio.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "AMHelper.h"

int main(int argc, char *argv[], char *envp[]) {
	@autoreleasepool {
        AMHelper *amh = [AMHelper sharedInstance];
        [amh startItUp];
        CFRunLoopRun();
		return 0;
	}
}
