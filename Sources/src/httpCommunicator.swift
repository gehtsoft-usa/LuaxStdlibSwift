import Foundation

public typealias httpCommunicator = HttpCommunicator

private enum HttpMethod: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

fileprivate struct UniqueUrl: Hashable {
    let uuid = UUID()
    let url: URL
}

//@DocBrief("HTTP communication class")
open class HttpCommunicator: NSObject {
    
    public var lock: NSRecursiveLock

    private static var httpCommunicatorQueue: DispatchQueue = {
        let result = DispatchQueue(label: "com.fxcm.fclite.http_communicator")
        return result
    }()

    private var _session: URLSession?
    private var session: URLSession {
        if let result = _session {
            return result
        }

        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.urlCache = nil

        let result = URLSession(configuration: sessionConfiguration,
                                delegate: self,
                                delegateQueue: nil)
        _session = result
        return result
    }

    public override init() {
        self.lock = NSRecursiveLock()
    }

    private var tasks: [UniqueUrl: URLSessionDataTask] = [:]
    private var readyTasksUrls = [UniqueUrl]()

    private var headers: [String: String] = [:]

    public var lastUrl: String? {
        var result: String?
        HttpCommunicator.httpCommunicatorQueue.sync {
            result = Array(tasks.keys).last?.url.absoluteString
        }
        return result
    }

    public var headersCount: Int {
        headers.count
    }

    public func header(name: String) -> String? {
        headers[name]
    }

    open func get(_ url : String?, _ callback : httpResponseCallback?) throws -> Void {
        try request(url: url, method: .get, body: nil, callback: callback)
    }

    open func post(_ url : String?, _ body : String?, _ callback : httpResponseCallback?) throws -> Void {
        try request(url: url, method: .post, body: body, callback: callback)
    }

    open func delete(_ url : String?, _ callback : httpResponseCallback?) throws -> Void {
        try request(url: url, method: .delete, body: nil, callback: callback)
    }

    open func setRequestHeader(_ name : String?, _ value : String?) -> Void {
        guard let name = name else { return }
        HttpCommunicator.httpCommunicatorQueue.sync {
            self.headers[name] = value
        }
    }

    open func cancel() -> Void {
        HttpCommunicator.httpCommunicatorQueue.sync {
            for (url, task) in tasks {
                if readyTasksUrls.contains(url) {
                    continue
                }
                task.cancel()
            }
            self.tasks.removeAll()
            self.readyTasksUrls.removeAll()
        }
    }

    private func request(url: String?, method: HttpMethod, body: String?, callback: httpResponseCallback?) throws {
        guard let url = url,
              let url = URL(string: url) else {
            try callback?.onError("Bad url")
            return
        }
        let uniqueUrl = UniqueUrl(url: url)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        HttpCommunicator.httpCommunicatorQueue.sync {
            for (header, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: header)
            }
        }

        if let body = body,
           let requestBody = body.data(using: .utf8),
           requestBody.count > 0 {
            urlRequest.httpBody = requestBody
        }

        let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            HttpCommunicator.httpCommunicatorQueue.sync {
                self?.readyTasksUrls.append(uniqueUrl)
            }
            do {
                try self?.parseResponse(url: uniqueUrl, data: data, response: response, error: error, callback: callback)
            } catch {
                try? callback?.onError(error.localizedDescription)
            }
        }
        HttpCommunicator.httpCommunicatorQueue.sync {
            self.tasks[uniqueUrl] = task
        }
        task.resume()
    }

    private func parseResponse(
            url: UniqueUrl,
            data: Data?,
            response: URLResponse?,
            error: Error?,
            callback: httpResponseCallback?
    ) throws {
        var canceled = true
        HttpCommunicator.httpCommunicatorQueue.sync {
            canceled = self.tasks[url] == nil
            let _ = self.tasks.removeValue(forKey: url)
        }
        if let error = error {
            if canceled {
                return
            }
            try callback?.onError(error.localizedDescription)
            return
        }
        guard let response = response else {
            if canceled {
                return
            }
            try callback?.onError("No response")
            return
        }
        guard let data = data else {
            if canceled {
                return
            }
            try callback?.onError("Response is empty")
            return
        }
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            if canceled {
                return
            }
            try callback?.onError("No status code in response")
            return
        }
        try callback?.onComplete(statusCode, String(data: data, encoding: .utf8) ?? "")
    }

}

extension HttpCommunicator: URLSessionDelegate {

    public func urlSession(_ session: URLSession,
            didReceive challenge: URLAuthenticationChallenge,
            completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else { return }
        completionHandler(.performDefaultHandling, URLCredential(trust: serverTrust))
    }

}
