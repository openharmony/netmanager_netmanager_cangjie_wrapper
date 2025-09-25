# 网络管理仓颉封装

## 简介

网络管理子系统，作为设备联网的必备组件，提供了对不同类型网络连接的统一管理、流量管理、策略管理、网络共享，并提供了网络协议栈能力。应用可以通过调用API来获取数据网络的连接信息，查询和订阅数据网络的连接状态，网络流量数据，网络策略以及网络共享等，并可通过网络协议栈进行数据传输。网络管理仓颉接口包含了网络连接管理、数据请求相关业务。当前开发的网络管理仓颉接口仅支持standard设备。

## 系统架构

![网络管理仓颉架构图](figures/netmanager_cangjie_wrapper_architecture.png)

**图 1** 网络管理仓颉架构图

如架构图所示：

接口层：

- 网络连接管理：提供管理网络能力。
- 数据请求：提供HTTP数据请求能力。

框架层：

- 网络连接管理封装：仓颉网络连接管理的实现封装，提供网络连接管理能力。
- 数据请求封装：仓颉数据请求的实现封装，提供数据请求能力。
- 仓颉网络管理FFI接口定义：定义C语言互操作仓颉接口，用于实现仓颉网络管理能力。

架构图中的依赖部件引入说明：

- Net Manager：提供基础网络连接管理能力，封装C语言接口提供给仓颉进行互操作。
- Net Stack：提供基础的网络协议栈，封装C语言接口提供给仓颉进行互操作。
- cangjie_ark_interop：负责提供仓颉注解类定义，用于对API进行标注，以及提供抛向用户的BusinessException异常类定义。
- hiviewdfx_cangjie_wrapper：负责提供日志接口，用于在关键路径处打印日志。

## 目录

仓目录结构如下：

```
foundation/communication/netmanager_cangjie_wrapper
├── figures                 # 存放README中的架构图
├── kit                     # 仓颉kit化代码
│   └── NetworkKit
└── ohos                    # 仓颉网络管理接口实现
│   └── net
│       ├── connection      # 网络连接管理相关接口
│       └── http            # 数据请求相关接口
└── test                    # 测试代码
    ├── connection          # connection测试用例
    └── http                # http测试用例
```

## 使用说明

当前网络管理仓颉接口提供了以下功能：

- 网络连接管理。
- 数据请求。

网络管理相关API请参见：
1. [网络连接管理](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_zh_cn/apis/NetworkKit/cj-apis-net-connection.md)
2. [数据请求](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_zh_cn/apis/NetworkKit/cj-apis-net-http.md)

相关指导请参见[网络管理开发指南](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/Dev_Guide/source_zh_cn/network)

## 约束

与ArkTS提供的API能力相比，暂不支持以下功能：

- 以太网连接管理。
- MDNS管理。
- 网络策略管理。
- Socket连接。
- 流量管理。
- 网络共享管理。
- VPN增强管理。
- VPN管理。
- WebSocket连接。
- 网络防火墙。
- 网络安全。
- 扩展认证。
- 三方VPN能力。

## 参与贡献

欢迎广大开发者贡献代码、文档等，具体的贡献流程和方式请参见[参与贡献](https://gitcode.com/openharmony/docs/blob/master/zh-cn/contribute/%E5%8F%82%E4%B8%8E%E8%B4%A1%E7%8C%AE.md)。

## 相关仓

[arkcompiler_cangjie_ark_interop](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop)

[communication_netmanager_base](https://gitcode.com/openharmony/communication_netmanager_base)

[communication_netstack](https://gitcode.com/openharmony/communication_netstack)

[hiviewdfx_hiviewdfx_cangjie_wrapper](https://gitcode.com/openharmony-sig/hiviewdfx_hiviewdfx_cangjie_wrapper)
