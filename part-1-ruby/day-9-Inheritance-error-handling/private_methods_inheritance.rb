class Bank
  def withdraw(amount)
    process(amount)
  end

  private

  def process(amount)
    puts "Processing withdrawal of #{amount}"
  end
end

class SavingsAccount < Bank
  def process(amount) # private method overriden.
    puts "Savings account processing withdrawal of #{amount}"
  end
end

puts SavingsAccount.new.withdraw(100)

# Private method can inheritance.
# Private methods can be overriden.