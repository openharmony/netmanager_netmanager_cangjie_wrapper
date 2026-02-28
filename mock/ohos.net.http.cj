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

package ohos.net.http

import ohos.labels.APILevel
import ohos.callback_invoke.{CallbackObject, Callback0Argument, Callback1Argument}
import std.collection.{HashMap, ArrayList}
import ohos.net.connection.HttpProxy
import ohos.business_exception.AsyncCallback

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public enum HttpRequestEvent {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    HeadersReceive
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    DataReceive
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    DataEnd
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    DataReceiveProgress
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    DataSendProgress
    | ...
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public enum RequestMethod {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Options
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Get
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Head
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Post
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Put
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Delete
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Trace
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Connect
    | ...
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public enum HttpProtocol {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Http1_1
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Http2
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Http3
    | ...
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public enum HttpDataType {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    StringValue
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    ArrayBuffer
    | ...
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public enum HttpData <: ToString {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    StringData(String)
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ] 
    ArrayData(Array<Byte>)
    | ...

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func toString(): String {
        return String()
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public enum UsingProxy {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    NotUse
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    UseDefault
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ] 
    UseSpecified(HttpProxy)
    | ...
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public enum CertType {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Pem
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Der
    |
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    P12
    | ...
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public class HttpRequestOptions {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var method: RequestMethod

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var extraData: HttpData

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var expectDataType: ?HttpDataType

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var usingCache: Bool

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var priority: UInt32

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var header: HashMap<String, String>

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var readTimeout: UInt32

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var connectTimeout: UInt32

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var usingProtocol: ?HttpProtocol

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var usingProxy: UsingProxy

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var caPath: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var resumeFrom: Int64

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var resumeTo: Int64

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var clientCert: ClientCert

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var dnsOverHttps: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var dnsServers: Array<String>

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var maxLimit: UInt32

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var multiFormDataList: Array<MultiFormData>

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public init(method!: RequestMethod = RequestMethod.Get, extraData!: HttpData = HttpData.StringData(""),
        expectDataType!: ?HttpDataType = None, usingCache!: Bool = true, priority!: UInt32 = 1, 
        header!: HashMap<String, String> = HashMap<String, String>(), readTimeout!: UInt32 = 60000, 
        connectTimeout!: UInt32 = 60000, usingProtocol!: ?HttpProtocol = None,
        usingProxy!: UsingProxy = UsingProxy.UseDefault, caPath!: String = "", resumeFrom!: Int64 = 0, 
        resumeTo!: Int64 = 0, clientCert!: ClientCert = ClientCert("",""), dnsOverHttps!: String = "",
        dnsServers!: Array<String> = Array<String>(), maxLimit!: UInt32 = 5 * 1024 * 1024, 
        multiFormDataList!: Array<MultiFormData> = Array<MultiFormData>()) {
        super()
        this.method = method
        this.extraData = extraData
        this.expectDataType = expectDataType
        this.usingCache = usingCache
        this.priority = priority
        this.header = header
        this.readTimeout = readTimeout
        this.connectTimeout = connectTimeout
        this.usingProtocol = usingProtocol
        this.usingProxy = usingProxy
        this.caPath = caPath
        this.resumeFrom = resumeFrom
        this.resumeTo = resumeTo
        this.clientCert = clientCert
        this.dnsOverHttps = dnsOverHttps
        this.dnsServers = dnsServers
        this.maxLimit = maxLimit
        this.multiFormDataList = multiFormDataList
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public class HttpResponse <: ToString {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var result: HttpData
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var resultType: HttpDataType
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var responseCode: UInt32
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var header: HashMap<String, String>
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var cookies: String
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var performanceTiming: PerformanceTiming

    init() {
        super()
        this.responseCode = 0
        this.resultType = HttpDataType.StringValue
        this.result = StringData("")
        this.header = HashMap<String, String>()
        this.cookies = ""
        this.performanceTiming = PerformanceTiming(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func toString(): String {
        return String()
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public class PerformanceTiming {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var dnsTiming: Float64
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var tcpTiming: Float64
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var tlsTiming: Float64
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var firstSendTiming: Float64
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var firstReceiveTiming: Float64
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var totalFinishTiming: Float64
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var redirectTiming: Float64
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var responseHeaderTiming: Float64
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var responseBodyTiming: Float64
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var totalTiming: Float64

    init(dnsTiming: Float64, tcpTiming: Float64, tlsTiming: Float64,
        firstSendTiming: Float64, firstReceiveTiming: Float64, totalFinishTiming: Float64,
        redirectTiming: Float64, responseHeaderTiming: Float64, responseBodyTiming: Float64,
        totalTiming: Float64) {
        super()
        this.dnsTiming = dnsTiming
        this.tcpTiming = tcpTiming
        this.tlsTiming = tlsTiming
        this.firstSendTiming = firstSendTiming
        this.firstReceiveTiming = firstReceiveTiming
        this.totalFinishTiming = totalFinishTiming
        this.redirectTiming = redirectTiming
        this.responseHeaderTiming = responseHeaderTiming
        this.responseBodyTiming = responseBodyTiming
        this.totalTiming = totalTiming
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public class DataReceiveProgressInfo {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var receiveSize: Int64

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var totalSize: Int64

    init(receiveSize: Int64, totalSize: Int64) {
        super()
        this.receiveSize = receiveSize
        this.totalSize = totalSize
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public class DataSendProgressInfo {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var sendSize: Int64

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var totalSize: Int64

    init(sendSize: Int64, totalSize: Int64) {
        super()
        this.sendSize = sendSize
        this.totalSize = totalSize
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public class ClientCert {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var certPath: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var certType: CertType

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var keyPath: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var keyPassword: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public init(certPath: String, keyPath: String, certType!: CertType = CertType.Pem, keyPassword!: String = "") {
        super()
        this.certPath = certPath
        this.keyPath = keyPath
        this.certType = certType
        this.keyPassword = keyPassword
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public class MultiFormData {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var name: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var contentType: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var remoteFileName: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var data: HttpData

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var filePath: String

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public init(name: String, contentType: String,  remoteFileName!: String = "",
        data!: HttpData = HttpData.StringData(""), filePath!: String = "") {
        super()
        this.name = name
        this.contentType = contentType
        this.remoteFileName = remoteFileName
        this.data = data
        this.filePath = filePath
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public func createHttp(): HttpRequest {
    return HttpRequest()
}

const MAX_CACHE_SIZE: UInt32 = 10 * 1024 * 1024

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public func createHttpResponseCache(cacheSize!: UInt32 = MAX_CACHE_SIZE): HttpResponseCache {
    return HttpResponseCache()
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public class HttpRequest {
    @!APILevel[
        since: "22",
        permission: "ohos.permission.INTERNET",
        syscap: "SystemCapability.Communication.NetStack",
        throwexception: true
    ]
    public func request(url: String, options: HttpRequestOptions, callback: AsyncCallback<HttpResponse>): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        permission: "ohos.permission.INTERNET",
        syscap: "SystemCapability.Communication.NetStack",
        throwexception: true
    ]
    public func request(url: String, callback: AsyncCallback<HttpResponse>): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        permission: "ohos.permission.INTERNET",
        syscap: "SystemCapability.Communication.NetStack",
        throwexception: true
    ]
    public func requestInStream(url: String, options: HttpRequestOptions, callback: AsyncCallback<UInt32>): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        permission: "ohos.permission.INTERNET",
        syscap: "SystemCapability.Communication.NetStack",
        throwexception: true
    ]
    public func requestInStream(url: String, callback: AsyncCallback<UInt32>): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func destroy(): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack",
        throwexception: true
    ]
    public func on(event: HttpRequestEvent, callback: Callback1Argument<HashMap<String, String>>): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack",
        throwexception: true
    ]
    public func once(event: HttpRequestEvent, callback: Callback1Argument<HashMap<String, String>>): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack",
        throwexception: true
    ]
    public func on(event: HttpRequestEvent, callback: Callback1Argument<Array<Byte>>): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack",
        throwexception: true
    ]
    public func on(event: HttpRequestEvent, callback: Callback0Argument): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack",
        throwexception: true
    ]
    public func on(event: HttpRequestEvent, callback: Callback1Argument<DataReceiveProgressInfo>): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack",
        throwexception: true
    ]
    public func on(event: HttpRequestEvent, callback: Callback1Argument<DataSendProgressInfo>): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack",
        throwexception: true
    ]
    public func off(event: HttpRequestEvent, callback!: ?CallbackObject = None): Unit {
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
    public func onDataReceive(callback: Callback1Argument<Array<Byte>>): Unit {
        return ()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func offDataReceive(callback!: ?Callback1Argument<Array<Byte>> = None): Unit {
        return ()
    }

    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func onceHeadersReceive(callback: Callback1Argument<HashMap<String, String>>): Unit {
        return ()
    }
}

@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public class HttpResponseCache {
    init() {}

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack",
        workerthread: true
    ]
    public func flush(): Unit {
        return ()
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack",
        workerthread: true
    ]
    public func delete(): Unit {
        return ()
    }
}

extend HttpRequestEvent <: Equatable<HttpRequestEvent> {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public operator func ==(other: HttpRequestEvent): Bool {
        return true
    }

    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public operator func !=(other: HttpRequestEvent): Bool {
        return true
    }
}

extend HttpRequestEvent <: Hashable {
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func hashCode(): Int64 {
        return 0
    }
}