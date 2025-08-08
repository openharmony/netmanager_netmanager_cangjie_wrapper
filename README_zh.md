# 网络管理子系统<a name="ZH-CN_TOPIC_0000001162422291"></a>

## 简介<a name="section104mcpsimp"></a>

网络管理子系统，作为设备联网的必备组件，提供了对不同类型网络连接的统一管理、流量管理、策略管理、网络共享，并提供了网络协议栈能力。应用可以通过调用API来获取数据网络的连接信息，查询和订阅数据网络的连接状态，网络流量数据，网络策略以及网络共享等，并可通过网络协议栈进行数据传输。

下图所示为网络管理子系统架构图。各个部件主要作用如下：

-   网络管理基础部件：主要功能是提供基础网络连接管理能力和对应的JS/Native API，包括不同网络连接优先级管理、网络连接信息查询、网络连接状态变化、DNS解析、流量统计管理、联网策略管理以及物理网络管理等。
-   网络管理扩展部件：主要功能是提供网络管理扩展能力和对应的JS/Native API，包括以太网连接、热点网络共享等。
-   网络协议栈部件：主要功能是提供基础的网络协议栈和对应的JS API，包括HTTP、HTTPS、WebSocket、TCP/UDP/TLS Socket等基础网络协议栈能力。

**图 1**   子系统架构图

![](figures/zh-cn_architecture-of-netmanager-subsystem.png)

## 目录<a name="section119mcpsimp"></a>

```
foundation/communication/netmanager_cangjie_api
├── ohos             # 仓颉网络管理子系统接口实现
├── kit              # 仓颉kit化代码
├── figures          # 存放readme中的架构图
```

## 相关仓<a name="section152mcpsimp"></a>

**网络管理子系统**

netmanager_cangjie_api

[communication_netmanager_base](https://gitee.com/openharmony/communication_netmanager_base/blob/master/README_zh.md)
