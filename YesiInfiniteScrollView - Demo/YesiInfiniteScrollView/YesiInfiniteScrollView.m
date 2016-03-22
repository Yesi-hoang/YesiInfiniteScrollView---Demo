//
//  YesiInfiniteScrollView.m
//  YesiInfiniteScrollView - Demo
//
//  Created by 黄丽萍 on 16/3/21.
//  Copyright © 2016年 黄丽萍. All rights reserved.
//

#import "YesiInfiniteScrollView.h"
#import "YesiInfiniteScrollCell.h"

static NSString  * YesiInfiniteScrollCellID = @"YesiInfiniteScrollCell";
/**
 *  enlargement multiple
 */
static NSInteger Times = 50;
@interface YesiInfiniteScrollView()
{
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_flowLayout;
    UIPageControl *_pageControl;
    
    NSTimer *_timer;
}
@end
@implementation YesiInfiniteScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        // 1. Create collectionView layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.frame.size;
        // Group space
        layout.minimumLineSpacing = 0;
        // Cell space
        layout.minimumInteritemSpacing = 0;
        // Scroll direction
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout = layout;
        
        // 2. Create a collectionView
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:collectionView];
        _collectionView = collectionView;
        
        // 3. Register cell(xib use registerNib otherwise registerClass)
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YesiInfiniteScrollCell class]) bundle:nil] forCellWithReuseIdentifier:YesiInfiniteScrollCellID];
        
        // 4. Create page control
        UIPageControl *page = [[UIPageControl alloc]init];
        // Current pageControl Color
        page.currentPageIndicatorTintColor = [UIColor whiteColor];
        // Common pageControl color
        page.pageIndicatorTintColor = [UIColor lightGrayColor];
        
        [self addSubview:page];
        
        _pageControl = page;
        
         }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1. Resize frame of collectionView and itemSize
    _collectionView.frame = self.bounds;
    _flowLayout.itemSize = self.bounds.size;
    
    // 1.1 Adjust position of pageControl
    _pageControl.center = CGPointMake(self.center.x, self.frame.size.height - 15);
    
    // 2. Scroll collectionView to the middle position
    NSInteger middleIndex = (self.dataModelArray.count * Times)/2;
    
    if (_collectionView.contentOffset.x == 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:middleIndex inSection:0];
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

/**
 *   Append data
 */
- (void)setDataModelArray:(NSArray<DataModel *> *)dataModelArray{
    _dataModelArray = dataModelArray;
    // Restart timer
    [self startTimer];
    // Set pageControl total count
    _pageControl.numberOfPages = self.dataModelArray.count;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.dataModelArray.count * Times;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YesiInfiniteScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YesiInfiniteScrollCellID forIndexPath:indexPath];
    
    cell.dataModel = self.dataModelArray[indexPath.item];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // collectionView current index
    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
    
    NSInteger currentImage = index % self.dataModelArray.count;
    
    _pageControl.currentPage = currentImage;
    
}
// Called when user are dragging
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // Stop timer
    [_timer invalidate];
    _timer = nil;
}
// Called when user stop dragging
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // Restart timer
    [self startTimer];
}

- (void)startTimer{
    [_timer invalidate];
    _timer = nil;
    
    // Create a timer
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(startAutoScroll) userInfo:nil repeats:YES];
    // Add timer to NSRunLoop
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    _timer = timer;
    
}

// Timer method
- (void)startAutoScroll
{
    /**
     1. Get current item
     2. Scroll to the next
     */
    CGFloat currentindex = _collectionView.contentOffset.x/_collectionView.bounds.size.width;
    
    currentindex++;
    
    if (currentindex == self.dataModelArray.count * Times) {
        // Back to page 0
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:currentindex inSection:0];
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

@end
