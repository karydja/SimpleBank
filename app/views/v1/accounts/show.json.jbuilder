json.data do
  json.id @account.id
  json.type @account.class.to_s

  json.attributes do
    json.extract!(@account, :name, :balance)
  end
end
