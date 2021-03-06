class Encounter < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :taggings, :dependent => :destroy
  has_many :tags, through: :taggings

  validates :category_id, presence: true
  validates :user_id, presence: true
  validates :description, presence: true

  scope :recently_added_encounters, -> (limit) { order("created_at desc").limit(limit) }

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(names)
    self.tags = names.split(',').map do |n|
      Tag.where(name: n.strip.downcase).first_or_create!
    end
  end

end
