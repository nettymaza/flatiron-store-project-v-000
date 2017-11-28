class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :line_items
  has_many :items, through: :line_items

  def total
    cart_total = 0
    self.line_items.each do |line_item|
      cart_total += line_item.item.price * line_item.quantity
    end
    cart_total
  end

  def add_item(item_id)
    # Find item by id
    new_line_item = self.line_items.find_by(item_id: item_id)
    # if item already exists, increase it by 1
    if new_line_item
      new_line_item.quantity += 1
    # else, build item.
    else
      new_line_item = self.line_items.build(item_id: item_id)
    end
      new_line_item
  end

  def checkout
    self.status = "submitted"
    self.save
    user.current_cart = nil
    user.save
    update_inventory
  end

  def update_inventory
    if self.status = "submitted"
      self.line_items.each do |line_item|
        line_item.item.inventory -= line_item.quantity
        line_item.item.save
      end
    end
  end

end
