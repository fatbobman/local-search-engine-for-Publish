func makeTagListHTML(
        for page: TagListPage,
        context: PublishingContext<Site>
    ) throws -> HTML? {
        
        return HTML(
            .lang(context.site.language),
            .searchHead(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .searchInput(),  //  search input
                    .ul(
                        .class("all-tags"),
                        .forEach(page.tags.sorted()) { tag in
                            .li(
                                .class(tag.colorfiedClass),
                                .a(
                                    .href(context.site.path(for: tag)),
                                    .text("\(tag.string) (\(tag.count))")
                                )
                            )
                        }
                    ),
                    .searchResult()  //search result
                ),

                .footer(for: context.site)
            )
        )
    }
