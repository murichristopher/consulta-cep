class Address < ApplicationRecord
  validates :cep, presence: true, uniqueness: true
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
    group(:city, :state).order(Arel.sql("COUNT(*) DESC")).limit(limit).count
  }

  def increment_count
    self.class.update_counters(id, search_count: 1)

    reload
  end
end
