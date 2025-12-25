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

package ohos.net.web_socket

import std.collection.HashMap
import ohos.ffi.cArr2cjArr
import ohos.labels.{APILevel, Hide}

/**
 * The clientCert field of the client certificate, which includes three attributes:
 * client certificate (certPath) and only support PEM format, certificate private key (keyPath), 
 * and passphrase (keyPassword).
 */
@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public class ClientCert {
    /**
     * The path to the client certificate file.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var certPath: String

    /**
     * The path of the client certificate private key file.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var keyPath: String

    /**
     * Client certificate password.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var keyPassword: String
    
    /**
     * ClientCert constructor.
     *
     * @param { String } certPath - The path to the client certificate file.
     * @param { String } keyPath - The path of the client certificate private key file.
     * @param { String } [ keyPassword ] - Client certificate password.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public init(certPath: String, keyPath: String, keyPassword!: String = "") {
        this.certPath = certPath
        this.keyPath = keyPath
        this.keyPassword = keyPassword
    }

    func toCClientCert(): CClientCert {
        var cert = CClientCert(CString(CPointer()), CString(CPointer()), CString(CPointer()))
        try {
            unsafe {
                cert.certPath = LibC.mallocCString(certPath)
                cert.keyPath = LibC.mallocCString(keyPath)
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
 * Defines the optional parameters carried in the request for establishing a WebSocket connection.
 */
@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public class WebSocketRequestOptions {
    /**
     * HTTP request header.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var header: HashMap<String, String>

    /**
     * File path for client cert.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var caPath: String

    @!Hide
    var skipServerCertVerification: Bool = false

    /**
     * Client cert.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var clientCert: ClientCert

    /**
     * HTTP proxy configuration. Use 'system' if this filed is not set.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var proxy: ProxyConfiguration

    /**
     * Self defined protocol.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var protocol: String

    /**
     * WebSocketRequestOptions constructor.
     *
     * @param { HashMap<String, String> } [ header ] - HTTP request header.
     * @param { String } [ caPath ] - File path for client cert.
     * @param { ClientCert } [ clientCert ] - Client cert.
     * @param { ProxyConfiguration } [ proxy ] - HTTP proxy configuration. Use 'system' if this filed is not set.
     * @param { String } [ protocol ] - Self defined protocol.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public init(header!: HashMap<String, String> = HashMap<String, String>(), caPath!: String = "/etc/ssl/certs/cacert.pem",
        clientCert!: ClientCert = ClientCert("", ""), proxy!: ProxyConfiguration = System, protocol!: String = "") {
        this.header = header
        this.caPath = caPath
        this.clientCert = clientCert
        this.proxy = proxy
        this.protocol = protocol
    }
}

/**
 * The result for closing a WebSocket connection.
 */
@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public class CloseResult {
    /**
     * Error code.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var code: UInt32

    /**
     * Error cause.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var reason: String

    init(code: UInt32, reason: String) {
        this.code = code
        this.reason = reason
    }
}

/**
 * Defines the optional parameters carried in the request for closing a WebSocket connection.
 */
@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public class WebSocketCloseOptions {
    /**
     * Error code.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var code: UInt32

    /**
     * Error cause.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public var reason: String

    /**
     * CloseResult constructor.
     *
     * @param { UInt32 } code - Error code.
     * @param { String } reason - Error cause.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public init(code!: UInt32 = 1000, reason!: String = "") {
        this.code = code
        this.reason = reason
    }
}

open class Response {
    Response(
        var code: Int32,
        var `type`: OnOffType
    ) {}

    init() {
        this(0, OnOffType.OPEN)
    }

    init(v: CWebSocketCallbackData) {
        this(v.code, OnOffType.parse(v.typeId))
    }

    static func parseCResponseData<T>(data: CPointer<UInt8>, dataLen: Int32): T where T <: CType {
        let size = Int32(unsafe { sizeOf<T>() })
        if (size < dataLen) {
            throw Exception("Data length mismatch, ${size}:${dataLen}.")
        }
        unsafe { CPointer<T>(data).read() }
    }
}

class OpenResponse <: Response {
    OpenResponse(var value: HashMap<UInt32, String>) {}

    init(v: CWebSocketCallbackData) {
        super(v.code, OnOffType.parse(v.typeId))
        let data = Response.parseCResponseData<COpenResponse>(v.data, v.dataLen)
        unsafe {
            this.value = HashMap<UInt32, String>(1)
            value.add(data.status, data.message.toString())
        }
    }
}

class MessageResponse <: Response {
    MessageResponse(var value: MessageData) {}

    init(v: CWebSocketCallbackData) {
        super(v.code, OnOffType.parse(v.typeId))
        let data = Response.parseCResponseData<CMessageResponse>(v.data, v.dataLen)
        let resultType = MessageDataType.parse(data.resultType)
        unsafe {
            value = match (resultType) {
                case STRING => StringData(CString(data.result.head).toString())
                case ARRAY_BUFFER => ArrayData(cArr2cjArr<UInt8, UInt8>(data.result.size, data.result.head, {i => i}))
            }
        }
    }
}

class ErrorResponse <: Response {
    ErrorResponse(
        var errCode: Int32,
        var httpResponse: UInt32
    ) {}

    init(v: CWebSocketCallbackData) {
        super(v.code, OnOffType.parse(v.typeId))
        let data = Response.parseCResponseData<CErrorResponse>(v.data, v.dataLen)
        unsafe {
            errCode = data.code
            httpResponse = data.httpResponse
        }
    }
}

class CloseResponse <: Response {
    CloseResponse(var value: CloseResult) {}

    init(v: CWebSocketCallbackData) {
        super(v.code, OnOffType.parse(v.typeId))
        let data = Response.parseCResponseData<CCloseResponse>(v.data, v.dataLen)
        unsafe {
            value = CloseResult(data.code, data.reason.toString())
        }
    }
}

class HeaderReceiveResponse <: Response {
    HeaderReceiveResponse(var value: ResponseHeaders) {}

    init(v: CWebSocketCallbackData) {
        super(v.code, OnOffType.parse(v.typeId))
        let data = Response.parseCResponseData<CReceiveResponse>(v.data, v.dataLen)
        let headerType = ResponseHeadersType.parse(data.headerType)
        unsafe {
            value = match (headerType) {
                case MAP => MapData(cArrString2Map(data.header))
                case ARRAY_STRING => ArrayStringData(
                    cArr2cjArr<CString, String>(data.header.size, data.header.head, {cstr => cstr.toString()}))
                case _ => ResponseHeaders.UndefinedData
            }
        }
    }
}
