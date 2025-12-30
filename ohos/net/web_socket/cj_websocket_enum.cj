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
import ohos.labels.APILevel
import ohos.ffi.{CArrUI8, cjArr2CArr}
import ohos.business_exception.BusinessException
import ohos.net.connection.HttpProxy

/**
 * HTTP proxy configuration.
 * system: means that use system proxy configuration.
 * no-proxy: means do not use proxy.
 * object of @type {connection.HttpProxy} means providing custom proxy settings
 */
@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public enum ProxyConfiguration {
    /**
     * means that use system proxy configuration.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    NoProxy
    |
    /**
     * means do not use proxy.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    System
    |
    /**
     * use HttpProxy.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    HttpProxyConfiguration(HttpProxy)
    | ...
}

/**
 * HTTP response headers.
 */
@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public enum ResponseHeaders {
    /**
     * Map data.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    MapData(HashMap<String, String>)
    |
    /**
     * Array data.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    ArrayStringData(Array<String>)
    |
    /**
     * Undefined data.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    UndefinedData
    | ...
}

enum ResponseHeadersType {
    MAP
    | ARRAY_STRING
    | UNDEFINED

    func getValue(): Int32 {
        match (this) {
            case MAP => 0
            case ARRAY_STRING => 1
            case UNDEFINED => 2
        }
    }

    static func parse(val: Int32): ResponseHeadersType {
        return if (val == 0) {
            MAP
        } else if (val == 1) {
            ARRAY_STRING
        } else {
            UNDEFINED
        }
    }
}

enum OnOffType {
    OPEN
    |
    MESSAGE
    |
    CLOSE
    |
    ERROR
    |
    DATAEND
    |
    HEADERRECEIVE
    | ...

    prop value: Int32 {
        get() {
            match (this) {
                case OPEN => 1
                case MESSAGE => 2
                case CLOSE => 3
                case ERROR => 4
                case DATAEND => 5
                case HEADERRECEIVE => 6
                case _ => throw BusinessException(2100001, "Invalid parameter value.")
            }
        }
    }

    static func parse(val: Int32) {
        match (val) {
            case 1 => OPEN
            case 2 => MESSAGE
            case 3 => CLOSE
            case 4 => ERROR
            case 5 => DATAEND
            case 6 => HEADERRECEIVE
            case _ => throw BusinessException(2100001, "Invalid parameter value.")
        }
    }
}

enum MessageDataType {
    STRING
    | ARRAY_BUFFER

    func getValue(): Int32 {
        match (this) {
            case STRING => 0
            case ARRAY_BUFFER => 1
        }
    }

    static func parse(val: Int32): MessageDataType {
        return if (val == 0) {
            STRING
        } else {
            ARRAY_BUFFER
        }
    }
}

/**
 * Message data.
 */
@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public enum MessageData {
    /**
     * String data.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    StringData(String)
    |
    /**
     * Array data.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    ArrayData(Array<Byte>)
    | ...

    func getData(): Array<UInt8> {
        match (this) {
            case StringData(str) => unsafe { str.rawData() }
            case ArrayData(arr) => arr
            case _ => throw BusinessException(2100001, "Invalid parameter value.")
        }
    }

    func getCData(): CArrUI8 {
        let data = getData()
        unsafe { CArrUI8(cjArr2CArr<UInt8, UInt8>(data, {i => i}), data.size) }
    }
}
