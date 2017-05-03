class Checkout
  attr_accessor(:id, :book_id, :patron_id, :checkout_date, :due_date)

  def initialize(attributes)
    @id = attributes[:id]

end
