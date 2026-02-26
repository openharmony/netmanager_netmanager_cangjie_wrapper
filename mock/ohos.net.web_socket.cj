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

package ohos.net.web_socket

import ohos.labels.APILevel
import ohos.net.connection.HttpProxy
import std.collection.{ArrayList, HashMap}
import ohos.callback_invoke.{CallbackObject, Callback1Argument, Callback0Argument}

@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public class ClientCert {
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var certPath: String

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var keyPath: String

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var keyPassword: String

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public init(certPath: String, keyPath: String, keyPassword!: String = "") {
        super()
        this.certPath = certPath
        this.keyPath = keyPath
        this.keyPassword = keyPassword
    }
}

@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public class WebSocketRequestOptions {
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var header: HashMap<String, String>

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var caPath: String

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var clientCert: ClientCert

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var proxy: ProxyConfiguration

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var protocol: String

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public init(header!: HashMap<String, String> = HashMap<String, String>(), caPath!: String = "/etc/ssl/certs/cacert.pem",
        clientCert!: ClientCert = ClientCert("", ""), proxy!: ProxyConfiguration = System, protocol!: String = "") {
        super()
        this.header = header
        this.caPath = caPath
        this.clientCert = clientCert
        this.proxy = proxy
        this.protocol = protocol
    }
}

@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public class CloseResult {
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var code: UInt32

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var reason: String

    init(code: UInt32, reason: String) {
        super()
        this.code = code
        this.reason = reason
    }
}

@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public class WebSocketCloseOptions {
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var code: UInt32

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var reason: String

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public init(code!: UInt32 = 1000, reason!: String = "") {
        super()
        this.code = code
        this.reason = reason
    }
}

@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public enum ProxyConfiguration {
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    NoProxy
    |
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    System
    |
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    HttpProxyConfiguration(HttpProxy)
    | ...
}

@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public enum ResponseHeaders {
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    MapData(HashMap<String, String>)
    |
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    ArrayStringData(Array<String>)
    |
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    UndefinedData
    | ...
}

@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public enum MessageData {
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    StringData(String)
    |
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    ArrayData(Array<Byte>)
    | ...
}

@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public func createWebSocket(): WebSocket {
    WebSocket()
}

@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public class WebSocket {
    @!APILevel[
        since: "24",
        permission: "ohos.permission.INTERNET",
        syscap: "SystemCapability.Communication.NetStack",
        throwexception: true,
        workerthread: true
    ]
    public func connect(url: String, options!: WebSocketRequestOptions = WebSocketRequestOptions()): Bool {
        return true
    }

    @!APILevel[
        since: "24",
        permission: "ohos.permission.INTERNET",
        syscap: "SystemCapability.Communication.NetStack",
        throwexception: true,
        workerthread: true
    ]
    public func send(data: MessageData): Bool {
        return true
    }

    @!APILevel[
        since: "24",
        permission: "ohos.permission.INTERNET",
        syscap: "SystemCapability.Communication.NetStack",
        throwexception: true,
        workerthread: true
    ]
    public func close(options!: WebSocketCloseOptions = WebSocketCloseOptions()): Bool {
        return true
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func onOpen(callback: Callback1Argument<HashMap<UInt32, String>>): Unit {
        return ()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func offOpen(callback!: ?Callback1Argument<HashMap<UInt32, String>> = None): Unit {
        return ()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func onMessage(callback: Callback1Argument<MessageData>): Unit {
        return ()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func offMessage(callback!: ?Callback1Argument<MessageData> = None): Unit {
        return ()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func onWebSocketClose(callback: Callback1Argument<CloseResult>): Unit {
        return ()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func offWebSocketClose(callback!: ?Callback1Argument<CloseResult> = None): Unit {
        return ()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func onWebSocketError(callback: Callback0Argument): Unit {
        return ()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func offWebSocketError(callback!: ?Callback0Argument = None): Unit {
        return ()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func onDataEnd(callback: Callback0Argument): Unit {
        return ()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func offDataEnd(callback!: ?Callback0Argument = None): Unit {
        return ()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func onHeaderReceive(callback: Callback1Argument<ResponseHeaders>): Unit {
        return ()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func offHeaderReceive(callback!: ?Callback1Argument<ResponseHeaders> = None): Unit {
        return ()
    }
}