# 网络管理仓颉接口

## 简介

网络管理仓颉接口是在OpenHarmony上基于网络管理子系统能力之上封装的仓颉API。网络管理子系统，作为设备联网的必备组件，提供了对不同类型网络连接的统一管理、流量管理、策略管理、网络共享，并提供了网络协议栈能力。应用可以通过调用API来获取数据网络的连接信息，查询和订阅数据网络的连接状态，网络流量数据，网络策略以及网络共享等，并可通过网络协议栈进行数据传输。网络管理仓颉接口包含了网络连接管理、数据请求相关业务。当前开发的网络管理仓颉接口仅支持standard设备。

## 系统架构

![网络管理仓颉架构图](figures/netmanager_cangjie_wrapper_architecture.png)

**图 1** 网络管理仓颉架构图

如架构图所示：

-   网络连接管理：提供管理网络能力。
-   数据请求：提供HTTP数据请求能力。
-   仓颉网络管理FFI接口定义：定义C互操作仓颉接口，用于实现仓颉网络管理能力。
-   网络管理基础：提供基础网络连接管理能力，封装C接口提供给仓颉进行互操作。
-   网络协议栈：提供基础的网络协议栈，封装C接口提供给仓颉进行互操作。

## 目录

仓目录结构如下：

```
foundation/communication/netmanager_cangjie_wrapper
├── figures          # 存放README中的架构图
├── kit              # 仓颉kit化代码
│   └── NetworkKit
└── ohos             # 仓颉网络管理接口实现
│   └── net
└── test             # 测试代码
```

## 使用说明

如架构图所示，网络管理仓颉接口提供了以下功能，开发者可以根据使用诉求，综合使用一类或多类接口：

-   网络连接管理。
-   数据请求。

与ArkTS相比，暂不支持以下功能：

-   以太网连接管理。
-   MDNS管理。
-   网络策略管理。
-   Socket连接。
-   流量管理。
-   网络共享管理。
-   VPN增强管理。
-   VPN管理。
-   WebSocket连接。WebSocket 
-   网络防火墙。
-   网络安全。
-   扩展认证。
-   三方VPN能力。

网络管理相关API请参见：
1. [ohos.net.connection](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_zh_cn/apis/NetworkKit/cj-apis-net-connection.md)
2. [ohos.net.http](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_zh_cn/apis/NetworkKit/cj-apis-net-http.md)

相关指导请参见[网络管理开发指南](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/Dev_Guide/source_zh_cn/network)

## 参与贡献

欢迎广大开发者贡献代码、文档等，具体的贡献流程和方式请参见[参与贡献](https://gitcode.com/openharmony/docs/blob/master/zh-cn/contribute/%E5%8F%82%E4%B8%8E%E8%B4%A1%E7%8C%AE.md)。

## 相关仓

[communication_netmanager_base](https://gitee.com/openharmony/communication_netmanager_base/blob/master/README_zh.md)

[communication_netstack](https://gitee.com/openharmony/communication_netstack/blob/master/README_zh.md)
