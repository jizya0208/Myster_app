# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Category.create(name: 'カジュアル')
Category.create(name: 'フォーマル')
Category.create(name: 'アウトドア')
Category.create(name: 'ルーム')
Category.create(name: 'その他')

TransactionType.create(name: 0)
TransactionType.create(name: 1)
TransactionType.create(name: 2)
