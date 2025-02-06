class Address < ApplicationRecord
  validates :cep, presence: true, uniqueness: { case_sensitive: false }
  validates :city, :state, presence: true

  scope :most_searched_ceps, ->(limit = 5) {
    order(search_count: :desc)
      .limit(limit)
      .pluck(:cep, :search_count)
      .to_h
  }

  scope :ceps_by_state, ->(limit = 5) {
    group(:state).order(Arel.sql("COUNT(*) DESC")).limit(limit).count
  }

  scope :most_searched_by_location, ->(limit = 5) {
    group(:city, :state)
      .order(Arel.sql("SUM(search_count) DESC"))
      .limit(limit)
      .sum(:search_count)
  }
  def formatted_cep
    cep.insert(5, "-")
  end

  def increment_count
    self.class.update_counters(id, search_count: 1)

    reload
  end
end
