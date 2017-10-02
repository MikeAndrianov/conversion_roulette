# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html = html_tag

  form_fields = [
    'textarea',
    'input',
    'select'
  ]

  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, " + form_fields.join(', ')
  elements.each do |e|
    if e.node_name.eql? 'label'
      html = "#{e}".html_safe
    elsif form_fields.include? e.node_name
      html_tag = Nokogiri::HTML::DocumentFragment.parse(html_tag)
      html_tag.children.add_class 'is-invalid'
      html_tag = html_tag.to_s

      if instance.error_message.kind_of?(Array)
        html = %(<div class="control-group error">#{html_tag}<div class="invalid-feedback">&nbsp;#{instance.error_message.uniq.join(', ')}</div></div>).html_safe
      else
        html = %(<div class="control-group error">#{html_tag}<div class="invalid-feedback">&nbsp;#{instance.error_message}</div></div>).html_safe
      end
    end
  end

  html.html_safe
end
