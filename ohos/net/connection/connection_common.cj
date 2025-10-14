/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// The Cangjie API is in Beta. For details on its capabilities and limitations, please refer to the README file.

package ohos.net.connection

import ohos.labels.*
import ohos.ffi.*
import ohos.business_exception.{getUniversalErrorMsg, BusinessException}
import std.collection.*
import std.deriving.Derive

/**
 * Provides an instance that bear data network capabilities.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class NetSpecifier {
    /**
     * The transmission capacity and support of the network's global proxy storage data network.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var netCapabilities: NetCapabilities
    /**
     * Network identifier, the identifier for Wi Fi networks is "wifi", and the identifier for cellular networks is
     * "simId1" (corresponding to SIM card 1).
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var bearerPrivateIdentifier: String 

    /**
     * NetSpecifier constructor
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public init(netCapabilities: NetCapabilities, bearerPrivateIdentifier!: String = "") {
        this.netCapabilities = netCapabilities
        this.bearerPrivateIdentifier = bearerPrivateIdentifier
    }
}

/**
 * Receive information about changes in network capabilities.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class NetCapabilityInfo {
    /**
     * Defines the handle of the data network.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var netHandle: NetHandle
    /**
     * Defines the network capability set.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var netCap: NetCapabilities
    
    /**
     * NetCapabilityInfo constructor
     */
    init(netHandle: NetHandle, netCap: NetCapabilities) {
        this.netHandle = netHandle
        this.netCap = netCap
    }

    /**
     * NetCapabilityInfo constructor
     */
    init(cInfo: CNetCapabilityInfo) {
        this.netHandle = NetHandle(cInfo.netHandle)
        this.netCap = NetCapabilities(cInfo.netCap)
    }
}

/**
 * Defines the network capability set.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class NetCapabilities {
    /**
     * Network type.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var bearerTypes: Array<NetBearType>
    /**
     * Uplink (device-to-network) bandwidth.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var linkUpBandwidthKbps: UInt32 
    /**
     * Downstream (network-to-device) bandwidth.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var linkDownBandwidthKbps: UInt32 
    /**
     * Network-specific capabilities.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var networkCap: Array<NetCap>
    
    /**
     * NetCapabilities constructor
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public init(bearerTypes: Array<NetBearType>, linkUpBandwidthKbps!: UInt32 = 0, linkDownBandwidthKbps!: UInt32 = 0,
        networkCap!: Array<NetCap> = Array<NetCap>()) {
        this.bearerTypes = bearerTypes
        this.linkUpBandwidthKbps = linkUpBandwidthKbps
        this.linkDownBandwidthKbps = linkDownBandwidthKbps
        this.networkCap = networkCap
    }
    
    /**
     * NetCapabilities constructor
     */
    init(cNetCapabilities: CNetCapabilities) {
        let bearedTypeSize = cNetCapabilities.bearedTypeSize
        let networkCapSize = cNetCapabilities.networkCapSize
        let bt = cNetCapabilities.bearerTypes
        let nc = cNetCapabilities.networkCap
        this.linkUpBandwidthKbps = cNetCapabilities.linkUpBandwidthKbps
        this.linkDownBandwidthKbps = cNetCapabilities.linkDownBandwidthKbps
        try {
            this.bearerTypes = Array<NetBearType>(
                bearedTypeSize,
                {
                    i => NetBearType.parse(unsafe { bt.read(i) })
                }
            )
            this.networkCap = Array<NetCap>(networkCapSize, {i => NetCap.parse(unsafe { nc.read(i) })})
            
        } finally {
            cNetCapabilities.free()
        }
    }
}

/**
 * Defines the network connection properties.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class ConnectionProperties {
    /**
     * Network card name.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var interfaceName: String
    /**
     * Domain. The default value is "".
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var domains: String
    /**
     * Link information.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var linkAddresses: Array<LinkAddress>
    /**
     * Network address, refer to [NetAddress].
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var dnses: Array<NetAddress>
    /**
     * Routing information.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var routes: Array<RouteInfo>
    /**
     * Maximum transmission unit.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var mtu: UInt32

    /**
     * ConnectionProperties constructor
     */
    init(interfaceName: String, domains: String, linkAddresses: Array<LinkAddress>, dnses: Array<NetAddress>, routes: Array<RouteInfo>, mtu: UInt32) {
        this.interfaceName = interfaceName
        this.domains = domains
        this.linkAddresses = linkAddresses
        this.dnses = dnses
        this.routes = routes
        this.mtu = mtu
    }
    
    /**
     * ConnectionProperties constructor
     */
    init(cProp: CConnectionProperties) {
        unsafe {
            this.interfaceName = cProp.interfaceName.toString()
            this.domains = cProp.domains.toString()
            this.mtu = UInt32(cProp.mtu)
            this.linkAddresses = cArr2cjArr<CLinkAddress, LinkAddress>(cProp.linkAddressSize, cProp.linkAddresses,
                {addr => LinkAddress(addr)})
            this.dnses = cArr2cjArr<CNetAddress, NetAddress>(cProp.dnsSize, cProp.dnses, {dns => NetAddress(dns)})
            this.routes = cArr2cjArr<CRouteInfo, RouteInfo>(cProp.routeSize, cProp.routes, {route => RouteInfo(route)})
            cProp.free()
        }
    }
}

/**
 * Defines network route information.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class RouteInfo {
    /**
     * Network card name.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var interfaceName: String

    /**
     * Destination Address
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var destination: LinkAddress

    /**
     * Gateway address.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var gateway: NetAddress

    /**
     * Whether a gateway is present.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var hasGateway: Bool

    /**
     * Whether the route is the default route.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var isDefaultRoute: Bool
    
    /**
     * RouteInfo constructor
     */
    init(interfaceName: String, destination: LinkAddress, gateway: NetAddress, hasGateway: Bool, isDefaultRoute: Bool) {
        this.interfaceName = interfaceName
        this.destination = destination
        this.gateway = gateway
        this.hasGateway = hasGateway
        this.isDefaultRoute = isDefaultRoute
    }
    
    /**
     * RouteInfo constructor
     */
    init(cRoute: CRouteInfo) {
        this.interfaceName = cRoute.interfaceName.toString()
        this.destination = LinkAddress(cRoute.destination)
        this.gateway = NetAddress(cRoute.gateway)
        this.hasGateway = cRoute.hasGateway
        this.isDefaultRoute = cRoute.isDefaultRoute
        cRoute.free()
    }
}

/**
 * Defines network link information.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class LinkAddress {
    /**
     * Link address.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var address: NetAddress
    /**
     * The length of the link address prefix.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var prefixLength: Int32
 
    /**
     * LinkAddress constructor
     */
    init(address: NetAddress, prefixLength: Int32) {
        this.address = address
        this.prefixLength = prefixLength
    }

    /**
     * LinkAddress constructor
     */
    init(cAddr: CLinkAddress) {
        this.address = NetAddress(cAddr.address)
        this.prefixLength = cAddr.prefixLength
    }
}

/**
 * Defines a network address.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class NetAddress {
    /**
     * Network address.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var address: String
    /**
     * Address family identifier. The value is 1 for IPv4 and 2 for IPv6. The default value is 1.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var family: UInt32
    /**
     * Port number. The value ranges from 0 to 65535.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var port: UInt32
   
    /**
     * NetAddress constructor
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public init(address: String, family!: UInt32 = 1, port!: UInt32 = 0) {
        this.address = address
        this.family = family
        this.port = port
    }
    
    /**
     * NetAddress constructor
     */
    init(cAddress: CNetAddress) {
        this.address = cAddress.address.toString()
        this.family = cAddress.family
        this.port = UInt32(cAddress.port)
        cAddress.free()
    }
}

/**
 * Network Global Proxy Configuration Information.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class HttpProxy {
    /**
     * Proxy server host name.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var host: String 
    /**
     * Host port.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var port: UInt32
    /**
     * Do not use a blocking list for proxy servers.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var exclusionList: Array<String> 

    /**
     * Http proxy username.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var username: String

    /**
     * Http proxy password.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var password: String

    /**
     * HttpProxy constructor
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public init(host: String,  port: UInt32, exclusionList: Array<String>,
        username!: String = "", password!: String = "") {
        this.host = host
        this.port = port
        this.exclusionList = exclusionList
        this.username = username
        this.password = password
    }

    /**
     * HttpProxy constructor
     */
    protected init(chttpProxy: CHttpProxy) {
        this.host = chttpProxy.host.toString()
        this.port = UInt32(chttpProxy.port)
        this.exclusionList = unsafe {
            cArr2cjArr<CString, String>(
                chttpProxy.exclusionListSize,
                chttpProxy.exclusionList,
                {cstring => cstring.toString()}
            )
        }
        this.username = ""
        this.password = ""
        chttpProxy.free()
    }
}

/**
 * Defines the network capability.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public enum NetCap {
    /**
     * Indicates that the network can access the carrier's MMSC to send and receive multimedia messages.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetCapabilityMms
    |
        /**
         * Indicates that the network traffic is not metered.
         */
        @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetCapabilityNotMetered
    |
        /**
         * Indicates that the network can access the Internet.
         */
        @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetCapabilityInternet
    |
        /**
         * Indicates that the network does not use a VPN.
         */
        @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetCapabilityNotVpn
    |
        /**
         * Indicates that the network is available.
         */
        @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetCapabilityValidated
    | ...

    /**
     * get the corresponding mapping value
     */
    func getValue(): Int32 {
        match (this) {
            case NetCapabilityMms => 0
            case NetCapabilityNotMetered => 11
            case NetCapabilityInternet => 12
            case NetCapabilityNotVpn => 15
            case NetCapabilityValidated => 16
            case _ => throw BusinessException(2100001, "Invalid parameter value.")
        }
    }

    static func parse(val: Int32): NetCap {
        match (val) {
            case 0 => NetCapabilityMms
            case 11 => NetCapabilityNotMetered
            case 12 => NetCapabilityInternet
            case 15 => NetCapabilityNotVpn
            case 16 => NetCapabilityValidated
            case _ => throw BusinessException(2100003, "System internal error.")
        }
    }
}

/**
 * Enumerates network types.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public enum NetBearType {
    /**
     * Indicates that the network is based on a cellular network.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    BearerCellular
    |
        /**
         * Indicates that the network is based on a Wi-Fi network.
         */
        @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    BearerWifi
    |
        /**
         * Indicates that the network is an Ethernet network.
         */
        @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    BearerEthernet
    | ...

    /**
     * get the corresponding mapping value
     */
    func getValue(): Int32 {
        match (this) {
            case BearerCellular => 0
            case BearerWifi => 1
            case BearerEthernet => 3
            case _ => throw BusinessException(2100001, "Invalid parameter value.")
        }
    }

    static func parse(val: Int32): NetBearType {
        match (val) {
            case 0 => BearerCellular
            case 1 => BearerWifi
            case 3 => BearerEthernet
            case _ => throw BusinessException(2100003, "System internal error.")
        }
    }
}

/**
 * net connection event type.
 */
@Derive[Equatable]
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public enum NetConnectionEvent {
    /**
     * netAvailable
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetAvailable
    |
    /**
     * netBlockStatusChange
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetBlockStatusChange
    |
    /**
     * netCapabilitiesChange
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetCapabilitiesChange
    |
    /**
     * netConnectionPropertiesChange
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetConnectionPropertiesChange
    |
    /**
     * netLost
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetLost
    |
    /**
     * netUnavailable
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetUnavailable
    | ...
}

let ERROR_CODE_MAP = HashMap<Int32, String>(
    [ /* Net base common error */
        (2100001, "Invalid parameter value."),
        (2100002, "Operation failed. Cannot connect to service."),
        (2100003, "System internal error."),
        /* Net ext common error */
        (2200001, "Invalid parameter value."),
        (2200002, "Operation failed. Cannot connect to service."),
        (2200003, "System internal error."),
        /* Net connection Manager */
        (2101002, "the supplier id is invalid."),
        (2101003, "the net type is not found."),
        (2101004, "no any net type."),
        (2101005, "no registered."),
        (2101006, "the net id is not found."),
        (2101007, "the callback is not found."),
        (2101008, "the same callback exists."),
        (2101009, "the request id is not found."),
        (2101010, "the net is not defualt."),
        (2101011, "the http proxy is invalid."),
        (2101012, "the httpProxy in service doesnot exist."),
        (2101013, "the network doesnot exist."),
        (2101014, "the service request connection failed."),
        (2101015, "the service update net link infomation failed."),
        (2101016, "supplier doesn't exist."),
        (2101017, "net monitor failed."),
        (2101018, "no service request."),
        (2101019, "address list doesnot exist."),
        (2101020, "the bestnetwork request was not found."),
        (2101021, "no restrict background."),
        (2101022, "the number of requests exceeded the maximum."),
        (2101023, "create dump failed.")
    ]
)

func getErrorCode(code: Int32): Int32 {
    if (code == -1) {
        2200003
    } else {
        code
    }
}

func getErrorMsg(code: Int32): String {
    if (let Some(v) <- getUniversalErrorMsg(code)) {
        return v
    } else if (ERROR_CODE_MAP.contains(code)) {
        return ERROR_CODE_MAP[code]
    } else {
        return "Unknown error code ${code}"
    }
}
