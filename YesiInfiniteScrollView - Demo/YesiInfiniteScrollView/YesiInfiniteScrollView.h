//
//  YesiInfiniteScrollView.h
//  YesiInfiniteScrollView - Demo
//
//  Created by 黄丽萍 on 16/3/21.
//  Copyright © 2016年 黄丽萍. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface YesiInfiniteScrollView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<DataModel *> *dataModelArray;

@end
