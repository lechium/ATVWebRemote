#include <stdio.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "RemoteTestHelper.h"

int main(int argc, char *argv[], char *envp[]) {
	@autoreleasepool {
        RemoteTestHelper *rmh = [RemoteTestHelper sharedInstance];
        [rmh startItUp];
        CFRunLoopRun();
		return 0;
	}
}
