import Foundation

enum DataTaskError: Error {
    case unexpectedCancel
}

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        let requestTask = Task { () -> (Data, URLResponse) in
            var uSesionDT: URLSessionDataTask?
            let summary: (Data, URLResponse) = try await withCheckedThrowingContinuation { continuation in
                uSesionDT = dataTask(with: urlRequest) { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    }
                    if let data = data, let response = response {
                        continuation.resume(returning: (data, response))
                    }
                }
            }
            if Task.isCancelled {
                uSesionDT?.cancel()
                throw DataTaskError.unexpectedCancel
            }
            return summary
        }
        let result = await requestTask.result
        switch result {
        case .success(let (data, response)):
            return (data, response)
        case let .failure(error):
            throw error
        }
    }
}
