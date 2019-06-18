class Order < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :wzs, -> { uniq }
  has_many :orders_wzs
  has_many :wzs, through: :orders_wzs
  has_many :resources

  has_paper_trail

  scope :metal, -> () { where(type: 'MetalOrder')}
  scope :furniture, -> () { where(type: 'FurnitureOrder')}

  scope :wsk, -> () { where(purchaser: 'WSK') }
  scope :diff, -> () { where(purchaser: 'Inne') }

  accepts_nested_attributes_for :resources

  validates_presence_of :description, :user_id, :quantity, :delivery_request_date, :status, :type

  before_update :check_status
  before_create :check_status

  scope :at_date, ->(date) {
    where('created_at >= ? AND created_at < ?',
          date.beginning_of_day,
          date.beginning_of_day + 1.day
    )
  }

  scope :at_month, ->(date) {
    where('created_at >= ? AND created_at <= ?',
          date.beginning_of_month,
          date.end_of_month
    )
  }

  scope :from_to, ->(from, to) {
    where('created_at >= ? AND created_at < ?',
          from.to_date.beginning_of_day,
          to.to_date.end_of_day
    )
  }

  scope :delivered_at, ->(date) {
    where('delivery_date >= ? AND delivery_date < ?',
          date.beginning_of_day,
          date.beginning_of_day + 1.day)
  }

  scope :at_status, ->(status) {
    where('status = ?', status)
  }

  def check_status
    if status == 'not_confirmed' && delivery_request_date.try(:to_date) == confirmation_date.try(:to_date)
      self.status = 'ordered'
    end
  end

end
