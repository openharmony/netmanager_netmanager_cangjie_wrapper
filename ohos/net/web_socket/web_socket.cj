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

import ohos.ffi.RemoteDataLite
import std.collection.HashMap
import ohos.business_exception.BusinessException
import ohos.ffi.{Callback1Param, safeMalloc, releaseFFIData, SUCCESS_CODE}
import ohos.callback_invoke.{CallbackObject, Callback1Argument, Callback0Argument}
import ohos.labels.APILevel

/**
 * Creates a web socket connection.
 * @returns { WebSocket } Returns the WebSocket of the createWebSocket.
 */
@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public func createWebSocket(): WebSocket {
    let id = unsafe { FfiOHOSWebSocketCreateWebSocket() }
    WebSocket(id)
}

/**
 * Defines a WebSocket object. Before invoking WebSocket APIs,
 * you need to call webSocket.createWebSocket to create a WebSocket object.</p>
 */
@!APILevel[
    since: "24",
    syscap: "SystemCapability.Communication.NetStack"
]
public class WebSocket <: RemoteDataLite {
    let onWebSocketManager = WebSocketManager()

    // id is RemoteData id, it`s not register to global map
    // will be released when close called
    WebSocket(private let id: Int64) {
        super(id)
    }

    ~init() {
        releaseFFIData(myDataId)
    }

    /**
     * Initiates a WebSocket request to establish a WebSocket connection to a given URL.
     *
     * @param { String } url - URL for establishing a WebSocket connection.
     * @param { WebSocketRequestOptions } [ options ] - Optional parameters {@link WebSocketRequestOptions}.
     * @returns { Bool } Returns whether the connection was successful.
     * @throws { BusinessException } 201 - Permission denied.
     * @throws { BusinessException } 2302001 - Websocket url error.
     * @throws { BusinessException } 2302002 - Websocket certificate file does not exist.
     * @throws { BusinessException } 2302003 - Websocket connection already exists.
     * @throws { BusinessException } 2302998 - It is not allowed to access this domain.
     * @throws { BusinessException } 2302999 - Internal error.
     */
    @!APILevel[
        since: "24",
        permission: "ohos.permission.INTERNET",
        syscap: "SystemCapability.Communication.NetStack",
        throwexception: true,
        workerthread: true
    ]
    public func connect(url: String, options!: WebSocketRequestOptions = WebSocketRequestOptions()): Bool {
        let (c_url, optPtr) = unsafe { parseConnectParam(url, options) }
        let ret = unsafe {
            FfiOHOSWebSocketConnect(id, c_url, optPtr)
        }
        unsafe {
            LibC.free(c_url)
            if (optPtr.isNotNull()) {
                optPtr.read().free()
                LibC.free<CWebSocketRequestOptions>(optPtr)
            }
        }
        if (ret.code != SUCCESS_CODE) {
            throw BusinessException(ret.code, getErrorMsg(ret.code))
        }
        return ret.data
    }

    /**
     * Sends data through a WebSocket connection.
     *
     * @param { MessageData } data - Data to send.
     * @returns { Bool } Returns whether sending the request was successful.
     * @throws { BusinessException } 201 - Permission denied.
     */
    @!APILevel[
        since: "24",
        permission: "ohos.permission.INTERNET",
        syscap: "SystemCapability.Communication.NetStack",
        throwexception: true,
        workerthread: true
    ]
    public func send(data: MessageData): Bool {
        let cMsg = unsafe { data.getCData() }
        let stringType = match (data) {
            case StringData(str) => true
            case ArrayData(arr) => false
            case _ => throw BusinessException(2100001, "Invalid parameter value.")
        }
        let ret = unsafe {
            FfiOHOSWebSocketSend(id, cMsg, stringType)
        }
        unsafe {
            LibC.free<UInt8>(cMsg.head)
        }
        if (ret.code != SUCCESS_CODE) {
            throw BusinessException(ret.code, getErrorMsg(ret.code))
        }
        return ret.data
    }

    /**
     * Closes a WebSocket connection.
     *
     * @param { WebSocketCloseOptions } [ options ] - Optional parameters {@link WebSocketCloseOptions}.
     * @returns { Bool } Returns whether the close request was created successfully.
     * @throws { BusinessException } 201 - Permission denied.
     */
    @!APILevel[
        since: "24",
        permission: "ohos.permission.INTERNET",
        syscap: "SystemCapability.Communication.NetStack",
        throwexception: true,
        workerthread: true
    ]
    public func close(options!: WebSocketCloseOptions = WebSocketCloseOptions()): Bool {
        let optPtr = unsafe { parseCloseParam(options) }
        let ret = unsafe {
            FfiOHOSWebSocketClose(id, optPtr)
        }
        unsafe {
            if (optPtr.isNotNull()) {
                optPtr.read().free()
                LibC.free<CWebSocketCloseOptions>(optPtr)
            }
        }
        if (ret.code != SUCCESS_CODE) {
            throw BusinessException(ret.code, getErrorMsg(ret.code))
        }
        return ret.data
    }

    /**
     * Enables listening for the open events of a WebSocket connection.
     *
     * @param { Callback1Argument<HashMap<UInt32, String>> } callback - the callback used to return the result.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func onOpen(callback: Callback1Argument<HashMap<UInt32, String>>): Unit {
        onMethod(OnOffType.OPEN, callback)
    }

    /**
     * Cancels listening for the open events of a WebSocket connection.
     *
     * @param { ?Callback1Argument<HashMap<UInt32, String>> } [ callback ] - the callback used to return the result.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func offOpen(callback!: ?Callback1Argument<HashMap<UInt32, String>> = None): Unit {
        match (callback) {
            case Some(cb) => off(OnOffType.OPEN, cb)
            case None => offAll(OnOffType.OPEN)
        }
    }

    /**
     * Enables listening for the message events of a WebSocket connection.
     *
     * @param { Callback1Argument<MessageData> } callback - the callback used to return the result.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func onMessage(callback: Callback1Argument<MessageData>): Unit {
        onMethod(OnOffType.MESSAGE, callback)
    }

    /**
     * Cancels listening for the message events of a WebSocket connection.
     *
     * @param { ?Callback1Argument<MessageData> } [ callback ] - the callback used to return the result.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func offMessage(callback!: ?Callback1Argument<MessageData> = None): Unit {
        match (callback) {
            case Some(cb) => off(OnOffType.MESSAGE, cb)
            case None => offAll(OnOffType.MESSAGE)
        }
    }

    /**
     * Enables listening for the close events of a WebSocket connection.
     *
     * @param { Callback1Argument<CloseResult> } callback - the callback used to return the result.
     * <br>close indicates the close error code and reason indicates the error code description.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func onWebSocketClose(callback: Callback1Argument<CloseResult>): Unit {
        onMethod(OnOffType.CLOSE, callback)
    }

    /**
     * Cancels listening for the close events of a WebSocket connection.
     *
     * @param { ?Callback1Argument<CloseResult> } [ callback ] - the callback used to return the result.
     * <br>close indicates the close error code and reason indicates the error code description.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func offWebSocketClose(callback!: ?Callback1Argument<CloseResult> = None): Unit {
        match (callback) {
            case Some(cb) => off(OnOffType.CLOSE, cb)
            case None => offAll(OnOffType.CLOSE)
        }
    }

    /**
     * Enables listening for the error events of a WebSocket connection.
     *
     * @param { Callback0Argument } callback - the callback used to return the result.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func onWebSocketError(callback: Callback0Argument): Unit {
        onMethod(OnOffType.ERROR, callback)
    }

    /**
     * Cancels listening for the error events of a WebSocket connection.
     *
     * @param { ?Callback0Argument } [ callback ] - the callback used to return the result.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func offWebSocketError(callback!: ?Callback0Argument = None): Unit {
        match (callback) {
            case Some(cb) => off(OnOffType.ERROR, cb)
            case None => offAll(OnOffType.ERROR)
        }
    }

    /**
     * Enables listening for receiving data ends events of a WebSocket connection.
     *
     * @param { Callback0Argument } callback - the callback used to return the result.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func onDataEnd(callback: Callback0Argument): Unit {
        onMethod(OnOffType.DATAEND, callback)
    }

    /**
     * Cancels listening for receiving data ends events of a WebSocket connection.
     *
     * @param { ?Callback0Argument } [ callback ] - the callback used to return the result.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func offDataEnd(callback!: ?Callback0Argument = None): Unit {
        match (callback) {
            case Some(cb) => off(OnOffType.DATAEND, cb)
            case None => offAll(OnOffType.DATAEND)
        }
    }

    /**
     * Registers an observer for HTTP Response Header events.
     *
     * @param { Callback1Argument<ResponseHeaders> } callback - the callback used to return the result.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func onHeaderReceive(callback: Callback1Argument<ResponseHeaders>): Unit {
        onMethod(OnOffType.HEADERRECEIVE, callback)
    }

    /**
     * Unregisters the observer for HTTP Response Header events.
     *
     * @param { ?Callback1Argument<ResponseHeaders> } [ callback ] - the callback used to return the result.
     */
    @!APILevel[
        since: "24",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func offHeaderReceive(callback!: ?Callback1Argument<ResponseHeaders> = None): Unit {
        match (callback) {
            case Some(cb) => off(OnOffType.HEADERRECEIVE, cb)
            case None => offAll(OnOffType.HEADERRECEIVE)
        }
    }

    func off(`type`: OnOffType, callback: CallbackObject): Unit {
        if (!onWebSocketManager.isWebSocketOn(`type`)) {
            return
        }
        let size = removeCallback(`type`, callback)
        if (size > 0) {
            return
        }
    }

    func offAll(`type`: OnOffType): Unit {
        if (!onWebSocketManager.isWebSocketOn(`type`)) {
            return
        }
        let size = removeAllCallback(`type`)
        if (size > 0) {
            return
        }
    }

    private func onMethod(`type`: OnOffType, callback: CallbackObject): Unit {
        let lambdaData = Callback1Param<CPointer<CWebSocketCallbackData>, Unit>(dataCallbackImpl)
        let ret: Int32 = unsafe {
            FfiOHOSWebSocketOnController(id, `type`.value, lambdaData.getID())
        }
        checkRet(ret, "[WebSocket] on: ");
        onWebSocketManager.getOrCreate(`type`).on(callback)
    }

    private func dataCallbackImpl(data: CPointer<CWebSocketCallbackData>): Unit {
        WEB_SOCKET_LOG.info("dataCallbackImpl is start.")
        if (data.isNull()) {
            WEB_SOCKET_LOG.error("CWebSocketCallbackData is nullptr.")
            return
        }

        let callbackData = unsafe { data.read() }
        let responseData = match (callbackData.convertToResponseOption()) {
            case None =>
                WEB_SOCKET_LOG.error("convertToResponse error")
                return
            case Some(v) => v
        }

        let onCallbackListOpt = onWebSocketManager.get(responseData.`type`.value)?.getAllCallbacks()
        emitWebSocketCallback(responseData.`type`.value, onCallbackListOpt, responseData)
    }

    private func removeCallback(`type`: OnOffType, callback: CallbackObject): Int64 {
        if (!WebSocketManager.isMatchType(`type`, callback)) {
            throw BusinessException(PARAM_INVALID, getErrorMsg(PARAM_INVALID))
        }

        let list = onWebSocketManager.getOrCreate(`type`)
        list.off(callback)
        if (list.isEmpty()) {
            onWebSocketManager.remove(`type`)
            let ret = unsafe {
                FfiOHOSWebSocketOffController(id, `type`.value)
            }
            checkRet(ret, "[WebSocket] removeCallback type = ${`type`.value.toString()}");
            return 0
        }

        return list.size()
    }

    private func removeAllCallback(`type`: OnOffType): Int64 {
        onWebSocketManager.remove(`type`)
        let ret = unsafe {
            FfiOHOSWebSocketOffController(id, `type`.value)
        }
        checkRet(ret, "[WebSocket] removeAllCallback: ");
        0
    }
}

private unsafe func parseConnectParam(url: String, options: WebSocketRequestOptions): (CString, CPointer<CWebSocketRequestOptions>) {
    let c_url = LibC.mallocCString(url)
    let ptr = safeMalloc<CWebSocketRequestOptions>(1) {LibC.free(c_url)}
    try {
        ptr.write(CWebSocketRequestOptions(options))
    } catch (e: Exception) {
        LibC.free(c_url)
        LibC.free(ptr)
        throw e
    }
    return (c_url, ptr)
}

private unsafe func parseCloseParam(options: WebSocketCloseOptions): CPointer<CWebSocketCloseOptions> {
    let ptr = safeMalloc<CWebSocketCloseOptions>()
    try {
        ptr.write(CWebSocketCloseOptions(options))
    } catch (e: Exception) {
        LibC.free(ptr)
        throw e
    }
    return ptr
}
