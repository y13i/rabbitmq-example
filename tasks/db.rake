namespace :db do
  desc "connect to sqlite3 database"
  task :connect do
    ActiveRecord::Base.establish_connection(
      adapter:  "sqlite3",
      database: "db.sqlite3",
    )
  end

  desc "create tables on db"
  task :create => :connect do
    User::InitialSchema.migrate :up
    Company::InitialSchema.migrate :up
    State::InitialSchema.migrate :up
  end

  desc "drop tables from db"
  task :drop => :connect do
    User::InitialSchema.migrate :down
    Company::InitialSchema.migrate :down
    State::InitialSchema.migrate :down
  end

  desc "create dummy records on db"
  task :seed => :connect do
    (ENV["COMPANY_COUNT"] || 10).times {Company.create}
    (ENV["STATE_COUNT"] || 10).times {State.create}
    (ENV["USER_COUNT"] || 100).times {User.create}
  end

  namespace :show do
    desc "show users"
    task :users => "db:connect" do
      User.includes(:company, :state).find_each {|user| puts user}
    end

    desc "show companies"
    task :companies => "db:connect" do
      Company.find_each {|company| puts company}
    end

    desc "show states"
    task :states => "db:connect" do
      State.find_each {|state| puts state}
    end
  end
end
