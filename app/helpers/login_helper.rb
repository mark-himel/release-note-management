module LoginHelper
  def omniauth_path(type)
    origin = params[:redirect_to] || '/'
    raise ArgumentError, "Hackers from #{origin} ?" unless origin.start_with?("/")
    "/auth/#{type}?origin=#{CGI.escape(origin)}"
  end
end
