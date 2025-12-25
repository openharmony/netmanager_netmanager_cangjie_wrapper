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

import std.collection.{ArrayList, HashMap}
import ohos.business_exception.BusinessException
import ohos.callback_invoke.{ CallbackObject, Callback1Argument, Callback0Argument }
import std.sync.Mutex

class CallbackList {
    private let callbackList: ArrayList<CallbackObject>
    private let callBackMutex: Mutex

    init() {
        callbackList = ArrayList<CallbackObject>()
        callBackMutex = Mutex()
    }

    func off(target: CallbackObject): Unit {
        synchronized(callBackMutex) {
            callbackList.removeIf({callback => refEq(callback, target)})
        }
    }

    func on(target: CallbackObject): Unit {
        synchronized(callBackMutex) {
            for (callback in callbackList) {
                if (refEq(callback, target)) {
                    WEB_SOCKET_LOG.info("The callback has been subscribed.")
                    return
                }
            }
            callbackList.add(target)
        }
    }

    func clear(): Unit {
        synchronized(callBackMutex) {
            callbackList.clear()
        }
    }

    func contains(target: Callback1Argument<Response>): Bool {
        synchronized(callBackMutex) {
            for (callback in callbackList) {
                if (refEq(callback, target)) {
                    return true
                }
            }
        }
        false
    }

    func isEmpty(): Bool {
        synchronized(callBackMutex) {
            callbackList.isEmpty()
        }
    }

    func size(): Int64 {
        synchronized(callBackMutex) {
            callbackList.size
        }
    }

    func getAllCallbacks(): Array<CallbackObject> {
        synchronized(callBackMutex) {
            return callbackList.toArray()
        }
    }
}

class WebSocketManager {
    private let webSocketMap: HashMap<Int32, CallbackList>
    private let mutex: Mutex

    init() {
        webSocketMap = HashMap<Int32, CallbackList>()
        mutex = Mutex()
    }

    func get(typeId: Int32): ?CallbackList {
        synchronized(mutex) {
            webSocketMap.get(typeId)
        }
    }

    func consume(typeId: Int32): ?CallbackList {
        synchronized(mutex) {
            webSocketMap.remove(typeId)
        }
    }

    func getOrCreate(`type`: OnOffType): CallbackList {
        synchronized(mutex) {
            if (let Some(v) <- webSocketMap.get(`type`.value)) {
                return v
            }
            let list = CallbackList()
            webSocketMap.add(`type`.value, list)
            list
        }
    }

    func isWebSocketOn(`type`: OnOffType): Bool {
        isWebSocketOn(`type`.value)
    }

    func isWebSocketOn(typeId: Int32): Bool {
        synchronized(mutex) {
            !(webSocketMap.get(typeId)?.isEmpty() ?? true)
        }
    }

    func remove(`type`: OnOffType) {
        synchronized(mutex) {
            webSocketMap.remove(`type`.value)
        }
    }

    static func isMatchType(`type`: OnOffType, callback: CallbackObject): Bool {
        match (`type`) {
            case OPEN => callback is Callback1Argument<HashMap<UInt32, String>>
            case MESSAGE => callback is Callback1Argument<MessageData>
            case CLOSE => callback is Callback1Argument<CloseResult>
            case ERROR => callback is Callback0Argument
            case DATAEND => callback is Callback0Argument
            case HEADERRECEIVE => callback is Callback1Argument<ResponseHeaders>
            case _ => throw BusinessException(2100001, "Invalid parameter value.")
        }
    }
}

func emitWebSocketCallback(typeId: Int32, callbackListOpt: ?Array<CallbackObject>, responseData: Response): Unit {
    if (let Some(callbackList) <- callbackListOpt) {
        try {
            for (callback in callbackList) {
                emitOneWebSocketTypeCallback(typeId, callback, responseData)
            }
        } catch (e: Exception) {
            WEB_SOCKET_LOG.error("convertToResponse error, callbackList typeId:${typeId}")
            return
        }
    } else {
        WEB_SOCKET_LOG.info("Fail to find websocket Callback id:${typeId} or callbackList is empty.")
    }
}

func emitOneWebSocketTypeCallback(typeId: Int32, callback: CallbackObject, responseData: Response): Unit {
    match (typeId) {
        case 1 =>
            if (let Some(callbackInst) <- (callback as Callback1Argument<HashMap<UInt32, String>>)) {
                if (let Some(res) <- (responseData as OpenResponse)) {
                    if (res.code != 0) {
                        callbackInst.invoke(BusinessException(res.code, getErrorMsg(res.code)), res.value)
                        return
                    }
                    callbackInst.invoke(None, res.value)
                }
            }
        case 2 =>
            if (let Some(callbackInst) <- (callback as Callback1Argument<MessageData>)) {
                if (let Some(res) <- (responseData as MessageResponse)) {
                    if (res.code != 0) {
                        callbackInst.invoke(BusinessException(res.code, getErrorMsg(res.code)), res.value)
                        return
                    }
                    callbackInst.invoke(None, res.value)
                }
            }
        case 3 =>
            if (let Some(callbackInst) <- (callback as Callback1Argument<CloseResult>)) {
                if (let Some(res) <- (responseData as CloseResponse)) {
                    if (res.code != 0) {
                        callbackInst.invoke(BusinessException(res.code, getErrorMsg(res.code)), res.value)
                        return
                    }
                    callbackInst.invoke(None, res.value)
                }
            }
        case 4 =>
            let callbackInstOpt = (callback as Callback0Argument)
            if (let Some(callbackInst) <- callbackInstOpt && let Some(res) <- (responseData as ErrorResponse)) {
                callbackInst.invoke((BusinessException(res.errCode, res.httpResponse.toString())))
            }
        case 5 =>
            let callbackInstOpt = (callback as Callback0Argument)
            if (let Some(callbackInst) <- callbackInstOpt) {
                callbackInst.invoke(None)
            }
        case 6 =>
            let callbackInstOpt = (callback as Callback1Argument<ResponseHeaders>)
            if (let Some(callbackInst) <- callbackInstOpt) {
                if (let Some(res) <- (responseData as HeaderReceiveResponse)) {
                    callbackInst.invoke(None, res.value)
                } else {
                    callbackInst.invoke(None, ResponseHeaders.UndefinedData)
                }
            }
        case _ => return
    }
}
