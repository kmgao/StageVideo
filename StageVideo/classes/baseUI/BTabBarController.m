
#import "BTabBarController.h"

@interface BTabBarController ()

@end

@implementation BTabBarController
@synthesize tabBarBgArray;

- (void)dealloc
{
    self.tabBarBgArray = nil;
}

- (id)initViewUI
{
    if(self = [super init])
    {
        [self customView];

    }
    return self;
}

- (void)customView
{
    NSArray *infoArray = [NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"tabbar_sms.png",@"normal",
                           @"tabbar_sms_sel.png",@"selected",
                           NSLocalizedString(@"key_tabBar_SMS",@"短信"),@"title",nil],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"tabbar_recent.png",@"normal",
                           @"tabbar_recent_sel.png",@"selected",
                           NSLocalizedString(@"key_tabBar_recentCall",@"最近通话"),@"title",nil],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"tabbar_contacts.png",@"normal",
                           @"tabbar_contacts_sel.png",@"selected",
                           NSLocalizedString(@"key_tabBar_contact",@"通讯录"),@"title",nil],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"tabbar_keyboard.png",@"normal",
                           @"tabbar_keyboard_sel.png",@"selected",
                           NSLocalizedString(@"key_tabBar_board",@"键盘拨号"),@"title",nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"tabbar_more.png",@"normal",
                           @"tabbar_more_sel.png",@"selected",
                           NSLocalizedString(@"key_tabBar_setMore",@"更多"),@"title",nil],
                          nil];
    
    CGRect frame = self.tabBar.frame;
    int count = [infoArray count];
    CGFloat width = frame.size.width/count;
    CGFloat height = frame.size.height;
    
    self.tabBarBgArray = [[NSMutableArray alloc] initWithCapacity:count];
    for(NSDictionary *dic in infoArray)
    {
        NSString *normalImgName = [dic objectForKey:@"normal"];
        NSString *selectedImgName = [dic objectForKey:@"selected"];
        NSString *title = [dic objectForKey:@"title"];
        NSLog(@"normalImageName = %@, selectedImageName = %@, title = %@",normalImgName,selectedImgName,title);
        NSInteger index = [infoArray indexOfObject:dic];
        CGRect rect = CGRectMake(index*width, -1, width, height);
        TabBarBg *tabBarBg = [[TabBarBg alloc] initWithFrame:rect normalImageName:normalImgName selectedImageName:selectedImgName title:title];
        [self.tabBar addSubview:tabBarBg];
        [self.tabBarBgArray addObject:tabBarBg];
    }
    self.tabBar.backgroundImage = [[UIImage imageNamed:@"tabbar_background.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
}

- (void)checkIndexPath:(NSInteger)index
{
    for(TabBarBg *tabBarBg in tabBarBgArray)
    {
        NSInteger thisIndex = [tabBarBgArray indexOfObject:tabBarBg];
        if(thisIndex == index)
        {
            tabBarBg.selected = YES;
        }else {
            tabBarBg.selected = NO;
        }
    }
}

-(BOOL)shouldAutorotate
{
    return NO;
}
@end

@implementation TabBarBg
@synthesize selected;

- (TabBarBg*)initWithFrame:(CGRect)frame normalImageName:(NSString*)normalImgName selectedImageName:(NSString*)selectedImgName title:(NSString*)title
{
    if(self = [super initWithFrame:frame])
    {
//        CGRect bgRect = frame;
//        bgRect.origin = CGPointZero;
//        _backgroundView.contentMode = UIViewContentModeScaleAspectFit;
//        _backgroundView = [[UIImageView alloc] initWithFrame:bgRect];
//        _backgroundView.image = nil;
//        _backgroundView.highlightedImage = [UIImage imageNamed:@"tabbar_background.png"];
//        [self addSubview:_backgroundView];
        
        UIImage  *_normalImage = [UIImage imageNamed:normalImgName];
        UIImage  * _selectedImage = [UIImage imageNamed:selectedImgName];
        CGSize size = _normalImage.size;
        
        CGFloat gap = 1.0;
        CGFloat yOffset = gap;
        CGRect imgViewRect = CGRectMake((frame.size.width-size.width)*0.5, yOffset, size.width, size.height);
        _imageView = [[UIImageView alloc] initWithFrame:imgViewRect];
        _imageView.image = _normalImage;
        _imageView.highlightedImage = _selectedImage;
        [self addSubview:_imageView];
        
        UIFont *font = [UIFont boldSystemFontOfSize:11.0];
        CGSize titleSize = [title sizeWithFont:font];
        CGRect rect = CGRectMake(gap, frame.size.height - titleSize.height - 1.0, frame.size.width-gap*2, titleSize.height);
        _titleLabel = [[UILabel alloc] initWithFrame:rect];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kDefaultGrayColor;
        _titleLabel.text = title;
        _titleLabel.font = font;
        [self addSubview:_titleLabel];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)s
{
    _selected = s;
    
    if(_selected)
    {
//         _backgroundView.highlighted = YES;
        _imageView.highlighted = YES;
        _titleLabel.textColor = kDefaultBlueColor;
    }else {
//        _backgroundView.highlighted = NO;
        _imageView.highlighted = NO;
        _titleLabel.textColor = kDefaultGrayColor;
    }
}

- (BOOL)selected
{
    return _selected;
}

- (void)dealloc
{
   
}
@end
