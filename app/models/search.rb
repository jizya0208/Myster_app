  def self.search(keyword)
    return Article.all() unless keyword
    Article.where('title LIKE(?) OR body LIKE(?)', "%#{keyword}%")
  end