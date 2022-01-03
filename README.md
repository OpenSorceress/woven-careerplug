## Code in /lib, test in /spec


Instructions

Your Notes

Help

IDE Settings
Calculating invoices for customer billing
Background
In the past, we provided some raw billing data in JSON format to the finance team, which they used to manually generate monthly invoices for our customers. Recently, they’ve asked us to create some automation to make this process less error-prone.

Instructions
Your goal is to implement the bill_for method to calculate the total monthly bill for a customer.

Customers are billed based on their subscription tier for the month. We charge them a prorated amount for each user who was active during that month.

You talked with the other engineers on the team and decided that the following algorithm would work:

Calculate a daily rate for the active subscription tier
For each day of the month, identify which users were active that day
Multiply the number of active users for the day by the daily rate to calculate the total for the day
Return the running total for the month at the end, rounded to 2 decimal places
Parameters
This billing function accepts the following parameters:



month
Always present. Has the following structure:

"2019-01"   # January 2019 in YYYY-MM format
active_subscription
May be nil. If present, has the following structure:

{
id: 1,
customer_id: 1,
monthly_price_in_dollars: 4  # price per active user per month
}
users
May be empty, but not nil. Has the following structure:

[
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
customer_id': 1,

    # when this user started
    activated_on: Date.new(2018, 12, 4),

    # hasn't been deactivated yet
    deactivated_on: nil
}
]

Return value
This function should return the total monthly bill for the customer, rounded to 2 decimal places.

If there are no users or the subscription is not present, the function should return 0 since the customer does not owe anything for that month.

Calculation Examples
Here is an example of calculating the amount to bill each customer using the algorithm described above. This example is captured by the "works when a user is activated during the month" test.

Testing
The automated tests we provide only cover a few key cases, so you should plan to add some of your own tests or modify the existing ones to ensure that your solution handles any edge cases. You should be able to follow the existing patterns for naming and constructing tests to add your own.

Notes / Edge cases
It’s more important for the return value to be correct than it is for the algorithm to be highly optimized.
You can store intermediate results as any kind of decimal type (e.g. float, double). You do not need to round values until the last step.
You should bill for all days between and including both the activation and deactivation dates since the user still had some access on the last day.
You should not change function names or return types of the provided functions since our test cases depend on those not changing.

