class Post < ApplicationRecord
  belongs_to :user
  belongs_to :cat, optional: true  # Optional: trueを使用して、Catが必須でないことを指定

  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags, dependent: :destroy

  # いいね設定
  has_many :likes, dependent: :destroy

  has_many :comments, dependent: :destroy

  mount_uploader :photo, PostPhotoUploader # アバターアップローダー、useで使ってるものと同じものを使う。

  validates :title, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 500 }

  def self.ransackable_attributes(auth_object = nil)
    %w[title body]  # 検索可能な属性を指定してください
  end

  def self.ransackable_associations(auth_object = nil)
    %w[cat user tags]  # 検索可能な関連モデルを指定してください
  end

  #tag保存メソッド
  def save_tags(tags)
    tags.each do |tag|
    # 「find_or_create_by」はActive Record モデルのメソッド。
    # 指定された属性でレコードを検索し、存在しない場合には新しいレコードを作成するメソッド
    # selfはこの場合は@postのこと
    # self.tags.find_or_create_by(name: tag) # 指定された属性でレコードを検索し、存在しない場合には新しいレコードを作成するメソッド
    tagname = Tag.find_by(name: tag) || Tag.new(name: tag)
    tagname.save unless tagname.persisted?
    self.tags << tagname
    end
  end

  # タグの更新処理
  def update_tags(tags)
    # @postの中のtagsを見ている。empty?で存在する場合（nillではない場合）に中の処理に入る。
    if self.tags.empty?
      add_to_empty_tag(tags) # タグが元々空の場合、タグ追加更新処理
    elsif tags.empty?
      empty_all_tags(tags) # 取得したtagsが空だった場合の処理
    else
      new_and_old_tags(tags) # 既存のタグと新しいタグがある場合の処理
    end
  end

  # タグが元々空の場合、タグ追加更新処理
  def add_to_empty_tag(tags)
    tags.each do |tag|
      tagname = Tag.find_by(name: tag) || Tag.new(name: tag)
      tagname.save unless tagname.persisted?
      self.tags << tagname
    end
  end

  def empty_all_tags(tags)
    # 取得したtagsが空だった場合の処理
    self.tags.each do |tag|
      #@postのtagをeach文で回して一つづつ削除している。
      self.tags.delete(tag)
    end
  end

  # 既存のタグと新しいタグがある場合の処理
  def new_and_old_tags(tags)
    # 新しいタグ = 入力タグ　ー　既存タグ
    new_tags = tags - self.tags.pluck(:name)
    # 古いタグ = 既存タグ　ー　入力タグ
    old_tags = self.tags.pluck(:name) - tags # old_tagは削除に使う。
    # 古いタグ配列を削除
    old_tags.each do |old_tag|
      # @古くなったtagをeach文で回して一つづつ削除している。
      # tagにfind_byを使ってold_tagと一致するタグをself.tagから探して入れる
      tag = self.tags.find_by(name: old_tag)
      self.tags.delete(tag) if tag.present?
    end
    # 新しいタグを追加。
    new_tags.each do |new_tag|
      tagname = Tag.find_by(name: new_tag) || Tag.new(name: new_tag)
      tagname.save unless tagname.persisted?
      self.tags << tagname
    end
  end
end
