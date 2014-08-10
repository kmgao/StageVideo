
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"

/**
 MJ友情提示：
 1. 添加头部控件的方法
 MJRefreshHeaderView *header = [MJRefreshHeaderView header];
 header.scrollView = self.collectionView; // 或者tableView
 
 2. 添加尾部控件的方法
 MJRefreshFooterView *footer = [MJRefreshFooterView footer];
 footer.scrollView = self.collectionView; // 或者tableView
 
 3. 监听刷新控件的状态有2种方式：
 * 设置delegate，通过代理方法监听(参考MJCollectionViewController.m)
 * 设置block，通过block回调监听(参考MJTableViewController.m)
 
 4. 可以在MJRefreshConst.h和MJRefreshConst.m文件中自定义显示的文字内容和文字颜色
 
 5. 本框架兼容iOS6\iOS7，iPhone\iPad横竖屏
 
 6.为了保证内部不泄露，最好在控制器的dealloc中释放占用的内存
    - (void)dealloc
    {
        [_header free];
        [_footer free];
    }
 
 7.自动刷新：调用beginRefreshing可以自动进入下拉刷新状态
 
 8.结束刷新
 1> endRefreshing
*/

//使用方法：

/*******************************************************
 
 
 
 //添加下拉刷新
 _header = [[MJRefreshHeaderView alloc] init];
 _header.delegate = self;
 _header.scrollView = self.tableView;
 
 //添加上拉加载更多
 _footer = [[MJRefreshFooterView alloc] init];
 _footer.delegate = self;
 _footer.scrollView = self.tableView;
 
 在代理行数实现刷新功能：
 #pragma mark 代理方法-进入刷新状态就会调用
 - (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
 {
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     formatter.dateFormat = @"HH : mm : ss.SSS";
     if (_header == refreshView) {
        for (int i = 0; i<5; i++) {
             [_data insertObject:[formatter stringFromDate:[NSDate date]] atIndex:0];
        }
    } 
    else 
    {
         for (int i = 0; i<5; i++) {
            [_data addObject:[formatter stringFromDate:[NSDate date]]];
          }
     }
     [NSTimer scheduledTimerWithTimeInterval:1 target:self.tableView selector:@selector(reloadData) userInfo:nil repeats:NO];
 }
 
 
 ********************************************************/


