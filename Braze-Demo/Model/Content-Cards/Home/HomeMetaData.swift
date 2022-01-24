import UIKit
import SwiftUI

// MARK: - HomeMetaData
struct HomeMetaData: Codable {
  var data: HomeData
}

extension HomeMetaData {
  static var empty: HomeMetaData {
    return HomeMetaData(data: HomeData(id: -1, attributes: HomeAttributes(createdAt: "", updatedAt: "", publishedAt: "", configuration: HomeConfiguration(id: -1, apiKey: "", configTitle: "", attributesDescription: "", vertical: ""), header: Header(id: -1, title: "", fontColorString: nil, backgroundColorString: nil), pills: [], bottles: [], composites: [])))
  }
}

// MARK: - HomeData
struct HomeData: Codable {
  let id: Int
  var attributes: HomeAttributes
}

// MARK: - HomeAttributes
struct HomeAttributes: Codable {
  let createdAt, updatedAt, publishedAt: String
  let configuration: HomeConfiguration
  let header: Header
  var pills, bottles: [HomeItem]
  var composites: [Composite]
  
  enum CodingKeys: String, CodingKey {
    case createdAt, updatedAt, publishedAt, header, pills, bottles, composites
    case configuration = "attributes"
  }
}

// MARK: - HomeConfiguration
struct HomeConfiguration: Codable {
  let id: Int
  let apiKey: String?
  let configTitle, attributesDescription, vertical: String

  enum CodingKeys: String, CodingKey {
    case id, vertical
    case apiKey = "api_key"
    case configTitle = "config_title"
    case attributesDescription = "description"
  }
}

// MARK: - Image
struct ImageMetaData: Codable, Hashable {
  let data: ImageData?
}

// MARK: - ImageData
struct ImageData: Codable, Hashable  {
  let id: Int
  let attributes: ImageAttributes
}

// MARK: - ImageAttributes
struct ImageAttributes: Codable, Hashable {
  let url: String
  let previewURL: String?

  enum CodingKeys: String, CodingKey {
    case url
    case previewURL = "previewUrl"
  }
}

protocol HomeColorable {
  var fontColorString: String? { get }
  var backgroundColorString: String? { get}
}

extension HomeColorable {
  var fontColor: Color {
    return Color(fontColorString?.colorValue() ?? .black)
  }
  
  var backgroundColor: Color {
    return Color(backgroundColorString?.colorValue() ?? .white)
  }
}

// MARK: - Composite
struct Composite: Codable, Hashable, HomeColorable {
  let id: Int
  let title, subtitle: String
  private(set) var fontColorString, backgroundColorString: String?
  let compositeID: Int
  var miniBottles: [HomeItem]

  enum CodingKeys: String, CodingKey {
    case id, title, subtitle
    case fontColorString = "font_color"
    case backgroundColorString = "background_color"
    case compositeID = "composite_id"
    case miniBottles = "mini_bottles"
  }
}

// MARK: - Header
struct Header: Codable, HomeColorable {
  let id: Int
  let title: String
  private(set) var fontColorString, backgroundColorString: String?

  enum CodingKeys: String, CodingKey {
    case id, title
    case fontColorString = "font_color"
  }
}
