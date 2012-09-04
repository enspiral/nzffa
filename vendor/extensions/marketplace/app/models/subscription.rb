class Subscription < ActiveRecord::Base
  FFT_BRANCH_NAME = 'Farm Forestry Timbers'

  has_one :order
  belongs_to :reader
  has_many :subscriptions_branches
  has_many :branches, :through => :subscriptions_branches
  belongs_to :main_branch, :class_name => 'Branch'
  validates_inclusion_of :membership_type, :in => ['full', 'casual']
  validates_inclusion_of :tree_grower_delivery_location, :in => ['new_zealand', 'australia', 'everywhere_else'], :if => 'receive_tree_grower_magazine? && membership_type == "casual"'
  validates_presence_of :expires_on, :begins_on
  validates_presence_of :reader

  validates_inclusion_of :ha_of_planted_trees, 
    :in => NzffaSettings.forest_size_levys.keys, :if => 'membership_type == "full"'

  def self.active_subscription_for(reader)
    find(:all, :conditions => {:reader_id => reader.id}, :order => 'id desc').each do |sub|
      return sub if sub.active?
    end
    nil
  end

  def active?
    if cancelled_on
      false
    else
      (begins_on..expires_on).include?(Date.today)
    end
  end

  def after_initialize
    self.begins_on ||= Date.today
    self.expires_on ||= Date.new(Date.today.year, 12, 31)
  end

  def associated_branch_names
    names = branches.map(&:name)
    names -= main_branch.name if main_branch.present?
    names
  end

  def associated_branch_names=(branch_names)
    if main_branch.present?
      branch_names -= [main_branch.name]
    end
    self.branches += Branch.find(:all, :conditions => {:name => branch_names})
  end

  def main_branch_name
    if main_branch.present?
      self.main_branch.name
    else
      nil
    end
  end

  def main_branch_name=(name)
    self.main_branch = Branch.find_by_name(name)
    self.branches << self.main_branch
  end

  def price_when_sold
    if order and order.paid?
      order.amount
    end
  end
end
