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
end
