一.环境

1.环境准备：安装安卓SDK + 真机 + appcrawler-2.1.3.jar

在放 appcrawler-2.1.0.jar 的文件夹下执行以下命令:

1.生成yml的demo：java -jar appcrawler-2.1.3.jar –demo

2.更改并运行yml配置文件:java -jar appcrawler-2.1.3.jar  -c example. yml

3.Java -jar appcrawler-2.1.0.jar -a jingdata.apk -c config.yml --output wyy/

Usage: java -jar appcrawler.jar [options]

  -a, --app <value>        Android或者iOS的文件地址, 可以是网络地址, 赋值给appium的app选项
  -c, --conf <value>       配置文件地址
  -p, --platform <value>   平台类型android或者ios, 默认会根据app后缀名自动判断
  -t, --maxTime <value>    最大运行时间. 单位为秒. 超过此值会退出. 默认最长运行3个小时
  -u, --appium <value>     appium的url地址
  -o, --output <value>     遍历结果的保存目录. 里面会存放遍历生成的截图, 思维导图和日志
  --capability k1=v1,k2=v2...
                           appium capability选项, 这个参数会覆盖-c指定的配置模板参数, 用于在模板配置之上的参数微调
  -r, --report <value>     输出html和xml报告
  -vv, --verbose           是否展示更多debug信息
  --help
示例
java -jar appcrawler.jar -a xueqiu.apk
java -jar appcrawler.jar -a xueqiu.apk --capability noReset=true
java -jar appcrawler.jar -c conf/xueqiu.yaml -p android -o result/
java -jar appcrawler.jar -c xueqiu.yaml --capability udid=[你的udid] -a Snowball.app
java -jar appcrawler.jar -c xueqiu.yaml -a Snowball.app -u 4730
java -jar appcrawler.jar -c xueqiu.yaml -a Snowball.app -u http://127.0.0.1:4730/wd/hub
java -jar appcrawler.jar --report result/

二.参数说明

1、java -jar appcrawler-2.1.0.jar –capability appPackage=xxxxxx,appActivity=xxxxxx 
2、命名启动appium:appium –session-override

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
given是条件 或输入 when是触发条件和动作 then是断言 
4、一次ctrl+c生成报告，两次ctrl+c是强行退出 
5、终端输入Scala进入Scala解释器，输入:q或:quit退出解释器 
6、遍历的深度应该怎么设置好，总是跳到其它页面，就回不到当前页面继续遍历了,看文档 通过黑白名单 
7、设置一个起始url和maxDepth, 用来在遍历时候指定初始状态和遍历深度

WebDriver 
1. 根据id class xpath进行定位
AppCrawler 
1. 先getPageSoruce获取所有的元素列表 
2. 根据xpath直接选择元素 
3. 截图时增加对选择控件的高亮区分 
4. 宽松策略的自动化机制

Page Source解读 
Android 
1. tag class 
2. resource-id 
3. content-desc 
4. text 
iOS 
1. tag 
2. name 
3. label 
4. value

xpath的定位 
绝对定位 /xxx/ddd/dddd 
相对定位 //android.widget.Button 
查找 
1. //* 
2. //*[contains(@resource-id,’login’)] 
3. //*[@text=’登录’] 
4. //*[contains(@resource-id,’login’) and contains(@text,’登录’)] 
5. //[contains(@text,’看点’)]/ancestor:://*[contains(name(),’EditText’)] 
6. //*[@clickable=”true”]//android.widget.TextView[string-length(@text)>0 and string-length(@text)<20]

多种方式匹配 
xpath 
1. //*[@resource-id=’xxxx’] 
2. //*[contains(@text,’密码’)] 
正则 
1. ^确定￥ 
2.^.输入密码 
包含 
1. 密码 
2. 输入 
3. 请
自动遍历过程 
信息的获取 
把当前app的界面dump为xml结构 
获取待遍历元素 
遍历范围selectedList 
过滤黑名单 小控制 不可见控件 blackList 
重新控件顺利firstList lastList 
跳过已点击 + 跳过限制点击的控件tagLimit 
跟进匹配的规则执行action 
循环上面的步骤

问题记录

设置登录账号、密码
triggerActions:
- action: "click"
  xpath: "//*[@resource-id='com.xxx.myfinance:id/login_tv']"
  times: 1
- action: "153xxxxxxxx"
  xpath: "//*[@resource-id='com.xxx.myfinance:id/phone_edit']"
  times: 1
- action: "123456"
  xpath: "//*[@resource-id='com.xxx.myfinance:id/pwd_edit']"
  times: 1
- action: "click"
  xpath: "//*[@resource-id='com.xxx.myfinance:id/btn_submit']"
  times: 1
 2.  编辑EditText
方式一：

 triggerActions:
  - action: "10000"
  xpath: "//*[@class='android.widget.EditText']"
  times: 1  
备注：times只能写1，否则EditText控件一直在那复制剪切 
不适用需要多次输入的EditText

方式二：

testcase:
  name: "sui guan jia"
  steps:
    - when: 
      xpath: //*[@resource-id='com.feidee.myfinance:id/cash_amount']
      action: ${random.int[100,1000]}
      times: 0
    then: []
备注：可点击的EditText获取不到

clickedIndex=-1 action=Ready
 xpath=//*[@resource-id=\"com.feidee.myfinance:id/action_bar_root\" and @index=\"0\"]/*[@resource-id=\"android:id/content\" and @index=\"0\"]/*[@index=\"0\"]/*[@resource-id=\"com.feidee.myfinance:id/common_toolbar\" and @index=\"0\"] 
 !!! CANCELED !!!
 

3 appcrawler经常会出现一些错误： 
2018-05-12 10:53:27 ERROR [Crawler.crawl.203] crawl not finish, return with exception 
2018-05-12 10:53:27 ERROR [Crawler.crawl.204] Unable to launch the app: Error: Trying to start logcat capture but it’s already started! (WARNING: The server did not provide any stacktrace information) 
Command duration or timeout: 0 milliseconds 
不太清楚，为什么会报错…… 总的感觉是getPageSoruce未获去到元素 
所以瞎改了

selectedList:
#android非空标签
- //*[@clickable='true']
#- //*[@clickable='true']//*[contains(name(), 'Text') and string-length(@text)>0 and string-length(@text)<10 ]
#通用的button和image
- //*[@clickable='true']//*[contains(name(), 'Button')]
- //*[@clickable='true']//*[contains(name(), 'Image')]
- //*[@clickable='true']//*[contains(name(), 'Layout')]
- //*[@class='android.view.ViewGroup']
- //*[@class='android.widget.EditText']
 

4 testcase 与 triggerActions 
自己试了一下，发现是先查找testcase，再查找triggerActions 
但是还是感觉逻辑关系有点混乱，或者没有办法支持复杂的逻辑关系，让自己的case更有逻辑顺序。