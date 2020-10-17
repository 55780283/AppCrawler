# XesUiCrawler

AppCrawle是自动遍历的app爬虫工具，最大的特点是灵活性，实现：对整个APP的所有可点击元素进行遍历点击。
 
优点：
1.支持android和iOS, 支持真机和模拟器
2.可通过配置来设定遍历的规则（比如设置黑名单和白名单，提高遍历的覆盖率）
3. 其本身的遍历深度覆盖较全，比如它拥有APP的dom树，根据每个activity下的可点击元素逐个点击，比monkey更具有规律性，覆盖更全面
4.生成的报告附带截图，可以精确看到点击了哪个元素及结果，对crash类的问题定位清晰
 
缺点：
1. 只能定位一页，对于翻页的无法进行下滑再点击，导致下面的内容无法遍历（需要自己设置下滑然后翻页）
2.对于调用第三方应用的不太稳定，比如每次到上传头像处就停止遍历
3.对于 整个layout区域是可点击，但是其中某个元素是不可点击的，没有进行遍历点击，比如：左上角的设置和右上角的私信都不能遍历到
4.对于H5页面无法进行精确的定位点击，比如它的整个布局layout是 一个大模块，不能进行点击 （机会页，融资速递，新品优选）


一.环境搭建：（前提是当然得有Java环境）
1.appcrawler的最新jar包（最新的功能多，兼容性比较高），我用的是 appcrawler-2.1.0.jar ，
下载地址如下：
百度网盘:  https://pan.baidu.com/s/1bpmR3eJ
2. appium ,用来开启session服务并定位元素的，也可以使用 appium GUI（桌面版），但是我使用跑了一半就崩溃了，内存不足，所以推荐使用命令行版本的
下载方式：
(1)在命令行下执行npm --registry http://registry.cnpmjs.org install -g appium (推荐这种,npm的国内镜像)
(2)检查appium所需的环境是否OK(这步很重要)：进入Cmd命令行，输入appium-doctor 显示正常则成功
3.Android SDK,主要是为了使用tools文件夹下的 uiautomatorviewer.bat 来定位元素，获取元素的xpath,用于准备工作前期。
 
二.执行步骤：
1.手机安装好最新的安装包，不需要登陆（避免不能遍历登陆前的页面内容，且登录后再进行遍历会出现activity不一致的报错，即和launchActivity不一致）
2.开启appium服务
在命令行中输入： appium ，提示： 则开启成功
3.在放 appcrawler-2.1.0.jar 的文件夹下执行以下命令：
Java -jar appcrawler-2.1.0.jar -a jingdata.apk -c config.yml --output wyy/
即可自动启动APP，并自动遍历点击元素
因为遍历的深度比较大，在覆盖比较全面的条件下，我这边测试会有496条case左右，基本要跑1个小时左右。
最后自动生成的报告如下：
技术分享
三. 如何写配置文件 config.yml （这才是运行的核心所在）
参数说明：
Java -jar appcrawler-2.1.0.jar 用来启动appcrawler
-a 后面跟安装包的名字 （用于自己手机没有安装包的时候的使用）
-c 后面跟自定义的配置文件的路径和名字
-output 后面跟输出的报告所在的文件夹，如果没有写，则会自动生成一个以时间为文件夹名字的报告文件
 
其实这里的重点就是如何来写配置文件：
配置文件基本都是以key-value格式，所以可以用文本编辑器，然后改名为 .yml或者.json文件即可。
先上一下我的配置文件 config.yml:

---
logLevel: "TRACE"
reportTitle: "Jingdata"    #指生成的HTML（index.html）报告头部显示的标题信息
saveScreen: true  
screenshotTimeout: 20
currentDriver: "android"
showCancel: true
tagLimitMax: 5
tagLimit:
- xpath: //*[../*[@selected=‘true‘]]
  count: 12
maxTime: 10800
resultDir: ""   #结果文件夹名，给定后，将不动态命名
capability:
  newCommandTimeout: 120
  launchTimeout: 120000
  platformVersion: ""
  platformName: "Android"
  autoWebview: "false"
  autoLaunch: "true"
  noReset: "true"
  androidInstallTimeout: 180000
androidCapability:
  deviceName: ""
  appPackage: "com.android36kr.investment"   
  appActivity: ""  #写不写无所谓，因为APP会自动判别当前的activity是否正确，是不是launchActivity,如果不是则会报错
  dontStopAppOnReset: true
  app: ""
  appium: "http://127.0.0.1:4723/wd/hub"
# automationName: uiautomator2
  automationName: uiautomator2
  reuse: 3 
headFirst: true
enterWebView: true
urlBlackList:
- //*[contains(@resource-id, "tv_setting_logout") and @clickable=‘true‘]   #登出
- //*[contains(@resource-id, "toolbar_close") and @clickable=‘true‘]   # 关闭按钮，否则会陷入死循环一直遍历同一个页面
- //*[contains(@resource-id, "login_36kr_forgot_pass") and @clickable=‘true‘]  # 忘记密码，避免登陆时按照遍历顺序影响登陆
- //*[contains(@resource-id, "mine_info_icon") and @clickable=‘true]  # 我的资料 头像部分设置不可点击（每次一运行到这里就结束了）
- //*[contains(@resource-id, "tv_name") and @clickable=‘true]  #头部卡片 姓名
- //*[contains(@resource-id, "tv_company_name") and @clickable=‘true]  # 头部卡片 公司和职位
- //*[contains(@resource-id, "company_avatar") and @clickable=‘true]  # 头部 禁止进入我的资料页面
- //*[contains(@resource-id, "chat_invest_card_rl") and @clickable=‘true] # 聊天页的项目头部，避免又进入详情页，跳出了循环
- //*[contains(@resource-id, "chat_send_contact_ll") and @clickable=‘true]  #聊天详情页，交换名片，避免遍历线上包时与线上用户交互
- //*[contains(@resource-id, "ll_header") and @clickable=‘true]  # 我的资料头像部分的整个头部区域，因为一点击头像后唤起照相就不运行了
urlWhiteList:
- //*[contains(@resource-id, "login_36kr_ll") and @clickable=‘true‘]   #必须遍历账号密码登录的按钮（以此方式才能登录成功）
- //*[contains(@resource-id, "fl_msg") and @clickable=‘true‘]   #右上角的私信按钮
- //*[contains(@resource-id, "iv_setting") and @clickable=‘true‘]  # 左上角的设置按钮
backButton:
- //*[contains(@resource-id, "toolbar_back") and @clickable=‘true‘]
triggerActions:    # 主要解决登录的问题，当遇到登录输入框时，输入内容，比testcase更好用
- action: "1771019****"
  xpath: "//*[@resource-id=‘com.android36kr.investment:id/login_36kr_phone_edit‘]"
  times: 1
- action: "123456"
  xpath: "//*[@resource-id=‘com.android36kr.investment:id/login_36kr_pass_code‘]"
  times: 1
- action: "click"
  xpath: "//*[@resource-id=‘com.android36kr.investment:id/login_36kr_go_btn‘]"
  times: 1 
- action: "swipe("down")"
  xpath: "//*[@resource-id=‘com.android36kr.investment:id/share‘]"
  times: 1 
startupActions: 
- swipe("left")

- println(driver)
testcase:
  name: swipeTest
  steps:
  - when:
      xpath: //*[contains(@resource-id, ‘share‘)]
      action: driver.swipe(0.5,0.8,0.5,0.2)
    then: []
还有一些其他的参数说明如下：

1、java -jar appcrawler-2.1.0.jar --capability appPackage=xxxxxx,appActivity=xxxxxx
2、appium --session-override：4：10，配置文件说明：11：00（看视频主要地方）
3、配置文件使用：true和false是开启和关闭的意思
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
4、一次ctrl+c生成报告，两次ctrl+c是强行退出
5、终端输入Scala进入Scala解释器，输入:q或:quit退出解释器
6、遍历的深度应该怎么设置好，总是跳到其它页面，就回不到当前页面继续遍历了,看文档 通过黑白名单 
7、设置一个起始url和maxDepth, 用来在遍历时候指定初始状态和遍历深度
四. 遇到的问题有哪些？如何解决

1.登录：
因为APP的登录页面是用户名+验证码，由于该页面按钮众多且有验证图标，需要滑动解锁很复杂，所以选用了账号密码登录的方式
（1）设置 账号密码登录 按钮为白名单，即必须点击，此时一定会编辑进入账户名密码登录页面，配置如下：
urlWhiteList:
- //*[contains(@resource-id, "login_36kr_ll") and @clickable=‘true‘]
#必须遍历账号密码登录的按钮
（2）设置账号密码登录中，用户名和密码元素的触发器，当定位到这两个元素时，输入用户名和密码，配置如下：
triggerActions:
# 主要解决登录的问题，当遇到登录输入框时，输入内容，比testcase更好用
- action: "177*******"
xpath: "//*[@resource-id=‘com.android36kr.investment:id/login_36kr_phone_edit‘]"
times: 1
- action: "123456"
xpath: "//*[@resource-id=‘com.android36kr.investment:id/login_36kr_pass_code‘]"
times: 1
（3）设置账号密码登录中，输入用户名和密码后，按照遍历顺序，接下来有一个忘记密码的点击事件开启了新页面，为了避免登陆的多余操作，将 忘记密码 这个元素设置为黑名单，不进行遍历，配置如下：
urlBlackList:
- //*[contains(@resource-id, "login_36kr_forgot_pass") and @clickable=‘true‘]
# 忘记密码，避免登陆时按照遍历顺序影响登陆