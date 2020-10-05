# Release App

This is an application where we can manage all the releases of a project. By manage it means
that whenever we have a merge event in git the information is then sent to this application
and then it fetches the story information of the pull/merge request from Jira and auto generates
a default note for the specific release (pull/merge request). The concerned developer will then
get notified through mail to make further changes to the note as the note will still be incomplete
as the developer hasn't made any changes to it. Once the developer updates his/her note only then
it's complete.

All ready releases will then be ready for the QA's to test and finally approve or reject. After the
QA have tested all the ready state releases and gave a resolution to it, the final release note
will then be prepared.

## Installation

* Install the dependencies with `bundle install`
* Copy `.env.example` to `.env`
* Create the database with `rake db:create`
* Initialize the database `rake db:schema:load`

## Prerequisite

As we're going to establish connections with Github and Jira we need to first make some credentials
before we start using the application.

* As we support github login in our app therefore we need to build an `OAuth application` in github
* We also need to create a `github access token` to access the github api's through Octokit
* As the event's will be coming through `webhooks` therefore don't forget to setup the webhook url
in the project github repos webhook settings
* We also need to generate a `jira api token` for each jira organization and set that under the settings
portion of all projects those are under the organization

## User Manual

* Create a Team (or so called organization according to Github)
* Create Projects under each Team
* Each project will have a setting where you can setup the necessary git and jira information of the
project (please note carefully these setup have to be the actual one's otherwise the events won't work)
* Under each project there are the releases of the project
* Both the git and jira information of the release will be auto mapped and the edit portion will be for
the developers to finalize the note


