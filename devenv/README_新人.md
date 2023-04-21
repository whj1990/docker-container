## wifi密码
DFL_MAX
dfl202101

## 安装软件
- golang 1.18
- node
- pnpm
- docker
- idea
- idea插件：
  - go
  - makefile language
  - python
  - scala
  - thrift support
  - vue.js
- datagrip

## go
- 依赖注入：https://github.com/google/wire
- 微服务：https://www.cloudwego.io/zh/docs/kitex/overview
- 数据库：https://gorm.io/zh_CN/docs/index.html
- http框架：https://github.com/gin-gonic/gin
- swagger：https://github.com/swaggo/swag

## vue
- script-setup：https://staging-cn.vuejs.org/api/sfc-script-setup.html
- 组件库：https://primefaces.org/primevue/setup
- 模版：https://github.com/primefaces/sakai-vue

## git
https://git.dp.ibbtv.cn/
自行注册账号后管理员开通权限

## 代码管理
- 开发阶段，从main分支拉取自己的开发分支，命名dev_xxx
- 本地测试完成，提交代码并通知管理员codereview
- codereview通过，管理员合并到main分支，发布
- 如果go工程有依赖变更（比如同时变更bff和app）
  - bff开发阶段go.mod中replace依赖进行开发
  - 完成本地测试
  - 提交app，codereview通过后合并到main并发布
  - bff去除go.mod中到replace，拉取最新的app依赖，再次完成本地测试后，提交代码-codereview-发布

## sql管理
- 在sql工程中，每次新增xxx.sql，编号递增
- 已经上线完成的sql不允许再次变更
- 本地新环境刷sql顺序
  - ddl
  - dml/gateway
  - dml/role
  - dml/其他

## makefile
- make init 安装make依赖
- make thrift 生成thrift文件
- make wire 生成go依赖注入

## 本地环境初始化
- 启动docker-compose
- 刷入sql
- 启动app-base,bff-base,api-gateway,vue-portal
- 访问http://localhost:8080，初始超级管理员账号密码n4JwAOG4iMgasUpi/admin
- 选择基础管理
- 组织架构中新增一条数据
- 角色中新增一条数据，并勾选所有菜单
- 用户中新增一条数据，并选择刚才新增的角色和组织
- 退出登陆，使用刚新增的普通用户登录
- 启动对应的子模块代码，点击跳转对应的子模块

## 一般curd开发流程
#### 建表
- 在sql工程中新增对应的ddl
#### app
- 在app/internal/repo中新增对应的repo文件，并在provider中新增构造方法
  - 结构体需要组合repository.BaseDBData或结构体需要组合repository.BaseCommonDBData，并实现TableName方法
  - 对默认对gorm的Joins预加载进行过封装，现在在结构体中使用`gorm:"foreignKey:xxx; references:xxx"`可以递归查询子结构体的子结构体数据
  - 参数需实现getConditions和listConditions方法
  - 接口需要组合repository.BaseCommonRepo，并实现Get、Count、List方法
- 在xxx.thrift中新增对应的rpc方法，然后执行make thrift
- 在app/internal/service中新增对应的service文件，新增对应的逻辑，并在provider中新增构造方法
- 在handler.go中新增service依赖，调用对应的service方法，并在main.go中修改handler的构造方法
- make wire
#### bff
- 在bff/internal/handler中新增handler，调用app的service，并在provider中新增构造方法
- 在bff/internal/router中新增对应的路由方法，调用handler
- make wire
#### sql
- dml/gateway中新增对应api的gateway_mapping和gateway_mapping_middleware数据
- dml/role中新增对应的权限数据
  - role_node为树型结构，type：'0:超级管理 1:管理用户 2:普通用户'，class：'0:模块 1:页面 2:元素'，一般子模块页面只刷type=2的数据
  - role_gateway为role_node节点绑定的gateway，用于勾选页面按钮权限后，赋予访问对应的接口权限，type:'0:公共 1:超级管理 2:管理用户 3:普通用户'，一般子模块页面只刷type=3的数据
#### vue
- 在api中新增对应的api
- 在views和store中新增对应的页面和数据逻辑
- 在router里新增对应的路由
#### 权限
- 用超级管理员账号登录勾选新的页面按钮权限
 
## 团队沟通
#### 问题反馈
- 遇到阻塞问题需要及时沟通，微信群/钉钉群/面对面沟通都可以
- 下班后的阻塞问题记录到日报里
- 关注jira的预估工时，禁止严重超时
#### 效率
- 每个新人的前两周为学习期，期间需要解决的问题
  - 环境配置
  - 框架熟悉
  - 开发流程熟悉
  - 日报
  - 至少完成一个完整的开发-codereview-上线
- 如果超过两周依然无法进入正常的开发状态，考虑人员交换
- 【注意】一个完整的开发-codereview-上线，不止是代码，也包含了上线sql、上线配置、自测以及上线功能演示，以及在codereview中可能会产生一些修改，需要自行控制时间
#### 会议/开发周期
- 两周一个sprint，主要确定下一个sprint的主体功能，需要开发/分析师参与
- 每天早10点过进度/问题讨论，需要开发参与
