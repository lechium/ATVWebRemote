//
//  AMHTTPConnection.h
//  ATVWebRemote
//
//  Created by Kevin Bradley on 4/3/16.
//  Copyright © 2016 nito. All rights reserved.
//

#import "HTTPConnection.h"

@interface AMHTTPConnection : HTTPConnection

+ (NSString *)airControlRoot;
+ (NSString *)properVersion;
+ (NSString *)osBuild;
- (float)currentVersion;
@end
