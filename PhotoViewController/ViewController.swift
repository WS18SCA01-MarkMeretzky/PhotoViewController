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
            fatalError("could not create baseURL");
        }
        
        let query: [String: String] = [
            "api_key": "DEMO_KEY",
        ];
        
        guard let url: URL = baseURL.withQueries(query) else {
            fatalError("could not create URL");
        }
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
            if let error: Error = error {
                print("error = \(error)");
            }
            
            guard let data: Data = data else {
                fatalError("Data is nil");
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

}
