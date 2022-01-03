# frozen_string_literal: true
require 'date'

json = [
  {
    id: 1,
    name: 'Employee #1',
    customer_id: 1,

    # when this user started
    activated_on: Date.new(2018, 11, 4),

    # last day to bill for user
    # should bill up to and including this date
    # since user had some access on this date
    deactivated_on: Date.new(2019, 1, 10)
  },
  {
    id: 2,
    name: 'Employee #2',
    customer_id: 1,

    # when this user started
    activated_on: Date.new(2018, 12, 4),

    # hasn't been deactivated yet
    deactivated_on: nil
  }
]

date = '2019-01'

# @param [Object] json
# @param [Object] date
# @return [Hash]
def bill_for(json, date)
  date += '-01'
  year = Date.parse(date.to_s).year
  month = Date.parse(date.to_s).month

  first_day = Date.new(year.to_i, month.to_i)
  last_day = Date.new(year.to_i, month.to_i, -1)

  days_in_month = Date.parse(last_day.to_s).strftime('%d')

  invoice_start_date = Date.new(year.to_i, month.to_i, Date.parse(first_day.to_s).day.to_i)
  invoice_end_date = Date.new(year.to_i, month.to_i, Date.parse(last_day.to_s).day.to_i)

  result = {}
  total_usage = 0
  deactivated_users = nil
  active_users = 0

  json.each do |employee|

    active_users += 1
    activated_on = :activated_on
    deactivated_on = :deactivated_on
    id = :id

    start_date = invoice_start_date
    start_date = employee[activated_on] if employee[activated_on] > invoice_start_date

    end_date = invoice_end_date
    unless employee[deactivated_on].nil?
      if [Date.parse(employee[deactivated_on].to_s).year, Date.parse(employee[deactivated_on].to_s).month] ==
         [Date.parse(invoice_end_date.to_s).year, Date.parse(invoice_end_date.to_s).month] &&
         Date.parse(employee[deactivated_on].to_s).day < Date.parse(invoice_end_date.to_s).day
        end_date = employee[deactivated_on]
      end
      deactivated_users += 1
    end

    active_days = end_date - start_date
    daily_rate = 4.to_f / days_in_month.to_i

    employee_id = "employee_#{employee[id]}"

    employee_usage = daily_rate * active_days

    total_usage += employee_usage
    result[employee_id] = employee_usage.round(2)

  end

  result['total usage'] = total_usage.round(2)
  result['users active'] = active_users
  result['users deactivated'] = deactivated_users
  puts result
  return result
end

bill_for(json, date)


def first_day_of_month(date)
  Date.new(date.year, date.month)
end

def last_day_of_month(date)
  Date.new(date.year, date.month, -1)
end
