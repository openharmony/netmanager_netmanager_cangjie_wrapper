# 网络管理仓颉接口

## 简介

网络管理仓颉接口是在 OpenHarmony 上基于网络管理子系统能力之上封装的仓颉API。网络管理子系统，作为设备联网的必备组件，提供了对不同类型网络连接的统一管理、流量管理、策略管理、网络共享，并提供了网络协议栈能力。应用可以通过调用API来获取数据网络的连接信息，查询和订阅数据网络的连接状态，网络流量数据，网络策略以及网络共享等，并可通过网络协议栈进行数据传输。

下图所示为网络管理仓颉架构图。各个部件主要作用如下：

-   网络管理基础部件：主要功能是提供基础网络连接管理能力和对应的JS/Native API，包括不同网络连接优先级管理、网络连接信息查询、网络连接状态变化、DNS解析、流量统计管理、联网策略管理以及物理网络管理等。
-   网络管理扩展部件：主要功能是提供网络管理扩展能力和对应的JS/Native API，包括以太网连接、热点网络共享等。
-   网络协议栈部件：主要功能是提供基础的网络协议栈和对应的JS API，包括HTTP、HTTPS、WebSocket、TCP/UDP/TLS Socket等基础网络协议栈能力。

**图 1**   子系统架构图

![](figures/netmanager_cangjie_wrapper_architecture.png)

## 目录

```
foundation/communication/netmanager_cangjie_wrapper
├── ohos             # 仓颉网络管理接口实现
├── kit              # 仓颉kit化代码
├── figures          # 存放readme中的架构图
```

## 约束

当前开发的网络管理仓颉接口仅支持standard设备。

## 使用说明

如架构图所示，网络管理仓颉接口提供了以下功能，开发者可以根据使用诉求，综合使用一类或多类接口：

-   网络连接管理。
-   数据请求。

与ArkTS相比，暂不支持以下功能：

-   网络共享。

网络管理相关API请参见
1. [ohos.net.connection](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_zh_cn/apis/NetworkKit/cj-apis-net-connection.md)。
2. [ohos.net.http](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_zh_cn/apis/NetworkKit/cj-apis-net-http.md)。

相关指导请参见[网络管理开发指南](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/Dev_Guide/source_zh_cn/network)。

## 参与贡献

欢迎广大开发者贡献代码、文档等，具体的贡献流程和方式请参见[参与贡献](https://gitcode.com/openharmony/docs/blob/master/zh-cn/contribute/%E5%8F%82%E4%B8%8E%E8%B4%A1%E7%8C%AE.md)。

## 相关仓

[communication_netmanager_base](https://gitee.com/openharmony/communication_netmanager_base/blob/master/README_zh.md)

[communication_netstack](https://gitee.com/openharmony/communication_netstack/blob/master/README_zh.md)
