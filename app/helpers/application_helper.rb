module ApplicationHelper
  def notifications_display
    form = []
    flash.each do |k,m|
      form << content_tag(:div, content_tag(:p, m.to_s), :id => "#{k}_notice", :class => "#{k} message")
    end
    raw(form.flatten.map { |e| e.mb_chars }.join())
  end
end