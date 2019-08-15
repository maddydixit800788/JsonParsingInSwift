//
//  ViewController.swift
//  JsonParsingSwift
//
//  Created by Madhav on 14/07/19.
//  Copyright © 2019 Madhav. All rights reserved.
//

import UIKit

struct Course_1 {
    let id : Int
    let name : String
    let link : String
    let imageUrl : String
    
    init(json : [String: Any]) {
        id = json["id"] as? Int ?? -1
        name = json["name"] as? String ?? ""
        link = json["link"] as? String ?? ""
        imageUrl = json["imageUrl"] as? String ?? ""
    }
}

struct Course_2 : Decodable {
    let id : Int
    let name : String
    let link : String
    let imageUrl : String
}

struct Course_3 : Decodable {
    let id : Int?
    let name : String?
    let link : String?
    let imageUrl : String?
}

struct CourseWithDescription : Decodable {
    let name: String
    let description: String
    let courses: [Course_2]
}

class ViewController: UIViewController {
    
    @IBOutlet weak var JsonListTable: UITableView!
    var strURL = String()
    
    let arrJsonsType = ["Single Object With Normal Method","Single Object Using Decoder","Same Object in Array","Multiple Objects","Missing Objects"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JsonListTable.tableFooterView = UIView()
    }
    
    func SingleObjectJsonParsing() {
        strURL = "https://api.letsbuildthatapp.com/jsondecodable/course"
        guard let url = URL(string: strURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else { return }
                
                let course = Course_1(json: json)
                print(course.name)
                
            } catch let jsonErr {
                print("Error serializing json : ",jsonErr)
            }
            }.resume()
    }
    
    func SingleObjectUsingDecoderJsonParsing() {
        strURL = "https://api.letsbuildthatapp.com/jsondecodable/course"
        guard let url = URL(string: strURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            
            do {
                let course = try JSONDecoder().decode(Course_2.self, from: data)
                print(course.name)
                
            } catch let jsonErr {
                print("Error serializing json : ",jsonErr)
            }
            }.resume()
    }
    
    func SameObjectInArrayJsonParsing() {
        strURL = "https://api.letsbuildthatapp.com/jsondecodable/courses"
        guard let url = URL(string: strURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            
            do {
                let courses = try JSONDecoder().decode([Course_2].self, from: data)
                for course in courses {
                    print("Course name : ",course.name)
                }
                
            } catch let jsonErr {
                print("Error serializing json : ",jsonErr)
            }
            }.resume()
    }
    
    func MultipleObjectsJsonParsing() {
        strURL = "https://api.letsbuildthatapp.com/jsondecodable/website_description"
        guard let url = URL(string: strURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            
            do {
                let coursesWithDescription = try JSONDecoder().decode(CourseWithDescription.self, from: data)
                print("Name : \(coursesWithDescription.name) \nDescription : \(coursesWithDescription.description)")
                
                for course in coursesWithDescription.courses {
                    print("Course name : ",course.name)
                }
                
            } catch let jsonErr {
                print("Error serializing json : ",jsonErr)
            }
            }.resume()
    }
    
    func MissingObjectJsonParsing() {
        strURL = "https://api.letsbuildthatapp.com/jsondecodable/courses_missing_fields"
        guard let url = URL(string: strURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            
            do {
                let courses = try JSONDecoder().decode([Course_3].self, from: data)
                for course in courses {
                    print("\n--------------------------------------------------------------------------------------------------------------------------")
                    print("Course id : ",course.id ?? "-NA-")
                    print("Course name : ",course.name ?? "-NA-")
                    print("Course link : ",course.link ?? "-NA-")
                    print("Course imageUrl : ",course.imageUrl ?? "-NA-")
                }
                
            } catch let jsonErr {
                print("Error serializing json : ",jsonErr)
            }
            }.resume()
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrJsonsType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JsonListTable.dequeueReusableCell(withIdentifier: "TVCell", for: indexPath)
        
        cell.textLabel?.text = arrJsonsType[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row : \(indexPath.row)")
        switch indexPath.row {
        case 0:
            SingleObjectJsonParsing()
            break
        case 1:
            SingleObjectUsingDecoderJsonParsing()
            break
        case 2:
            SameObjectInArrayJsonParsing()
            break
        case 3:
            MultipleObjectsJsonParsing()
            break
        case 4:
            MissingObjectJsonParsing()
            break
        default:
            print("No row available")
        }
    }
    
}

