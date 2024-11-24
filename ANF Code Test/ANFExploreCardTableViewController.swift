//
//  ANFExploreCardTableViewController.swift
//  ANF Code Test
//

import UIKit

class ANFExploreCardTableViewController: UITableViewController {
    
    // Array to hold the parsed data
    var promoItems: [PromoItem] = []
    var networkManager: DataFetchable!

    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager = NetworkManager()

        tableView.register(ExploreContentCell.self, forCellReuseIdentifier: "ExploreContentCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400  // Estimated height for better performance

        // Fetch data from the URL
        fetchPromoData()

    }
    
    func fetchPromoData() {
        let urlString = "https://www.abercrombie.com/anf/nativeapp/qa/codetest/codeTest_exploreData.css"
        guard let url = URL(string: urlString) else { return }
        
        networkManager.fetchData(from: url) { result in
            switch result {
            case .success(let data):
                // Debug: Print raw JSON to see its structure
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON Response: \(jsonString)")
                }
                
                do {
                    let decoder = JSONDecoder()
                    self.promoItems = try decoder.decode([PromoItem].self, from: data)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
                
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreContentCell", for: indexPath) as! ExploreContentCell
        let promoItem = promoItems[indexPath.row]
        cell.configure(with: promoItem)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let promoItem = promoItems[indexPath.row]
        
        // Fixed height for background image
        let backgroundImageHeight: CGFloat = 200
        
        // Calculate the height of the top description label
        let topDescriptionLabelHeight = getHeightForLabel(promoItem.topDescription, font: UIFont.systemFont(ofSize: 13), width: tableView.frame.width - 30) // 15 + 15 padding
        
        // Calculate the height of the title label
        let titleLabelHeight = getHeightForLabel(promoItem.title, font: UIFont.boldSystemFont(ofSize: 17), width: tableView.frame.width - 30) // 15 + 15 padding
        
        // Calculate the height of the promo message label
        let promoMessageLabelHeight = getHeightForLabel(promoItem.promoMessage, font: UIFont.systemFont(ofSize: 11), width: tableView.frame.width - 30) // 15 + 15 padding
        
        // Calculate the height of the bottom description label
        let bottomDescriptionLabelHeight = getHeightForLabel(promoItem.bottomDescription, font: UIFont.systemFont(ofSize: 13), width: tableView.frame.width - 30) // 15 + 15 padding
        
        // Calculate the height of the contentStackView based on the number of buttons
        let buttonHeight: CGFloat = 40 // Height of each button
        let stackViewHeight = CGFloat(promoItem.content?.count ?? 0) * buttonHeight + (CGFloat(promoItem.content?.count ?? 0) - 1) * 8 // 8 is the spacing between buttons
        
        // Padding between elements
        let padding: CGFloat = 10
        let totalHeight = backgroundImageHeight + topDescriptionLabelHeight + titleLabelHeight + promoMessageLabelHeight + bottomDescriptionLabelHeight + stackViewHeight + padding * 5
        return totalHeight
    }


    private func getHeightForLabel(_ text: String?, font: UIFont, width: CGFloat) -> CGFloat {
        guard let text = text else { return 0 }
        
        let label = UILabel()
        label.font = font
        label.text = text
        label.numberOfLines = 0  // Allow for multiple lines
        label.lineBreakMode = .byWordWrapping
        let size = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        return size.height
    }


}
