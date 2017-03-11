struct Blog {
    let id: Int
    let title: String
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
    
    static var dummyData: Blog {
        return Blog(id: 0, title: "タイトル")
    }
}
