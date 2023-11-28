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
end
