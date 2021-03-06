//
//  UIView+Positioning.h
//  DJkit
//
//  Created by DennisDeng on 14-5-5.
//  Copyright (c) 2014年 DennisDeng. All rights reserved.
//

#import "UIView+Positioning.h"
#import "UIView+Size.h"

@implementation UIView (Positioning)

- (void)centerInRect:(CGRect)rect
{
    [self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self width]) % 2 ? .5 : 0) , floorf(CGRectGetMidY(rect)) + ((int)floorf([self height]) % 2 ? .5 : 0))];
}

- (void)centerInRect:(CGRect)rect leftOffset:(CGFloat)left
{
    [self setCenter:CGPointMake(left + floorf(CGRectGetMidX(rect)) + ((int)floorf([self width]) % 2 ? .5 : 0) , floorf(CGRectGetMidY(rect)) + ((int)floorf([self height]) % 2 ? .5 : 0))];
}

- (void)centerInRect:(CGRect)rect topOffset:(CGFloat)top
{
    [self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self width]) % 2 ? .5 : 0) , top + floorf(CGRectGetMidY(rect)) + ((int)floorf([self height]) % 2 ? .5 : 0))];
}

- (void)centerVerticallyInRect:(CGRect)rect
{
    [self setCenter:CGPointMake([self center].x, floorf(CGRectGetMidY(rect)) + ((int)floorf([self height]) % 2 ? .5 : 0))];
}

- (void)centerVerticallyInRect:(CGRect)rect left:(CGFloat)left
{
//    [self setCenter:CGPointMake(left + [self center].x, floorf(CGRectGetMidY(rect)) + ((int)floorf([self height]) % 2 ? .5 : 0))];
    
    [self centerVerticallyInRect:rect];
    self.left = left;
}

- (void)centerHorizontallyInRect:(CGRect)rect
{
    [self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self width]) % 2 ? .5 : 0), [self center].y)];
}

- (void)centerHorizontallyInRect:(CGRect)rect top:(CGFloat)top
{
//    [self setCenter:CGPointMake(floorf(CGRectGetMidX(rect)) + ((int)floorf([self width]) % 2 ? .5 : 0), top + ((int)floorf([self height]) % 2 ? .5 : 0))];
    
    [self centerHorizontallyInRect:rect];
    self.top = top;
}

- (void)centerInSuperView
{
    [self centerInRect:[[self superview] bounds]];
}

- (void)centerInSuperViewWithLeftOffset:(CGFloat)left
{
    [self centerInRect:[[self superview] bounds] leftOffset:left];
}

- (void)centerInSuperViewWithTopOffset:(CGFloat)top
{
    [self centerInRect:[[self superview] bounds] topOffset:top];
}

- (void)centerVerticallyInSuperView
{
    [self centerVerticallyInRect:[[self superview] bounds]];
}

- (void)centerVerticallyInSuperViewWithLeft:(CGFloat)left
{
    [self centerVerticallyInRect:[[self superview] bounds] left:left];
}

- (void)centerHorizontallyInSuperView
{
    [self centerHorizontallyInRect:[[self superview] bounds]];
}

- (void)centerHorizontallyInSuperViewWithTop:(CGFloat)top
{
    [self centerHorizontallyInRect:[[self superview] bounds] top:top];
}

- (void)centerHorizontallyBelow:(UIView *)view padding:(CGFloat)padding
{
    // for now, could use screen relative positions.
    NSAssert([self superview] == [view superview], @"views must have the same parent");
    
    [self setCenter:CGPointMake([view center].x,
                                floorf(padding + CGRectGetMaxY([view frame]) + ([self height] / 2)))];
}

- (void)centerHorizontallyBelow:(UIView *)view
{
    [self centerHorizontallyBelow:view padding:0];
}

@end


@implementation UIView (wiSubview)

- (void) addSubviewToBack:(UIView*)view
{
    [self addSubview:view];
    [self sendSubviewToBack:view];
}

- (UIViewController*)viewController
{
//    for (UIView* next = [self superview]; next; next = next.superview) 
//    {
//        UIResponder* nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[UIViewController class]])
//        {
//            return (UIViewController*)nextResponder;
//        }
//    }
//    return nil;
    
    //通过响应者链，获取此视图所在的视图控制器
    UIResponder *next = self.nextResponder;
    do
    {
        //判断响应者对象是否是视图控制器对象
        if ([next isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)next;
        }
        //不停的指向下一个响应者
        next = next.nextResponder;
        
    }
    while (next != nil);
    
    return nil;
}

- (NSInteger)subviewIndex
{
    if (self.superview == nil)
    {
        return NSNotFound;
    }
    
    return [self.superview.subviews indexOfObject:self];
}

- (UIView *)superviewWithClass:(Class)aClass
{
    return [self superviewWithClass:aClass strict:NO];
}

- (UIView *)superviewWithClass:(Class)aClass strict:(BOOL)strict
{
    UIView *view = self.superview;
    
    while(view)
    {
        if(strict && [view isMemberOfClass:aClass])
        {
            break;
        }
        else if(!strict && [view isKindOfClass:aClass])
        {
            break;
        }
        else
        {
            view = view.superview;
        }
    }
    
    return view;
}

- (UIView*)descendantOrSelfWithClass:(Class)aClass
{
    return [self descendantOrSelfWithClass:aClass strict:NO];
}

- (UIView *)descendantOrSelfWithClass:(Class)aClass strict:(BOOL)strict
{
    if (strict && [self isMemberOfClass:aClass])
    {
        return self;
    }
    else if (!strict && [self isKindOfClass:aClass])
    {
        return self;
    }
    
    for (UIView* child in self.subviews)
    {
        UIView* viewWithClass = [child descendantOrSelfWithClass:aClass strict:strict];
        
        if (viewWithClass != nil)
        {
            return viewWithClass;
        }
    }
    
    return nil;
}

- (void)removeAllSubviews
{
    while (self.subviews.count > 0)
    {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (void)bringToFront
{
    [self.superview bringSubviewToFront:self];
}

- (void)sendToBack
{
    [self.superview sendSubviewToBack:self];
}

- (void)bringOneLevelUp
{
    NSInteger currentIndex = self.subviewIndex;
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex+1];
}

- (void)sendOneLevelDown
{
    NSInteger currentIndex = self.subviewIndex;
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex-1];
}

- (BOOL)isInFront
{
    return (self.superview.subviews.lastObject == self);
}

- (BOOL)isAtBack
{
    return ([self.superview.subviews objectAtIndex:0] == self);
}

- (void)swapDepthsWithView:(UIView*)swapView
{
    [self.superview exchangeSubviewAtIndex:self.subviewIndex withSubviewAtIndex:swapView.subviewIndex];
}


#pragma mark -
#pragma mark view searching

- (UIView *)viewMatchingPredicate:(NSPredicate *)predicate
{
    if ([predicate evaluateWithObject:self])
    {
        return self;
    }

    for (UIView *view in self.subviews)
    {
        UIView *match = [view viewMatchingPredicate:predicate];
        if (match)
        {
            return match;
        }
    }

    return nil;
}

- (UIView *)viewWithTag:(NSInteger)tag ofClass:(Class)viewClass
{
    return [self viewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, __unused NSDictionary *bindings) {
        return [evaluatedObject tag] == tag && [evaluatedObject isKindOfClass:viewClass];
    }]];
}

- (UIView *)viewOfClass:(Class)viewClass
{
    return [self viewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, __unused NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:viewClass];
    }]];
}

- (NSArray *)viewsMatchingPredicate:(NSPredicate *)predicate
{
    NSMutableArray *matches = [NSMutableArray array];

    if ([predicate evaluateWithObject:self])
    {
        [matches addObject:self];
    }

    for (UIView *view in self.subviews)
    {
        //check for subviews
        //avoid creating unnecessary array
        if ([view.subviews count])
        {
        	[matches addObjectsFromArray:[view viewsMatchingPredicate:predicate]];
        }
        else if ([predicate evaluateWithObject:view])
        {
            [matches addObject:view];
        }
    }

    return matches;
}

- (NSArray *)viewsWithTag:(NSInteger)tag
{
    return [self viewsMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, __unused id bindings) {
        return [evaluatedObject tag] == tag;
    }]];
}

- (NSArray *)viewsWithTag:(NSInteger)tag ofClass:(Class)viewClass
{
    return [self viewsMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, __unused id bindings) {
        return [evaluatedObject tag] == tag && [evaluatedObject isKindOfClass:viewClass];
    }]];
}

- (NSArray *)viewsOfClass:(Class)viewClass
{
    return [self viewsMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, __unused id bindings) {
        return [evaluatedObject isKindOfClass:viewClass];
    }]];
}

- (UIView *)firstSuperviewMatchingPredicate:(NSPredicate *)predicate
{
    if ([predicate evaluateWithObject:self])
    {
        return self;
    }

    return [self.superview firstSuperviewMatchingPredicate:predicate];
}

- (UIView *)firstSuperviewOfClass:(Class)viewClass
{
    return [self firstSuperviewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *superview, __unused id bindings) {
        return [superview isKindOfClass:viewClass];
    }]];
}

- (UIView *)firstSuperviewWithTag:(NSInteger)tag
{
    return [self firstSuperviewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *superview, __unused id bindings) {
        return superview.tag == tag;
    }]];
}

- (UIView *)firstSuperviewWithTag:(NSInteger)tag ofClass:(Class)viewClass
{
    return [self firstSuperviewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *superview, __unused id bindings) {
        return superview.tag == tag && [superview isKindOfClass:viewClass];
    }]];
}

- (BOOL)viewOrAnySuperviewMatchesPredicate:(NSPredicate *)predicate
{
    if ([predicate evaluateWithObject:self])
    {
        return YES;
    }

    return [self.superview viewOrAnySuperviewMatchesPredicate:predicate];
}

- (BOOL)viewOrAnySuperviewIsKindOfClass:(Class)viewClass
{
    return [self viewOrAnySuperviewMatchesPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *superview, __unused id bindings) {
        return [superview isKindOfClass:viewClass];
    }]];
}

//- (BOOL)isSuperviewOfView:(UIView *)view
//{
//    return [self firstSuperviewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *superview, __unused id bindings) {
//        return superview == view;
//    }]] != nil;
//}
//
//- (BOOL)isSubviewOfView:(UIView *)view
//{
//    return [view isSuperviewOfView:self];
//}

- (BOOL)isSuperviewOfView:(UIView *)view
{
    return [view isSubviewOfView:self];
}

- (BOOL)isSubviewOfView:(UIView *)view
{
    return [self isDescendantOfView:view];
}


#pragma mark -
#pragma mark responder chain

- (UIViewController *)firstViewController
{
    UIResponder *responder = self;

    while ((responder = [responder nextResponder]))
    {
        if ([responder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)responder;
        }
    }

    return nil;
}

- (UIView *)firstResponder
{
    return [self viewMatchingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, __unused id bindings) {
        return [evaluatedObject isFirstResponder];
    }]];
}

- (CGPoint)convertCenterToView:(UIView *)view
{
    if (self.superview)
    {
        return [self.superview convertPoint:self.center toView:view];
    }
    
    return CGPointZero;
}

- (CGRect)convertFrameToView:(UIView *)view
{
    if (self.superview)
    {
        return [self.superview convertRect:self.frame toView:view];
    }
    
    return CGRectZero;
}

- (void)moveToView:(UIView *)view
{
    if (self.superview)
    {
        self.center = [self convertCenterToView:view];
        [self removeFromSuperview];
        [view addSubview:self];
    }
}

- (void)moveToBackOfView:(UIView *)view
{
    if (self.superview)
    {
        self.center = [self convertCenterToView:view];
        [self removeFromSuperview];
        [view addSubviewToBack:self];
    }
}

@end


#pragma mark -
#pragma mark UIView + TTUICommon

@implementation UIView (TTUICommon)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)descendantOrSelfWithClass:(Class)cls
{
    if ([self isKindOfClass:cls])
    {
        return self;
    }
    
    for (UIView *child in self.subviews)
    {
        UIView *it = [child descendantOrSelfWithClass:cls];
        if (it)
        {
            return it;
        }
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)ancestorOrSelfWithClass:(Class)cls
{
    if ([self isKindOfClass:cls])
    {
        return self;
    }
    else if (self.superview)
    {
        return [self.superview ancestorOrSelfWithClass:cls];
    }
    else
    {
        return nil;
    }
}

@end
