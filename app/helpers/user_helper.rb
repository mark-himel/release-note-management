module UserHelper
  def github_user_avatar(avatar_url, github_username)
    image_tag avatar_url,
              title: github_username,
              class: 'avatar--github',
              'data-toggle': 'tooltip'
  end
end
