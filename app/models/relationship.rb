class Relationship < ApplicationRecord
  # フォロー被与関係からfollowerとfollowedの２つのモデルを生成。Relationshipモデルはそれらの中間テーブルであり、class_name: "Member"でMemberモデルから派生したクラスであることを補足。
  belongs_to :follower, class_name: "Member"
  belongs_to :followed, class_name: "Member"
end
