# MBFullScreenMovieViewController
App launch video player.
#MBFullScreenMovieViewController

    MBFullScreenMovieViewController 主要功能是启动APP播放视频.

1. 使用方式: 

    1).导入头文件 `#import "MBFullScreenMovieViewController.h"`
    2).初始化后设置视频路径 `mbMovieViewController.videoUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video.mp4"ofType:nil]];`
    3).设置为根视图控制器

2. 常用属性:
    * loopCount 视频轮播次数(默认为0, 无限循环)
    * videoUrl 视频路径(NSUrl)
    * enterBtnTitleFont 默认进入按钮的字体
    * enterBtnTintColor 默认进入按钮的TintColor
    * transmitAnimation 是否开启过渡动画(默认开启)
3. 回调操作:
    * 遵循delegate, 实现对应的方法:
        播放结束回调
        `- (void)mb_movieViewController:(MBFullScreenMovieViewController *)viewController playComplate:(NSTimeInterval)totalInterval;`  
        点击默认的进入按钮
        `- (void)mb_movieViewController:(MBFullScreenMovieViewController *)viewController enterBtnClick:(UIButton *)enterBtn;`
    * 通过block回调 
        
        `- (void)mb_moviePlayComplate:(mb_moviePlayComplateBlock)block;`
    *    
        `- (void)mb_moviePlayEnterBtnClick:(mb_moviePlayEnterBtnClickBlock)block;`
4. 注意事项:
    如果大了全局断点调试, 会出现Exception, 松开断点继续跑就可以了, 并不是崩溃.
    **all exceptions就表明,所有exceptions都会被catch, 即使这个exception在代码里已经处理了的, 也会被catch, 高亮. 如果是因为C++导致的, 你可以右键点击all exceptions编辑将exception->all改为objective-c.** 



