## 本地环境启动
docker-compose up -d

## go依赖公共包配置
- git config --global url."git@git.dp.ibbtv.cn:dp-backend/".insteadOf "http://git.dp.ibbtv.cn/dp-backend/"
- git config --global url."ssh://git@git.dp.ibbtv.cn:dp-backend/".insteadOf "https://git.dp.ibbtv.cn/dp-backend/"
- go env -w GOPRIVATE=git.dp.ibbtv.cn
- go env -w GOPROXY=https://goproxy.cn,direct

## 安装已有的依赖
go mod tidy

## 添加新的依赖包
go get -d git.dp.ibbtv.cn/dp-backend/xxx

## 依赖包更新
- 方式1: 删除go.mod里对应的包，然后执行 go mod tidy
- 方式2: go get -u git.dp.ibbtv.cn/dp-backend/xxx
- 方式3（保熟）: 删除go.mod里对应的包，然后执行 go get -d git.dp.ibbtv.cn/dp-backend/xxx

## vue命令
- pnpm i
- pnpm serve
- pnpm up @dp-frontend/vue-common
- pnpm install git+ssh://git@git.dp.ibbtv.cn:dp-frontend/vue-common.git#main

## 工程初始化
### go-bff
- [工程模版](https://git.dp.ibbtv.cn/dp-backend/template/-/tree/main/bff)
- apollo配置中心创建应用bff-xxx，添加dev密钥，并修改conf/config.yml的appid和secret
- 修改go.mod中的module名，并更新go-common和go-core包到最新版本
- 修改internal/router下的xxx_router为真实的router，并修改main中的newRouterQuote方法
- 修改wire.go中的import
- make init && make wire

### go-app
- [工程模版](https://git.dp.ibbtv.cn/dp-backend/template/-/tree/main/app)
- apollo配置中心创建应用app-xxx，添加dev密钥，并修改conf/config.yml的appid和secret
- 修改go.mod中的module名，并更新go-common和go-core包到最新版本
- 删除kitex_gen目录和handler.go文件，修改xxx.thrift为真实的模版文件
- 修改Makefile中thrift的包名、service名和文件名
- make init && make thrift
- 修改wire.go中的newXxxImpl为真实构造方法，修改main.go中对应的xxx方法
- make wire
- 添加对应的rpc_xxx的client

### vue
- [工程模版](https://git.dp.ibbtv.cn/dp-backend/template/-/tree/main/vue)
- 修改package.json工程名称
- 更新@dp-frontend/vue-common依赖
- 修改.env中的VUE_APP_TITLE和VUE_APP_MODULE_CODE
- 修改.env.development中的启动端口VUE_APP_PORT和对应子模块的url
- .env的全局变量： VUE_APP_TITLE(项目名称),VUE_APP_MODULE_CODE(项目标识),VUE_APP_CONTACT_TEAM(页脚显示邮箱),VUE_APP_COPYRIGHT(页脚版权),VUE_APP_SHOW_FOOTER_LOGO(页脚logo显示),VUE_APP_VERSION(版本号)
                 

### macbook arm64 kafka依赖
- brew install openssl
- brew install librdkafka
- brew install pkg-config
- 环境变量添加export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig"
- git clone https://github.com/google/wire.git
- cd wire
- go build -tags dynamic -o wire cmd/wire/main.go
- mv wire $GOPATH/bin
- idea的Go tool arguments添加-tags dynamic

### kafka create topic
kafka-topics.sh --bootstrap-server localhost:9092 --create --topic base

### 异步任务
- base.task_config表刷一条任务配置
- 查看job-kafka的BaseService里的client引用，如果使用了新的微服务需要添加对应的client，代码在(switch task.App)块里
- bff中添加异步任务提交接口，导入文件参考bff-data.DataDictionaryHandler.ImportDataDictionary，同步任务参考bff-data.MetadataHandler.SyncMetadata
- app中添加处理逻辑的方法，固定格式void xxx(1: i64 taskId, 2: binary param, 3: i64 organizationId)
