module ApplicationHelper
  def popover(model_name, attribute)
    i18n_base = "simple_form.popovers.#{model_name.downcase}.#{attribute}"

    content_tag(:i, '', class: "icon-question-sign",
                        id: "#{attribute}_help",
                        title: I18n.t("#{i18n_base}.title"),
                        data: {
                            # don't use popover as it conflicts with the actual pop-over thingy
                            pop_over: true,
                            content: I18n.t("#{i18n_base}.text")
                        })
  end

  def twitterized_type(type)
    case type
      when :alert
        "alert-block"
      when :error
        "alert-error"
      when :notice
        "alert-info"
      when :success
        "alert-success"
      else
        type.to_s
    end
  end
end
