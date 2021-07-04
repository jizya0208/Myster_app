class Rating < ApplicationRecord
  belongs_to :member
  belongs_to :article_comment
end
