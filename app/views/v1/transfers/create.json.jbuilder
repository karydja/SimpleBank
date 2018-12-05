json.data do
  json.id @transfer.id
  json.type @transfer.class.to_s

  json.attributes do
    json.extract!(@transfer,
                 :amount,
                 :source_account_id,
                 :destination_account_id,
                 :created_at,
                 :updated_at)
  end

  json.relationships do
    json.source_account do
      json.data do
        json.id @transfer.source_account.id
        json.type @transfer.source_account.class.to_s
        json.attributes do
          json.extract!(@transfer.source_account,
                       :name,
                       :created_at,
                       :updated_at)
        end
      end
    end

    json.destination_account do
      json.data do
        json.id @transfer.destination_account.id
        json.type @transfer.destination_account.class.to_s
        json.attributes do
          json.extract!(@transfer.destination_account,
                       :name,
                       :created_at,
                       :updated_at)
        end
      end
    end
  end
end
