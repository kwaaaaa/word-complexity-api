class ComplexityScoreRequest < ApplicationRecord
  before_validation :assign_uuid, on: :create

  enum :status, {
    pending: "pending",
    in_progress: "in_progress",
    completed: "completed",
    failed: "failed"
  }

  validates :uuid, presence: true, uniqueness: true

  private

  def assign_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
