# netmanager_cangjie_wrapper

## Introduction

The netmanager_cangjie_wrapper is a Cangjie API encapsulated on OpenHarmony based on the capabilities of the net management Subsystem. As a mandatory component for device networking, the network management subsystem implements unified connection management, traffic management, policy management, network sharing of different types of networks, and provides network protocol stack capabilities. An application can call APIs to obtain connection information of a data network, query and subscribe to connection status, network traffic data, and network policy, share the network, and transfer data using a network protocol stack.

The figure below shows the architecture of the network management subsystem. The network management subsystem consists of the following components:

-   Basic network management: provides basic network connection management and related JS and native APIs, including connection priority management, connection information query, connection status observation, DNS resolution, traffic management, networking policy management, and physical network management.
-   Extended network management: provides extended network management capabilities and related JS and native APIs, including Ethernet connection and hotspot sharing.
-   Network protocol stacks: provides basic network protocol stacks (such as HTTP, HTTPS, WebSocket, and TCP/UDP/TLS socket) and related JS APIs.

**Figure 1** Architecture of the netmanager_cangjie_wrapper

![](figures/netmanager_cangjie_wrapper_architecture_en.png)

## Directory Structure

```
foundation/communication/netmanager_cangjie_wrapper
├── ohos             # Cangjie Network Management code
├── kit              # Cangjie kit code
├── figures          # architecture pictures
```

## Constraints

The network management cangjie interface currently under development only supports standard devices.

## Usage

The netmanager_cangjie_wrapper provides the following capabilities:

-   Network Connection Management.
-   Data Request.

Compared to ArkTS, the following features are currently not supported:

-   Network Sharing.

For netmanager APIs, please refer to
1. [ohos.net.connection](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_en/apis/NetworkKit/cj-apis-net-connection.md)。
2. [ohos.net.http](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/API_Reference/source_en/apis/NetworkKit/cj-apis-net-http.md)。

For relevation guidance, please refer to [Network Development Guide](https://gitcode.com/openharmony-sig/arkcompiler_cangjie_ark_interop/blob/master/doc/Dev_Guide/source_en/network)。

## Code Contribution

Developers are welcome to contribute code, documentation, etc. For specific contribution processes and methods, please refer to [Code Contribution](https://gitcode.com/openharmony/docs/blob/master/en/contribute/code-contribution.md).

## Repositories Involved

[communication_netmanager_base](https://gitee.com/openharmony/communication_netmanager_base/blob/master/README.md)

[communication_netstack](https://gitee.com/openharmony/communication_netstack/blob/master/READEME.md)
