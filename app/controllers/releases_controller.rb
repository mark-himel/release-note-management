class ReleasesController < ApplicationController
  load_and_authorize_resource :team
  load_and_authorize_resource :project
  load_and_authorize_resource

  def index
    @releases = @project.releases
  end

  def update
    if @release.update(release_params)
      redirect_to team_project_releases_path(@team, @project)
    else
      render :edit
    end
  end

  private

  def release_params
    params.require(:release).permit(:description)
  end
end
