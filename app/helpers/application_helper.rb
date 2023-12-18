module ApplicationHelper
  def page_title(title = '')
    base_title = 'NeCommunity'
    title.present? ? "#{title} | #{base_title}" : base_title
  end

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

  def show_meta_tags
    # @twitter_share_url = "https://twitter.com/share?url=#{CGI.escape(request.original_url)}&text=#{CGI.escape(@post.title)}&via=your_twitter_username"
    assign_meta_tags if display_meta_tags.blank?
    display_meta_tags
  end
  
  def assign_meta_tags(options = {})
    defaults = t('meta_tags.defaults')
    options.reverse_merge!(defaults)
    site = options[:site]
    title = options[:title]
    # description = options[:description]
    # keywords = options[:keywords]
    image = options[:image].presence || image_url('cat-5830643_1920.jpg')
    image = 'cat-5830643_1920.jpg' if image == 'c34caee90e20401e3fa0e8c574bdc298.jpg'
  
    configs = {
      separator: '|',
      reverse: true,
      site: site,
      title: title,
      # description:,
      # keywords:,
      canonical: request.original_url,
      icon: {
        href: image_url('cat-5830643_1920.jpg')
      },
      og: {
        type: 'website',
        title: title.presence || site,
        # description:,
        url: request.original_url,
        image: image, # 使用する画像のパスを指定
        site_name: site
      },
      twitter: {
        site: site,
        card: 'summary_large_image',
        image: image # 使用する画像のパスを指定
      }
    }
    set_meta_tags(configs)
  end
  
end
