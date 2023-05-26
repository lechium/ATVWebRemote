//
//  NSObject+AssociatedObjects.h
//
//  Created by Andy Matuschak on 8/27/09.
//  Public domain because I love you.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (RecursiveClass)

- (id)recursiveSubviewWithClass:(Class)theClass;
- (id)windowWithSceneID:(NSString *)sceneId;
@end

@interface NSObject (AMAssociatedObjects)
- (void)associateValue:(id)value withKey:(void *)key; // Strong reference
- (void)weaklyAssociateValue:(id)value withKey:(void *)key;
- (id)associatedValueForKey:(void *)key;
@end

@interface NSDate (Science)
+ (BOOL)passedEpochDateInterval:(NSTimeInterval)interval;
@end

