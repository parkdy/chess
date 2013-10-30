def prompt(prompt_message, &is_valid)
  input = nil
  invalid = true
  is_valid = Proc.new { |input| true } unless block_given?

  while invalid
    print prompt_message
    input = gets.chomp

    invalid = !is_valid.call(input)
  end

  input
end