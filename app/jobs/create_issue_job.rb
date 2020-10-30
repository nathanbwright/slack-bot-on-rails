# frozen_string_literal: true

# create github issue and post link to slack thread
class CreateIssueJob < ApplicationJob
  # Default settings for this job. These are optional - without them, jobs
  # will default to priority 100 and run immediately.
  # self.run_at = proc { 1.minute.from_now }

  # We use the Linux priority scale - a lower number is more important.
  self.priority = 10

  def run(thread_id:)
    installation = GithubInstallation.last
    # issues require a repository
    return unless installation&.repository&.present?

    slack_thread = SlackThread.find(thread_id)
    issue = installation.create_issue(title: "Slack thread ##{slack_thread.id}")

    SlackThread.transaction do
      slack_thread.update(issue_url: issue.html_url) if issue&.html_url
      # destroy the job when finished
      destroy
    end

    return unless issue&.html_url

    # post link to issue in the slack thread
    slack_thread.post_message("Issue created: #{issue.html_url} :ticket:")
  end
end
