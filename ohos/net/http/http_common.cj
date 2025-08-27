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

package ohos.net.http

import ohos.labels.*
import ohos.ffi.*
import ohos.net.connection.HttpProxy
import std.collection.*
import std.deriving.Derive

/**
 * http request event type.
 */
@Derive[Equatable, Hashable]
@!APILevel[
    21,
    stagemodelonly: true,
    syscap: "SystemCapability.Communication.NetStack"
]
public enum HttpRequestEvent {
    /**
     * headersReceive
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    HeadersReceive
    |
    /**
     * dataReceive
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    DataReceive
    |
    /**
     * dataEnd
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    DataEnd
    |
    /**
     * dataReceiveProgress
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    DataReceiveProgress
    |
    /**
     * dataSendProgress
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    DataSendProgress
    | ...
}

/**
 * Defines an HTTP request method.
 * @relation export enum RequestMethod
 */
@!APILevel[
    21,
    stagemodelonly: true,
    syscap: "SystemCapability.Communication.NetStack"
]
public enum RequestMethod {
    /**
     * OPTIONS method.
     * @relation OPTIONS = "OPTIONS"
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Options
    /**
     * GET method.
     * @relation GET = "GET"
     */
    | @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Get
    /**
     * HEAD method.
     * @relation HEAD = "HEAD"
     */
    | @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Head
    /**
     * POST method.
     * @relation POST = "POST"
     */
    | @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Post
    /**
     * PUT method.
     * @relation PUT = "PUT"
     */
    | @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Put
    /**
     * DELETE method.
     * @relation DELETE = "DELETE"
     */
    | @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Delete
    /**
     * TRACE method.
     * @relation TRACE = "TRACE"
     */
    | @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Trace
    /**
     * CONNECT method.
     * @relation CONNECT = "CONNECT"
     */
    | @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Connect
    | ...

    func getValue(): String {
        match (this) {
            case Options => "OPTIONS"
            case Get => "GET"
            case Head => "HEAD"
            case Post => "POST"
            case Put => "PUT"
            case Delete => "DELETE"
            case Trace => "TRACE"
            case Connect => "CONNECT"
            case _ => throw IllegalArgumentException("The type is not supported.")
        }
    }
}

/**
  * Supported protocols.
  * @relation export enum HttpProtocol
  */
@!APILevel[
    21,
    stagemodelonly: true,
    syscap: "SystemCapability.Communication.NetStack"
]
public enum HttpProtocol {
    /**
    * Protocol http1.1
    * @relation HTTP1_1
    */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Http1_1
    /**
     * Protocol http2
     * @relation HTTP2
     */
    | @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Http2
    /**
     * Protocol http3 for https only.
     * @relation HTTP3
     */
    | @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Http3
    | ...

    func getValue(): Int32 {
        match (this) {
            case Http1_1 => 0
            case Http2 => 1
            case Http3 => 2
            case _ => throw IllegalArgumentException("The type is not supported.")
        }
    }
}

/**
  * Indicates the type of the returned data.
  * @relation export enum HttpDataType
  */
@!APILevel[
    21,
    stagemodelonly: true,
    syscap: "SystemCapability.Communication.NetStack"
]
public enum HttpDataType {
    /**
     * The returned type is string.
     * @relation STRING
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    StringValue
    /**
     * The returned type is ArrayBuffer.
     * @relation ARRAY_BUFFER
     */
    | @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    ArrayBuffer
    | ...

    func getValue(): Int32 {
        match (this) {
            case StringValue => 0
            case ArrayBuffer => 2
            case _ => throw IllegalArgumentException("The type is not supported.")
        }
    }

    static func parse(val: Int32): HttpDataType {
        return if (val == 0) {
            StringValue
        } else {
            ArrayBuffer
        }
    }
}

/**
  * Indicates the type of http data.
  * @relation string | Object | ArrayBuffer
  */
@!APILevel[
    21,
    stagemodelonly: true,
    syscap: "SystemCapability.Communication.NetStack"
]
public enum HttpData {
    /**
     * The returned type is string.
     * @relation STRING
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    StringData(String)
    | @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    /**
     * The returned type is ArrayBuffer.
     * @relation ARRAY_BUFFER
     */
    ArrayData(Array<Byte>)
    | ...

    func getData(): Array<UInt8> {
        match (this) {
            case StringData(str) => unsafe { str.rawData() }
            case ArrayData(arr) => arr
            case _ => throw IllegalArgumentException("The type is not supported.")
        }
    }

    func getCData(): CArrUI8 {
        let data = getData()
        unsafe { CArrUI8(cjArr2CArr<UInt8, UInt8>(data, {i => i}), data.size) }
    }
}

/**
 * Enum for proxy using
 */
@!APILevel[
    21,
    stagemodelonly: true,
    syscap: "SystemCapability.Communication.NetStack"
]
public enum UsingProxy {
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    /*not use HttpProxy*/
    NotUse
    | @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    /*use default HttpProxy*/
    UseDefault
    | @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    /*use HttpProxy*/
    UseSpecified(HttpProxy)
    | ...
}
/**
 * Enum for certificate types
 * @relation export enum CertType
 */
@!APILevel[
    21,
    stagemodelonly: true,
    syscap: "SystemCapability.Communication.NetStack"
]
public enum CertType {
    /**
     * PEM format certificate
     * @relation PEM
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Pem
    /**
     * DER format certificate
     * @relation DER
     */
    | @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    Der
    /**
     * P12 format certificate
     * @relation P12
     */
    | @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    P12
    | ...

    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    func getValue(): String {
        match (this) {
            case Pem => "PEM"
            case Der => "DER"
            case P12 => "P12"
            case _ => throw IllegalArgumentException("The type is not supported.")
        }
    }
}

/**
 * Specifies the type and value range of the optional parameters in the HTTP request.
 * @relation export interface HttpRequestOptions
 */
@!APILevel[
    21,
    stagemodelonly: true,
    syscap: "SystemCapability.Communication.NetStack"
]
public class HttpRequestOptions {
    /**
     * Request method,default is GET.
     * @relation method?: RequestMethod
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var method: RequestMethod

    /**
     * Additional data of the request.
     * extraData can be a string or an Object (API 6) or an ArrayBuffer(API 8).
     * @relation extraData?: string | Object | ArrayBuffer
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var extraData: HttpData

    /**
     * Data type to be returned. If this parameter is set, the system preferentially returns the specified type.
     * @relation expectDataType?: HttpDataType
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var expectDataType: ?HttpDataType

    /**
     * default is true
     * @relation usingCache?: boolean
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var usingCache: Bool

    /**
     * [1, 1000], default is 1.
     * @relation priority?: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var priority: UInt32

    /**
     * HTTP request header. default is 'content-type': 'application/json'
     * @relation header?: Object
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var header: HashMap<String, String>

    /**
     * Read timeout period. The default value is 60,000, in ms.
     * @relation readTimeout?: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var readTimeout: UInt32

    /**
     * Connection timeout interval. The default value is 60,000, in ms.
     * @relation connectTimeout?: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var connectTimeout: UInt32

    /**
     * default is automatically specified by the system.
     * @relation usingProtocol?: HttpProtocol
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var usingProtocol: ?HttpProtocol

    /**
     * If this parameter is set as type of boolean, the system will use default proxy or not use proxy.
     * If this parameter is set as type of HttpProxy, the system will use the specified HttpProxy.
     * @relation usingProxy?: boolean | HttpProxy
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var usingProxy: UsingProxy

    /**
     * If this parameter is set, the system will use ca path specified by user, or else use preset ca by the system.
     * @relation caPath?: string
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var caPath: String

    /**
     * Used to set to uploading or downloading the start bytes. The default value is 0.
     * HTTP standard (RFC 7233 section 3.1) allows servers to ignore range requests.
     * For HTTP PUT uploads this option should not be used, since it may conflict with other options.
     * @relation resumeFrom?: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var resumeFrom: Int64

    /**
     * Used to set to uploading or downloading the end bytes. Translate to the end if not set.
     * HTTP standard (RFC 7233 section 3.1) allows servers to ignore range requests.
     * For HTTP PUT uploads this option should not be used, since it may conflict with other options.
     * @relation resumeTo?: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var resumeTo: Int64

    /**
     * Support the application to pass in client certificates, allowing the server to verify the client's identity.
     * @relation clientCert?: ClientCert
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var clientCert: ClientCert

    /**
     * If this parameter is set, incoming DNS resolution server URL for the DoH server to use for name resolving.
     * The parameter must be URL-encoded in the following format: "https://host:port/path".
     * It MUST specify an HTTPS URL.
     * @relation dnsOverHttps?: string
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var dnsOverHttps: String

    /**
     * If this parameter is set, use the specified DNS server for DNS resolution.
     * Multiple DNS resolution servers can be set up, with a maximum of 3 servers.
     * Only take the first three if there are more than three.
     * @relation dnsServers?: Array<string>
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var dnsServers: Array<String>

    /**
     * The maximum limit of the response body. The default value is 5 * 1024 * 1024, in Byte.
     * The maximum value is 100 * 1024 *1024, in Byte.
     * @relation maxLimit?: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var maxLimit: UInt32

    /**
     * The data fields which is supported by the HTTP protocol to post
     * forms and by the SMTP and IMAP protocols to provide
     * the email data to send/upload.
     * @relation multiFormDataList?: Array<MultiFormData>
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var multiFormDataList: Array<MultiFormData>

    /**
     * init the HttpRequestOptions
     */
    @!APILevel[
        21,
        stagemodelonly: true,
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

/**
 * Defines the response to an HTTP request.
 * @relation export interface HttpResponse 
 */
@!APILevel[
    21,
    stagemodelonly: true,
    syscap: "SystemCapability.Communication.NetStack"
]
public class HttpResponse {
    /**
     * result can be a string (API 6) or an ArrayBuffer(API 8). Object is deprecated from API 8.
     * @relation result: string | Object | ArrayBuffer
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var result: HttpData
    /**
     * If the resultType is string, you can get result directly.
     * If the resultType is Object, you can get result such as this: result['key'].
     * If the resultType is ArrayBuffer, you can use ArrayBuffer to create the binary objects.
     * @relation resultType: HttpDataType
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var resultType: HttpDataType
    /**
     * Server status code.
     * @relation responseCode: ResponseCode | number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var responseCode: UInt32
    /**
     * All headers in the response from the server.
     * @relation header: Object
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var header: HashMap<String, String>
    /**
     * Cookies returned by the server.
     * @relation cookies: string
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var cookies: String

    /**
     * The time taken of various stages of HTTP request.
     * @relation performanceTiming: PerformanceTiming
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var performanceTiming: PerformanceTiming

    init(resp: CHttpResponse) {
        unsafe {
            this.responseCode = resp.responseCode
            this.resultType = HttpDataType.parse(resp.resultType)
            this.result = match (resultType) {
                case StringValue => StringData(CString(resp.result.head).toString())
                case ArrayBuffer => ArrayData(cArr2cjArr<UInt8, UInt8>(resp.result.size, resp.result.head, {i => i}))
                case _ => throw IllegalArgumentException("The type is not supported.")
            }
            this.header = cArrString2Map(resp.header)
            this.cookies = resp.cookies.toString()
            this.performanceTiming = PerformanceTiming(resp.performanceTiming)
            resp.free()
        }
    }
}

/**
 * Counting the time taken of various stages of HTTP request.
 * @relation export interface PerformanceTiming
 */
@!APILevel[
    21,
    stagemodelonly: true,
    syscap: "SystemCapability.Communication.NetStack"
]
public class PerformanceTiming {
    /**
     * Time taken from startup to DNS resolution completion, in milliseconds.
     * @relation dnsTiming: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var dnsTiming: Float64

    /**
     * Time taken from startup to TCP connection completion, in milliseconds.
     * @relation tcpTiming: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var tcpTiming: Float64

    /**
     * Time taken from startup to TLS connection completion, in milliseconds.
     * @relation tlsTiming: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var tlsTiming: Float64

    /**
     * Time taken from startup to start sending the first byte, in milliseconds.
     * @relation firstSendTiming: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var firstSendTiming: Float64

    /**
     * Time taken from startup to receiving the first byte, in milliseconds.
     * @relation firstReceiveTiming: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var firstReceiveTiming: Float64

    /**
     * Time taken from startup to the completion of the request, in milliseconds.
     * @relation totalFinishTiming: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var totalFinishTiming: Float64

    /**
     * Time taken from startup to completion of all redirection steps, in milliseconds.
     * @relation redirectTiming: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var redirectTiming: Float64

    /**
     * Time taken from HTTP request to header completion, in milliseconds.
     * @relation responseHeaderTiming: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var responseHeaderTiming: Float64

    /**
     * Time taken from HTTP Request to body completion, in milliseconds.
     * @relation responseBodyTiming: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var responseBodyTiming: Float64

    /**
     * Time taken from HTTP Request to callback to the application, in milliseconds.
     * @relation totalTiming: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var totalTiming: Float64

    /**
     * init PerformanceTiming
     */
    init(dnsTiming: Float64, tcpTiming: Float64, tlsTiming: Float64,
        firstSendTiming: Float64, firstReceiveTiming: Float64, totalFinishTiming: Float64,
        redirectTiming: Float64, responseHeaderTiming: Float64, responseBodyTiming: Float64,
        totalTiming: Float64) {
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

    init(timing: CPerformanceTiming) {
        this.dnsTiming = timing.dnsTiming
        this.tcpTiming = timing.tcpTiming
        this.tlsTiming = timing.tlsTiming
        this.firstSendTiming = timing.firstSendTiming
        this.firstReceiveTiming = timing.firstReceiveTiming
        this.totalFinishTiming = timing.totalFinishTiming
        this.redirectTiming = timing.redirectTiming
        this.responseHeaderTiming = timing.responseHeaderTiming
        this.responseBodyTiming = timing.responseBodyTiming
        this.totalTiming = timing.totalTiming
    }
}

/**
 * This interface is used to obtain the progress information of file upload or download.
 * @relation export interface DataReceiveProgressInfo
 */
@!APILevel[
    21,
    stagemodelonly: true,
    syscap: "SystemCapability.Communication.NetStack"
]
public class DataReceiveProgressInfo {
    /**
     * Number of data bytes received.
     * @relation receiveSize: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var receiveSize: Int64

    /**
     * Total number of bytes to receive.
     * @relation totalSize: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var totalSize: Int64

    /**
     * init the DataReceiveProgressInfo
     */
    init(receiveSize: Int64, totalSize: Int64) {
        this.receiveSize = receiveSize
        this.totalSize = totalSize
    }

    init(info: CDataReceiveProgressInfo) {
        this.receiveSize = Int64(info.receiveSize)
        this.totalSize = Int64(info.totalSize)
    }
}

/**
 * This interface is used to monitor the progress of sending data.
 * @relation export interface DataSendProgressInfo
 */
@!APILevel[
    21,
    stagemodelonly: true,
    syscap: "SystemCapability.Communication.NetStack"
]
public class DataSendProgressInfo {
    /**
     * Used to specify the data size to be sent.
     * @relation sendSize: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var sendSize: Int64

    /**
     * Total number of bytes to receive.
     * @relation totalSize: number
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var totalSize: Int64
    /**
     * init the DataSendProgressInfo
     */
    init(sendSize: Int64, totalSize: Int64) {
        this.sendSize = sendSize
        this.totalSize = totalSize
    }

    init(info: CDataSendProgressInfo) {
        this.sendSize = Int64(info.sendSize)
        this.totalSize = Int64(info.totalSize)
    }
}

/**
 * The clientCert field of the client certificate, which includes 4 attributes:
 * client certificate (cert), client certificate type (certType), certificate private key (key), and passphrase (keyPassword).
 * @relation export interface ClientCert
 */
@!APILevel[
    21,
    stagemodelonly: true,
    syscap: "SystemCapability.Communication.NetStack"
]
public class ClientCert {
    /**
     * The path to the client certificate file.
     * @relation certPath: string
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var certPath: String

    /**
     * The path of the client certificate private key file.
     * @relation keyPath: string
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var keyPath: String

    /**
     * The type of the client certificate.
     * @relation certType?: CertType
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var certType: CertType

    /**
     * Password required to use the client certificate private key.
     * @relation keyPassword?: string
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var keyPassword: String

    /**
     * init the ClientCert
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public init(certPath: String, keyPath: String, certType!: CertType = CertType.Pem, keyPassword!: String = "") {
        this.certPath = certPath
        this.keyPath = keyPath
        this.certType = certType
        this.keyPassword = keyPassword
    }

    func toCClientCert(): CClientCert {
        var cert = CClientCert(CString(CPointer()), CString(CPointer()), CString(CPointer()), CString(CPointer()))
        try {
            unsafe {
                cert.certPath = LibC.mallocCString(certPath)
                cert.keyPath = LibC.mallocCString(keyPath)
                cert.certType = LibC.mallocCString(certType.getValue())
                cert.keyPassword = mallocStringOp(keyPassword)
            }
        } catch (e: Exception) {
            cert.free()
            throw e
        }
        return cert
    }
}

/**
 * Represents the properties of a form object.
 * @relation export interface MultiFormData
 */
@!APILevel[
    21,
    stagemodelonly: true,
    syscap: "SystemCapability.Communication.NetStack"
]
public class MultiFormData {
    /**
     * MIME name for the data field.
     * @relation name: string
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var name: String

    /**
     * Content type of the data field.
     * @relation contentType: string
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var contentType: String

    /**
     * Remote file name for the data field.
     * @relation remoteFileName?: string
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var remoteFileName: String

    /**
     * This parameter sets a mime part's body content from memory data.
     * @relation data?: string | Object | ArrayBuffer
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var data: HttpData

    /**
     * This parameter sets a mime part's body content from the file's contents.
     * This is an alternative to curl_mime_data for setting data to a mime part.
     * If data is empty, filePath must be set.
     * If data has a value, filePath does not take effect.
     * @relation filePath?: string
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var filePath: String
    /**
     * init the MultiFormData
     */
    @!APILevel[
        21,
        stagemodelonly: true,
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public init(name: String, contentType: String,  remoteFileName!: String = "",
        data!: HttpData = HttpData.StringData(""), filePath!: String = "") {
        this.name = name
        this.contentType = contentType
        this.remoteFileName = remoteFileName
        this.data = data
        this.filePath = filePath
    }
}

func cArrString2Map(cArrString: CArrString): HashMap<String, String> {
    if (cArrString.head.isNull() || cArrString.size == 0) {
        return HashMap<String, String>(0)
    }
    let size = cArrString.size
    let ptr = cArrString.head
    let map = HashMap<String, String>(size / 2)
    for (i in 0..size : 2) {
        unsafe {
            map.add(ptr.read(i).toString(), ptr.read(i + 1).toString())
        }
    }
    map
}

unsafe func map2CArrString(map: HashMap<String, String>): CArrString {
    if (map.isEmpty()) {
        return CArrString(CPointer<CString>(), 0)
    }
    let arrLen = map.size * 2
    var index = 0
    let ptr = safeMalloc<CString>(count: arrLen)
    try {
        for ((k, v) in map) {
            let key = LibC.mallocCString(k)
            ptr.write(index, key)
            index++
            let value = LibC.mallocCString(v)
            ptr.write(index, value)
            index++
        }
    } catch (e: Exception) {
        for (i in 0..index) {
            LibC.free(ptr.read(i))
        }
        LibC.free(ptr)
        throw e
    }
    CArrString(ptr, arrLen)
}
