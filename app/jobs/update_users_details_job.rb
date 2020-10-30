# frozen_string_literal: true

# update all recent threads with metadata from the Slack API
class UpdateUsersDetailsJob < ApplicationJob
  # Default settings for this job. These are optional - without them, jobs
  # will default to priority 100 and run immediately.
  # self.run_at = proc { 1.minute.from_now }

  # We use the Linux priority scale - a lower number is more important.
  self.priority = 100

  LAST_CHANGED_AT = 7.days.ago.to_date.freeze

  def run
    users = User.where(real_name: nil)

    User.transaction do
      users.each(&:update_profile_details)
      # destroy the job when finished
      destroy
    end
  end
end
