//
//  PickerFlowLayout.m
//  Apsiape
//
//  Created by Dario Lass on 28.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "PickerFlowLayout.h"

@interface PickerFlowLayout ()

@end

@implementation PickerFlowLayout

#define ITEM_SIZE 100
#define ACTIVE_DISTANCE 100
#define ZOOM_FACTOR 0.3

-(id)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.minimumLineSpacing = - 40;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSMutableArray* attributeArray = [NSMutableArray array];
    for (NSInteger i=0 ; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributeArray addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }

    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    return attributeArray;
}



- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    attributes.zIndex = indexPath.row*(-1);
    return attributes;
}

//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//    CGFloat offsetAdjustment = MAXFLOAT;
//    CGFloat verticalCenter = proposedContentOffset.y + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
//    
//    CGRect targetRect = CGRectMake(0.0, proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
//    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
//    
//    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
//        CGFloat itemVerticalCenter = layoutAttributes.center.y;
//        if (ABS(itemVerticalCenter - verticalCenter) < ABS(offsetAdjustment)) {
//            offsetAdjustment = itemVerticalCenter - verticalCenter;
//        }
//    }
//    return CGPointMake(proposedContentOffset.x, proposedContentOffset.y + offsetAdjustment);
//}
@end
