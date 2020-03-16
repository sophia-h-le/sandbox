puts('start')

require 'csv'
table = CSV.parse(File.read("./test.csv"), headers:true)

puts("found a file with #{table.length()} row")
puts("printing first line")
puts("DEPARTMENT NAME->#{table[0]["DEPARTMENT NAME"]}, EMPLOYEE NAME->#{table[0]["EMPLOYEE NAME"]}, REGULAR EARNINGS->#{table[0]["REGULAR EARNINGS"]}")
#ignore if department = "BUILDING AND COMPLIANCE", name contains "JOHN", overtime earning = 0
#the employee with the highest regular earnings

puts()
puts('done')

def departmentFilter(table)
    #ignore if department = "BUILDING AND COMPLIANCE", name contains "JOHN", overtime earning = 0
    newTable = []
    for row in table do
        if row["DEPARTMENT NAME"] == "BUILDINGS AND COMPLIANCE" || row["OVERTIME EARNINGS"] == "0.00" || row["EMPLOYEE NAME"].include?("JOHN")#overtime earnings?
            next
        end

        newTable.append(row)
    end
    return newTable
end

#the filtered table1
table1 = departmentFilter(table)
puts("after filtering there are #{table1.length()} rows")

#highest regular earnings
#create a function
def highestRegularEarning(table)
    max = 0.0
    returnRecord = table[0]
    for row in table do
        regularEarnings = row["REGULAR EARNINGS"].to_f
        if regularEarnings > max
            max = regularEarnings
            returnRecord = row
        end
    end
    return returnRecord
end
#employ the funciton
highestRegularEarningsRow = highestRegularEarning(table1)
puts("Employee with highest regular earnings is: #{highestRegularEarningsRow["EMPLOYEE NAME"]} with regular earnings = #{highestRegularEarningsRow["REGULAR EARNINGS"]}")


#how many department have more than 150 employees?
#function to count employees in each department
def employeeCount(table, hash)
    for row in table do
        key = row["DEPARTMENT NAME"]
        if hash.key?(key)
            value = hash[key] + 1
            hash[key] = value
        else 
            hash[key] = 1
        end
    end
    return hash
end

count = Hash.new

count = employeeCount(table1, count)
#business.each do |key, value|
#puts "The hash key is #{key} and the value is #{value}."
#end
puts ""
puts "Department(s) with more than 150 employees:"
count.each do |key, value|
    if value > 150
        puts key
    end
end

#median overtime earnings among all employees in departments with more than 50 employees
#which departments have more than 50 employees
puts ""
puts "Department(s) with more than 50 employees:"
count.each do |key, value|
    if value > 50
        puts key
    end
end
puts "Total employee count of the above departments:"
a = 0
count.each do |key, value|
    if value > 50
        a += value
    end
end
puts "#{a}"
#total overtime earnings of the above departments
b = 0
def totalOvertimeEarnings(table, i, hash)
    for row in table do
        key = row["DEPARTMENT NAME"]
        if hash[key] > 50
            overtimeEarnings = row["OVERTIME EARNINGS"].to_f
            i += overtimeEarnings
        end
    end
    return i
end
b = totalOvertimeEarnings(table1, b, count)
medianOvertimeEarnings = b / a
puts "The median overtime earnings of the above departments is:"
puts "#{medianOvertimeEarnings}"

puts ""
mayorTotalEarnings = 0
puts "Total earnings of the Mayor is:" 
for employee in table do
    if employee["TITLE"] == "MAYOR"
        puts(employee["TOTAL EARNINGS"]) 
        mayorTotalEarnings = employee["TOTAL EARNINGS"].to_f
    end
end
puts "Fire Department employees whose name does not start with R and earns more than the mayor in total earnings are:"
for employee in table1 do
    if employee["DEPARTMENT NAME"] == "FIRE DEPARTMENT" && ((employee["EMPLOYEE NAME"].start_with? ("R")) == false)
        totalearnings = employee["TOTAL EARNINGS"].to_f
        if totalearnings > mayorTotalEarnings
            puts "#{employee["EMPLOYEE NAME"]} with #{employee["TOTAL EARNINGS"]} "
        end
    end
end

puts ""
puts ""
medianIncomeNY = 54948
require 'set'
highIncomeDepartment = Set.new
for employee in table1 do
    longevityPay = employee["LONGEVITY PAY"].to_f
    totalEarnings = employee["TOTAL EARNINGS"].to_f
    if longevityPay > 1000 && totalEarnings > medianIncomeNY
        highIncomeDepartment.add(employee["DEPARTMENT NAME"])
    end
end
puts "Departments with employees earn more than 1000 in longevity pay and more than median household income in NY State are:"
highIncomeDepartment.each do |n|
    puts n
end        
puts "finish"


