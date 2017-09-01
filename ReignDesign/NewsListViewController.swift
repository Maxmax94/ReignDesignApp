//
//  NewsListViewController.swift
//  ReignDesign
//
//  Created by Delapille on 01/09/2017.
//  Copyright © 2017 Delapille. All rights reserved.
//

import UIKit
import Alamofire

class NewsListViewController: UIViewController {
    
    @IBOutlet weak var tvNews: UITableView!
    var news: [News] = []
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        tvNews.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tvNews?.addSubview(refreshControl)

    }
    
    @objc fileprivate func reloadData() {
        if news.count > 0 {
            tvNews.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: false)
        }
        news = []
        tvNews.reloadData()
        loadData()
        
        if self.refreshControl.isRefreshing == true {
            self.refreshControl.endRefreshing()
        }
    }
    
    func loadData() {
        Alamofire.request("http://hn.algolia.com/api/v1/search_by_date?query=ios")
            .responseJSON { response in
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8), let dataNews = JsonNews(JSONString: utf8Text) {
                    
                    guard let newsInfo = dataNews.hits else { return }
                    self.news = newsInfo
                    self.tvNews.reloadData()
                }
        }

    }
    
    func offsetFrom(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let newDate = dateFormatter.date(from: date) else {
            assert(false, "no date from string")
            return ""
        }
        
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: newDate, to: Date())
        
        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + " " + seconds
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours
        
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "showWebView" {

            let destination = segue.destination as? NewsWebViewViewController
            guard let NewsIndex = tvNews.indexPathForSelectedRow?.row else { return }
            let info = self.news[NewsIndex]

            destination?.queryString = info.webViewUrl
        }
    }
}

extension NewsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.news.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NewsListCellView"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsListCellView  else {  fatalError("The dequeued cell is not an instance of NewsListCellView.") }
        
        let info = self.news[indexPath.row]
        
        cell.lblDescription.text = info.storyTitle
        cell.lblAuthor.text = info.author
        cell.lblTime.text = offsetFrom(date: info.createdDate ?? "")
        
        
        return cell
        
    }
}

extension NewsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.news.remove(at: indexPath.row)
            self.tvNews.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}





