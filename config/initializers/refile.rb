#画像のアップロード先を変更
Refile.backends['store'] = Refile::Backend::FileSystem.new('public/uploads/')