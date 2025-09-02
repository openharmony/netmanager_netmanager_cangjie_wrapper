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

package ohos_app_cangjie_entry

internal import kit.NetworkKit.*
import std.unittest.testmacro.*
import std.unittest.*
import std.unittest.common.*
import std.unittest.testmacro.*
import ohos.base.*
import ohos.hilog.Hilog
import std.collection.HashMap
import ohos.net.http.CertType as Type

import ohos.callback_invoke.*
import ohos.business_exception.*

@Test
public class Test_http {

    @TestCase
    @Tag[APILevel21, TestLevel0]
    func test_request() {
        let request = createHttp()
        let option = HttpRequestOptions(
            method: RequestMethod.Options, // 可选，默认为http.RequestMethod.GET
            expectDataType: HttpDataType.ArrayBuffer, // 可选，指定返回数据的类型
            usingProtocol: HttpProtocol.Http2, // 可选，协议类型默认值由系统自动指定
            usingProxy: UsingProxy.UseDefault, //可选，默认不使用网络代理，自API 10开始支持该属性
            resumeFrom: 100000,
        )

        request.request(
            "http://www.baidu.com",
            option,
            {
                err, code =>
                if (let Some(e) <- err) {
                    Hilog.error(0, "test_request", "exception: ${e}")
                }

                if (let Some(resp) <- code) {
                    Hilog.info(0, "test_request", "resp: ${resp.responseCode}")
                } else {
                    Hilog.info(0, "test_request", "resp is none")
                }
                request.destroy()
            }
        )
    }

    @TestCase
    @Tag[APILevel21, TestLevel0]
    func test_destory() {
        let request = createHttp()
        request.destroy()
    }

    @TestCase
    @Tag[APILevel21, TestLevel0]
    func test_requestInStream_03() {
        let request = createHttp()
        let option = HttpRequestOptions(
            method: RequestMethod.Post, // 可选，默认为http.RequestMethod.GET
            expectDataType: HttpDataType.StringValue, // 可选，指定返回数据的类型
            usingProtocol: HttpProtocol.Http1_1, // 可选，协议类型默认值由系统自动指定
            usingProxy: UsingProxy.UseDefault, //可选，默认不使用网络代理，自API 10开始支持该属性
            resumeFrom: 100000,
        )

        request.requestInStream(
            "http://www.baidu.com",
            option,
            {
                err, code =>
                if (let Some(e) <- err) {
                    Hilog.error(0, "test_requestInStream_03", "err: ${e}")
                }

                if (let Some(resp) <- code) {
                    Hilog.info(0, "test_requestInStream_03", "resp: ${resp}")
                } else {
                    Hilog.info(0, "test_requestInStream_03", "resp is none")
                }
                request.destroy()
            }
        )
    }

    @TestCase
    @Tag[APILevel21, TestLevel0]
    func test_capath_resumefrom_resumeto_03(): Unit {
        Hilog.info(0, "", "before createhttp")
        let httpRequest = createHttp()
        let opt = HttpRequestOptions(
            method: RequestMethod.Post,
            caPath: "",
            resumeFrom: 4294967296,
            resumeTo: 4294967296
        )
        Hilog.info(0, "", "createhttp ok")
        httpRequest.request(
            "http://www.baidu.com",
            opt,
            {
                e, resp =>
                if (let Some(err) <- e) {
                    Hilog.info(0, "wbt", "${err.code}")
                    Hilog.info(0, "wbt", "${err.message}")
                }
                if (let Some(r) <- resp) {
                    Hilog.info(0, "wbt", "resp: ${r.responseCode}")
                    match (r.resultType) {
                        case STRING => Hilog.info(0, "wbt", "STRING")
                        case ARRAY_BUFFER => Hilog.info(0, "wbt", "ARRAY_BUFFER")
                        case _ => throw Exception("unsupported enum constructor")
                    }
                    match (r.responseCode) {
                        case OK => Hilog.info(0, "wbt", "200")
                        case CREATED => Hilog.info(0, "wbt", "201")
                        case _ => ()
                    }
                    Hilog.info(0, "wbt", "${r.header}")
                    Hilog.info(0, "wbt", "${r.cookies}")
                    Hilog.info(0, "wbt", "${r.performanceTiming.dnsTiming}")
                    Hilog.info(0, "wbt", "${r.performanceTiming.tcpTiming}")
                    Hilog.info(0, "wbt", "${r.performanceTiming.tlsTiming}")
                    Hilog.info(0, "wbt", "${r.performanceTiming.firstSendTiming}")
                    Hilog.info(0, "wbt", "${r.performanceTiming.firstReceiveTiming}")
                    Hilog.info(0, "wbt", "${r.performanceTiming.totalFinishTiming}")
                    Hilog.info(0, "wbt", "${r.performanceTiming.redirectTiming}")
                    Hilog.info(0, "wbt", "${r.performanceTiming.responseHeaderTiming}")
                    Hilog.info(0, "wbt", "${r.performanceTiming.responseBodyTiming}")
                    Hilog.info(0, "wbt", "${r.performanceTiming.totalTiming}")
                } else {
                    Hilog.error(0, "wbt", "response is none")
                }
            }
        )
        Hilog.info(0, "", "request ok")
    }

    @TestCase
    @Tag[APILevel21, TestLevel0]
    func test_netHttp_01() {
        let httpRequest = createHttp()

        let option = HttpRequestOptions(
            method: RequestMethod.Post, // 可选，默认为http.RequestMethod.GET
            //            // 当使用POST请求时此字段用于传递内容
            extraData: HttpData.StringData("data to send"),
            expectDataType: HttpDataType.StringValue, // 可选，指定返回数据的类型
            usingCache: true, // 可选，默认为true
            priority: 1, // 可选，默认为1
            //            // 开发者根据自身业务需要添加header字段
            //            header: HashMap<String, String>([("content-type", "application/json")]),
            readTimeout: 60000, // 可选，默认为6000ms
            connectTimeout: 60000 // 可选，默认为6000ms
            //            usingProtocol: HttpProtocol.Http1_1, // 可选，协议类型默认值由系统自动指定
            //            usingProxy: UsingProxy.UseDefault, //可选，默认不使用网络代理，自API 10开始支持该属性
            //            caPath: "/path/to/cacert.pem", // 可选，默认使用系统预设CA证书，自API 10开始支持该属性
            //            clientCert: ClientCert(
            //                "/path/to/client.pem", // 默认不使用客户端证书
            //                "/path/to/client.key", // 若证书包含Key信息，传入空字符串
            //                certType: CertType.PEM, // 可选，默认使用PEM
            //                keyPassword: "passwordToKey" // 可选，输入key文件的密码
            //            )
        )

        let dataReceiveCallBack = DataReceiveCb({ data => Hilog.info(0, "test_netHttp_01", "resp11111111: ${data}") })
        httpRequest.on(HttpRequestEvent.DataReceive, dataReceiveCallBack)

        httpRequest.requestInStream(
            "http://www.example.com",
            option,
            {
                err, code =>
                if (let Some(e) <- err) {
                    Hilog.error(0, "test_netHttp_01", "exception: ${e.message}")
                }
                if (let Some(respCode) <- code) {
                    Hilog.info(0, "test_netHttp_01", "resp2222222: ${respCode}")
                } else {
                    Hilog.error(0, "test_netHttp_01", "response is none")
                }
                httpRequest.destroy()
            }
        )
    }

    @TestCase
    @Tag[APILevel21, TestLevel0]
    func testRequest1(): Unit {
        let client = createHttp()
        let response = Box<HttpResponse>(unsafe { zeroValue<HttpResponse>() })
        client.request(
            "http://www.baidu.com",
            {
                err, resp =>
                if (let Some(e) <- err) {
                    Hilog.error(0, "test", "exception: ${e.message}")
                }
                if (let Some(r) <- resp) {
                    Hilog.error(0, "test", "${r.responseCode}")
                    response.value = r
                } else {
                    Hilog.error(0, "test", "response is none")
                    @Expect(false)
                }
                client.destroy()
            }
        )
        while (refEq(response.value, unsafe { zeroValue<HttpResponse>() })) {}
        Hilog.error(0, "test", "${response.value.responseCode}")
    }

    @TestCase
    @Tag[APILevel21, TestLevel0]
    func testRequest2(): Unit {
        let client = createHttp()
        let opt = HttpRequestOptions()
        client.request(
            "http://www.baidu.com",
            opt,
            {
                err, resp =>
                if (let Some(e) <- err) {
                    Hilog.error(0, "testRequest2", "exception: ${e.message}")
                }
                if (let Some(r) <- resp) {
                    Hilog.error(0, "testRequest2", "${r.responseCode}")
                } else {
                    Hilog.error(0, "testRequest2", "response is none")
                }
                client.destroy()
            },
        )
    }

    @TestCase
    @Tag[APILevel21, TestLevel0]
    func testRequest3(): Unit {
        let client = createHttp()
        let opt = HttpRequestOptions(
            method: RequestMethod.Post, // 可选，默认为http.RequestMethod.GET
            // 当使用POST请求时此字段用于传递内容
            extraData: HttpData.ArrayData("data to send".toArray()),
            expectDataType: HttpDataType.StringValue, // 可选，指定返回数据的类型
            usingCache: true, // 可选，默认为true
            priority: 1, // 可选，默认为1
            // 开发者根据自身业务需要添加header字段
            header: HashMap<String, String>([("content-type", "application/json")]),
            readTimeout: 60000, // 可选，默认为60000ms
            connectTimeout: 60000, // 可选，默认为60000ms
            usingProtocol: HttpProtocol.Http1_1, // 可选，协议类型默认值由系统自动指定
            usingProxy: UseDefault, //可选，默认不使用网络代理，自API 10开始支持该属性
            caPath: "/path/to/cacert.pem",
            clientCert: ClientCert(
                "/path/to/client.pem", // 默认不使用客户端证书
                "/path/to/client.key", // 若证书包含Key信息，传入空字符串
            ),
            multiFormDataList: [ // 可选，仅当Header中，'content-Type'为'multipart/form-data'时生效
                MultiFormData(
                    "Part1", // 数据名
                    "text/plain", // 数据类型
                    data: StringData("Example data"), // 可选，数据内容
                    remoteFileName: "example.txt" // 可选
                ),
                MultiFormData(
                    "Part2", // 数据名
                    "text/plain", // 数据类型
                    filePath: "/data/app/el2/100/base/com.example.myapplication/haps/entry/files/fileName.txt", // 可选，传入文件路径
                    remoteFileName: "fileName.txt" // 可选
                )
            ]
        )
        client.request(
            "http://www.baidu.com",
            opt,
            {
                err, resp =>
                if (let Some(e) <- err) {
                    Hilog.error(0, "testRequest3", "exception: ${e.message}")
                }
                if (let Some(r) <- resp) {
                    Hilog.error(0, "testRequest3", "${r.responseCode}")
                } else {
                    Hilog.error(0, "testRequest3", "response is none")
                }
                client.destroy()
            }
        )
    }

    @TestCase
    @Tag[APILevel21, TestLevel0]
    func testRequest4(): Unit {
        let client = createHttp()
        let opt = HttpRequestOptions(
            method: RequestMethod.Post, // 可选，默认为http.RequestMethod.GET
            // 当使用POST请求时此字段用于传递内容
            extraData: HttpData.ArrayData("data to send".toArray()),
            expectDataType: HttpDataType.StringValue, // 可选，指定返回数据的类型
            usingCache: true, // 可选，默认为true
            priority: 1, // 可选，默认为1
            // 开发者根据自身业务需要添加header字段
            header: HashMap<String, String>([("content-type", "application/json")]),
            readTimeout: 60000, // 可选，默认为60000ms
            connectTimeout: 60000, // 可选，默认为60000ms
            usingProtocol: HttpProtocol.Http1_1, // 可选，协议类型默认值由系统自动指定
            usingProxy: UseDefault, //可选，默认不使用网络代理，自API 10开始支持该属性
            caPath: "/path/to/cacert.pem",
            clientCert: ClientCert(
                "/path/to/client.pem", // 默认不使用客户端证书
                "/path/to/client.key", // 若证书包含Key信息，传入空字符串
                certType: Type.P12
            ),
            multiFormDataList: [ // 可选，仅当Header中，'content-Type'为'multipart/form-data'时生效
                MultiFormData(
                    "Part1", // 数据名
                    "text/plain", // 数据类型
                    data: StringData("Example data"), // 可选，数据内容
                    remoteFileName: "example.txt" // 可选
                ),
                MultiFormData(
                    "Part2", // 数据名
                    "text/plain", // 数据类型
                    filePath: "/data/app/el2/100/base/com.example.myapplication/haps/entry/files/fileName.txt", // 可选，传入文件路径
                    remoteFileName: "fileName.txt" // 可选
                )
            ]
        )
        client.request(
            "http://www.baidu.com",
            opt,
            {
                err, resp =>
                if (let Some(e) <- err) {
                    Hilog.error(0, "testRequest4", "exception: ${e.message}")
                }
                if (let Some(r) <- resp) {
                    Hilog.error(0, "testRequest4", "${r.responseCode}")
                } else {
                    Hilog.error(0, "testRequest4", "response is none")
                }
                client.destroy()
            }
        )
    }

    @TestCase
    @Tag[APILevel21, TestLevel0]
    func testRequestInStream(): Unit {
        let client = createHttp()

        let headersReceiveCallBack = HeadersReceiveCb({ map => Hilog.info(0, "test", "header info: ${map}") })
        client.on(HttpRequestEvent.HeadersReceive, headersReceiveCallBack)

        let onceHeadersReceiveCallBack = HeadersReceiveCb({ map => Hilog.info(0, "test", "header info once: ${map}") })
        client.once(HttpRequestEvent.HeadersReceive, onceHeadersReceiveCallBack)

        let dataReceiveCallBack = DataReceiveCb({ bytes => Hilog.info(0, "test", "data info : ${bytes}") })
        client.on(HttpRequestEvent.DataReceive, dataReceiveCallBack)

        let dataEndCallBack = DataEndCb({ => Hilog.info(0, "test", "data end") })
        client.on(HttpRequestEvent.DataEnd,dataEndCallBack)

        let dataReceiveProgressCallBack = DataReceiveProgressCb({ info => Hilog.info(0, "test", "receive progress ${info.receiveSize} ${info.totalSize} ") })
        client.on(HttpRequestEvent.DataReceiveProgress, dataReceiveProgressCallBack)

        Hilog.info(0, "", "create ok")
        client.requestInStream(
            "http://www.baidu.com",
            {
                err, code =>
                if (let Some(e) <- err) {
                    Hilog.error(0, "testRequestInStream", "exception: ${e.message}")
                }
                if (let Some(c) <- code) {
                    Hilog.error(0, "testRequestInStream", "${c}")
                } else {
                    Hilog.error(0, "testRequestInStream", "code is none")
                }
                client.destroy()
            }
        )
    }

    @TestCase
    @Tag[APILevel21, TestLevel0]
    func testCallback() {
        let client = createHttp()

        let headersReceiveCallBack = HeadersReceiveCb({ map => Hilog.info(0, "test", "header info: ${map}") })
        client.on(HttpRequestEvent.HeadersReceive, headersReceiveCallBack)

        let onceHeadersReceiveCallBack = HeadersReceiveCb({ map => Hilog.info(0, "test", "header info once: ${map}") })
        client.once(HttpRequestEvent.HeadersReceive, onceHeadersReceiveCallBack)

        let dataReceiveCallBack = DataReceiveCb({ bytes => Hilog.info(0, "test", "data info : ${bytes}") })
        client.on(HttpRequestEvent.DataReceive, dataReceiveCallBack)

        let dataEndCallBack = DataEndCb({ => Hilog.info(0, "test", "data end") })
        client.on(HttpRequestEvent.DataEnd,dataEndCallBack)

        let dataReceiveProgressCallBack = DataReceiveProgressCb({ info => Hilog.info(0, "test", "receive progress ${info.receiveSize} ${info.totalSize} ") })
        client.on(HttpRequestEvent.DataReceiveProgress, dataReceiveProgressCallBack)

        let dataSendProgressCallBack = DataSendProgressCb({info => Hilog.info(0, "test", "send progress ${info.sendSize} ${info.totalSize} ")})
        client.on(HttpRequestEvent.DataSendProgress, dataSendProgressCallBack)

        client.off(HttpRequestEvent.HeadersReceive)
        client.off(HttpRequestEvent.DataReceive)
        client.off(HttpRequestEvent.DataEnd)
        client.off(HttpRequestEvent.DataReceiveProgress)
        client.off(HttpRequestEvent.DataSendProgress)
        Hilog.info(0, "", "create ok")
        client.requestInStream(
            "http://www.baidu.com",
            {
                err, code =>
                if (let Some(e) <- err) {
                    Hilog.error(0, "testCallback", "exception: ${e.message}")
                }
                if (let Some(c) <- code) {
                    Hilog.error(0, "testCallback", "${c}")
                } else {
                    Hilog.error(0, "testCallback", "code is none")
                }
                client.destroy()
            }
        )
    }

    @TestCase
    @Tag[APILevel21, TestLevel0]
    func testCache(): Unit {
        let respCache = createHttpResponseCache()
        respCache.flush()
        respCache.delete()
    }

    @TestCase
    @Tag[APILevel21, TestLevel0]
    func Request_InvalideUrl_Excption(): Unit {
        let url = "http://www.baidubaidu.com/"
        let request = createHttp()
        let requestCB: (?BusinessException, ?HttpResponse) -> Unit = {
            err, code =>
            Hilog.info(0, "requestCallback", "request callback execute")
            if (let Some(e) <- err) {
                Hilog.error(0, "requestCallback", "exception: ${e.message}")
            }
            if (let Some(respCode) <- code) {
                Hilog.info(0, "requestCallback", "response code is: ${respCode.responseCode}")
            }
        }
        // will cause exception in commonCallback
        request.request(url, requestCB)
        request.request(url, requestCB)
        sleepFor(3.second)
    }

    @TestCase
    @Tag[APILevel21, TestLevel0]
    func RequestInStream_InvalideUrl_Excption(): Unit {
        let url = "http://www.baidubaidu.com/"
        let request = createHttp()
        let requestInStreamCB: (?BusinessException, ?UInt32) -> Unit = {
            err, code =>
            Hilog.info(0, "requestCallback", "requestInStream callback execute")
            if (let Some(e) <- err) {
                Hilog.error(0, "requestCallback", "exception: ${e.message}")
            }
            if (let Some(respCode) <- code) {
                Hilog.info(0, "requestCallback", "response code is: ${respCode}")
            }
        }
        // will cause exception in commonCallback
        request.requestInStream(url, requestInStreamCB)
        request.requestInStream(url, requestInStreamCB)
        sleepFor(3.second)
    }

}

public func stringifier(CertType: Type): String {
    match (CertType) {
        case PEM => "PEM"
        case DER => "DER"
        case P12 => "P12"
        case _ => ""
    }
}

func expectBusinessException(errCode: Int32, f: () -> Unit) {
    try {
        f()
        @Expect(false)
    } catch (e: BusinessException) {
        @Expect(e.code, errCode)
    }
}

class DataReceiveCb <: Callback1Argument<Array<Byte>> {
    let callback_: (Array<Byte>)->Unit
    public init(callback: (Array<Byte>)->Unit) {callback_ = callback}
    public open func invoke(err: ?BusinessException, val: Array<Byte>): Unit {
        callback_(val)
    }
}

class HeadersReceiveCb <: Callback1Argument<HashMap<String, String>> {
    let callback_: (HashMap<String, String>)->Unit
    public init(callback: (HashMap<String, String>)->Unit) {callback_ = callback}
    public open func invoke(err: ?BusinessException, val: HashMap<String, String>): Unit {
        callback_(val)
    }
}

class DataEndCb <: Callback0Argument {
    let callback_: ()->Unit
    public init(callback: ()->Unit) {callback_ = callback}
    public open func invoke(err: ?BusinessException): Unit {
        callback_()
    }
}

class DataReceiveProgressCb <: Callback1Argument<DataReceiveProgressInfo> {
    let callback_: (DataReceiveProgressInfo)->Unit
    public init(callback: (DataReceiveProgressInfo)->Unit) {callback_ = callback}
    public open func invoke(err: ?BusinessException, val: DataReceiveProgressInfo): Unit {
        callback_(val)
    }
}

class DataSendProgressCb <: Callback1Argument<DataSendProgressInfo> {
    let callback_: (DataSendProgressInfo)->Unit
    public init(callback: (DataSendProgressInfo)->Unit) {callback_ = callback}
    public open func invoke(err: ?BusinessException, val: DataSendProgressInfo): Unit {
        callback_(val)
    }
}
