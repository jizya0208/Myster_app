class ArticleImage < ApplicationRecord
  belongs_to :article
  attachment :image
end
