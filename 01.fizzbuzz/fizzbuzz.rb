def i_15?(i) #15の倍数か？
    return i % 15 == 0
end
def i_3?(i) #3の倍数か？
    return i % 3 == 0
end
def i_5?(i) #5の倍数か？
    return i % 5 == 0
end

(1..20).each do |i|
    if i_15?(i)
        puts "FizzBuzz"
    elsif i_3?(i)
        puts "Fizz"
    elsif i_5?(i)
        puts "Buzz"
    else
        puts i
    end
end