class User < ActiveRecord::Base
  def self.filter(params)
    UserFilter.new(all, params).to_query
  end
end
