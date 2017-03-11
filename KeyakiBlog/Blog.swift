struct Blog {

    let id: Int
    let title: String
    let author: String
    let publishedAt: String
    let image: String?
    
    init(_ id: Int, _ title: String, _ author: String, _ publishedAt: String, _ image: String? = nil) {
        self.id = id
        self.title = title
        self.author = author
        self.publishedAt = publishedAt
        self.image = image
    }
    
    static var dummies: [Blog] {
        return [
            Blog(0, "タイトル", "欅　太郎" , "2017/03/01"),
            Blog(1, "タイトル２", "欅　花子" , "2017/03/02"),
            Blog(1, "タイトル３", "欅　太郎" , "2017/03/03"),
            Blog(1, "タイトル４", "欅　太郎" , "2017/03/04"),
            Blog(1, "タイトル５", "欅　花子" , "2017/03/05"),
            Blog(1, "タイトル６", "欅　太郎" , "2017/03/06")
        ]
    }
    
}
