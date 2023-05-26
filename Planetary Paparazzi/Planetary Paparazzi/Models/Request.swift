//
//  Request.swift
//  Planetary Paparazzi
//
//  Created by Jaswitha Reddy G on 5/21/23.
//

import Foundation
import Combine

struct Request {
    
    public init(type: LoadType) {
        self.type = type
    }
    
    enum LoadType {
        case refresh
        case append
    }
    
    let type: LoadType
    
    private var delegate: [RequestDelegate] = []
    
    mutating func bindingDelegate(_ delegate: RequestDelegate) {
        self.delegate.append(delegate)
    }
    
    func boardcastSuccess(_ apods: [BlockData]) {
        delegate.forEach { (delegate) in
            delegate.requestSuccess(apods, type)
        }
    }
    
    func boardcastFailure(_ error: RequestError) {
        delegate.forEach { (delegate) in
            delegate.requestError(error)
        }
    }
    
    // API data
    var date: Date?
    var concept_tags: Bool?
    var hd: Bool?
    var count: Int?
    var start_date: Date?
    var end_date: Date?
    var thumbs: Bool?
    var api_key: String = UserSetting.shared.apiKey
    
    private enum ReflectionKey: String {
        case date
        case concept_tags
        case hd
        case count
        case start_date
        case end_date
        case thumbs
        case api_key
    }
    
    enum RequestError: Error {
        case UrlError(_ error: URLError)
        case Other(_ str: String)
        case Empty
    }
    
    static private let requestUrl: URL = URL(string: "https://api.nasa.gov/planetary/apod")!
    private var formatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df
    }
    
    private func makeRequestHeader() -> [String: String] {
        var dict: [String: String] = [:]
        //let reflection = Mirror(reflecting: self);
        dict.updateValue(api_key, forKey: ReflectionKey.api_key.rawValue)
        
        let dateFormat = self.formatter;
        
        if let date = self.date {
            dict.updateValue(dateFormat.string(from: date), forKey: ReflectionKey.date.rawValue)
        }
        if let hd = self.hd {
            dict.updateValue(hd.description, forKey: ReflectionKey.hd.rawValue)
        }
        if let count = self.count {
            dict.updateValue(count.description, forKey: ReflectionKey.count.rawValue)
        }
        if let start_date = self.start_date {
            dict.updateValue(dateFormat.string(from: start_date), forKey: ReflectionKey.start_date.rawValue)
        }
        if let end_date = self.end_date {
            dict.updateValue(dateFormat.string(from: end_date), forKey: ReflectionKey.end_date.rawValue)
        }
        if let thumbs = self.thumbs {
            dict.updateValue(thumbs.description, forKey: ReflectionKey.thumbs.rawValue)
        }
        if let concept_tags = self.concept_tags {
            dict.updateValue(concept_tags.description, forKey: ReflectionKey.thumbs.rawValue)
        }
        return dict
    }
    
    func sendRequest() -> some AnyCancellable
    {
        let header = makeRequestHeader().map { (key, value) -> URLQueryItem in
            URLQueryItem(name: key, value: value)
        }
        var components = URLComponents(url: Self.requestUrl, resolvingAgainstBaseURL: false)
        components?.queryItems = header
        guard let url = components?.url else { fatalError("request url wrong")}
        var request = URLRequest(url: url);
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTaskPublisher(for: request)
            .mapError({ (error) -> RequestError in
                RequestError.UrlError(error)
            })
            .tryMap({ (data, response) in
                var results: [Result] = []
                let decoder = JSONDecoder()
                print(String(data: data, encoding: .utf8)!)
                
                if let array = try? decoder.decode(Array<Result>.self, from: data) {
                    results.append(contentsOf: array)
                }else if let single = try? decoder.decode(Result.self, from: data) {
                    results.append(single)
                }else if let error = try? decoder.decode(Result.Error.self, from: data){
                    throw RequestError.Other(error.msg)
                }else if let error = try? decoder.decode([String: Result.Error].self, from: data) {
                    throw RequestError.Other(error.first!.value.msg)
                }else {
                    throw RequestError.Other("Unknown Error")
                }
                return results
            })
            .mapError({ error in
                error as! RequestError
            })
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    self.boardcastFailure(error)
                default:
                    break
                }
            })
            { (input: [Result]) in
                let block: [BlockData] = input.map { (result) -> BlockData in
                    BlockData(content: result)
                }
                
                self.boardcastSuccess(block)
            }
        return task
    }
}

protocol RequestDelegate {
    func requestError(_ error: Request.RequestError)
    func requestSuccess(_ apods: [BlockData], _ type: Request.LoadType)
}

