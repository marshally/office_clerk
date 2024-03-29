# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    product
    quantity 1
    price {product.price}
    tax 10
    sequence( :name) { |n| "product #{n}" }
    factory :item_quantity do
      quantity 1 
    end
    factory :item2 do
      factory :item22 do
        quantity 2
      end
    end
  end
end
