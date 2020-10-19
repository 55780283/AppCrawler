#!/bin/bash

#java -jar AppCrawler/appcrawler-2.4.0.jar -c AppCrawler/MyConfig.yml

killAppium(){
    ps -ax | grep 4723 | awk '{print $1}' | xargs kill -9
}

startAppium(){
    appium --session-override  -p  4723 &
}

#runAppCrawler(){
#    java -jar appcrawler-2.4.0.jar -c MyConfig.yml
#}