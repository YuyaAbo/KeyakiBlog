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
    
    static var dummies: [Article] {
        return [
            Article(0, "タイトル", "http://test", "欅　太郎" , "2017/03/01"),
            Article(1, "タイトル２", "http://test", "欅　花子" , "2017/03/02"),
            Article(1, "タイトル３", "http://test", "欅　太郎" , "2017/03/03"),
            Article(1, "タイトル４", "http://test", "欅　太郎" , "2017/03/04"),
            Article(1, "タイトル５", "http://test", "欅　花子" , "2017/03/05"),
            Article(1, "タイトル６", "http://test", "欅　太郎" , "2017/03/06")
        ]
    }
    
}
