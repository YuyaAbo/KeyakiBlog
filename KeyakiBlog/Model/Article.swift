struct Article {

    let id: Int
    let title: String
    let url: String
    let author: String
    let publishedAt: String
    let image: String?
    
    init(_ id: Int, _ title: String, _ url: String, _ author: String, _ publishedAt: String, _ image: String? = nil) {
        self.id = id
        self.title = title
        self.url = url
        self.author = author
        self.publishedAt = publishedAt
        self.image = image
    }
    
}
