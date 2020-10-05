module AuthorizationHelper
  # rubocop:disable Metrics/MethodLength
  def authorization_modal(link_text, title, intro,
                          open: false,
                          modal_css_class: nil,
                          modal_content_class: nil,
                          link_css_class: nil,
                          close_css_class: 'modal__close',
                          modal_id: nil, &block)
    modal_id ||= SecureRandom.hex(5)
    locals = {
      link_text: link_text,
      title: title,
      intro: intro,
      open: open,
      modal_id: "modal-#{modal_id}",
      link_css_class: link_css_class,
      close_css_class: close_css_class,
      modal_css_class: modal_css_class,
      modal_content_class: modal_content_class
    }
    render layout: 'components/modal', locals: locals do
      yield
    end
  end
  # rubocop:enable Metrics/MethodLength
end
