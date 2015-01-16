EasyNews
========

网易新闻无广告山寨版本😄



##编程规范
- 使用storyboard（简称sb）来调整自动布局.
- 头文件能不import就不要import文件，节省编译时间.
- 命名要规范，全局变量前面加上下划线。
- push之前尽量去掉或者注释掉输出，多注意，方便debug.
- 协议用"#pragma mark - protocol"来标记.
- 头文件要有一定量的注释.
- 不使用prefix header 文件,节省编译时间.
- 图片使用Images.xcassets.
- View千万不要处理业务逻辑.否则别怪我驳回代码.
- 能用OperationQueue的地方不要用GCD.
- 常量不要用宏定义指定，用静态变量声明.
- 用分析去查看内存用错的地方.
- 用Profile测试程序的性能.


##MVC
###View的做法
View的功能就是展示UI，不储存任何数据，不参与任何业务逻辑
View的数据来源是Datasource，交互事件是Delegate

###Controller
程序的中心，对Model和V有绝对的控制权，业务的核心。

###Model
Model要求不高，用原生数据类型或者jsonModel生成的都可以。
通常情况下Controller去修改model，修改完后该刷新UI刷新UI。


###总结
 - Controller对Model和View的绝对控制权。
 - Model通过Notification来通知Controller数据发生了变化。
 - View通过Datasource或者Delegate来告知Controller自己发生了变化/是否需要发生变化。
 - Model和View不直接通信，没有任何关系。
 - Controller之间可以互相帮忙，大量的Controller结合起来就形成了一个完整的程序