class WebhooksController < ApplicationController
  protect_from_forgery with: :reset_session
  skip_before_action :require_login
  skip_authorization_check
  http_basic_authenticate_with name: Global.github.webhook.username,
                               password: Global.github.webhook.password

  def github
    verify_signature(request.body.read)
    StoreGitMergeInformation.call(JSON.parse(request.body.read))
  end

  private

  def verify_signature(payload_body)
    token = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), Global.github.webhook.secret, payload_body)
    signature = "sha1=#{token}"
    unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
      fail I18n.t('github.unauthorize_access')
    end
  end
end
