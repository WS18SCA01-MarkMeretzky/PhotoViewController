//
//  URL.swift
//  PhotoViewController
//
//  Created by Mark Meretzky on 3/3/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

import Foundation;

extension URL {   //p. 844
    func withQueries(_ queries: [String: String]) -> URL? {
        guard var components: URLComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil;
        }
        components.queryItems = queries.map {URLQueryItem(name: $0.0, value: $0.1)}
        return components.url;
    }
}
