class Company < ActiveRecord::Base
  extend ClassExtension

  has_many :users

  after_initialize :set_default_value
  after_create     :notify_creation

  def to_s
    "##{id} #{name.colorize(color.intern)}"
  end

  private

  def set_default_value
    self.name  ||= Faker::Company.name
    self.color ||= String.colors.reject {|c| c.to_s.match(/black|white|default/)}.sample.to_s
  end

  def notify_creation
    puts "#{self.class} created: #{self} (ID: `#{id}`)"
  end

  class InitialSchema < ActiveRecord::Migration
    def self.up
      create_table :companies do |t|
        t.string :name
        t.string :color
      end
    end

    def self.down
      drop_table :companies
    end
  end
end
