class User < ActiveRecord::Base
  has_many :carts
  belongs_to :current_cart, :class_name => "Cart", :foreign_key => 'current_cart_id'
  has_many :orders

  #user belongs_to current_cart but the actual name of the model containing current_cart is cart.

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def create_current_cart
    cart = Cart.create
    self.current_cart_id = cart.id
    save
  end



end
