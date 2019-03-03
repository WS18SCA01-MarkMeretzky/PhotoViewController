//
//  PhotoInfo.swift
//  PhotoViewController
//
//  Created by Mark Meretzky on 3/3/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

import Foundation;

struct PhotoInfo: Codable {   //p. 855
    var title: String;
    var description: String;   //in the JSON, this is called explanation
    var date: Date;
    var mediaType: String;
    var url: URL;
    var hdUrl: URL;   //high definition
    var serviceVersion: String;
    var copyright: String?;
    
    enum CodingKeys: String, CodingKey {    //CodingKey is a protocol, p. 856
        case title;
        case description = "explanation";   //in the JSON, this is called explanation
        case date;
        case mediaType = "media_type";
        case url;
        case hdUrl = "hdurl";
        case serviceVersion = "service_version";
        case copyright;
    }
    
    init(from decoder: Decoder) throws {   //pp. 857-858
        let valueContainer: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self);
        
        title          = try  valueContainer.decode(String.self, forKey: CodingKeys.title);
        description    = try  valueContainer.decode(String.self, forKey: CodingKeys.description);
        mediaType      = try  valueContainer.decode(String.self, forKey: CodingKeys.mediaType);
        url            = try  valueContainer.decode(URL.self,    forKey: CodingKeys.url);
        hdUrl          = try  valueContainer.decode(URL.self,    forKey: CodingKeys.hdUrl);
        serviceVersion = try  valueContainer.decode(String.self, forKey: CodingKeys.serviceVersion);
        copyright      = try? valueContainer.decode(String.self, forKey: CodingKeys.copyright);
        
        let dateString: String = try valueContainer.decode(String.self, forKey: CodingKeys.date);
        let dateFormatter: DateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd";
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0);
        
        guard let date: Date = dateFormatter.date(from: dateString) else {
            let context: DecodingError.Context = DecodingError.Context(codingPath: [CodingKeys.date], debugDescription: "bad date \(dateString)")
            throw DecodingError.dataCorrupted(context);
        }
        self.date = date;
    }
}
