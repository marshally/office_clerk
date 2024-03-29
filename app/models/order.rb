class Order < ActiveRecord::Base
  has_one :basket , :as => :kori , :autosave => true

  store :address, accessors: [ :name , :street , :city , :phone ] #, coder: JSON

  after_validation :generate_order_number, :on => :create

  validates :name,  :presence => true , :if => :needs_address?
  validates :street,:presence => true , :if => :needs_address?
  validates :city,  :presence => true , :if => :needs_address?
  validates :phone, :presence => true , :if => :needs_address?
  validates :email, :presence => true , :email => {:ban_disposable_email => true, :mx_with_fallback => true }
  
  default_scope { order('created_at DESC')}

  # many a european goverment requires buisnesses to have running order/transaction numbers.
  # this is what we use, but it can easily be changed by redifining this method
  # format RYYYYRUNIN  R, 4 digit year and a running number
  def generate_order_number
    if last = Order.first # last, but default order is reversed
      num = last.number[5..9].to_i + 1
    else
      num = 30000
    end
    self.number = "R#{Time.now.year}#{num}"
  end

  def total_price
    basket.total_price + shipment_price
  end

  # total tax is for when the rates don't matter, usually to cutomers.
  # only on bills or invoices do we need the detailed list you get from the taxes function
  def total_tax
    basket.total_tax + shipment_tax*shipment_price
  end

  # return a hash of rate => amount , because products may have different taxes, 
  # the items in an order may have a collection of tax rates.
  def taxes
    cart = basket.taxes
    s_tax = self.shipment_price * shipment_tax
    #relies on basket creating a default value of 0
    cart[self.shipment_tax] += s_tax if self.shipment_tax and self.shipment_tax != 0
    cart
  end
  
  #quick checkout, ie ship (hand over) and pay (externally)
  def pos_checkout email
    self.ordered_on    = Date.today unless self.ordered_on
    self.paid_on    = Date.today unless self.paid_on
    self.shipped_on = Date.today unless self.shipped_on
    self.shipment_price = 0 unless self.shipment_price
    self.shipment_tax   = 0 unless self.shipment_tax
    self.email = email
    self.basket.deduct!
  end

  def shipment_type= typ
    write_attribute(:shipment_type, typ)
    calc = OfficeClerk::ShippingMethod.all[typ.to_sym]
    cost = calc.price_for(self.basket)
    self.shipment_price = cost
  end

  private
  # the name says a lot ,but what for? for shipping. For pickup or store sales we don't need an address
  def needs_address?
    return false unless shipment_type
    return shipment_type != "pickup"
  end
end
