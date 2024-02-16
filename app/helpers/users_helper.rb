module UsersHelper
  def avatar(username)
    if username.nil?
      return content_tag(:div, '', class: 'w-10 h-10 rounded-full')
    end
    hash = Digest::SHA256.hexdigest(username)
    color = "##{hash[0..5]}"
    content_tag(:div, '', class: 'w-10 h-10 rounded-full', style: "background-color: #{color};")
  end
end
