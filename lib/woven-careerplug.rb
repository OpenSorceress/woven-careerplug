# frozen_string_literal: true
require 'date'

users = [
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

active_subscription = {
  id: 1,
  customer_id: 1,
  monthly_price_in_dollars: 4
}

date = '2019-01'

# @param [Object] json
# @param [Object] date
# @return [Hash]
def bill_for(month, active_subscription = nil, users = {})

  date = "#{month.to_s}-01"
  year = Date.parse(date.to_s).year
  month = Date.parse(date.to_s).month

  first_day = Date.new(year.to_i, month.to_i)
  last_day = Date.new(year.to_i, month.to_i, -1)

  days_in_month = Date.parse(last_day.to_s).strftime('%d')

  invoice_start_date = Date.new(year.to_i, month.to_i, Date.parse(first_day.to_s).day.to_i)
  invoice_end_date = Date.new(year.to_i, month.to_i, Date.parse(last_day.to_s).day.to_i)

  active_users = :active_users
  total_usage = :total_usage
  billing_period = :billing_period

  invoice = {}
  invoice[billing_period] = [invoice_start_date.to_s, invoice_end_date.to_s]
  invoice[total_usage] = 0
  invoice[active_users] = 0

  return invoice if active_subscription.nil? || users.length.zero?

  deactivated_users = 0

  monthly_rate = :monthly_price_in_dollars
  if !active_subscription.nil? && users.length.positive?
    daily_rate = active_subscription[monthly_rate].to_f / days_in_month.to_i

    users.each do |employee|

      invoice[active_users] += 1
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
    employee_usage = daily_rate * active_days

    employee_id = "employee_#{employee[id]}"
    invoice[employee_id] = employee_usage.round(2)
      total = invoice[total_usage].to_f + employee_usage.to_f
      invoice[total_usage] = total.round(2)
    end
  end


  invoice['active_users'] = active_users
  invoice['users_deactivated'] = deactivated_users
  puts invoice
  invoice
end

bill_for(date, active_subscription, users)


def first_day_of_month(date)
  Date.new(date.year, date.month)
end

def last_day_of_month(date)
  Date.new(date.year, date.month, -1)
end
