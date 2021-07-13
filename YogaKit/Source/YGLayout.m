/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "UIView+Yoga.h"
#import "YGLayout+Private.h"

#define YG_PROPERTY(type, lowercased_name, capitalized_name)        \
-(type)lowercased_name {                                            \
    return YGNodeStyleGet##capitalized_name(self.node);             \
}                                                                   \
                                                                    \
-(void)set##capitalized_name : (type)lowercased_name {              \
    YGNodeStyleSet##capitalized_name(self.node, lowercased_name);   \
}

#define YG_VALUE_PROPERTY(lowercased_name, capitalized_name)                    \
-(YGValue)lowercased_name {                                                     \
    return YGNodeStyleGet##capitalized_name(self.node);                         \
}                                                                               \
                                                                                \
-(void)set##capitalized_name : (YGValue)lowercased_name {                       \
    switch (lowercased_name.unit) {                                             \
        case YGUnitUndefined:                                                   \
            YGNodeStyleSet##capitalized_name(self.node, lowercased_name.value); \
            break;                                                              \
        case YGUnitPoint:                                                       \
            YGNodeStyleSet##capitalized_name(self.node, lowercased_name.value); \
            break;                                                              \
        case YGUnitPercent:                                                     \
            YGNodeStyleSet##capitalized_name##Percent(                          \
            self.node, lowercased_name.value);                                  \
            break;                                                              \
        default:                                                                \
            NSAssert(NO, @"Not implemented");                                   \
    }                                                                           \
}

#define YG_AUTO_VALUE_PROPERTY(lowercased_name, capitalized_name)               \
-(YGValue)lowercased_name {                                                     \
    return YGNodeStyleGet##capitalized_name(self.node);                         \
}                                                                               \
                                                                                \
-(void)set##capitalized_name : (YGValue)lowercased_name {                       \
    switch (lowercased_name.unit) {                                             \
        case YGUnitPoint:                                                       \
            YGNodeStyleSet##capitalized_name(self.node, lowercased_name.value); \
            break;                                                              \
        case YGUnitPercent:                                                     \
            YGNodeStyleSet##capitalized_name##Percent(                          \
            self.node, lowercased_name.value);                                  \
            break;                                                              \
        case YGUnitAuto:                                                        \
            YGNodeStyleSet##capitalized_name##Auto(self.node);                  \
            break;                                                              \
        default:                                                                \
            NSAssert(NO, @"Not implemented");                                   \
    }                                                                           \
}

#define YG_EDGE_PROPERTY_GETTER(type, lowercased_name, capitalized_name, property, edge)    \
-(type)lowercased_name {                                                                    \
    return YGNodeStyleGet##property(self.node, edge);                                       \
}

#define YG_EDGE_PROPERTY_SETTER(lowercased_name, capitalized_name, property, edge)          \
-(void)set##capitalized_name : (CGFloat)lowercased_name {                                   \
    YGNodeStyleSet##property(self.node, edge, lowercased_name);                             \
}

#define YG_EDGE_PROPERTY(lowercased_name, capitalized_name, property, edge)                         \
        YG_EDGE_PROPERTY_GETTER(CGFloat, lowercased_name, capitalized_name, property, edge)         \
        YG_EDGE_PROPERTY_SETTER(lowercased_name, capitalized_name, property, edge)

#define YG_VALUE_EDGE_PROPERTY_SETTER(objc_lowercased_name, objc_capitalized_name, c_name, edge)    \
-(void)set##objc_capitalized_name : (YGValue)objc_lowercased_name {                                 \
    switch (objc_lowercased_name.unit) {                                                            \
        case YGUnitUndefined:                                                                       \
            YGNodeStyleSet##c_name(self.node, edge, objc_lowercased_name.value);                    \
            break;                                                                                  \
        case YGUnitPoint:                                                                           \
            YGNodeStyleSet##c_name(self.node, edge, objc_lowercased_name.value);                    \
            break;                                                                                  \
        case YGUnitPercent:                                                                         \
            YGNodeStyleSet##c_name##Percent(                                                        \
            self.node, edge, objc_lowercased_name.value);                                           \
            break;                                                                                  \
        default:                                                                                    \
            NSAssert(NO, @"Not implemented");                                                       \
    }                                                                                               \
}

#define YG_VALUE_EDGE_PROPERTY(lowercased_name, capitalized_name, property, edge)               \
        YG_EDGE_PROPERTY_GETTER(YGValue, lowercased_name, capitalized_name, property, edge)     \
        YG_VALUE_EDGE_PROPERTY_SETTER(lowercased_name, capitalized_name, property, edge)

#define YG_VALUE_EDGES_PROPERTIES(lowercased_name, capitalized_name)                          \
        YG_VALUE_EDGE_PROPERTY(lowercased_name##Left,                                         \
                               capitalized_name##Left,                                        \
                               capitalized_name,                                              \
                               YGEdgeLeft)                                                    \
        YG_VALUE_EDGE_PROPERTY(lowercased_name##Top,                                          \
                               capitalized_name##Top,                                         \
                               capitalized_name,                                              \
                               YGEdgeTop)                                                     \
        YG_VALUE_EDGE_PROPERTY(lowercased_name##Right,                                        \
                               capitalized_name##Right,                                       \
                               capitalized_name,                                              \
                               YGEdgeRight)                                                   \
        YG_VALUE_EDGE_PROPERTY(lowercased_name##Bottom,                                       \
                               capitalized_name##Bottom,                                      \
                               capitalized_name,                                              \
                               YGEdgeBottom)                                                  \
        YG_VALUE_EDGE_PROPERTY(lowercased_name##Start,                                        \
                               capitalized_name##Start,                                       \
                               capitalized_name,                                              \
                               YGEdgeStart)                                                   \
        YG_VALUE_EDGE_PROPERTY(lowercased_name##End,                                          \
                               capitalized_name##End,                                         \
                               capitalized_name,                                              \
                               YGEdgeEnd)                                                     \
        YG_VALUE_EDGE_PROPERTY(lowercased_name##Horizontal,                                   \
                               capitalized_name##Horizontal,                                  \
                               capitalized_name,                                              \
                               YGEdgeHorizontal)                                              \
        YG_VALUE_EDGE_PROPERTY(lowercased_name##Vertical,                                     \
                               capitalized_name##Vertical,                                    \
                               capitalized_name,                                              \
                               YGEdgeVertical)                                                \
        YG_VALUE_EDGE_PROPERTY(lowercased_name, capitalized_name, capitalized_name, YGEdgeAll)

static CGFloat YGScaleFactor() {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^() {
#if TARGET_OS_OSX
        scale = [NSScreen mainScreen].backingScaleFactor;
#else
        scale = [UIScreen mainScreen].scale;
#endif
    });

    return scale;
}

static YGConfigRef YGGlobalConfig() {
    static YGConfigRef globalConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^() {
        globalConfig = YGConfigNew();
        YGConfigSetExperimentalFeatureEnabled(globalConfig, YGExperimentalFeatureWebFlexBasis, true);
        YGConfigSetPointScaleFactor(globalConfig, YGScaleFactor());
    });

    return globalConfig;
}

NS_INLINE CGFloat YGFloatValidate(CGFloat x) {
    return isnan(x) || isinf(x) ? 0 : x;
}

NS_INLINE CGFloat YGFloatNonNegative(CGFloat x) {
    return fmax(YGFloatValidate(x), 0);
}

@interface YGLayout ()

@property(nonatomic, weak, readonly) UIView* view;
@property(nonatomic, readonly) BOOL isBaseView;
@property(nonatomic) BOOL isApplingLayout;

@end

#pragma mark - Style

@implementation YGLayout (Properties)

- (YGPositionType)position {
    return YGNodeStyleGetPositionType(self.node);
}

- (void)setPosition:(YGPositionType)position {
    YGNodeStyleSetPositionType(self.node, position);
}

YG_PROPERTY(YGDirection, direction, Direction)
YG_PROPERTY(YGFlexDirection, flexDirection, FlexDirection)
YG_PROPERTY(YGJustify, justifyContent, JustifyContent)
YG_PROPERTY(YGAlign, alignContent, AlignContent)
YG_PROPERTY(YGAlign, alignItems, AlignItems)
YG_PROPERTY(YGAlign, alignSelf, AlignSelf)
YG_PROPERTY(YGWrap, flexWrap, FlexWrap)
YG_PROPERTY(YGOverflow, overflow, Overflow)
YG_PROPERTY(YGDisplay, display, Display)

YG_PROPERTY(CGFloat, flex, Flex)
YG_PROPERTY(CGFloat, flexGrow, FlexGrow)
YG_PROPERTY(CGFloat, flexShrink, FlexShrink)
YG_AUTO_VALUE_PROPERTY(flexBasis, FlexBasis)

YG_VALUE_EDGE_PROPERTY(left, Left, Position, YGEdgeLeft)
YG_VALUE_EDGE_PROPERTY(top, Top, Position, YGEdgeTop)
YG_VALUE_EDGE_PROPERTY(right, Right, Position, YGEdgeRight)
YG_VALUE_EDGE_PROPERTY(bottom, Bottom, Position, YGEdgeBottom)
YG_VALUE_EDGE_PROPERTY(start, Start, Position, YGEdgeStart)
YG_VALUE_EDGE_PROPERTY(end, End, Position, YGEdgeEnd)
YG_VALUE_EDGES_PROPERTIES(margin, Margin)
YG_VALUE_EDGES_PROPERTIES(padding, Padding)

YG_EDGE_PROPERTY(borderLeftWidth, BorderLeftWidth, Border, YGEdgeLeft)
YG_EDGE_PROPERTY(borderTopWidth, BorderTopWidth, Border, YGEdgeTop)
YG_EDGE_PROPERTY(borderRightWidth, BorderRightWidth, Border, YGEdgeRight)
YG_EDGE_PROPERTY(borderBottomWidth, BorderBottomWidth, Border, YGEdgeBottom)
YG_EDGE_PROPERTY(borderStartWidth, BorderStartWidth, Border, YGEdgeStart)
YG_EDGE_PROPERTY(borderEndWidth, BorderEndWidth, Border, YGEdgeEnd)
YG_EDGE_PROPERTY(borderWidth, BorderWidth, Border, YGEdgeAll)

YG_AUTO_VALUE_PROPERTY(width, Width)
YG_AUTO_VALUE_PROPERTY(height, Height)
YG_VALUE_PROPERTY(minWidth, MinWidth)
YG_VALUE_PROPERTY(minHeight, MinHeight)
YG_VALUE_PROPERTY(maxWidth, MaxWidth)
YG_VALUE_PROPERTY(maxHeight, MaxHeight)
YG_PROPERTY(CGFloat, aspectRatio, AspectRatio)

@end

@implementation YGLayout

- (instancetype)initWithView:(UIView*)view {
    if (self = [super init]) {
        _view = view;
        _node = YGNodeNewWithConfig(YGGlobalConfig());
        YGNodeSetContext(_node, (__bridge void*)view);
       
        _isIncludedInLayout = YES;
        _isBaseView = [view isMemberOfClass:UIView.class] || [view isMemberOfClass:UIControl.class];
    }

    return self;
}

- (void)dealloc {
    YGNodeFree(self.node);
}

- (UIView *)rootYogaView {
    UIView *node = self.view;

    while (node) {
        UIView *parent = node.superview;
        if (!parent || !parent.isYogaEnabled || !parent.yoga.isIncludedInLayout) {
            break;
        }

        node = parent;
    }

    return node;
}

- (BOOL)isDirty {
    return YGNodeIsDirty(self.node);
}

- (void)markDirty {
    if (!self.isIncludedInLayout || !self.isLeaf) {
        return;
    }

    // Yoga is not happy if we try to mark a node as "dirty" before we have set
    // the measure function. Since we already know that this is a leaf,
    // this *should* be fine. Forgive me Hack Gods.
    const YGNodeRef node = self.node;
    if (!YGNodeHasMeasureFunc(node)) {
        YGNodeSetMeasureFunc(node, YGMeasureView);
    }

    YGNodeMarkDirty(node);

    const UIView *view = self.rootYogaView;
    if (!view) {
        return;
    }

    if (view._yoga_isAutoLayoutEnabled) {
        view._yoga_maxLayoutWidth = YGUndefined;
        [view invalidateIntrinsicContentSize];
#if !TARGET_OS_OSX
        [view.superview layoutIfNeeded];
#endif
    }
}

- (NSUInteger)numberOfChildren {
    return YGNodeGetChildCount(self.node);
}

- (BOOL)isLeaf {
    NSAssert([NSThread isMainThread], @"This method must be called on the main thread.");

    if (self.isIncludedInLayout) {
        for (UIView* subview in self.view.subviews) {
            if (!subview.isYogaEnabled) {
                continue;
            }
            
            YGLayout* const yoga = subview.yoga;
            if (yoga.isIncludedInLayout) {
                return NO;
            }
        }
    }

    return YES;
}

#pragma mark - Layout and Sizing

- (YGDirection)resolvedDirection {
    return YGNodeLayoutGetDirection(self.node);
}

- (void)applyLayout {
    [self applyLayoutPreservingOrigin:NO dimensionFlexibility:0];
}

- (void)applyLayoutPreservingOrigin:(BOOL)preserveOrigin {
    [self applyLayoutPreservingOrigin:preserveOrigin dimensionFlexibility:0];
}

- (void)applyLayoutPreservingOrigin:(BOOL)preserveOrigin
               dimensionFlexibility:
(YGDimensionFlexibility)dimensionFlexibility {
    if (self.isApplingLayout || !self.isIncludedInLayout) {
        return;
    }

    CGSize size = self.view.bounds.size;

    if (dimensionFlexibility & YGDimensionFlexibilityFlexibleWidth) {
        size.width = YGUndefined;
    }

    if (dimensionFlexibility & YGDimensionFlexibilityFlexibleHeight) {
        size.height = YGUndefined;
    }

    (void)[self calculateLayoutWithSize:size];
    YGApplyLayoutToViewHierarchy(self.view, preserveOrigin);
}

- (CGSize)intrinsicSize {
    const CGSize constrainedSize = { .width = YGUndefined, .height = YGUndefined };

    return [self calculateLayoutWithSize:constrainedSize];
}

- (CGSize)calculateLayoutWithSize:(CGSize)size {
    NSAssert([NSThread isMainThread], @"Yoga calculation must be done on main.");
    NSAssert(self.isIncludedInLayout, @"Yoga is not enabled for this view.");

    YGAttachNodesFromViewHierachy(self.view);

    const YGNodeRef node = self.node;
    YGNodeCalculateLayout(node, size.width, size.height, YGNodeStyleGetDirection(node));

    return (CGSize){
        .width = YGFloatNonNegative((CGFloat)YGNodeLayoutGetWidth(node)),
        .height = YGFloatNonNegative((CGFloat)YGNodeLayoutGetHeight(node))
    };
}

- (void)configureLayoutWithBlock:(NS_NOESCAPE YGLayoutConfigurationBlock)block {
    if (block) {
        block(self);
    }
}

#pragma mark - Private

static YGSize YGMeasureView(YGNodeRef node, double width, YGMeasureMode widthMode, double height, YGMeasureMode heightMode) {
    const CGFloat constrainedWidth = (widthMode == YGMeasureModeUndefined) ? CGFLOAT_MAX : width;
    const CGFloat constrainedHeight = (heightMode == YGMeasureModeUndefined) ? CGFLOAT_MAX : height;

    UIView* view = (__bridge UIView*)YGNodeGetContext(node);

    // The default implementation of sizeThatFits: returns the existing size of
    // the view. That means that if we want to layout a member of UIView or UIControl, which
    // already has got a frame set, its measured size should be CGSizeZero, but
    // UIKit returns the existing size.
    //
    // See https://github.com/facebook/yoga/issues/606 for more information.

    YGLayout *yoga = view.yoga;
    if (yoga.isBaseView) {
        return (YGSize){ .width = 0, .height = 0 };
    }

    CGSize sizeThatFits = CGSizeZero;

#if TARGET_OS_OSX
    view._yoga_isFittingSize = YES;
    CGSize fittingSize = view.fittingSize;
    view._yoga_isFittingSize = NO;
    sizeThatFits = (CGSize){
        .width = fmin(constrainedWidth, fittingSize.width),
        .height = fmin(constrainedHeight, fittingSize.height)
    };
#else
    sizeThatFits = [view sizeThatFits:(CGSize){
        .width = constrainedWidth,
        .height = constrainedHeight
    }];
#endif
    CGSize size = (CGSize){
        .width = YGSanitizeMeasurement(
                                       constrainedWidth, sizeThatFits.width, widthMode),
        .height = YGSanitizeMeasurement(
                                        constrainedHeight, sizeThatFits.height, heightMode),
    };

        // Use original implementation when transform is not used on view
    if (CGAffineTransformEqualToTransform(CGAffineTransformIdentity, view.transform)) {
        return (YGSize){
            .width = size.width,
            .height = size.height,
        };
    }
        // Using abs() to normalize size after applying transform
    CGSize transformed = CGSizeApplyAffineTransform(size, view.transform);

    return (YGSize){
        .width = abs(transformed.width),
        .height = abs(transformed.height),
    };
}

NS_INLINE CGFloat YGSanitizeMeasurement(
                                        CGFloat constrainedSize,
                                        CGFloat measuredSize,
                                        YGMeasureMode measureMode) {
    CGFloat result;
    switch (measureMode) {
        case YGMeasureModeExactly:
            result = constrainedSize;
            break;
        case YGMeasureModeAtMost:
            result = fmin(constrainedSize, measuredSize);
            break;
        default:
            result = measuredSize;
            break;
    }

    return fmax(result, 0);
}

static BOOL YGNodeHasExactSameChildren(
                                       const YGNodeRef node,
                                       NSArray<UIView*>* subviews) {
    if (YGNodeGetChildCount(node) != subviews.count) {
        return NO;
    }

    for (int i = 0; i < subviews.count; i++) {
        if (YGNodeGetChild(node, i) != subviews[i].yoga.node) {
            return NO;
        }
    }

    return YES;
}

static void YGAttachNodesFromViewHierachy(UIView* const view) {
    YGLayout* const yoga = view.yoga;
    const YGNodeRef node = yoga.node;

    // Only leaf nodes should have a measure function
    if (yoga.isLeaf) {
        YGNodeRemoveAllChildren(node);
        YGNodeSetMeasureFunc(node, YGMeasureView);
    } else {
        YGNodeSetMeasureFunc(node, NULL);

        NSMutableArray<UIView*>* subviewsToInclude = [[NSMutableArray alloc] initWithCapacity:view.subviews.count];
        for (UIView* subview in view.subviews) {
            if (!subview.isYogaEnabled) {
                continue;
            }
            
            YGLayout *yoga = subview.yoga;
            if (yoga.isIncludedInLayout) {
                [subviewsToInclude addObject:subview];
            }
        }

        if (!YGNodeHasExactSameChildren(node, subviewsToInclude)) {
            YGNodeRemoveAllChildren(node);
            for (int i = 0; i < subviewsToInclude.count; i++) {
                YGNodeInsertChild(node, subviewsToInclude[i].yoga.node, i);
            }
        }

        for (UIView* const subview in subviewsToInclude) {
            YGAttachNodesFromViewHierachy(subview);
        }
    }
}

static void YGApplyLayoutToViewHierarchy(UIView* view, BOOL preserveOrigin) {
    NSCAssert([NSThread isMainThread], @"Framesetting should only be done on the main thread.");

    const YGLayout* yoga = view.yoga;
    if (yoga.isApplingLayout || !yoga.isIncludedInLayout) {
        return;
    }

    yoga.isApplingLayout = YES;

    // layout leaf node first
    if (!yoga.isLeaf) {
        for (UIView *subview in view.subviews) {
            if (!subview.isYogaEnabled) {
                continue;
            }

            YGLayout *yoga = subview.yoga;
            if (yoga.isIncludedInLayout) {
                YGApplyLayoutToViewHierarchy(subview, NO);
            }
        }
    }

    YGNodeRef node = yoga.node;
    CGFloat left = YGFloatValidate((CGFloat)YGNodeLayoutGetLeft(node));
    CGFloat top = YGFloatValidate((CGFloat)YGNodeLayoutGetTop(node));

    const CGPoint topLeft = (CGPoint) { .x = left, .y = top };

    CGFloat width = YGFloatNonNegative((CGFloat)YGNodeLayoutGetWidth(node));
    CGFloat height = YGFloatNonNegative((CGFloat)YGNodeLayoutGetHeight(node));

    const CGSize size = {
        .width = width,
        .height = height
    };

#if TARGET_OS_OSX
    const CGPoint origin = preserveOrigin ? view.frame.origin : CGPointZero;
#else
    BOOL transformIsIdentity = CGAffineTransformIsIdentity(view.transform);
    // use bounds/center and not frame if non-identity transform.
    const CGPoint origin = preserveOrigin ? (transformIsIdentity ? view.frame.origin : (CGPoint) {
        .x = (CGFloat)(view.center.x - CGRectGetWidth(view.bounds) * 0.5),
        .y = (CGFloat)(view.center.y - CGRectGetHeight(view.bounds) * 0.5)
    })
    : CGPointZero;
#endif

    CGRect frame = (CGRect) {
        .origin = (CGPoint) { .x = topLeft.x + origin.x, .y = topLeft.y + origin.y },
        .size = size
    };

#if TARGET_OS_OSX
    UIView *superview = view.superview;
    if (superview && !superview.isFlipped && superview.isYogaEnabled) {
        YGLayout *yoga = superview.yoga;
        if (yoga.isIncludedInLayout) {
            CGFloat height = YGFloatNonNegative((CGFloat)YGNodeLayoutGetHeight(yoga.node));
            frame.origin.y = height - CGRectGetMaxY(frame);
        }
    }

    view.frame = frame;
#else
    if (transformIsIdentity) {
        view.frame = frame;
    } else {
        CGRect bounds = view.bounds;
        bounds.size = size;
        view.bounds = bounds;

        view.center = (CGPoint) { .x = CGRectGetMidX(frame), .y = CGRectGetMidY(frame) };
    }
#endif

    yoga.isApplingLayout = NO;
}

@end
