//
//  PromoItem.swift
//  ANF Code Test
//
//

import Foundation

// Define the main structure for each promo item
struct PromoItem: Codable {
    let title: String
    let backgroundImage: String?
    let content: [PromoContent]?
    let promoMessage: String?
    let topDescription: String?
    let bottomDescription: String?

    enum CodingKeys: String, CodingKey {
        case title
        case backgroundImage
        case content
        case promoMessage
        case topDescription
        case bottomDescription
    }
   init(backgroundImage: String, topDescription: String, title: String, promoMessage: String, bottomDescription: String, content: [PromoContent]?) {
       self.backgroundImage = backgroundImage
       self.topDescription = topDescription
       self.title = title
       self.promoMessage = promoMessage
       self.bottomDescription = bottomDescription
       self.content = content
   }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        backgroundImage = try container.decode(String.self, forKey: .backgroundImage)
        content = try container.decodeIfPresent([PromoContent].self, forKey: .content)
        promoMessage = try container.decodeIfPresent(String.self, forKey: .promoMessage)
        topDescription = try container.decodeIfPresent(String.self, forKey: .topDescription) ?? "Default Top Description"  // Provide a default value
        bottomDescription = try container.decodeIfPresent(String.self, forKey: .bottomDescription)
    }
}

// Define the structure for the content items (buttons)
struct PromoContent: Codable {
    let target: String
    let title: String
    
    init(title: String, target: String) {
         self.title = title
         self.target = target
     }
}


