

import UIKit

struct Film: Codable {
  let title: String
  let year: String
  let poster: String
  let plot: String
  var isExpanded: Bool
  
  // Custom init to set isExpanded bool to false
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    title = try container.decode(String.self, forKey: .title)
    year = try container.decode(String.self, forKey: .year)
    poster = try container.decode(String.self, forKey: .poster)
    plot = try container.decode(String.self, forKey: .plot)
    isExpanded = false
  }
}






