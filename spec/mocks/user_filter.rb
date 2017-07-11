class UserFilter < QueryFilter::Base
  scope :name
  date_range :created_at
  range :login_count
  splitter_range :failed_attempts
  order_by :sort_column, via: :sort_mode

  scope :first_name, if: :allow_first_name?

  def scope_name(value)
    query.where(name: value)
  end

  def scope_first_name(_)
    query.where(first_name: 'admin')
  end

  def date_range_created_at(period)
    query.where(created_at: period.range)
  end

  def range_login_count(range)
    query.where(range.query('users.login_count'))
  end

  def splitter_range_failed_attempts(value)
    query.where(failed_attempts: value.range)
  end

  def order_by_sort_column(column, direction)
    query.reorder("users.#{column} #{direction}")
  end

  protected

  def allow_first_name?
    @params[:fn] == 'test'
  end
end
