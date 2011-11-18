module ApplicationHelper
  
  def notifications_display
    form = []
    flash.each do |k,m|
      form << content_tag(:div, content_tag(:p, m.to_s), :id => "#{k}_notice", :class => "#{k} message")
    end
    raw(form.flatten.map { |e| e.mb_chars }.join())
  end
  
  def authentication_error
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:div, content_tag(:strong, t('error')) + msg, :class => 'warning message') }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML 
      <h2>#{sentence}</h2>
      #{messages}
    HTML

    html.html_safe
  end
end