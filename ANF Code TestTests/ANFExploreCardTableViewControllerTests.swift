//
//  ANF_Code_TestTests.swift
//  ANF Code TestTests
//

import XCTest
@testable import ANF_Code_Test

class ExploreContentCellTests: XCTestCase {
    
    var cell: ExploreContentCell!
    var promoItem: PromoItem!
    
    override func setUp() {
          super.setUp()
          
          // Initialize the cell and promo item
          let tableView = UITableView()
          cell = ExploreContentCell(style: .default, reuseIdentifier: "ExploreContentCell")
          tableView.addSubview(cell)
          
          promoItem = PromoItem(
              backgroundImage: "http://img.abercrombie.com/is/image/anf/ANF-2024-060624-M-HP-NewArrivals-USCA-Mens.jpg",
              topDescription: "A&F ESSENTIALS",
              title: "TOPS STARTING AT $12",
              promoMessage: "USE CODE: 12345",
              bottomDescription: "*In stores & online. <a href=\\\"http://www.abercrombie.com/anf/media/legalText/viewDetailsText20160602_Tier_Promo_US.html\\\">Exclusions apply. See Details</a>",
              content: [
                  PromoContent(title: "Shop Men", target: "https://www.abercrombie.com/shop/us/mens-new-arrivals"),
                  PromoContent(title: "Shop Women", target: "https://www.abercrombie.com/shop/us/womens-new-arrivals")
              ]
          )
      }
    
    override func tearDown() {
        cell = nil
        promoItem = nil
        super.tearDown()
    }

    // Test if the cell UI is correctly configured based on the promoItem data
    func testCellUIConfiguration() {
        // Call configure method with the promo item
        cell.configure(with: promoItem)

        // Check if the labels and text fields are correctly updated
        XCTAssertEqual(cell.topDescriptionLabel.text, promoItem.topDescription)
        XCTAssertEqual(cell.titleLabel.text, promoItem.title)
        XCTAssertEqual(cell.promoMessageLabel.text, promoItem.promoMessage)

    }

    // Test if the layout of the cell is correct after configuring it
    func testCellLayout() {
        // Call configure to set up the cell
        cell.configure(with: promoItem)

        // Trigger layout
        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        // Check the layout of the top description label
        XCTAssertTrue(cell.topDescriptionLabel.frame.origin.y > 0)
        
        // Check if the stack view is laid out properly even when there are no buttons
        XCTAssertTrue(cell.contentStackView.frame.origin.y > cell.titleLabel.frame.maxY)
    }

}
