struct Blog {

    let id: Int
    let title: String
    let publishedAt: String
    let image: String?
    
    init(_ id: Int, _ title: String, _ publishedAt: String, _ image: String? = nil) {
        self.id = id
        self.title = title
        self.publishedAt = publishedAt
        self.image = image
    }
    
    static var dummies: [Blog] {
        return [
            Blog(0, "タイトル", "2017/03/01"),
            Blog(1, "タイトル２", "2017/03/02"),
            Blog(1, "タイトル３", "2017/03/03"),
            Blog(1, "タイトル４", "2017/03/04"),
            Blog(1, "タイトル５", "2017/03/05"),
            Blog(1, "タイトル６", "2017/03/06")
        ]
    }
    
}
