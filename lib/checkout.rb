class Checkout
  attr_accessor(:id, :book_id, :patron_id, :checkout_date, :due_date)

  def initialize(attributes)
    @id = attributes[:id]
    @book_id = attributes[:book_id]
    @patron_id = attributes[:patron_id]
    @checkout_date = attributes[:checkout_date]
    @due_date = attributes[:due_date]
  end

end
