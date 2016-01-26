class User < ActiveRecord::Base
  extend ClassExtension

  belongs_to :company
  belongs_to :state

  after_initialize :set_default_value
  after_create     :notify_creation

  def to_s
    "##{id} #{name.light_white} (#{company}) @ #{state}"
  end

  private

  def set_default_value
    self.name    ||= Faker::Name.name
    self.color   ||= String.colors.reject {|c| c.to_s.match(/black|white|default/)}.sample.to_s
    self.company ||= Company.sample
    self.state   ||= State.sample
  end

  def notify_creation
    puts "#{self.class} created: #{self} (ID: `#{id}`)"
  end

  class InitialSchema < ActiveRecord::Migration
    def self.up
      create_table :users do |t|
        t.string  :name
        t.string  :color
        t.integer :company_id
        t.integer :state_id
      end
    end

    def self.down
      drop_table :users
    end
  end
end
