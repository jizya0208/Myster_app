class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) } #作成日を降順でソートすることで、新しい通知から順に並ぶ
  belongs_to :article, optional: true  #belongs_toの紐付けによりデフォルトでnilは許可されないが、optional: trueで、nilを許容
  belongs_to :article_comments, optional: true
  belongs_to :visitor, class_name: 'Member', foreign_key: 'visitor_id'
  belongs_to :visited, class_name: 'Member', foreign_key: 'visited_id'
end
