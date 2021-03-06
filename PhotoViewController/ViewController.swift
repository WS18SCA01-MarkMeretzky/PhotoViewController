//
//  ViewController.swift
//  PhotoViewController
//
//  Created by Mark Meretzky on 3/3/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

import UIKit;

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchPhotoInfo {(fetchedInfo: PhotoInfo?) in   //p. 866
            guard let fetchedInfo: PhotoInfo = fetchedInfo else {
                print("nil passed to closure passed to fetchPhotoInfo(completion:)");
                return;
            }

            //Only the main thread can write on the user interface.
            DispatchQueue.main.async {
                self.updateUI(with: fetchedInfo);
            }
        }
    }
    
    func fetchPhotoInfo(completion: @escaping (PhotoInfo?) -> Void) {   //p. 867
        //Astronomy Picture of The Day
        guard let baseURL: URL = URL(string: "https://api.nasa.gov/planetary/apod") else {
            print("could not create baseURL");
            completion(nil);
            return;
        }
        
        let query: [String: String] = [
            "api_key": "DEMO_KEY",
        ];
        
        guard let url: URL = baseURL.withQueries(query) else {
            print("could not create URL");
            completion(nil);
            return;
        }
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
            if let error: Error = error {
                print("error = \(error)");
                completion(nil);
                return;
            }
            
            guard let data: Data = data else {
                print("Data is nil");
                completion(nil);
                return;
            }
            
            let jsonDecoder: JSONDecoder = JSONDecoder();
            
            if let photoInfo: PhotoInfo = try? jsonDecoder.decode(PhotoInfo.self, from: data) {
                completion(photoInfo);   //p. 865
            } else {
                print("Either no data was returned, or data was not properly decoded.");   //p. 866
                completion(nil);
            }
        }
        
        task.resume();
    }
    
    func updateUI(with photoInfo: PhotoInfo) {
        //Loop through the properties of photoInfo.
        let mirror: Mirror = Mirror(reflecting: photoInfo);
        
        mirror.children.forEach {
            textView.text! += "\($0.label!): \($0.value)\n";
        }
    }
    
    /*
    // I could also have written updateUI(with:) this way:
    
    func updateUI(with photoInfo: PhotoInfo) {
        textView.text! += "title: \(photoInfo.title)\n";
        textView.text! += "description: \(photoInfo.description)\n";
        textView.text! += "date: \(photoInfo.date)\n";
        textView.text! += "mediaType: \(photoInfo.mediaType)\n";
        textView.text! += "url: \(photoInfo.url)\n";
        textView.text! += "hdUrl: \(photoInfo.hdUrl?)\n";
        textView.text! += "serviceVersion: \(photoInfo.serviceVersion)\n";
        textView.text! += "copyright: \(photoInfo.copyright?)\n";
    }
    */

}
