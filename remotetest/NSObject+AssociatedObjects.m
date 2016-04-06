//
//  NSObject+AssociatedObjects.m
//
//  Created by Andy Matuschak on 8/27/09.
//  Public domain because I love you.
//

#import "NSObject+AssociatedObjects.h"
#import <objc/runtime.h>

@interface FBScene : NSObject

- (id)identifier;
- (id)client;
- (id)delegate;

@end
@interface FBSceneHostWrapperView: NSObject

- (id)scene;
- (id)window;

@end



@implementation UIView (RecursiveClass)

#define FBSHWV objc_getClass("FBSceneHostWrapperView")


- (id)windowWithSceneID:(NSString *)sceneId
{
    if ([self isKindOfClass:FBSHWV])
    {
        if ([self respondsToSelector:@selector(scene)])
        {
            
            FBScene *theScene = [(FBSceneHostWrapperView *)self scene];
            id client = [theScene client];
            id delegate = [theScene delegate];
            NSString *ident = [theScene identifier];
            if ([ident isEqualToString:sceneId])
            {
                id containerView = [self valueForKey:@"_hostContainerView"];
              //  NSLog(@"### client: %@ delegate: %@", client, delegate);
                
                NSLog(@"hcv: %@", containerView);
                if (containerView != nil)
                {
                    id delegates = [containerView delegate];
                    id ds = [containerView dataSource];
                   // id views = [containerView valueForKey:@"_hostViews"];
                    NSLog(@"#### delegate; %@ ds: %@", delegates, ds);
                }
                return [(FBSceneHostWrapperView *)self window];
            }
        }
    }
    id foundView = nil;
    
    for (UIView *v in self.subviews) {
        foundView = [v windowWithSceneID:sceneId];
        
        if (foundView != nil)
        {
            return foundView;
        }
    }
    return nil;
}

- (id)recursiveSubviewWithClass:(Class)theClass
{
    if ([self isKindOfClass:theClass])
    {
        return self;
    }
    id foundView = nil;
    
    for (UIView *v in self.subviews) {
        foundView = [v recursiveSubviewWithClass:theClass];
        
        if (foundView != nil)
        {
            return foundView;
        }
    }
    
    
    return nil;
}


@end

@implementation NSObject (AMAssociatedObjects)


- (void)associateValue:(id)value withKey:(void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN);
}

- (void)weaklyAssociateValue:(id)value withKey:(void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (id)associatedValueForKey:(void *)key
{
    return objc_getAssociatedObject(self, key);
}

@end

@implementation NSDate (Science)

+ (BOOL)passedEpochDateInterval:(NSTimeInterval)interval
{
    //return true; //force to test to see if it works
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSComparisonResult result = [date compare:[NSDate date]];
    if (result == NSOrderedAscending)
    {
        return true;
    }
    return false;
}

@end