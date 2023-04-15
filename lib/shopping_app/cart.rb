require_relative "item_manager"
require_relative "ownable"
require_relative "item"

class Cart
  include ItemManager
  include Ownable

  def initialize(owner)
    self.owner = owner
    @items = []
  end

  def items
    # Cartにとってのitemsは自身の@itemsとしたいため、ItemManagerのitemsメソッドをオーバーライドします。
    # CartインスタンスがItemインスタンスを持つときは、オーナー権限の移譲をさせることなく、自身の@itemsに格納(Cart#add)するだけだからです。
    @items
  end

  def add(item)
    @items << item
  end

  def total_amount
    @items.sum(&:price)
  end

  def check_out
    return if owner.wallet.balance < total_amount
    @items.each do |item|
      item.owner.wallet.withdraw(item.price)
      self.owner.wallet.deposit(item.price)
    end
  
    #Transfer ownership of each item in the cart to the cart owner
    @items.each do |item|
      item.owner = self.owner
    end
  
    # Empty the cart
    @items = []
  end

end
