//
//  File.swift
//  
//
//  Created by Yang Xu on 2021/2/2.
//

import Foundation
import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    public static func searchResult() -> Node{
        .div(
            .id("local-search-result"),
            .class("local-search-result-cls")
        )
    }


    public static func searchInput() -> Node{
        .div(
        .form(
            .class("site-search-form"),
            .input(
                .class("st-search-input"),
                .attribute(named: "type", value: "text"),
                .id("local-search-input"),
                .required(true)
                ),
            .a(
                .class("clearSearchInput"),
                .href("javascript:"),
                .onclick("document.getElementById('local-search-input').value = '';")

            )
        ),
        .script(
            .id("local.search.active"),
            .raw(
            """
            var inputArea       = document.querySelector("#local-search-input");
            inputArea.onclick   = function(){ getSearchFile(); this.onclick = null }
            inputArea.onkeydown = function(){ if(event.keyCode == 13) return false }
            """
            )
        ),
            .script(
                .raw(searchJS)
            )

        )
    }
}


