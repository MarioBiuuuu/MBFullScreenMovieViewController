# MBFullScreenMovieViewController
App launch video player.
#MBFullScreenMovieViewController

    MBFullScreenMovieViewController 主要功能是启动APP播放视频, 以及倒计时显示图片.

1. 使用方式: 

    1).导入头文件 
    `#import "MBFullScreenMovieViewController.h"`
    `#import "MBImageObject.h"`
    2).初始化视图控制器
    `mbLaunghViewController = [[MBFullScreenLaunghViewController alloc] initWithLaunghStyle:MBFullScreenLaunghStyleImage];`
    3).设置对应的`videUrl` or `imageObject`
    4).设置正式的根视图控制器 `appRootViewController`
    5).设置为根视图控制器

2. 常用属性:
    * loopCount 视频轮播次数(默认为0, 无限循环)
    * videoUrl 视频路径(NSUrl)
    * enterBtnTitleFont 默认进入按钮的字体
    * enterBtnTintColor 默认进入按钮的TintColor
    * transmitAnimation 是否开启过渡动画(默认开启)
    * appRootViewController 正式根视图控制器
    * imageObject 图片模型对象
    * countDownTime 图片展示时间（倒计时）  
    
    **MBImageObject 常用属性：**
    	* localImage 本地图片UIImage对象
    	* localImagePath 本地图片资源路径（Bundle）
    	* imageUrl 网络图片路径
    	* ~~*localGifData gif本地资源*~~
    	* ~~*gifUrl gif网络资源*~~
    
3. 视频回调操作:
	
    * 遵循delegate, 实现对应的方法:
        播放视频结束回调
        `- (void)mb_movieViewController:(MBFullScreenMovieViewController *)viewController playComplate:(NSTimeInterval)totalInterval;`  
        点击默认的进入按钮
        `- (void)mb_movieViewController:(MBFullScreenMovieViewController *)viewController enterBtnClick:(UIButton *)enterBtn;`
    * 通过block回调 
        
        `- (void)mb_moviePlayComplate:(mb_moviePlayComplateBlock)block;`
    *    
        `- (void)mb_moviePlayEnterBtnClick:(mb_moviePlayEnterBtnClickBlock)block;`
        
4. 图片回调操作
     * 遵循delegate，实现对应的方法：
	 		倒计时结束
		   `- (void)mb_fullScreenLaunghViewController:(MBFullScreenLaunghViewController *)viewController imageLaunghComplate:(MBImagesLaunghViewController *)imageLaunghViewController;`
		   倒计时
			 `- (void)mb_fullScreenLaunghViewController:(MBFullScreenLaunghViewController *)viewController imageLaunghCountDown:(MBImagesLaunghViewController *)imageLaunghViewController currentTime:(NSUInteger)currentTime;` 
			 
	 * 通过block回调 
			`- (void)mb_imageLaunghCountDown:(mb_imageLaunghCountDownBlock)block;` 
4. 注意事项:
    如果大了全局断点调试, 会出现Exception, 松开断点继续跑就可以了, 并不是崩溃.
    **all exceptions就表明,所有exceptions都会被catch, 即使这个exception在代码里已经处理了的, 也会被catch, 高亮. 如果是因为C++导致的, 你可以右键点击all exceptions编辑将exception->all改为objective-c.** 
 
5. 使用：
	* 图片
	 
	```
	self.mb = [[MBFullScreenLaunghViewController alloc] initWithLaunghStyle:MBFullScreenLaunghStyleImage];
	    
	MBImageObject *obj = [[MBImageObject alloc] init];
	obj.localImage = [UIImage imageNamed:@"1111.jpeg"];
	// obj.localImagePath = [[NSBundle mainBundle] pathForResource:@"1111.jpeg" ofType:nil];
	// obj.imageUrl = [NSURL URLWithString:@"http://imgsrc.baidu.com/forum/w%3D580/sign=e285eb946259252da3171d0c049a032c/3d998801a18b87d61c03a291050828381e30fd04.jpg"];
	self.mb.imageObject = obj;
	self.mb.countDownTime = 10;    
	UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	self.mb.appRootViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
	self.window.rootViewController = self.mb;
	```  
	* 视频  
	    
	```
	self.mb = [[MBFullScreenLaunghViewController alloc] initWithLaunghStyle:MBFullScreenLaunghStyleMovie];
	self.mb.delegate = self;
	    
	[self.mb mb_moviePlayComplate:^(MBMoviePlayerViewController *playerViewController, NSTimeInterval totalInterval) {
		NSLog(@"block ---> complaet : %@", @(totalInterval));
	 }];
	    
	[self.mb mb_moviePlayEnterBtnClick:^(UIButton *enterBtn) {
		NSLog(@"block ---> enter : %@", enterBtn);
	}];
	self.mb.loopCount = 2;
	self.mb.videoUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video.mp4"ofType:nil]];  
	
	UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	self.mb.appRootViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainViewController"];  
	
	self.window.rootViewController = self.mb;
	```
	* Gif
	使用方式同图片, 需设置对应的gif路径:

    ```
    self.mb = [[MBFullScreenLaunghViewController alloc] initWithLaunghStyle:MBFullScreenLaunghStyleGif];
    obj.gifUrl = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1488169434327&di=d2e31e662ac562585d602302ee26f3f4&imgtype=0&src=http%3A%2F%2Fwww.365take.com%2Fupload%2Fimg%2F99CI1ocbw4Ww3hfPpivZNpvyLoIHtOcG-y00VX4CEVZFSZW9biQqZFeSOJrB9CT%2FNfWXCgWSnsBhW114zlJjUdp4%2FS2ZsA.jpg"];  
    
    obj.localGifUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"timg" ofType:@"gif"]];
    ```

	* 自定义视图添加  

	```
	UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	
	mb.frontViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
	```



