module MapHelper
  def address(veterinary)
    formatted_address_address = veterinary['result']['formatted_address']
    # 郵便番号以降を取得する正規表現を格納
    postalCodeRegex = /〒(\d{3}-\d{4})\s(.*)/

    # 正規表現にマッチするか確認
    match = formatted_address_address.match(postalCodeRegex)

    # マッチした場合、郵便番号以降の情報を取得
    return unless match

    match[2] # 郵便番号以降の住所
  end
end
