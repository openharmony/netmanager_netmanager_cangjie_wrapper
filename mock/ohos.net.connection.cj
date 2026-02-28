/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

package ohos.net.connection
import ohos.ffi.*
import ohos.business_exception.*
import ohos.callback_invoke.*
import ohos.labels.*
import std.collection.*

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class NetSpecifier {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var netCapabilities: NetCapabilities

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var bearerPrivateIdentifier: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public init(netCapabilities: NetCapabilities, bearerPrivateIdentifier!: String = "") {
        super()
        this.netCapabilities = NetCapabilities(
            Array(),
            linkUpBandwidthKbps: 0,
            linkDownBandwidthKbps: 0,
            networkCap: Array()
        )
        this.bearerPrivateIdentifier = String()
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class NetCapabilityInfo {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var netHandle: NetHandle

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var netCap: NetCapabilities
    
    public init() {
        super()
        this.netHandle = NetHandle()
        this.netCap = NetCapabilities(
            Array(),
            linkUpBandwidthKbps: 0,
            linkDownBandwidthKbps: 0,
            networkCap: Array()
        )
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class NetCapabilities {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var bearerTypes: Array<NetBearType>

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var linkUpBandwidthKbps: UInt32

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var linkDownBandwidthKbps: UInt32

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var networkCap: Array<NetCap>

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public init(bearerTypes: Array<NetBearType>, linkUpBandwidthKbps!: UInt32 = 0, linkDownBandwidthKbps!: UInt32 = 0,
        networkCap!: Array<NetCap> = Array<NetCap>()) {
        super()
        this.bearerTypes = Array()
        this.linkUpBandwidthKbps = 0
        this.linkDownBandwidthKbps = 0
        this.networkCap = Array()
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class ConnectionProperties {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var interfaceName: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var domains: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var linkAddresses: Array<LinkAddress>

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var dnses: Array<NetAddress>

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var routes: Array<RouteInfo>

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var mtu: UInt32
    
    public init() {
        super()
        this.interfaceName = String()
        this.domains = String()
        this.linkAddresses = Array()
        this.dnses = Array()
        this.routes = Array()
        this.mtu = 0
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class RouteInfo {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var interfaceName: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var destination: LinkAddress

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var gateway: NetAddress

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var hasGateway: Bool

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var isDefaultRoute: Bool
    
    public init() {
        super()
        this.interfaceName = String()
        this.destination = LinkAddress()
        this.gateway = NetAddress(
            String(),
            family: 0,
            port: 0
        )
        this.hasGateway = true
        this.isDefaultRoute = true
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class LinkAddress {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var address: NetAddress

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var prefixLength: Int32
    
    public init() {
        super()
        this.address = NetAddress(
            String(),
            family: 0,
            port: 0
        )
        this.prefixLength = 0
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class NetAddress {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var address: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var family: UInt32

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var port: UInt32

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public init(address: String, family!: UInt32 = 1, port!: UInt32 = 0) {
        super()
        this.address = String()
        this.family = 0
        this.port = 0
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class HttpProxy {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var host: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var port: UInt32

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var exclusionList: Array<String>

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var username: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var password: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public init(host: String, port: UInt32, exclusionList: Array<String>, username!: String = "", password!: String = "") {
        super()
        this.host = String()
        this.port = 0
        this.exclusionList = Array()
        this.username = String()
        this.password = String()
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public enum NetCap {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetCapabilityMms
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetCapabilityNotMetered
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetCapabilityInternet
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetCapabilityNotVpn
    |
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

    /**
     * @throws { BusinessException } 2100003 - System internal error.
     */
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

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public enum NetBearType {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    BearerCellular
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    BearerWifi
    |
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

    /**
     * @throws { BusinessException } 2100003 - System internal error.
     */
    static func parse(val: Int32): NetBearType {
        match (val) {
            case 0 => BearerCellular
            case 1 => BearerWifi
            case 3 => BearerEthernet
            case _ => throw BusinessException(2100003, "System internal error.")
        }
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public enum NetConnectionEvent {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetAvailable
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetBlockStatusChange
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetCapabilitiesChange
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetConnectionPropertiesChange
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetLost
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    NetUnavailable
    | ...
}

extend NetConnectionEvent <: Equatable<NetConnectionEvent> {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public operator func ==(other: NetConnectionEvent): Bool {
        return true
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public operator func !=(other: NetConnectionEvent): Bool {
        return true
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public func createNetConnection(netSpecifier!: ?NetSpecifier = None, timeout!: UInt32 = 0): NetConnection {
    return NetConnection()
}

@!APILevel[
    since: "22",
    permission: "ohos.permission.GET_NETWORK_INFO",
    syscap: "SystemCapability.Communication.NetManager.Core",
    throwexception: true,
    workerthread: true
]
public func getDefaultNet(): NetHandle {
    return NetHandle()
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core",
    throwexception: true,
    workerthread: true
]
public func getDefaultHttpProxy(): HttpProxy {
    return HttpProxy(
        String(),
        0,
        Array(),
        username: String(),
        password: String()
    )
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core",
    throwexception: true,
    workerthread: true
]
public func getAppNet(): NetHandle {
    return NetHandle()
}

@!APILevel[
    since: "22",
    permission: "ohos.permission.INTERNET",
    syscap: "SystemCapability.Communication.NetManager.Core",
    throwexception: true,
    workerthread: true
]
public func setAppNet(netHandle: NetHandle): Unit {
    return ()
}

@!APILevel[
    since: "22",
    permission: "ohos.permission.GET_NETWORK_INFO",
    syscap: "SystemCapability.Communication.NetManager.Core",
    throwexception: true,
    workerthread: true
]
public func getAllNets(): Array<NetHandle> {
    return Array()
}

@!APILevel[
    since: "22",
    permission: "ohos.permission.GET_NETWORK_INFO",
    syscap: "SystemCapability.Communication.NetManager.Core",
    throwexception: true,
    workerthread: true
]
public func getConnectionProperties(netHandle: NetHandle): ConnectionProperties {
    return ConnectionProperties()
}

@!APILevel[
    since: "22",
    permission: "ohos.permission.GET_NETWORK_INFO",
    syscap: "SystemCapability.Communication.NetManager.Core",
    throwexception: true,
    workerthread: true
]
public func getNetCapabilities(netHandle: NetHandle): NetCapabilities {
    return NetCapabilities(
        Array(),
        linkUpBandwidthKbps: 0,
        linkDownBandwidthKbps: 0,
        networkCap: Array()
    )
}

@!APILevel[
    since: "22",
    permission: "ohos.permission.GET_NETWORK_INFO",
    syscap: "SystemCapability.Communication.NetManager.Core",
    throwexception: true,
    workerthread: true
]
public func isDefaultNetMetered(): Bool {
    return true
}

@!APILevel[
    since: "22",
    permission: "ohos.permission.GET_NETWORK_INFO",
    syscap: "SystemCapability.Communication.NetManager.Core",
    throwexception: true,
    workerthread: true
]
public func hasDefaultNet(): Bool {
    return true
}

@!APILevel[
    since: "22",
    permission: "ohos.permission.GET_NETWORK_INFO" & "ohos.permission.INTERNET",
    syscap: "SystemCapability.Communication.NetManager.Core",
    throwexception: true,
    workerthread: true
]
public func reportNetConnected(netHandle: NetHandle): Unit {
    return ()
}

@!APILevel[
    since: "22",
    permission: "ohos.permission.GET_NETWORK_INFO" & "ohos.permission.INTERNET",
    syscap: "SystemCapability.Communication.NetManager.Core",
    throwexception: true,
    workerthread: true
]
public func reportNetDisconnected(netHandle: NetHandle): Unit {
    return ()
}

@!APILevel[
    since: "22",
    permission: "ohos.permission.INTERNET",
    syscap: "SystemCapability.Communication.NetManager.Core",
    throwexception: true,
    workerthread: true
]
public func getAddressesByName(host: String): Array<NetAddress> {
    return Array()
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class NetConnection {
    @!APILevel[
        since: "22",
        permission: "ohos.permission.GET_NETWORK_INFO",
        syscap: "SystemCapability.Communication.NetManager.Core",
        throwexception: true,
        workerthread: true
    ]
    public func register(): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core",
        throwexception: true,
        workerthread: true
    ]
    public func unregister(): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core",
        throwexception: true
    ]
    public func on(event: NetConnectionEvent, callback: Callback1Argument<NetHandle>): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core",
        throwexception: true
    ]
    public func on(event: NetConnectionEvent, callback: Callback1Argument<NetBlockStatusInfo>): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core",
        throwexception: true
    ]
    public func on(event: NetConnectionEvent, callback: Callback1Argument<NetCapabilityInfo>): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core",
        throwexception: true
    ]
    public func on(event: NetConnectionEvent, callback: Callback1Argument<NetConnectionPropertyInfo>): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core",
        throwexception: true
    ]
    public func on(event: NetConnectionEvent, callback: Callback0Argument): Unit {
        return ()
    }
    
    public init() {
        super()
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class NetHandle {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var netId: Int32

    @!APILevel[
        since: "22",
        permission: "ohos.permission.INTERNET",
        syscap: "SystemCapability.Communication.NetManager.Core",
        throwexception: true,
        workerthread: true
    ]
    public func getAddressesByName(host: String): Array<NetAddress> {
        return Array()
    }

    @!APILevel[
        since: "22",
        permission: "ohos.permission.INTERNET",
        syscap: "SystemCapability.Communication.NetManager.Core",
        throwexception: true,
        workerthread: true
    ]
    public func getAddressByName(host: String): NetAddress {
        return NetAddress(
            String(),
            family: 0,
            port: 0
        )
    }
    
    public init() {
        super()
        this.netId = 0
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class NetConnectionPropertyInfo {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var netHandle: NetHandle

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var connectionProperties: ConnectionProperties
    
    public init() {
        super()
        this.netHandle = NetHandle()
        this.connectionProperties = ConnectionProperties()
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetManager.Core"
]
public class NetBlockStatusInfo {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var netHandle: NetHandle

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetManager.Core"
    ]
    public var blocked: Bool
    
    public init() {
        super()
        this.netHandle = NetHandle()
        this.blocked = true
    }
}

@C
struct CNetSpecifier {
    CNetSpecifier(
        let netCapabilities: CNetCapabilities,
        let bearerPrivateIdentifier: CString,
        let hasSpecifier!: Bool = false
    ) {}

    /**
     * @throws { BusinessException } 2100003 - System internal error.
     */
    init(netSpecifier: NetSpecifier) {
        this.netCapabilities = CNetCapabilities(netSpecifier.netCapabilities)
        this.bearerPrivateIdentifier = try {
            unsafe { LibC.mallocCString(netSpecifier.bearerPrivateIdentifier) }
        } catch (e: Exception) {
            netCapabilities.free()
            throw BusinessException(2100003, getErrorMsg(2100003))
        }
        this.hasSpecifier = true
    }
    init() {
        this.hasSpecifier = false
        this.bearerPrivateIdentifier = CString(CPointer<UInt8>())
        this.netCapabilities = CNetCapabilities()
    }

    func free(): Unit {
        unsafe {
            LibC.free(bearerPrivateIdentifier)
            netCapabilities.free()
        }
    }
}

// net.http will use this struct ,so make it public
@C
protected struct CHttpProxy {
    protected CHttpProxy(
        protected let host: CString,
        protected let port: UInt16,
        protected let exclusionList: CPointer<CString>,
        protected let exclusionListSize: Int64
    ) {}

    /**
     * @throws { BusinessException } 2100003 - System internal error.
     */
    protected init(httpProxy: HttpProxy) {
        this.host = unsafe { LibC.mallocCString(httpProxy.host) }
        this.port = UInt16(httpProxy.port)
        this.exclusionListSize = httpProxy.exclusionList.size
        unsafe {
            try {
                this.exclusionList = cjArr2CArr<String, CString>(httpProxy.exclusionList,
                    {str => LibC.mallocCString(str)}) {cstr => LibC.free(cstr)}
            } catch (e: Exception) {
                LibC.free(host)
                throw BusinessException(2100003, getErrorMsg(2100003))
            }
        }
    }

    protected func free() {
        unsafe {
            LibC.free(host)
            for (i in 0..exclusionListSize) {
                LibC.free(exclusionList.read(i))
            }
            LibC.free<CString>(exclusionList)
        }
    }
}

@C
struct CNetAddress {
    CNetAddress(
        let address: CString,
        let family: UInt32,
        let port: UInt16
    ) {}

    func free() {
        unsafe { LibC.free(address) }
    }
}

@C
struct CLinkAddress {
    CLinkAddress(
        let address: CNetAddress,
        let prefixLength: Int32
    ) {}

    func free(): Unit {
        unsafe { address.free() }
    }
}

@C
struct CRouteInfo {
    CRouteInfo(
        let interfaceName: CString,
        let destination: CLinkAddress,
        let gateway: CNetAddress,
        let hasGateway: Bool,
        let isDefaultRoute: Bool
    ) {}

    func free(): Unit {
        unsafe {
            LibC.free(interfaceName)
            destination.free()
            gateway.free()
        }
    }
}

@C
struct RetNetAddressArr {
    RetNetAddressArr(
        let code: Int32,
        let size: Int64,
        let data: CPointer<CNetAddress>
    ) {}

    func free(): Unit {
        unsafe {
            for (i in 0..size) {
                data.read(i).free()
            }
            LibC.free<CNetAddress>(data)
        }
    }
}

@C
struct CNetCapabilities {
    CNetCapabilities(
        let bearedTypeSize: Int64,
        let networkCapSize: Int64,
        let linkUpBandwidthKbps: UInt32,
        let linkDownBandwidthKbps: UInt32,
        let bearerTypes: CPointer<Int32>,
        let networkCap: CPointer<Int32>
    ) {}

    /**
     * @throws { BusinessException } 2100003 - System internal error.
     */
    init(netCapabilities: NetCapabilities) {
        this.linkUpBandwidthKbps = netCapabilities.linkUpBandwidthKbps
        this.linkDownBandwidthKbps = netCapabilities.linkDownBandwidthKbps
        this.bearedTypeSize = netCapabilities.bearerTypes.size
        let networkCapArr = netCapabilities.networkCap
        this.networkCapSize = networkCapArr.size
        unsafe {
            this.bearerTypes = cjArr2CArr<NetBearType, Int32>(netCapabilities.bearerTypes, {enums => enums.getValue()})
            try {
                this.networkCap = cjArr2CArr<NetCap, Int32>(networkCapArr, {enums => enums.getValue()})
            } catch (e: Exception) {
                LibC.free<Int32>(bearerTypes)
                throw BusinessException(2100003, getErrorMsg(2100003))
            }
        }
    }

    init() {
        this.linkUpBandwidthKbps = 0
        this.linkDownBandwidthKbps = 0
        this.bearedTypeSize = 0
        this.networkCapSize = 0
        this.bearerTypes = CPointer<Int32>()
        this.networkCap = CPointer<Int32>()
    }

    func free(): Unit {
        unsafe {
            LibC.free<Int32>(bearerTypes)
            LibC.free<Int32>(networkCap)
        }
    }
}

@C
struct CNetCapabilityInfo {
    CNetCapabilityInfo(
        let netHandle: Int32,
        let netCap: CNetCapabilities
    ) {}

    func free(): Unit {
        unsafe { netCap.free() }
    }
}

@C
struct CConnectionProperties {
    var interfaceName: CString = CString(CPointer<UInt8>())
    var domains: CString = CString(CPointer<UInt8>())
    var linkAddressSize: Int64 = 0
    var dnsSize: Int64 = 0
    var routeSize: Int64 = 0
    var mtu: UInt16 = 0
    var linkAddresses: CPointer<CLinkAddress> = CPointer<CLinkAddress>()
    var dnses: CPointer<CNetAddress> = CPointer<CNetAddress>()
    var routes: CPointer<CRouteInfo> = CPointer<CRouteInfo>()

    func free(): Unit {
        unsafe {
            LibC.free(interfaceName)
            LibC.free(domains)
            if (linkAddresses.isNotNull()) {
                for (i in 0..linkAddressSize) {
                    linkAddresses.read(i).free()
                }
            }
            LibC.free<CLinkAddress>(linkAddresses)
            if (dnses.isNotNull()) {
                for (i in 0..dnsSize) {
                    dnses.read(i).free()
                }
            }
            if (routes.isNotNull()) {
                for (i in 0..routeSize) {
                    routes.read(i).free()
                }
            }
            LibC.free<CNetAddress>(dnses)
            LibC.free<CRouteInfo>(routes)
        }
    }
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
