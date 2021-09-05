class Favorite < ApplicationRecord
  belongs_to :member
  belongs_to :article
  counter_culture :article
end
