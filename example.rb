# frozen_string_literal: true

class Common
  def initialize(user)
    cannot [:edit, :update], Legislation::Proposal do |proposal|
      proposal.editable_by?(user)
    end

    cannot %i[edit update], Legislation::Proposal do |proposal|
    proposal.editable_by?(user)
    end
  end
end