//
//  File.swift
//  
//
//  Created by Yang Xu on 2021/2/1.
//

import Foundation
import Publish
import Plot
import Sweep

extension PublishingStep{
    static func makeSearchIndex(includeCode:Bool = true) -> PublishingStep{
        step(named: "make search index file"){ content in
            let xml = XML(
                .element(named: "search",nodes:[
                    .entry(content:content,includeCode: includeCode)
                ])
            )
            let result = xml.render()
            do {
                try content.createFile(at: Path("/Output/search.xml")).write(result)
            }
            catch {
                print("Failed to make search index file error:\(error)")
            }
        }
    }
}

extension Item{
    public func htmlForSearch(includeCode:Bool = true) -> String{
        var result = body.html
        result = result.replacingOccurrences(of: "]]>", with: "]>")
        if !includeCode {
        var search = true
        var check = false
        while search{
            check = false
            result.scan(using: [.init(identifier: "<code>", terminator: "</code>", allowMultipleMatches: false, handler: { match,range in
                result.removeSubrange(range)
                check = true
            })])
            if !check {search = false}
        }
        }
        return result
    }
}

extension Node {
    static func entry<Site: Website>(content:PublishingContext<Site>,includeCode:Bool) -> Node{
        let items = content.allItems(sortedBy: \.date)
        return  .forEach(items.enumerated()){ index,item in
            .element(named: "entry",nodes: [
                .element(named: "title", text: item.title),
                .selfClosedElement(named: "link", attributes: [.init(name: "href", value: "/" + item.path.string)] ),
                .element(named: "url", text: "/" + item.path.string),
                .element(named: "content", nodes: [
                    .attribute(named: "type", value: "html"),
                    .raw("<![CDATA[" + item.htmlForSearch(includeCode: includeCode) + "]]>")
                ]),
                .forEach(item.tags){ tag in
                    .element(named:"tag",text:tag.string)
                }
            ])
        }
    }
}
