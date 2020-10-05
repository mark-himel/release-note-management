class GithubAuthorization
  attr_accessor :login, :github

  def initialize(login, token)
    @login = login
    @github = Octokit::Client.new(access_token: token)
  end

  def role
    if config.organization
      teams = github.organization_teams(config.organization)
      owner_team = find_team(teams, config.admin_team)
      deploy_team = find_team(teams, config.deploy_team)

      if team_member?(owner_team)
        User.roles[:admin]
      elsif team_member?(deploy_team)
        User.roles[:deployer]
      elsif organization_member?
        User.roles[:viewer]
      end
    else
      User.roles[:viewer]
    end
  end

  private

  def organization_member?
    github.organization_member?(config.organization, login)
  end

  def find_team(teams, slug)
    teams.find { |t| t.slug == slug }
  end

  def team_member?(team)
    team && github.team_member?(team.id, login)
  end

  def config
    Global.github
  end
end
