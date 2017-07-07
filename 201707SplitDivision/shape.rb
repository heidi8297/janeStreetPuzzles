#!/usr/local/bin/ruby
# encoding: UTF-8

# this is the code I used to solve July 2017's Jane Street Puzzle ("Split Division")
# Like all of my code for puzzling, it is hobbled together with the intent of finding a solution quickly
#   and then never using the code again (at least not in its entirety).
# Thus, it is full of hard-coding and some components which were useful early on but ultimately not
#   used in the final version posted here (e.g. "verbose" mode in the divisionValidation method)


# for a given division problem, figure out if it meets the criteria described in the original problem.
def divisionValidation(dividend,divisor,verbose = false,findOnlyCorrectShape = false)
	return nil if findOnlyCorrectShape and dividend.to_s.length != 7
	quotient = dividend/divisor
	return nil if quotient < 100 or quotient > 999
	remainder = dividend.divmod(divisor)[1]
	return nil if remainder >= 100 or remainder < 10 or (not ["1","2","3","6","9"].include?(remainder.to_s[0]))
	return nil if [5,9].include?(quotient%10)
	quotientString = quotient.to_s

	shape = [quotientString.length,(divisor.to_s+dividend.to_s).length]
	dividendShort1 = dividend.to_s[0,divisor.to_s.length].to_i
	dividendShort1 = dividend.to_s[0,divisor.to_s.length+1].to_i if dividendShort1 < divisor
	puts "\ndivisor: #{divisor}" if verbose
	puts "dividend: #{dividend}" if verbose
	puts "dividendShort1: #{dividendShort1}" if verbose
	calcQuotient = dividendShort1/divisor	# yields a whole number because neither is a float
	puts "calcQuotient: #{calcQuotient}" if verbose
	subtrahend1 = calcQuotient * divisor
	puts "\nsubtrahend1: #{subtrahend1}" if verbose
	shape << subtrahend1.to_s.length
	return nil if shape.last != 5
	return nil if not (["1","2","3","6","9"].include?(subtrahend1.to_s[0]) and ["1","2","3","6","9"].include?(subtrahend1.to_s[1]))

	difference1 = dividendShort1 - subtrahend1
	puts "difference1: #{difference1}" if verbose

	minuend1 = (difference1.to_s + dividend.to_s[dividendShort1.to_s.length]).to_i
	puts "minuend1: #{minuend1}" if verbose
	shape << minuend1.to_s.length
	return nil if shape.last != 5
	return nil if not (["1","2","3","6","9"].include?(minuend1.to_s[3]) and ["1","2","4","8"].include?(minuend1.to_s[4]))

	calcQuotient = (calcQuotient.to_s + (minuend1/divisor).to_s).to_i
	puts "calcQuotient: #{calcQuotient}" if verbose

	dividendShort2 = dividend.to_s[0,dividendShort1.to_s.length+1].to_i

	subtrahend2 = calcQuotient.to_s[-1].to_i*divisor
	shape << subtrahend2.to_s.length
	return nil if shape.last != 4
	return nil if not [1,8].include?(subtrahend2%10)

	puts "\nsubtrahend2: #{subtrahend2}" if verbose
	difference2 = minuend1 - subtrahend2
	puts "difference2: #{difference2}" if verbose

	minuend2 = (difference2.to_s + dividend.to_s[dividendShort2.to_s.length]).to_i
	puts "minuend2: #{minuend2}" if verbose
	shape << minuend2.to_s.length
	return nil if shape.last != 4
	return nil if not [1,7].include?(minuend2%10)

	calcQuotient = (calcQuotient.to_s + (minuend2/divisor).to_s).to_i
	puts "calcQuotient: #{calcQuotient}" if verbose

	dividendShort3 = dividend.to_s[0,dividendShort2.to_s.length+1].to_i

	subtrahend3 = calcQuotient.to_s[-1].to_i*divisor
	shape << subtrahend3.to_s.length
	return nil if shape.last != 4

	puts "\nsubtrahend3: #{subtrahend3}" if verbose
	difference3 = minuend2 - subtrahend3

	
	return nil if calcQuotient*divisor == dividend

	puts "difference3: #{difference3}"	if verbose
	puts "divisor: #{divisor}"		if verbose
	puts "dividend: #{dividend}" if verbose
	puts "dividendShort3: #{dividendShort3}" if verbose
	puts "calcQuotient: #{calcQuotient}" if verbose
	if dividend == dividendShort3
		minuend3 = difference3
	else
		minuend3 = (difference3.to_s + dividend.to_s[dividendShort3.to_s.length]).to_i
	end
	puts "minuend3: #{minuend3}" if verbose
	shape << difference3.to_s.length
	return nil if shape.last != 2
	return nil if not ["1","2","3","6","9"].include?(difference3.to_s[0])

	calcQuotient = (calcQuotient.to_s + (minuend3/divisor).to_s).to_i



	# print the long division - this method is neat for printing long division, but it's
	#   currently limited to printing division problems that are 9 lines long
	divisionPrintable = "\n1: "+" "*(divisor.to_s.length+1)+calcQuotient.to_s.rjust(dividendShort3.to_s.length," ")
	divisionPrintable << "\n2: "+" "*(divisor.to_s.length+1)+"_"*dividend.to_s.length
	divisionPrintable << "\n3: #{divisor}|#{dividend}"
	divisionPrintable << "\n4: "+" "*(divisor.to_s.length+1)+"#{subtrahend1.to_s.rjust(dividendShort1.to_s.length," ")}"
	divisionPrintable << "\n5: "+" "*(divisor.to_s.length+1)+"#{minuend1.to_s.rjust(dividendShort1.to_s.length+1," ")}"
	divisionPrintable << "\n6: "+" "*(divisor.to_s.length+1)+"#{subtrahend2.to_s.rjust(dividendShort2.to_s.length," ")}"
	divisionPrintable << "\n7: "+" "*(divisor.to_s.length+1)+"#{minuend2.to_s.rjust(dividendShort2.to_s.length+1," ")}"
	divisionPrintable << "\n8: "+" "*(divisor.to_s.length+1)+"#{subtrahend3.to_s.rjust(dividendShort3.to_s.length," ")}"
	divisionPrintable << "\n9: "+" "*(divisor.to_s.length+1)+"#{minuend3.to_s.rjust(dividendShort3.to_s.length," ")}"

	puts "\n#{divisionPrintable}" #if verbose

	divisionNumbers = [quotient.to_s.split(''), divisor.to_s.split('')+dividend.to_s.split(''), subtrahend1.to_s.split(''), 
		minuend1.to_s.split(''), subtrahend2.to_s.split(''), minuend2.to_s.split(''), subtrahend3.to_s.split(''), difference3.to_s.split('')]
	divisionNumbers.collect!{|x| x.collect!{|y| y.to_i}}
	#puts "\ndivisionNumbers: #{divisionNumbers}"

	return divisionNumbers

	puts "\nshape: #{shape}" if verbose
	return true
end

countNils = 0
countSols = 0
countGeneric = 0
validDivisors = []

# this is a list of ~25,000 possible dividends, calculated from the most basic restrictions
#   e.g. the 4th number must be a 5 or 1
myString = File.read("dividends2.txt")
validDividends = myString[1,myString.length-3].split(", ").collect!{|x| x.to_i}


divisionNumSets = []


#  initially i ran this loop for all numbers in this range, then once i had a list of valid divisors i used those
#(2000...10000).each do |divisor|

calculatedDivisors = [2402, 2417, 2437, 2472, 3257, 3267, 3277, 4559, 4569, 4619, 4639, 4684, 4734,
	4739, 4744, 4754, 4779, 4799, 4874, 4904, 4914, 9201, 9721, 9748, 9761, 9808, 9941]

calculatedDivisors.each do |divisor|

	#show progress of the script
	if divisor%100 == 0
		print divisor
	elsif divisor%10 == 0
		print "!#{(divisor%100)/10}"
	else
		print "!"
	end
	largestDividend = divisor * 999  # because we already know the quotient is a 3 digit number
	validDividends.each do |dividend|
		next if dividend > largestDividend
		if not (dividend%10 == 7 or dividend%10 == 1)
			countNils += 1
		end
		dividendString = dividend.to_s
		if not (dividendString[3] == "5" or dividendString[3] == "1")
			countNils += 1
		elsif not (dividendString[4] == "6" or dividendString[4] == "1")
			countNils += 1
		elsif not ["1","2","4","8"].include?(dividendString[5])
			countNils += 1
		elsif divisionValidation(dividend,divisor,false,true) == nil
			countNils += 1
		else
			countSols += 1
			divisionNumSets << divisionValidation(dividend,divisor,false,true)
			if not validDivisors.include?(divisor)
				validDivisors << divisor
				puts "\nvalidDivisors: #{validDivisors}"
				puts "\nvalidSolutions: #{countSols}"
			end
		end
		countGeneric += 1
		print "." if countGeneric%200000 == 0
	end
end
puts "\n\n\ncountNils: #{countNils}"
puts "\ncountSols: #{countSols}"
puts "\nvalidDivisors: #{validDivisors}"
#puts "divisionNumSets: #{divisionNumSets}"

validPairs = []

# now compare every pair of division problems to see if they match the constraints given in the problem.
divisionNumSets.each do |divSet1|
	div1Flat = divSet1.flatten(1)
	divisionNumSets.each do |divSet2|
		div2Flat = divSet2.flatten(1)
		match = true
		(0...38).each do |i|
			pair = [div1Flat[i],div2Flat[i]].sort
			if pair[0] == 0
				ratio = 0.1  #don't divide by zero!  insert a "filler" ratio here.
			else
				ratio = pair[1].to_f/pair[0]
			end
			match = false if (i == 0 or i == 1) and ratio%1 == 0
			match = false if i == 2 and ratio != 2
			match = false if (i == 3 or i == 4) and ratio%1 == 0
			match = false if i == 5 and ratio != 1
			match = false if (i == 6 or i == 7 or i == 8 or i == 9) and ratio%1 == 0
			match = false if i == 10 and ratio != 5
			match = false if i == 11 and ratio != 6
			match = false if i == 12 and ratio != 4
			match = false if i == 13 and ratio != 7
			match = false if i == 14 and ratio != 3
			match = false if i == 15 and ratio != 3
			match = false if (i == 16 or i == 17 or i == 18) and ratio%1 == 0
			match = false if i == 19 and ratio != 1
			match = false if (i == 20 or i == 21) and ratio%1 == 0
			match = false if i == 22 and ratio != 3
			match = false if i == 23 and ratio != 4
			match = false if i == 24 and ratio != 1
			match = false if (i == 25 or i == 26) and ratio%1 == 0
			match = false if i == 27 and ratio != 8
			match = false if (i == 28 or i == 29 or i == 30) and ratio%1 == 0
			match = false if i == 31 and ratio != 7
			match = false if (i == 32 or i == 33 or i == 34 or i == 35) and ratio%1 == 0
			match = false if i == 36 and ratio != 3
			match = false if i == 37 and ratio%1 == 0
		end
		validPairs << [divSet1,divSet2]  if match
	end
end

puts
puts validPairs.length

puts validPairs[0][0].inspect
puts
puts validPairs[0][1].inspect


