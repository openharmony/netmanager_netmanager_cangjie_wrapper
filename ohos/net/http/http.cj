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

package ohos.net.http

import ohos.business_exception.{BusinessException, AsyncCallback}
import ohos.callback_invoke.{CallbackObject, Callback0Argument, Callback1Argument}
import ohos.ffi.{CArrString, CArrUI8, SUCCESS_CODE, Callback1Param, safeMalloc, Callback0Param,
    cArr2cjArr}
import ohos.hilog.HilogChannel
import std.collection.{HashMap, ArrayList}
import ohos.labels.APILevel

let HTTP_LOG = HilogChannel(0, 0xD0015B0, "CJ-net-Http")
const MAX_CACHE_SIZE: UInt32 = 10 * 1024 * 1024
/**
 * Creates an HTTP request task.
 * @returns { HttpRequest } the HttpRequest of the createHttp.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public func createHttp(): HttpRequest {
    let id = unsafe { CJ_CreateHttp() }
    HttpRequest(id)
}

/**
 * Creates a default {@code HttpResponseCache} object to store the responses of HTTP access requests.
 * @param { UInt32 } cacheSize - the size of cache(max value is 10MB), default is 10*1024*1024(10MB).
 * @returns { HttpResponseCache } the HttpResponseCache of the createHttpResponseCache.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public func createHttpResponseCache(cacheSize!: UInt32 = MAX_CACHE_SIZE): HttpResponseCache {
    HTTP_LOG.info("createHttpResponseCache start")
    let retCode = unsafe { CJ_CreateHttpResponseCache(cacheSize) }
    if (retCode != SUCCESS_CODE) {
        HTTP_LOG.error("createHttpResponseCache failed: ${retCode}")
        throw BusinessException(retCode, "createHttpResponseCache failed: ${retCode}")
    }
    HTTP_LOG.info("createHttpResponseCache success")
    HttpResponseCache()
}

/**
 * Defines an HTTP request task. Before invoking APIs provided by HttpRequest,
 * you must call createHttp() to create an HttpRequestTask object.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public class HttpRequest {
    private var requested: Bool = false

    // id is RemoteData id, it`s not register to global map
    // will be released when destroy called
    HttpRequest(private let id: Int64) {}

    private unsafe func parseParam(url: String, options: ?HttpRequestOptions): (CString, CPointer<CHttpRequestOptions>) {
        let c_url = LibC.mallocCString(url)
        let optPtr = match (options) {
            case Some(v) =>
                let ptr = safeMalloc<CHttpRequestOptions>(1) {LibC.free(c_url)}
                try {
                    ptr.write(CHttpRequestOptions(v))
                } catch (e: Exception) {
                    LibC.free(c_url)
                    LibC.free(ptr)
                    throw e
                }
                ptr
            case None => CPointer<CHttpRequestOptions>()
        }
        (c_url, optPtr)
    }

    private func freeOptions(ptr: CPointer<CHttpRequestOptions>): Unit {
        if (ptr.isNotNull()) {
            unsafe {
                ptr.read().free()
                LibC.free<CHttpRequestOptions>(ptr)
            }
        }
    }

    private let callBackMap = HashMap<HttpRequestEvent, ArrayList<CallbackObject>>()
    private let registerMap = HashMap<HttpRequestEvent, Bool>(
        [(HeadersReceive, false), (DataReceive, false), (DataEnd, false),
        (DataReceiveProgress, false), (DataSendProgress, false)])

    private func findCallbackObject(callbackType: HttpRequestEvent, callback: CallbackObject, remove!: Bool = false): Int64 {
        let callbackList = callBackMap.get(callbackType) ?? return -1
        for (idx in 0..callbackList.size) {
            if (refEq(callback, callbackList[idx])) {
                if (remove) {
                    callbackList.remove(at: idx)
                }
                return idx
            }
        }
        return -1
    }

    private func register(callbackType: HttpRequestEvent, callbackId: Int64) {
        unsafe {
            match (callbackType) {
                case HttpRequestEvent.HeadersReceive => CJ_OnHeadersReceive(id, false, callbackId)
                case HttpRequestEvent.DataReceive => CJ_OnDataReceive(id, callbackId)
                case HttpRequestEvent.DataEnd => CJ_OnDataEnd(id, callbackId)
                case HttpRequestEvent.DataReceiveProgress => CJ_OnDataReceiveProgress(id, callbackId)
                case HttpRequestEvent.DataSendProgress => CJ_OnDataSendProgress(id, callbackId)
                case _ => throw BusinessException(2100001, "Invalid parameter value.")
            }
        }
    }

    private func argWrapper0(callbackType: HttpRequestEvent): Int64  {
        let wrapper = { =>
            let callbackList = callBackMap.get(callbackType) ?? ArrayList<CallbackObject>()
            for (caller in callbackList) {
                (caller as Callback0Argument)?.invoke(None)
            }
        }
        let registerCall = Callback0Param<Unit>(wrapper)
        registerCall.getID()
    }

    private func argWrapper1<CT, T>(callbackType: HttpRequestEvent, ctor: (CT) -> T): Int64 where CT <: CType {
        let wrapper = {
            ctype: CT =>
            let cjType = ctor(ctype)
            let callbackList = callBackMap.get(callbackType) ?? ArrayList<CallbackObject>()
            for (caller in callbackList) {
                (caller as Callback1Argument<T>)?.invoke(None, cjType)
            }
        }
        let registerCall = Callback1Param<CT, Unit>(wrapper)
        registerCall.getID()
    }

    private func commonSubscribe0Arg(callbackType: HttpRequestEvent, callback: CallbackObject) {
        if (!registerMap[callbackType]) {
            register(callbackType, argWrapper0(callbackType))
            registerMap[callbackType] = true
        } else {
            if (findCallbackObject(callbackType, callback) >= 0) {
                HTTP_LOG.info("The callback is registered, no need to re-registered")
                return
            }
        }
        callBackMap.addIfAbsent(callbackType, ArrayList<CallbackObject>())
        callBackMap[callbackType].add(callback)
    }

    private func commonSubscribe1Arg<CT, T>(callbackType: HttpRequestEvent, callback: CallbackObject,
        ctor: (CT) -> T) where CT <: CType {
        if (!registerMap[callbackType]) {
            register(callbackType, argWrapper1<CT, T>(callbackType, ctor))
            registerMap[callbackType] = true
        } else {
            if (findCallbackObject(callbackType, callback) >= 0) {
                HTTP_LOG.info("The callback is registered, no need to re-registered")
                return
            }
        }
        callBackMap.addIfAbsent(callbackType, ArrayList<CallbackObject>())
        callBackMap[callbackType].add(callback)
    }

    /**
     * Initiates an HTTP request to a given URL.
     * @permission ohos.permission.INTERNET
     * @param { String } url - URL for initiating an HTTP request.
     * @param { HttpRequestOptions } options - Optional parameters {@link HttpRequestOptions}.
     * @param { AsyncCallback<HttpResponse> } callback - The callback of request.
     * @throws { BusinessException } 401 - Parameter error.
     * @throws { BusinessException } 201 - Permission denied.
     * @throws { BusinessException } 2300001 - Unsupported protocol.
     * @throws { BusinessException } 2300003 - URL using bad/illegal format or missing URL.
     * @throws { BusinessException } 2300005 - Couldn't resolve proxy name.
     * @throws { BusinessException } 2300006 - Couldn't resolve host name.
     * @throws { BusinessException } 2300007 - Couldn't connect to server.
     * @throws { BusinessException } 2300008 - Weird server reply.
     * @throws { BusinessException } 2300009 - Access denied to remote resource.
     * @throws { BusinessException } 2300016 - Error in the HTTP2 framing layer.
     * @throws { BusinessException } 2300018 - Transferred a partial file.
     * @throws { BusinessException } 2300023 - Failed writing received data to disk/application.
     * @throws { BusinessException } 2300025 - Upload failed.
     * @throws { BusinessException } 2300026 - Failed to open/read local data from file/application.
     * @throws { BusinessException } 2300027 - Out of memory.
     * @throws { BusinessException } 2300028 - Timeout was reached.
     * @throws { BusinessException } 2300047 - Number of redirects hit maximum amount.
     * @throws { BusinessException } 2300052 - Server returned nothing (no headers, no data).
     * @throws { BusinessException } 2300055 - Failed sending data to the peer.
     * @throws { BusinessException } 2300056 - Failure when receiving data from the peer.
     * @throws { BusinessException } 2300058 - Problem with the local SSL certificate.
     * @throws { BusinessException } 2300059 - Couldn't use specified SSL cipher.
     * @throws { BusinessException } 2300060 - SSL peer certificate or SSH remote key was not OK.
     * @throws { BusinessException } 2300061 - Unrecognized or bad HTTP Content or Transfer-Encoding.
     * @throws { BusinessException } 2300063 - Maximum file size exceeded.
     * @throws { BusinessException } 2300070 - Disk full or allocation exceeded.
     * @throws { BusinessException } 2300073 - Remote file already exists.
     * @throws { BusinessException } 2300077 - Problem with the SSL CA cert (path? access rights?).
     * @throws { BusinessException } 2300078 - Remote file not found.
     * @throws { BusinessException } 2300094 - An authentication function returned an error.
     * @throws { BusinessException } 2300997 - Cleartext traffic not permitted.
     * @throws { BusinessException } 2300998 - It is not allowed to access this domain.
     * @throws { BusinessException } 2300999 - Unknown Other Error.
     */
    @!APILevel[
        since: "22",
        permission: "ohos.permission.INTERNET",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func request(url: String, options: HttpRequestOptions, callback: AsyncCallback<HttpResponse>): Unit {
        if (requested) {
            return
        }
        requested = true
        HTTP_LOG.info("HttpRequest request start")
        let (c_url, optPtr) = unsafe { parseParam(url, options) }
        let wrapper = {
            resp: CHttpResponse =>
            HTTP_LOG.info("request callback called")
            if (resp.errCode != SUCCESS_CODE) {
                let errMsg = resp.errMsg.toString()
                HTTP_LOG.error("HttpRequest request failed: ${resp.errCode}")
                let error = BusinessException(resp.errCode, "HttpRequest request failed: ${errMsg}")
                callback(error, None)
            } else {
                callback(None, HttpResponse(resp))
            }
            resp.free()
            HTTP_LOG.info("request callback end")
        }
        let registerCall = Callback1Param<CHttpResponse, Unit>(wrapper)
        let ret = unsafe { CJ_SendRequest(id, c_url, optPtr, false, registerCall.getID()) }
        let retCode = ret.code
        let errMsg = ret.data.toString()
        unsafe {
            FFiOHOSNetHttpFreeCString(ret.data)
            LibC.free(c_url)
            freeOptions(optPtr)
        }
        if (retCode != SUCCESS_CODE) {
            HTTP_LOG.error("HttpRequest request failed: ${retCode}")
            throw BusinessException(retCode, "HttpRequest request failed: ${errMsg}")
        }
        HTTP_LOG.info("HttpRequest request success")
    }

    /**
     * Initiates an HTTP request to a given URL.
     * @permission ohos.permission.INTERNET
     * @param { String } url - URL for initiating an HTTP request.
     * @param { AsyncCallback<HttpResponse> } callback - The callback of request.
     * @throws { BusinessException } 401 - Parameter error.
     * @throws { BusinessException } 201 - Permission denied.
     * @throws { BusinessException } 2300001 - Unsupported protocol.
     * @throws { BusinessException } 2300003 - URL using bad/illegal format or missing URL.
     * @throws { BusinessException } 2300005 - Couldn't resolve proxy name.
     * @throws { BusinessException } 2300006 - Couldn't resolve host name.
     * @throws { BusinessException } 2300007 - Couldn't connect to server.
     * @throws { BusinessException } 2300008 - Weird server reply.
     * @throws { BusinessException } 2300009 - Access denied to remote resource.
     * @throws { BusinessException } 2300016 - Error in the HTTP2 framing layer.
     * @throws { BusinessException } 2300018 - Transferred a partial file.
     * @throws { BusinessException } 2300023 - Failed writing received data to disk/application.
     * @throws { BusinessException } 2300025 - Upload failed.
     * @throws { BusinessException } 2300026 - Failed to open/read local data from file/application.
     * @throws { BusinessException } 2300027 - Out of memory.
     * @throws { BusinessException } 2300028 - Timeout was reached.
     * @throws { BusinessException } 2300047 - Number of redirects hit maximum amount.
     * @throws { BusinessException } 2300052 - Server returned nothing (no headers, no data).
     * @throws { BusinessException } 2300055 - Failed sending data to the peer.
     * @throws { BusinessException } 2300056 - Failure when receiving data from the peer.
     * @throws { BusinessException } 2300058 - Problem with the local SSL certificate.
     * @throws { BusinessException } 2300059 - Couldn't use specified SSL cipher.
     * @throws { BusinessException } 2300060 - SSL peer certificate or SSH remote key was not OK.
     * @throws { BusinessException } 2300061 - Unrecognized or bad HTTP Content or Transfer-Encoding.
     * @throws { BusinessException } 2300063 - Maximum file size exceeded.
     * @throws { BusinessException } 2300070 - Disk full or allocation exceeded.
     * @throws { BusinessException } 2300073 - Remote file already exists.
     * @throws { BusinessException } 2300077 - Problem with the SSL CA cert (path? access rights?).
     * @throws { BusinessException } 2300078 - Remote file not found.
     * @throws { BusinessException } 2300094 - An authentication function returned an error.
     * @throws { BusinessException } 2300997 - Cleartext traffic not permitted.
     * @throws { BusinessException } 2300998 - It is not allowed to access this domain.
     * @throws { BusinessException } 2300999 - Unknown Other Error.
     */
    @!APILevel[
        since: "22",
        permission: "ohos.permission.INTERNET",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func request(url: String, callback: AsyncCallback<HttpResponse>): Unit {
        if (requested) {
            return
        }
        requested = true
        HTTP_LOG.info("HttpRequest request start")
        let (c_url, optPtr) = unsafe { parseParam(url, None) }
        let wrapper = {
            resp: CHttpResponse =>
            HTTP_LOG.info("request callback called")
            if (resp.errCode != SUCCESS_CODE) {
                let errMsg = resp.errMsg.toString()
                HTTP_LOG.error("HttpRequest request failed: ${resp.errCode}")
                let error = BusinessException(resp.errCode, "HttpRequest request failed: ${errMsg}")
                callback(error, None)
            } else {
                callback(None, HttpResponse(resp))
            }
            resp.free()
            HTTP_LOG.info("request callback end")
        }
        let registerCall = Callback1Param<CHttpResponse, Unit>(wrapper)
        let ret = unsafe { CJ_SendRequest(id, c_url, optPtr, false, registerCall.getID()) }
        let retCode = ret.code
        let errMsg = ret.data.toString()
        unsafe {
            FFiOHOSNetHttpFreeCString(ret.data)
            LibC.free(c_url)
            freeOptions(optPtr)
        }
        if (retCode != SUCCESS_CODE) {
            HTTP_LOG.error("HttpRequest request failed: ${retCode}")
            throw BusinessException(retCode, "HttpRequest request failed: ${errMsg}")
        }
        HTTP_LOG.info("HttpRequest request success")
    }

    /**
     * Initiates an HTTP request to a given URL, applicable to scenarios where http response supports streaming.
     * @permission ohos.permission.INTERNET
     * @param { String } url - URL for initiating an HTTP request.
     * @param { HttpRequestOptions } options - Optional parameters {@link HttpRequestOptions}.
     * @param { AsyncCallback<UInt32> } callback - The callback of request.
     * @throws { BusinessException } 401 - Parameter error.
     * @throws { BusinessException } 201 - Permission denied.
     * @throws { BusinessException } 2300001 - Unsupported protocol.
     * @throws { BusinessException } 2300003 - URL using bad/illegal format or missing URL.
     * @throws { BusinessException } 2300005 - Couldn't resolve proxy name.
     * @throws { BusinessException } 2300006 - Couldn't resolve host name.
     * @throws { BusinessException } 2300007 - Couldn't connect to server.
     * @throws { BusinessException } 2300008 - Weird server reply.
     * @throws { BusinessException } 2300009 - Access denied to remote resource.
     * @throws { BusinessException } 2300016 - Error in the HTTP2 framing layer.
     * @throws { BusinessException } 2300018 - Transferred a partial file.
     * @throws { BusinessException } 2300023 - Failed writing received data to disk/application.
     * @throws { BusinessException } 2300025 - Upload failed.
     * @throws { BusinessException } 2300026 - Failed to open/read local data from file/application.
     * @throws { BusinessException } 2300027 - Out of memory.
     * @throws { BusinessException } 2300028 - Timeout was reached.
     * @throws { BusinessException } 2300047 - Number of redirects hit maximum amount.
     * @throws { BusinessException } 2300052 - Server returned nothing (no headers, no data).
     * @throws { BusinessException } 2300055 - Failed sending data to the peer.
     * @throws { BusinessException } 2300056 - Failure when receiving data from the peer.
     * @throws { BusinessException } 2300058 - Problem with the local SSL certificate.
     * @throws { BusinessException } 2300059 - Couldn't use specified SSL cipher.
     * @throws { BusinessException } 2300060 - SSL peer certificate or SSH remote key was not OK.
     * @throws { BusinessException } 2300061 - Unrecognized or bad HTTP Content or Transfer-Encoding.
     * @throws { BusinessException } 2300063 - Maximum file size exceeded.
     * @throws { BusinessException } 2300070 - Disk full or allocation exceeded.
     * @throws { BusinessException } 2300073 - Remote file already exists.
     * @throws { BusinessException } 2300077 - Problem with the SSL CA cert (path? access rights?).
     * @throws { BusinessException } 2300078 - Remote file not found.
     * @throws { BusinessException } 2300094 - An authentication function returned an error.
     * @throws { BusinessException } 2300997 - Cleartext traffic not permitted.
     * @throws { BusinessException } 2300998 - It is not allowed to access this domain.
     * @throws { BusinessException } 2300999 - Unknown Other Error.
     */
    @!APILevel[
        since: "22",
        permission: "ohos.permission.INTERNET",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func requestInStream(url: String, options: HttpRequestOptions, callback: AsyncCallback<UInt32>): Unit {
        if (requested) {
            return
        }
        requested = true
        HTTP_LOG.info("HttpRequest requestInStream start")
        let (c_url, optPtr) = unsafe { parseParam(url, options) }

        let wrapper = {
            resp: CHttpResponse =>
            HTTP_LOG.info("requestInStream callback called")
            if (resp.errCode != SUCCESS_CODE) {
                let errMsg = resp.errMsg.toString()
                HTTP_LOG.error("HttpRequest requestInStream failed: ${resp.errCode}")
                let error = BusinessException(resp.errCode, "HttpRequest requestInStream failed: ${errMsg}")
                callback(error, None)
            } else {
                callback(None, resp.responseCode)
            }
            resp.free()
            HTTP_LOG.info("requestInStream callback end")
        }
        let registerCall = Callback1Param<CHttpResponse, Unit>(wrapper)

        let ret = unsafe { CJ_SendRequest(id, c_url, optPtr, true, registerCall.getID()) }
        let retCode = ret.code
        let errMsg = ret.data.toString()
        unsafe {
            FFiOHOSNetHttpFreeCString(ret.data)
            LibC.free(c_url)
            freeOptions(optPtr)
        }

        if (retCode != SUCCESS_CODE) {
            HTTP_LOG.error("HttpRequest requestInStream failed: ${retCode}")
            throw BusinessException(retCode, "HttpRequest requestInStream failed: ${errMsg}")
        }
        HTTP_LOG.info("HttpRequest requestInStream success")
    }

    /**
     * Initiates an HTTP request to a given URL, applicable to scenarios where http response supports streaming.
     * @permission ohos.permission.INTERNET
     * @param { String } url - URL for initiating an HTTP request.
     * @param { HttpRequestOptions } options - Optional parameters {@link HttpRequestOptions}.
     * @throws { BusinessException } 401 - Parameter error.
     * @throws { BusinessException } 201 - Permission denied.
     * @throws { BusinessException } 2300001 - Unsupported protocol.
     * @throws { BusinessException } 2300003 - URL using bad/illegal format or missing URL.
     * @throws { BusinessException } 2300005 - Couldn't resolve proxy name.
     * @throws { BusinessException } 2300006 - Couldn't resolve host name.
     * @throws { BusinessException } 2300007 - Couldn't connect to server.
     * @throws { BusinessException } 2300008 - Weird server reply.
     * @throws { BusinessException } 2300009 - Access denied to remote resource.
     * @throws { BusinessException } 2300016 - Error in the HTTP2 framing layer.
     * @throws { BusinessException } 2300018 - Transferred a partial file.
     * @throws { BusinessException } 2300023 - Failed writing received data to disk/application.
     * @throws { BusinessException } 2300025 - Upload failed.
     * @throws { BusinessException } 2300026 - Failed to open/read local data from file/application.
     * @throws { BusinessException } 2300027 - Out of memory.
     * @throws { BusinessException } 2300028 - Timeout was reached.
     * @throws { BusinessException } 2300047 - Number of redirects hit maximum amount.
     * @throws { BusinessException } 2300052 - Server returned nothing (no headers, no data).
     * @throws { BusinessException } 2300055 - Failed sending data to the peer.
     * @throws { BusinessException } 2300056 - Failure when receiving data from the peer.
     * @throws { BusinessException } 2300058 - Problem with the local SSL certificate.
     * @throws { BusinessException } 2300059 - Couldn't use specified SSL cipher.
     * @throws { BusinessException } 2300060 - SSL peer certificate or SSH remote key was not OK.
     * @throws { BusinessException } 2300061 - Unrecognized or bad HTTP Content or Transfer-Encoding.
     * @throws { BusinessException } 2300063 - Maximum file size exceeded.
     * @throws { BusinessException } 2300070 - Disk full or allocation exceeded.
     * @throws { BusinessException } 2300073 - Remote file already exists.
     * @throws { BusinessException } 2300077 - Problem with the SSL CA cert (path? access rights?).
     * @throws { BusinessException } 2300078 - Remote file not found.
     * @throws { BusinessException } 2300094 - An authentication function returned an error.
     * @throws { BusinessException } 2300997 - Cleartext traffic not permitted.
     * @throws { BusinessException } 2300998 - It is not allowed to access this domain.
     * @throws { BusinessException } 2300999 - Unknown Other Error.
     */
    @!APILevel[
        since: "22",
        permission: "ohos.permission.INTERNET",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func requestInStream(url: String, callback: AsyncCallback<UInt32>): Unit {
        if (requested) {
            return
        }
        requested = true
        HTTP_LOG.info("HttpRequest requestInStream start")
        let (c_url, optPtr) = unsafe { parseParam(url, None) }

        let wrapper = {
            resp: CHttpResponse =>
            HTTP_LOG.info("requestInStream callback called")
            if (resp.errCode != SUCCESS_CODE) {
                let errMsg = resp.errMsg.toString()
                HTTP_LOG.error("HttpRequest requestInStream failed: ${resp.errCode}")
                let error = BusinessException(resp.errCode, "HttpRequest requestInStream failed: ${errMsg}")
                callback(error, None)
            } else {
                callback(None, resp.responseCode)
            }
            resp.free()
            HTTP_LOG.info("requestInStream callback end")
        }
        let registerCall = Callback1Param<CHttpResponse, Unit>(wrapper)

        let ret = unsafe { CJ_SendRequest(id, c_url, optPtr, true, registerCall.getID()) }
        let retCode = ret.code
        let errMsg = ret.data.toString()
        unsafe {
            FFiOHOSNetHttpFreeCString(ret.data)
            LibC.free(c_url)
            freeOptions(optPtr)
        }

        if (retCode != SUCCESS_CODE) {
            HTTP_LOG.error("HttpRequest requestInStream failed: ${retCode}")
            throw BusinessException(retCode, "HttpRequest requestInStream failed: ${errMsg}")
        }
        HTTP_LOG.info("HttpRequest requestInStream success")
    }

    /**
     * Destroys an HTTP request.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func destroy(): Unit {
        HTTP_LOG.info("HttpRequest destroy start")
        if (!requested) {
            requested = true
        }
        unsafe { CJ_DestroyRequest(id) }
        HTTP_LOG.info("HttpRequest destroy success")
    }

    /**
     * Registers an observer for HTTP Response Header events.
     * @param { (HashMap<String, String>) -> Unit } callback - the callback used to return the result.
     * @throws { BusinessException } 2100001 - Invalid parameter value.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func on(event: HttpRequestEvent, callback: Callback1Argument<HashMap<String, String>>): Unit {
        HTTP_LOG.info("HttpRequest register onHeadersReceive start")
        if (event != HttpRequestEvent.HeadersReceive) {
            HTTP_LOG.error("Invalid event, valid event is HttpRequestEvent.HeadersReceive")
            throw BusinessException(2100001, "Invalid parameter value.")
        }
        commonSubscribe1Arg(event, callback) {
            cArrString: CArrString =>
            let map = cArrString2Map(cArrString)
            unsafe { FFiOHOSNetHttpFreeCArrString(cArrString) }
            return map
        }
        HTTP_LOG.info("HttpRequest register onHeadersReceive end")
    }

    /**
     * Registers a one-time observer for HTTP Response Header events.
     * @param { (HashMap<String, String>) -> Unit } callback - the callback used to return the result.
     * @throws { BusinessException } 2100001 - Invalid parameter value.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func once(event: HttpRequestEvent, callback: Callback1Argument<HashMap<String, String>>): Unit {
        HTTP_LOG.info("HttpRequest register onceHeadersReceive start")
        if (event != HttpRequestEvent.HeadersReceive) {
            HTTP_LOG.error("Invalid event, valid event is HttpRequestEvent.HeadersReceive")
            throw BusinessException(2100001, "Invalid parameter value.")
        }
        let wrapper = {
            cArrString: CArrString =>
            let map = cArrString2Map(cArrString)
            unsafe { FFiOHOSNetHttpFreeCArrString(cArrString) }
            callback.invoke(None, map)
        }
        let registerCall = Callback1Param<CArrString, Unit>(wrapper)
        unsafe { CJ_OnHeadersReceive(id, true, registerCall.getID()) }
        HTTP_LOG.info("HttpRequest register onceHeadersReceive end")
    }

    /**
     * Registers an observer for receiving HTTP Response data events continuously.
     * @param { callback: (Array<Byte>) -> Unit } callback - the callback used to return the result.
     * @throws { BusinessException } 2100001 - Invalid parameter value.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func on(event: HttpRequestEvent, callback: Callback1Argument<Array<Byte>>): Unit {
        HTTP_LOG.info("HttpRequest register onDataReceive start")
        if (event != HttpRequestEvent.DataReceive) {
            HTTP_LOG.error("Invalid event, valid event is HttpRequestEvent.DataReceive")
            throw BusinessException(2100001, "Invalid parameter value.")
        }
        commonSubscribe1Arg(event, callback) {
            cstr: CArrUI8 => unsafe {
                let bytes = cArr2cjArr<UInt8, UInt8>(cstr.size, cstr.head, {i => i})
                FFiOHOSNetHttpFreeCArrUI8(cstr)
                return bytes
            }
        }
        HTTP_LOG.info("HttpRequest register onDataReceive end")
    }

    /**
     * Registers an observer for receiving HTTP Response data ends events.
     * @param { () -> Unit } callback - the callback used to return the result.
     * @throws { BusinessException } 2100001 - Invalid parameter value.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func on(event: HttpRequestEvent, callback: Callback0Argument): Unit {
        HTTP_LOG.info("HttpRequest register onDataEnd start")
        if (event != HttpRequestEvent.DataEnd) {
            HTTP_LOG.error("Invalid event, valid event is HttpRequestEvent.DataEnd")
            throw BusinessException(2100001, "Invalid parameter value.")
        }
        commonSubscribe0Arg(event, callback)
        HTTP_LOG.info("HttpRequest register onDataEnd end")
    }

    /**
     * Registers an observer for progress of receiving HTTP Response data events.
     * @param { (DataReceiveProgressInfo) -> Unit } callback - the callback used to return the result.
     * @throws { BusinessException } 2100001 - Invalid parameter value.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func on(event: HttpRequestEvent, callback: Callback1Argument<DataReceiveProgressInfo>): Unit {
        HTTP_LOG.info("HttpRequest register onDataReceiveProgress start")
        if (event != HttpRequestEvent.DataReceiveProgress) {
            HTTP_LOG.error("Invalid event, valid event is HttpRequestEvent.DataReceiveProgress")
            throw BusinessException(2100001, "Invalid parameter value.")
        }
        commonSubscribe1Arg(event, callback) {
            info: CDataReceiveProgressInfo => DataReceiveProgressInfo(info)
        }
        HTTP_LOG.info("HttpRequest register onDataReceiveProgress end")
    }

    /**
     * Registers an observer for progress of sendSize HTTP Response data events.
     * @param { (DataSendProgressInfo) -> Unit } callback - the callback of on.
     * @throws { BusinessException } 2100001 - Invalid parameter value.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func on(event: HttpRequestEvent, callback: Callback1Argument<DataSendProgressInfo>): Unit {
        HTTP_LOG.info("HttpRequest register onDataSendProgress start")
        if (event != HttpRequestEvent.DataSendProgress) {
            HTTP_LOG.error("Invalid event, valid event is HttpRequestEvent.DataSendProgress")
            throw BusinessException(2100001, "Invalid parameter value.")
        }
        commonSubscribe1Arg(event, callback) {
            info: CDataSendProgressInfo => DataSendProgressInfo(info)
        }
        HTTP_LOG.info("HttpRequest register onDataSendProgress end")
    }

    /**
     * Unregisters the observer for HttpRequest.
     * @throws { IllegalArgumentException } The parameter check failed.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func off(event: HttpRequestEvent, callback!: ?CallbackObject = None): Unit {
        HTTP_LOG.info("unsubscribe stateChange")
        if (!callBackMap.contains(event)) {
            return
        }
        if (let Some(v) <- callback) {
            findCallbackObject(event, v, remove: true)
            return
        }
        callBackMap[event].clear()
    }
}

/**
 * Defines an object that stores the response to an HTTP request.
 */
@!APILevel[
    since: "22",
    syscap: "SystemCapability.Communication.NetStack"
]
public class HttpResponseCache {
    init() {}
    /**
     * Writes data in the cache to the file system so that all the cached data can be accessed in the next HTTP request.
     * @returns { Unit } The promise returned by the flush.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func flush(): Unit {
        HTTP_LOG.info("HttpResponseCache flush start")
        let retCode = unsafe { CJ_HttpResponseCacheFlush() }
        if (retCode != SUCCESS_CODE) {
            HTTP_LOG.error("HttpResponseCache flush failed: ${retCode}")
            throw BusinessException(retCode, "HttpResponseCache flush failed: ${retCode}")
        }
        HTTP_LOG.info("HttpResponseCache flush success")
    }

    /**
     * Disables a cache and deletes the data in it.
     * @returns { Unit } The promise returned by the delete.
     */
    @!APILevel[
        since: "22",
        syscap: "SystemCapability.Communication.NetStack"
    ]
    public func delete(): Unit {
        HTTP_LOG.info("HttpResponseCache delete start")
        let retCode = unsafe { CJ_HttpResponseCacheDelete() }
        if (retCode != SUCCESS_CODE) {
            HTTP_LOG.error("HttpResponseCache delete failed: ${retCode}")
            throw BusinessException(retCode, "HttpResponseCache delete failed: ${retCode}")
        }
        HTTP_LOG.info("HttpResponseCache delete success")
    }
}
