module ApplicationHelper
  # ページタイトルを動的に変更する処理
  def page_title(title = '')
    base_title = 'NeCommunity'
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  # フラッシュメッセージ表示処理
  def flash_class(key)
    case key
    when 'success'
      'bg-green-100 border-green-400 text-green-700'
    when 'danger', 'error'
      'bg-red-100 border-red-400 text-red-700'
    else
      'bg-blue-100 border-blue-400 text-blue-700'
    end
  end

  # Twitterへシェアするための設定
  def show_meta_tags
    assign_meta_tags if display_meta_tags.blank?
    display_meta_tags
  end

  # Twitterへシェアするための設定
  def assign_meta_tags(options = {})
    defaults = t('meta_tags.defaults')
    options.reverse_merge!(defaults)
    site = options[:site]
    title = options[:title]
    image = options[:image].presence || image_url('OGP-image.jpg')

    configs = {
      separator: '|',
      reverse: true,
      # 以下の「site」「title」はページタイトルに影響したためコメントにした。
      # site: site,
      # title: title,
      canonical: request.original_url,
      icon: {
        href: image_url('OGP-image.jpg')
      },
      og: {
        type: 'website',
        title: title.presence || site,
        url: request.original_url,
        image: image, # 使用する画像のパスを指定
        site_name: site
      },
      twitter: {
        site: site,
        card: 'summary_large_image',
        image: #image # 使用する画像のパスを指定
      }
    }
    set_meta_tags(configs)
  end

  def address(veterinary)
    veterinary["result"]["formatted_address"]
    # binding.pry
  end
end
