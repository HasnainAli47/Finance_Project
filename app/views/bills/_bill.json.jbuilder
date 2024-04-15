json.extract! bill, :id, :amount, :description, :status, :bill_reference, :created_at, :updated_at
json.url bill_url(bill, format: :json)
