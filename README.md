# Ui遍历使用文档

---
AppCrawle是自动遍历的app爬虫工具，最大的特点是灵活性，实现：对整个APP的所有可点击元素进行遍历点击。

---

###### 优点：
1. 支持android和iOS, 支持真机和模拟器
2. 可通过配置来设定遍历的规则（比如设置黑名单和白名单，提高遍历的覆盖率）
3. 其本身的遍历深度覆盖较全，比如它拥有APP的dom树，根据每个activity下的可点击元素逐个点击，比monkey更具有规律性，覆盖更全面
4. 生成的报告附带截图，可以精确看到点击了哪个元素及结果，对crash类的问题定位清晰

###### 缺点：
1. 只能定位一页，对于翻页的无法进行下滑再点击，导致下面的内容无法遍历（需要自己设置下滑然后翻页）
2. 对于调用第三方应用的不太稳定，比如每次到上传头像处就停止遍历
3. 对于 整个layout区域是可点击，但是其中某个元素是不可点击的，没有进行遍历点击，比如：左上角的设置和右上角的私信都不能遍历到
4. 对于H5页面无法进行精确的定位点击


---

#### 一.环境搭建：
1. appcrawler的最新jar包（最新的功能多，兼容性比较高），我用的是 appcrawler-2.1.0.jar ，
下载地址如下：百度网盘:https://pan.baidu.com/s/1bpmR3eJ
2. appium ,用来开启session服务并定位元素的，也可以使用 appium GUI（桌面版），但是我使用跑了一半就崩溃了，内存不足，所以推荐使用命令行版本的
3. 下载方式：
- 在命令行下执行npm --registry http://registry.cnpmjs.org install -g appium (推荐这种,npm的国内镜像)
- 检查appium所需的环境是否OK(这步很重要)：进入Cmd命令行，输入appium-doctor 显示正常则成功
4. Android SDK,主要是为了使用tools文件夹下的 uiautomatorviewer.bat 来定位元素，获取元素的xpath,用于准备工作前期。

---

#### 二.执行步骤：
1. 手机安装好最新的安装包，不需要登陆（避免不能遍历登陆前的页面内容，且登录后再进行遍历会出现activity不一致的报错，即和launchActivity不一致）
1. 开启appium服务在命令行中输入： appium ，提示：则开启成功
1. 在放 appcrawler-2.4.jar 的文件夹下执行以下命令：

- java -jar appcrawler-2.4.0.jar -c MyConfig.yml


---

#### 三. 配置文件
参数说明：
Java -jar appcrawler-2.1.0.jar 用来启动appcrawler
-a 后面跟安装包的名字 （用于自己手机没有安装包的时候的使用）
-c 后面跟自定义的配置文件的路径和名字
-output 后面跟输出的报告所在的文件夹，如果没有写，则会自动生成一个以时间为文件夹名字的报告文件
 
其实这里的重点就是如何来写配置文件：
配置文件基本都是以key-value格式，所以可以用文本编辑器，然后改名为 .yml或者.json文件即可。
先上一下我的配置文件 config.yml:

```
# 插件列表
pluginList: [
  "com.testerhome.appcrawler.plugin.LogPlugin",
  "com.testerhome.appcrawler.plugin.TagLimitPlugin"
]
# 是否截图
saveScreen: true
reportTitle: "课堂页-UI遍历测试报告"
# 结果目录
resultDir: "/Users/liumingwei/Crawler"
# 在执行操作后等待多少毫秒刷新
waitLoading: 500
waitLaunch: 6000
# 结果报告是否展示没有遍历被取消的控件
showCancel: true
# 最大运行时间
maxTime: 10800
# 默认的最大深度10, 结合baseUrl可很好的控制遍历的范围
maxDepth: 10

# appium的capability通用配置
capability:
  # Appium是否需要自动安装和启动应用。默认值true
  autoLaunch: "true"
  # 直接转换到 WebView 上下文。 默认值 false
  autoWebview: "false"
  # 不要在会话前重置应用状态。默认值false。
  noReset: "true"
  fullReset: "false"
  appium: "http://0.0.0.0:4723/wd/hub"
  deviceName: "ce071717d999471e057e"
  appPackage: "com.xes.jazhanghui.activity"
  appActivity: ".mvp.start.StartActivity"
  # dontStopAppOnReset: true
  automationName: "uiautomator2"
  platformName: "Android"
  #以下为重置手机输入法为 appium 输入法
  unicodeKeyboard: true
  resetKeyboard: true

# 默认遍历列表，如果不是指定的类型，而是确定控件，会分别点击控件
selectedList:
  - xpath: "//*[@clickable='true']"
  - xpath: "//android.widget.TextView[@text='课堂']"
    action: "click"

# 优先被遍历
firstList:
  - xpath: "//android.widget.TextView[@text='课堂']"
    action: "click"

# 最后遍历的元素
lastList:
  - action: driver.swipe(0.5, 0.8, 0.5, 0.2)
    times: 3

# url黑名单，用户排除某些页面
urlBlackList:
  - "//android.widget.TextView[@text='发现']"

# 排除某些控件，黑名单列表 匹配风格, 默认排除内容是2个数字以上的控件
blackList:
  - xpath: "//*[contains(@resource-id,'Custom_InfoWindow_Navigate')]"
    action: null
    actions: []
    times: 0
  - xpath: "//*[contains(@text,'我的')]"
    action: null
    actions: []
    times: 0
  - xpath: "//*[contains(@text,'选课')]"
    action: null
    actions: []
    times: 0

  # 屏蔽报错控件
  - xpath: "//*[contains(@class,'android.support.v7.app.ActionBar$Tab')]"
    action: null
    actions: []
    times: 0

  # ------------ 防止跳出课堂页面 -----------
  - xpath: "//*[contains(@resource-id,'id/bottomBar')]"
    action: null
    actions: []
    times: 0
  - xpath: "//*[contains(@resource-id,'id/img_bottom_bar')]"
    action: null
    actions: []
    times: 0
  - xpath: "//android.widget.TextView[@text='发现']"
    action: null
    actions: []
    times: 0
  # ------------ 防止跳出课堂页面 -----------

#  制定规则（action、xpath、times）
triggerActions:
  # 去开启
  - action: "click"
    xpath: "//android.widget.TextView[@text='去开启']"
    times: 0

  # 权限允许
  - action: "click"
    xpath: "//*[contains(@resource-id,'permission_allow_button')]"
    times: 0

  # 系统个性化 确定
  - action: "click"
    xpath: "//*[contains(@resource-id,'button1')]"
    times: 0

  # 协议 同意
  - action: "click"
    xpath: "//android.widget.TextView[@text='同意']"
    times: 0

  # 升级弹框 关闭
  - action: "click"
    xpath: "//*[contains(@resource-id,'version_update_close_img')]"
    times: 3

  # 相机&相册 取消
  - action: "click"
    xpath: "//*[contains(@resource-id,'MapThirdMaps_Cancel')]"
    times: 3

  # 登录流程
  - action: "click"
    xpath: "//android.widget.TextView[@text='密码登录']"
    times: 1
  - action: "15011162592"
    xpath: "//*[contains(@resource-id,'xes_login_username')]"
    times: 1
  - action: "123456Qaz"
    xpath: "//*[contains(@resource-id,'xes_login_password')]"
    times: 1
  - action: "click"
    xpath: "//*[contains(@resource-id,'xes_login_button')]"
    times: 1

  # 关闭趣味电台
  - action: "click"
    xpath: "//*[contains(@resource-id,'iv_player_close')]"
    times: 0

  # 关闭任务答题弹款
  - action: "click"
    xpath: "//*[contains(@resource-id,'iv_dialog_icon_center_close')]"
    times: 0
    
```

---


#### 四、参数说明

```
配置文件使用：true和false是开启和关闭的意思
  logLevel：日志级别
  saveScreen：是否截图
  reportTitle：报告名字
  screenshotTimeout：屏幕超时时间
  currentDriver：当前设备（Android/iOS）
  resultDir：结果文件夹名，给定后，将不动态命名
  tagLimitMax：ios的元素tag控制
  tagLimit：给tag
  maxTime：最大运行时间
  showCancel：应该是控制是否展示注释
  capability：用于配置appium
  androidCapability：Android专属配置，最后会和capability合并
  iosCapability：iOS专属配置
  urlWhiteList/blackList：白名单/黑名单
  xpathAttributes：用来设定可以用那些种类型去定位控件
  defineUrl：用来确定url的元素定位xpath 他的text会被取出当作url因素（没理解）
  baseUrl：设置一个起始url和maxDepth, 用来在遍历时候指定初始状态和遍历深度
  maxDepth：默认的最大深度10, 结合baseUrl可很好的控制遍历的范围
  appWhiteList：app白名单，如果跳转到其他app，需要设定规则，是否允许停留在次app中
  headFirst：是否是前向遍历或者后向遍历
  enterWebView：是否遍历WebView控件
  urlBlackList：url黑名单.用于排除某些页面
  urlWhiteList：url白名单, 第一次进入了白名单的范围, 就始终在白名单中. 不然就算不在白名单中也得遍历.
                上层是白名单, 当前不是白名单才需要返回
  defaultBackAction：默认的返回动作（没看到例子，貌似不特指的话，是click）
  backButton：给一些返回控件，用于返回动作使用
  firstList：优先遍历元素
  selectedList：默认遍历列表，如果不是指定的类型，而是确定控件，会分别点击控件
  lastList：最后遍历的元素
  blackList：排除某些控件
  triggerActions：制定规则（action、xpath、times）
  autoCrawl：自动抓取，看源码指定true后运行crawl(conf.maxDepth)命令
             （crawl——清空堆栈 开始重新计数）应该是appcrawler的主要方法
  asserts：断言，用于是否失败的判断
  testcase：测试用例，看appcrawler日志，每次都是首先运行用例才会往下执行
  beforeElementAction：貌似没什么人用，字面意思在元素动作之前
  afterElementAction：与beforeElementAction的待遇差不多
  afterUrlFinished：也是很冷门的待遇
  monkeyEvents：monkey的点击数
  monkeyRunTimeSeconds：monkey运行时间
  given是条件 或输入  when是触发条件和动作 then是断言
  
  
```
- 一次ctrl+c生成报告，两次ctrl+c是强行退出
- 终端输入Scala进入Scala解释器，输入:q或:quit退出解释器
- 遍历的深度应该怎么设置好，总是跳到其它页面，就回不到当前页面继续遍历了,看文档 通过黑白名单 
- 设置一个起始url和maxDepth,用来在遍历时候指定初始状态和遍历深度

---

#### 五、遍历控制
配置选项的作用可参考项目目录下的yaml格式的配置文件, 里面有详细的注释解释每个配置项的作用.

- 唯一性
appcrawler试图用接口测试的理念来定义app遍历测试. 每个app界面认为是一个url.
默认是用当前的activity名字或者navigatorbar来表示. 这个可以通过defineUrl配置实现自定义.

控件的唯一性通过配置项的xpathAttributes来定义. 默认是通过基本属性iOS的为name label value path, Androd的为resource-id content-desc text index这几个属性来唯一定义一个元素. 可以通过修改这个配置项实现自定义.

url的定义是一门艺术, 可以决定如何优雅快速有效的遍历
- 遍历行为控制
整体的配置项应用顺序为
1.capability
androidCapability和iosCapability分别用来存放不同的平台的设置. 最后会和capability合并为一个.
2.startupActions
用于启动时候自定义一些划屏或者刷新的动作.
3.selectedList
适用于在一些列表页或者tab页中精确的控制点击顺序  
selectedList表示要遍历的元素特征  
firstList表示优先遍历元素特征  
lastList表示最后应该遍历的元素特征  
tagLimit定义特定类型的控件遍历的最大次数. 比如列表项只需要遍历少数  
**需要注意的是firstList和lastList指定的元素必须包含在selectedList中**

- 元素定位方法
appcrawler大量的使用XPath来表示元素的范围. 大部分的选项都可以通过XPath来指定范围. 比如黑白名单, 遍历顺序等
- 元素操纵方法
在一些配置的action字段里面, 除了支持简单的dsl方法列表外, 也支持scala语句. 这意味着你可以完全定义自己的流程.
比如action可以定义为click back等方法. 也可以定位为driver.findElementBy...方法. 甚至是Thread.sleep(3000)等编程语句.

---
#### 六、遇到的问题有哪些？如何解决

```

```

